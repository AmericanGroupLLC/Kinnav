import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

/// A short-lived credential for joining one call channel.
class CallToken {
  const CallToken({
    required this.appId,
    required this.channel,
    required this.token,
    required this.uid,
    required this.expiresAt,
  });

  /// The RTC provider's App ID. Comes from the server with the token so the
  /// client never has to ship it, and so it can be rotated without a release.
  final String appId;
  final String channel;
  final String token;
  final int uid;
  final DateTime expiresAt;

  /// Treated as expired a minute early: a token that dies mid-handshake fails
  /// the call, and on a safety app that is the worst possible moment.
  bool get isExpired =>
      DateTime.now().toUtc().isAfter(expiresAt.subtract(const Duration(minutes: 1)));

  factory CallToken.fromJson(Map<String, dynamic> json) {
    final expires = json['expiresAt'] ?? json['expires_at'];
    return CallToken(
      appId: (json['appId'] ?? json['app_id'] ?? '') as String,
      channel: (json['channel'] ?? json['channel_name'] ?? '') as String,
      token: (json['token'] ?? '') as String,
      uid: (json['uid'] as num?)?.toInt() ?? 0,
      expiresAt: expires is int
          // Unix seconds is what Agora's own examples return.
          ? DateTime.fromMillisecondsSinceEpoch(expires * 1000, isUtc: true)
          : DateTime.tryParse('$expires')?.toUtc() ??
              DateTime.now().toUtc().add(const Duration(hours: 1)),
    );
  }
}

class CallTokenException implements Exception {
  const CallTokenException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => 'CallTokenException($statusCode): $message';
}

/// Asks the Kinnav backend for a call token.
///
/// The app never talks to the RTC provider's REST API and never holds the App
/// Certificate — that stays server-side, which is the whole point of the
/// token endpoint. The client only ever sees a credential scoped to one
/// channel and a few hours:
///
///   app → POST {API_BASE_URL}/calls/token → backend signs with App
///   ID + Certificate → short-lived token → app joins the channel
///
/// Expected request  `{"channel": "...", "role": "publisher"}`
/// Expected response `{"appId": "...", "channel": "...", "token": "...",
///                     "uid": 123, "expiresAt": 1770000000}`
///
/// `expiresAt` is accepted as Unix seconds or an ISO-8601 string. If the real
/// endpoint differs, [CallToken.fromJson] and [path] are the only things to
/// change.
class CallTokenClient {
  CallTokenClient({http.Client? client, this.path = '/calls/token'})
      : _client = client ?? http.Client();

  final http.Client _client;

  /// Appended to [AppConfig.apiBaseUrl].
  final String path;

  /// The signed-in user's access token, so the backend can decide whether this
  /// person is allowed into that channel. Null when signed out — the request
  /// still goes, and the server should refuse it.
  String? _accessToken() {
    try {
      return Supabase.instance.client.auth.currentSession?.accessToken;
    } catch (_) {
      // Supabase not initialised (tests, offline start).
      return null;
    }
  }

  Future<CallToken> fetch({
    required String channel,
    String role = 'publisher',
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
    final jwt = _accessToken();

    http.Response res;
    try {
      res = await _client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              if (jwt != null) 'Authorization': 'Bearer $jwt',
            },
            body: jsonEncode({'channel': channel, 'role': role}),
          )
          // A call is an urgent action; waiting forever on a hung server is
          // worse than failing fast and letting the UI offer another route.
          .timeout(timeout);
    } catch (e) {
      throw CallTokenException('Could not reach the call service: $e');
    }

    if (res.statusCode != 200) {
      throw CallTokenException(
        _errorFrom(res.body) ?? 'Call service returned ${res.statusCode}',
        statusCode: res.statusCode,
      );
    }

    final Map<String, dynamic> body;
    try {
      body = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      throw const CallTokenException('Call service returned a malformed response');
    }

    final token = CallToken.fromJson(body);
    if (token.token.isEmpty || token.appId.isEmpty) {
      throw const CallTokenException(
          'Call service response is missing appId or token');
    }
    return token;
  }

  /// Pulls `{"error": "..."}` out of a failure body when the server sends one.
  String? _errorFrom(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['error'] is String) {
        return decoded['error'] as String;
      }
    } catch (_) {}
    return null;
  }

  void close() => _client.close();
}

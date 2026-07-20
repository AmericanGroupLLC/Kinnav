import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'secure_store.dart';

/// Thrown for non-2xx responses; carries the gateway's `{ "error": "..." }`.
class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Thin HTTP client for the AmericanGroupLLC API Gateway
/// (`https://api.americangroupllc.com/api/v1`). Attaches the Bearer token,
/// transparently refreshes on 401, and normalizes the error envelope.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final _http = http.Client();
  final _store = SecureStore.instance;

  Uri _uri(String path) => Uri.parse('${AppConfig.apiBaseUrl}$path');

  Future<Map<String, String>> _headers({bool auth = true}) async {
    final h = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await _store.accessToken;
      if (token != null) h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  Future<dynamic> get(String path, {bool auth = true}) =>
      _send(() async => _http.get(_uri(path), headers: await _headers(auth: auth)),
          path, auth);

  Future<dynamic> post(String path, Map<String, dynamic> body,
          {bool auth = true}) =>
      _send(
          () async => _http.post(_uri(path),
              headers: await _headers(auth: auth), body: jsonEncode(body)),
          path,
          auth);

  Future<dynamic> _send(
      Future<http.Response> Function() run, String path, bool auth) async {
    var res = await run();
    if (res.statusCode == 401 && auth && await _refresh()) {
      res = await run(); // retry once with a fresh token
    }
    return _decode(res);
  }

  dynamic _decode(http.Response res) {
    final body = res.body.isEmpty ? {} : jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) return body;
    final msg = body is Map && body['error'] != null
        ? body['error'].toString()
        : 'Request failed';
    throw ApiException(res.statusCode, msg);
  }

  /// Exchanges the refresh token for a new access token. Returns false on failure.
  Future<bool> _refresh() async {
    final rt = await _store.refreshToken;
    if (rt == null) return false;
    try {
      final res = await _http.post(_uri('/auth/auth/refresh'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refresh_token': rt}));
      if (res.statusCode ~/ 100 != 2) return false;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      await _store.saveTokens(
        accessToken: data['access_token'] as String,
        refreshToken: (data['refresh_token'] ?? rt) as String,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}

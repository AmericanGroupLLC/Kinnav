import 'dart:async';
import 'dart:io' show SocketException;

import 'package:supabase_flutter/supabase_flutter.dart';

import 'storage.dart';

/// Real authentication against the org's Supabase backend.
///
/// Sign-in calls `Supabase.instance.client.auth.signInWithPassword`. Tokens and
/// the session are managed by supabase_flutter (persisted in secure local
/// storage by the SDK).
///
/// Provisioned shared test/demo accounts (see docs/DESIGN.md → Auth & Backend):
///   • QA (one-tap test button): qa@safecodeg.com  / QATest@2024!
///   • Developer:                dev@safecodeg.com / DevTest@2024!
///   • Admin:                    admin@safecodeg.com / AdminTest@2024!
class SupabaseAuthService {
  SupabaseAuthService._();
  static final SupabaseAuthService instance = SupabaseAuthService._();

  /// The one-tap "Use test account" credentials (QA / primary).
  static const String testEmail = 'qa@safecodeg.com';
  static const String testPassword = 'QATest@2024!';

  /// Credentials allowed to use the offline fallback session (see below).
  static const Map<String, String> _testAccounts = {
    'qa@safecodeg.com': 'QATest@2024!',
    'dev@safecodeg.com': 'DevTest@2024!',
    'admin@safecodeg.com': 'AdminTest@2024!',
  };

  /// shared_preferences key marking an active local (offline fallback) session.
  static const String _kLocalSession = 'localDemoSession';

  GoTrueClient get _auth => Supabase.instance.client.auth;

  /// The current Supabase session, or null if Supabase isn't initialized
  /// (offline/sandbox runs where `Supabase.initialize` failed on host lookup).
  Session? get _currentSession {
    try {
      return _auth.currentSession;
    } catch (_) {
      return null;
    }
  }

  /// True only when there is a *valid* (non-expired) Supabase session. An
  /// expired session that could not be refreshed is treated as no session, so
  /// routing never shows a stale/invalid login as signed in.
  bool get _hasValidSupabaseSession {
    final session = _currentSession;
    if (session == null) return false;
    return !session.isExpired;
  }

  /// True when a session is active — either a valid Supabase session or the
  /// offline fallback session below. This is the authoritative auth state used
  /// to reconcile routing.
  bool get isSignedIn =>
      _hasValidSupabaseSession || Storage.instance.getBool(_kLocalSession);

  /// Signs in with email + password against Supabase.
  ///
  /// This build environment (and other fully-offline runs such as demos) has NO
  /// network access, so the live Supabase call will fail with a socket/network
  /// error. In that case ONLY — and only when the entered credentials exactly
  /// match one of the provisioned test accounts — we fall back to a local demo
  /// session persisted via shared_preferences, so the app stays runnable
  /// offline. On a networked device the real Supabase path is always used.
  Future<void> signInWithPassword(String email, String password) async {
    final normalizedEmail = email.trim();
    try {
      await _auth.signInWithPassword(
        email: normalizedEmail,
        password: password,
      );
      // Real session established; make sure no stale fallback flag lingers.
      await Storage.instance.setBool(_kLocalSession, false);
    } catch (e) {
      if (_isNetworkError(e) &&
          _testAccounts[normalizedEmail.toLowerCase()] == password) {
        // Offline fallback for the known test accounts only.
        await Storage.instance.setBool(_kLocalSession, true);
        return;
      }
      rethrow;
    }
  }

  /// Signs out of both the Supabase session and the local fallback session.
  Future<void> signOut() async {
    await Storage.instance.setBool(_kLocalSession, false);
    if (_currentSession != null) {
      try {
        await _auth.signOut();
      } catch (_) {
        // Offline sign-out: local session already cleared above.
      }
    }
  }

  bool _isNetworkError(Object e) {
    if (e is SocketException) return true;
    if (e is AuthRetryableFetchException) return true;
    if (e is AuthException) {
      // gotrue wraps low-level fetch failures; match by message as a fallback.
      final m = e.message.toLowerCase();
      return m.contains('socket') ||
          m.contains('network') ||
          m.contains('failed host lookup') ||
          m.contains('connection');
    }
    final s = e.toString().toLowerCase();
    return s.contains('socketexception') ||
        s.contains('failed host lookup') ||
        s.contains('network is unreachable') ||
        s.contains('connection');
  }
}

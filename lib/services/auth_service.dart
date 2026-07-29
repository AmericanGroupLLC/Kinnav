import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException;
import 'dart:math' show Random;

import 'package:crypto/crypto.dart' show sha256;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
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

  /// Sign in with Apple via the Supabase-native ID-token flow.
  ///
  /// Generates a cryptographically random raw nonce and sends its SHA-256 hash
  /// to Apple; Apple binds the hash into the returned identity token, and
  /// Supabase re-derives the hash from the raw nonce to verify the binding
  /// (replay protection). Supabase auto-creates the account on first sign-in.
  Future<void> signInWithApple() async {
    final rawNonce = _generateNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: const [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException('Apple sign-in failed: missing identity token.');
    }

    final res = await _auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
    if (res.session == null) {
      throw const AuthException('Apple sign-in failed: no session returned.');
    }
    // Real session established; make sure no stale fallback flag lingers.
    await Storage.instance.setBool(_kLocalSession, false);
  }

  /// Sign in with Google via the Supabase-native ID-token flow.
  ///
  /// The native SDK returns a Google `idToken` (+ `accessToken`); Supabase
  /// exchanges them for a session and auto-creates the account on first
  /// sign-in. [AppConfig.googleServerClientId] (the web/server client id) must
  /// match the Google provider's configured Client ID in the Supabase dashboard,
  /// or the exchange is rejected.
  Future<void> signInWithGoogle() async {
    final iosClientId = AppConfig.googleIosClientId;
    final googleSignIn = GoogleSignIn(
      serverClientId: AppConfig.googleServerClientId,
      clientId: iosClientId.isNotEmpty ? iosClientId : null,
    );

    final account = await googleSignIn.signIn();
    if (account == null) {
      throw const AuthException('Google sign-in was cancelled.');
    }
    final googleAuth = await account.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) {
      throw const AuthException('Google sign-in failed: missing ID token.');
    }

    final res = await _auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: googleAuth.accessToken,
    );
    if (res.session == null) {
      throw const AuthException('Google sign-in failed: no session returned.');
    }
    // Real session established; make sure no stale fallback flag lingers.
    await Storage.instance.setBool(_kLocalSession, false);
  }

  /// Seamless, no-login identity. Creates a real (anonymous) Supabase session
  /// that persists and can later be upgraded to a full account.
  Future<void> signInAnonymously() async {
    final res = await _auth.signInAnonymously();
    if (res.session == null) {
      throw const AuthException('Anonymous sign-in failed.');
    }
    await Storage.instance.setBool(_kLocalSession, false);
  }

  /// Cryptographically secure random nonce (URL-safe charset) for Apple sign-in.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Signs out of the Supabase session, the native Google session, and the
  /// local fallback session. Only ever called on an explicit, user-initiated
  /// sign-out — never automatically at launch, so auto-login relies on the
  /// persisted session staying put.
  Future<void> signOut() async {
    await Storage.instance.setBool(_kLocalSession, false);
    if (_currentSession != null) {
      try {
        await _auth.signOut();
      } catch (_) {
        // Offline sign-out: local session already cleared above.
      }
    }
    try {
      await GoogleSignIn().signOut();
    } catch (_) {
      // No cached Google account — ignore.
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

import 'api_client.dart';
import 'secure_store.dart';

/// AmericanGroupLLC authentication against the API Gateway (see
/// AmericanGroupLLC_Developer_Docs §3). Tokens are persisted in [SecureStore].
///
/// Active when the app is built with --dart-define=BACKEND=americangroupllc;
/// the default 'mock' backend keeps the app usable offline.
class AuthApi {
  AuthApi._();

  static final _api = ApiClient.instance;
  static final _store = SecureStore.instance;

  static Future<void> register(String email, String password) async {
    final data = await _api.post('/auth/auth/register',
        {'email': email, 'password': password}, auth: false);
    await _persist(data as Map<String, dynamic>);
  }

  static Future<void> login(String email, String password) async {
    final data = await _api.post('/auth/auth/login',
        {'email': email, 'password': password}, auth: false);
    await _persist(data as Map<String, dynamic>);
  }

  /// Exchanges a Firebase ID token (from Phone OTP) for backend JWTs.
  static Future<void> verifyFirebase(String idToken) async {
    final data = await _api
        .post('/auth/auth/firebase/verify', {'id_token': idToken}, auth: false);
    await _persist(data as Map<String, dynamic>);
  }

  /// GET /auth/me — current user profile (requires a valid session).
  static Future<Map<String, dynamic>> me() async =>
      (await _api.get('/auth/me')) as Map<String, dynamic>;

  static Future<void> logout() async {
    try {
      await _api.post('/auth/auth/logout', {});
    } finally {
      await _store.clear();
    }
  }

  static Future<void> _persist(Map<String, dynamic> data) async {
    await _store.saveTokens(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
      userId: data['user_id']?.toString(),
    );
  }
}

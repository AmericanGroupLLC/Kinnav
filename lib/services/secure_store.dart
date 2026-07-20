import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure token storage backed by the iOS Keychain / Android Keystore.
/// Per AmericanGroupLLC policy, JWTs must NEVER be stored in plain
/// SharedPreferences — only here.
class SecureStore {
  SecureStore._();
  static final SecureStore instance = SecureStore._();

  static const _access = 'access_token';
  static const _refresh = 'refresh_token';
  static const _userId = 'user_id';

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    String? userId,
  }) async {
    await _storage.write(key: _access, value: accessToken);
    await _storage.write(key: _refresh, value: refreshToken);
    if (userId != null) await _storage.write(key: _userId, value: userId);
  }

  Future<String?> get accessToken => _storage.read(key: _access);
  Future<String?> get refreshToken => _storage.read(key: _refresh);
  Future<String?> get userId => _storage.read(key: _userId);

  Future<bool> get hasSession async => (await accessToken) != null;

  Future<void> clear() async {
    await _storage.delete(key: _access);
    await _storage.delete(key: _refresh);
    await _storage.delete(key: _userId);
  }
}

/// Authentication boundary. The mock implementation simulates OTP sign-in;
/// swap in Firebase Auth / a custom OTP backend in Phase 3 without touching UI.
abstract class AuthService {
  Future<bool> requestOtp(String phoneOrEmail);
  Future<bool> verifyOtp(String code);
}

class MockAuthService implements AuthService {
  @override
  Future<bool> requestOtp(String phoneOrEmail) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return phoneOrEmail.trim().isNotEmpty;
  }

  @override
  Future<bool> verifyOtp(String code) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Mock: accept any 4+ digit code.
    return code.trim().length >= 4;
  }
}

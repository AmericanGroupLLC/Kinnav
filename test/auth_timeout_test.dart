import 'package:flutter_test/flutter_test.dart';
import 'package:kinnav/services/auth_service.dart';

/// Sign-in must fail fast when the network is unreachable.
///
/// Without an explicit timeout the call inherits the platform's DNS/TCP
/// timeout — measured at ~60s on an emulator with no route out — and the user
/// watches an indefinite spinner. On a safety app someone in a dead zone needs
/// to be told quickly, not left guessing, so the bound is asserted here rather
/// than left to whatever the platform happens to do.
void main() {
  test('sign-in has a bounded timeout', () {
    expect(SupabaseAuthService.signInTimeout, isNotNull);
    expect(SupabaseAuthService.signInTimeout.inSeconds, greaterThan(0),
        reason: 'a zero timeout would fail every attempt');
    expect(SupabaseAuthService.signInTimeout.inSeconds, lessThanOrEqualTo(20),
        reason: 'longer than ~20s reads as a hang to the person waiting');
  });
}

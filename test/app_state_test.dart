import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kinnav/app_state.dart';
import 'package:kinnav/models/call_record.dart';
import 'package:kinnav/models/user_profile.dart';
import 'package:kinnav/services/storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<AppState> freshState() async {
    SharedPreferences.setMockInitialValues({});
    // Reset the singleton so each test gets a clean store.
    final storage = await Storage.init();
    await storage.clear();
    return AppState(storage);
  }

  test('starts unonboarded and signed out', () async {
    final s = await freshState();
    expect(s.onboarded, false);
    expect(s.signedIn, false);
    expect(s.hasProfile, false);
  });

  test('persists profile and reward redemption', () async {
    final s = await freshState();
    await s.setProfile(const UserProfile(
        name: 'Mia', birthMonth: 3, birthYear: 1995));
    await s.redeemReward('Yoga Classes');
    expect(s.hasProfile, true);
    expect(s.isRedeemed('Yoga Classes'), true);
    expect(s.isRedeemed('Counseling'), false);
  });

  test('guardian course completion verifies guardian', () async {
    final s = await freshState();
    await s.setProfile(const UserProfile(
        name: 'Leah', birthMonth: 5, birthYear: 1990));
    for (var i = 0; i < AppState.totalGuardianCourseSteps; i++) {
      await s.advanceGuardianCourse();
    }
    expect(s.isGuardianCourseComplete, true);
    expect(s.profile?.isGuardian, true);
  });

  test('records call history', () async {
    final s = await freshState();
    await s.addCallRecord(const CallRecord(
      typeLabel: 'Video Call',
      guardianCount: 4,
      durationSeconds: 65,
      policeAdded: false,
      startedAtMs: 0,
    ));
    expect(s.callHistory.length, 1);
    expect(s.callHistory.first.durationLabel, '01:05');
  });
}

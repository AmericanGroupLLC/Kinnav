import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kinnav/app_state.dart';
import 'package:kinnav/models/call_record.dart';
import 'package:kinnav/models/safety_contact.dart';
import 'package:kinnav/models/user_profile.dart';
import 'package:kinnav/services/storage.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  // logOut() clears the Keychain/Keystore via flutter_secure_storage, which has
  // no implementation in a unit test. Answer its channel so the sign-out path
  // is exercisable here.
  const secureStorageChannel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  setUp(() {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      secureStorageChannel,
      (call) async => call.method == 'readAll' ? <String, String>{} : null,
    );
  });
  tearDown(() {
    binding.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, null);
  });

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

  test('a new user has no safety contacts', () async {
    final s = await freshState();
    // Seeding fictional contacts is dangerous here: starting a Safe Call texts
    // every safety contact the user's precise live location.
    expect(s.contacts, isEmpty);
  });

  group('logOut clears the signed-in user from the device', () {
    test('drops profile, contacts, history, rewards and plan', () async {
      final s = await freshState();
      await s.completeOnboarding();
      await s.signIn();
      await s.setProfile(
          const UserProfile(name: 'Mia', birthMonth: 3, birthYear: 1995));
      await s.addContact(const SafetyContact(
          name: 'Real Friend',
          phone: '+15551234567',
          relation: 'Friend',
          colorValue: 0xFFAB47BC));
      await s.addCallRecord(const CallRecord(
        typeLabel: 'Video Call',
        guardianCount: 2,
        durationSeconds: 30,
        policeAdded: false,
        startedAtMs: 0,
      ));
      await s.redeemReward('Yoga Classes');
      await s.toggleModuleComplete('Situational Awareness');
      await s.setPlan(SubscriptionPlan.monthly);

      await s.logOut();

      expect(s.signedIn, false);
      // hasProfile must be false, or the next person to sign in skips profile
      // setup and lands on Home under the previous user's name.
      expect(s.hasProfile, false);
      expect(s.contacts, isEmpty);
      expect(s.callHistory, isEmpty);
      expect(s.redeemedRewards, isEmpty);
      expect(s.completedModules, isEmpty);
      expect(s.plan, SubscriptionPlan.none);
      // Onboarding describes the device, not the user, so it survives.
      expect(s.onboarded, true);
    });

    test('cleared data does not come back on the next launch', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await Storage.init();
      await storage.clear();

      final first = AppState(storage);
      await first.completeOnboarding();
      await first.signIn();
      await first.setProfile(
          const UserProfile(name: 'Mia', birthMonth: 3, birthYear: 1995));
      await first.addCallRecord(const CallRecord(
        typeLabel: 'Video Call',
        guardianCount: 2,
        durationSeconds: 30,
        policeAdded: false,
        startedAtMs: 0,
      ));
      await first.logOut();

      // Same storage, new AppState — i.e. the next cold start.
      final second = AppState(storage);
      expect(second.hasProfile, false);
      expect(second.callHistory, isEmpty);
      expect(second.signedIn, false);
    });
  });

  group('corrupt stored data cannot brick the launch', () {
    test('malformed JSON falls back to defaults instead of throwing', () async {
      // _load() runs in the constructor, before runApp. Throwing here would
      // fail every launch with no user-facing recovery.
      SharedPreferences.setMockInitialValues({});
      final storage = await Storage.init();
      await storage.clear();
      // Written through the live store: Storage.init() is a cached singleton,
      // so setMockInitialValues alone would not reach this instance.
      await storage.setString('profile', 'not json at all');
      await storage.setString('callHistory', '{"unexpected":"shape"}');
      await storage.setString('safetyContacts', '[[]]');

      late AppState s;
      expect(() => s = AppState(storage), returnsNormally);
      expect(s.hasProfile, false);
      expect(s.callHistory, isEmpty);
      expect(s.contacts, isEmpty);
    });
  });
}

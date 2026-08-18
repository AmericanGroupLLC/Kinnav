// Store-screenshot run. Not an assertion suite — app_test.dart is that.
//
// Signs in with the provisioned QA account rather than seeding a demo session,
// so the screens show a real signed-in profile, then stops on each screen long
// enough for the host to photograph it.
//
//   flutter drive --driver=test_driver/integration_test.dart \
//     --target=integration_test/screenshots_test.dart -d <udid> \
//     --dart-define=SCREENSHOT=true --dart-define=HOLD_MS=5000
//
// SCREENSHOT=true hides the debug-only "Demo mode (dev)" buttons, which the
// release build never renders — a screenshot showing them is a rejection.
// The host captures with `xcrun simctl io … screenshot` because
// `binding.takeScreenshot` returns a blank frame on iOS.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kinnav/app_state.dart';
import 'package:kinnav/main.dart' as app;
import 'package:kinnav/models/user_profile.dart';

Future<void> main() async {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const holdMs = int.fromEnvironment('HOLD_MS', defaultValue: 5000);

  /// Parks on the current screen so the host can photograph it.
  Future<void> hold(WidgetTester tester, String label) async {
    debugPrint('SHOT >>> $label');
    await tester.pumpAndSettle();
    await Future<void>.delayed(const Duration(milliseconds: holdMs));
  }

  Future<void> start(WidgetTester tester) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));
    // main() installs its own FlutterError.onError; leaving it in place trips
    // flutter_test's "handler was overridden" assertion.
    FlutterError.onError = (d) => FlutterError.presentError(d);
  }

  testWidgets('walk the app for store screenshots', (tester) async {
    await start(tester);

    // ── onboarding ────────────────────────────────────────────────────────
    if (find.text('Welcome to Kinnav').evaluate().isNotEmpty) {
      await hold(tester, '01-welcome');
      for (final label in ['Next', 'Next', 'Next']) {
        if (find.text(label).evaluate().isEmpty) break;
        await tester.tap(find.text(label).first);
        await tester.pumpAndSettle();
      }
      if (find.text('Get Started').evaluate().isNotEmpty) {
        await tester.tap(find.text('Get Started'));
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }
    }

    // ── sign in with the real QA account ──────────────────────────────────
    if (find.text('Use test account').evaluate().isNotEmpty) {
      await hold(tester, '02-sign-in');
      await tester.tap(find.text('Use test account'));
      // A real network round trip to Supabase, so allow generously.
      await tester.pumpAndSettle(const Duration(seconds: 12));
    }

    // Offline or a rejected credential would strand the run on sign-in; fall
    // back so the remaining screens are still captured rather than losing all
    // of them to one failure.
    if (!appState.signedIn) {
      debugPrint('SHOT >>> sign-in did not complete; seeding a session');
      await appState.signIn();
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    // ── profile ───────────────────────────────────────────────────────────
    if (!appState.hasProfile) {
      await appState.setProfile(const UserProfile(
        name: 'Priya',
        birthMonth: 6,
        birthYear: 1996,
        identity: 'Woman',
        languages: ['English', 'Hindi'],
      ));
      await tester.pumpAndSettle(const Duration(seconds: 4));
    }

    // ── map ───────────────────────────────────────────────────────────────
    if (find.text('CALL GUARDIANS').evaluate().isNotEmpty) {
      await hold(tester, '03-guardian-map');

      await tester.tap(find.text('CALL GUARDIANS'));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await hold(tester, '04-reach-a-guardian');
      if (find.byIcon(Icons.close).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.close).first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    }

    // ── drawer destinations ───────────────────────────────────────────────
    for (final entry in const [
      ['Self Care & Empowerment', '05-modules'],
      ['Rewards', '06-rewards'],
      ['My Safety Contacts', '07-safety-contacts'],
    ]) {
      if (find.byIcon(Icons.menu).evaluate().isEmpty) break;
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      if (entry[0] == 'Self Care & Empowerment') await hold(tester, '04b-menu');
      final item = find.text(entry[0]);
      if (item.evaluate().isEmpty) {
        await tester.tap(find.byIcon(Icons.close).first);
        continue;
      }
      await tester.ensureVisible(item);
      await tester.pumpAndSettle();
      await tester.tap(item);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await hold(tester, entry[1]);
      await tester.pageBack();
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    debugPrint('SHOT >>> done');
    await binding.convertFlutterSurfaceToImage().catchError((_) {});
  });
}

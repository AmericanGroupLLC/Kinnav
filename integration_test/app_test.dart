// End-to-end pass over the real app on a real device.
//
// The widget tests in test/ pump individual screens; this drives the shipped
// binary the way a person does — cold start, tap through, assert what is on
// screen — so it catches wiring the widget tests cannot: a missing asset, a
// route that does not resolve, state that fails to persist.
//
// It doubles as the screenshot generator. The iOS Simulator has no equivalent
// of `adb shell input tap`, so store screenshots for iOS could not be captured
// by automation before this; here the app taps itself.
//
//   flutter drive --driver=test_driver/integration_test.dart \
//     --target=integration_test/app_test.dart -d <device>
//
// Screenshots land in build/screenshots/. See store/README.md.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:kinnav/app_state.dart';
import 'package:kinnav/config/app_config.dart';
import 'package:kinnav/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Captures the current screen.
  ///
  /// On Android the surface can be converted and grabbed in-process. On iOS
  /// it cannot — `convertFlutterSurfaceToImage` is Android-only and
  /// `takeScreenshot` returns a blank frame — so the run instead holds still
  /// on each screen and the host grabs it with `xcrun simctl io screenshot`.
  /// Pass --dart-define=HOLD_MS=6000 to enable that.
  ///
  /// This distinction matters: without it the suite writes seven convincing
  /// but empty PNGs and reports success.
  const holdMs = int.fromEnvironment('HOLD_MS');
  Future<void> shoot(String name) async {
    if (holdMs > 0) {
      // Callers have already settled the frame; just stay put long enough for
      // the host to take the picture.
      await Future<void>.delayed(const Duration(milliseconds: holdMs));
      return;
    }
    try {
      await binding.convertFlutterSurfaceToImage();
      await binding.takeScreenshot(name);
    } catch (_) {
      // No surface to convert (iOS): nothing useful can be captured here.
    }
  }

  /// Starts the real app and hands error reporting back to the test harness.
  ///
  /// main() installs its own FlutterError.onError so crashes reach the
  /// analytics boundary. Left in place that trips flutter_test's assertion
  /// that a test did not leave the handler overridden, which surfaces as a
  /// confusing failure unrelated to whatever is being asserted.
  Future<void> launch(WidgetTester tester) async {
    final harnessOnError = FlutterError.onError;
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));
    FlutterError.onError = harnessOnError;
  }

  group('Kinnav end to end', () {
    testWidgets('cold start lands on onboarding with the brand mark',
        (tester) async {
      await launch(tester);

      // A fresh install must not skip onboarding.
      expect(find.text('Welcome to Kinnav'), findsOneWidget);
      // The mark is an asset, so this fails if the asset is missing from the
      // bundle — something no widget test catches.
      expect(
        find.byWidgetPredicate((w) =>
            w is Image &&
            w.image is AssetImage &&
            (w.image as AssetImage).assetName.contains('kinnav_icon')),
        findsOneWidget,
      );
      await shoot('01-welcome');
    });

    testWidgets('walks onboarding, reaches the map, and opens the menu',
        (tester) async {
      await launch(tester);

      // Page through the walkthrough rather than skipping, so every slide is
      // exercised and its copy asserted.
      for (final title in [
        'Press a button',
        'Guardians stay with you',
        'Grow & get rewarded',
      ]) {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
        expect(find.text(title), findsOneWidget);
      }

      // Last slide completes onboarding.
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(appState.onboarded, isTrue);

      // Real sign-in needs a network round trip. The debug-only "Demo mode"
      // button does the same thing, but the harness cannot tap it — it sits
      // behind an IgnorePointer during the route swap — so seed the session
      // through the state API it calls. The screens themselves are still
      // driven by real taps below.
      await appState.enterDemoMode();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('CALL GUARDIANS'), findsOneWidget);
      await shoot('02-guardian-map');

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      expect(find.text('Contact Us'), findsOneWidget);
      await shoot('03-menu');
    });

    testWidgets('reach-a-guardian offers every call type', (tester) async {
      await launch(tester);
      await _enterDemo(tester);

      await tester.tap(find.text('CALL GUARDIANS'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      for (final label in ['Voice Call', 'Video Call', 'Emergency']) {
        expect(find.text(label), findsOneWidget);
      }
      await shoot('04-reach-a-guardian');
    });

    testWidgets('About shows the support address the stores publish',
        (tester) async {
      await launch(tester);
      await _enterDemo(tester);

      await _openFromMenu(tester, 'About Us');

      await tester.dragUntilVisible(
        find.text(AppConfig.supportEmail),
        find.byType(Scrollable).first,
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // The listing's support URL and the app must name the same inbox.
      expect(find.text(AppConfig.supportEmail), findsOneWidget);
      expect(AppConfig.supportEmail, 'support@kinnav.com');
      await shoot('05-about');
    });

    testWidgets('the legal screens link the published policy', (tester) async {
      await launch(tester);
      await _enterDemo(tester);

      await _openFromMenu(tester, 'About Us');

      await tester.dragUntilVisible(
        find.text('Privacy Policy'),
        find.byType(Scrollable).first,
        const Offset(0, -300),
      );
      await tester.tap(find.text('Privacy Policy'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // A reviewer opening the listing's policy URL must see the same document
      // the app points at, so the button has to be present.
      expect(find.textContaining('kinnav.com'), findsWidgets);
      expect(find.textContaining('pending legal review'), findsNothing);
      await shoot('06-privacy');
    });

    testWidgets('feedback refuses an empty submission', (tester) async {
      await launch(tester);
      await _enterDemo(tester);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Feedback'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('Send feedback'));
      await tester.pumpAndSettle();

      // It used to accept anything and silently discard it.
      expect(find.text('Add a rating or a note first.'), findsOneWidget);
      await shoot('07-feedback');
    });
  });
}

/// Puts the app on the home map so a test can start from there.
///
/// Uses the same state transition the debug "Demo mode" button performs.
/// Tapping that button is not reliable under the harness (it is briefly
/// behind an IgnorePointer while the root route swaps), and these tests are
/// about the screens past sign-in, not about sign-in itself.
Future<void> _openFromMenu(WidgetTester tester, String item) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  final entry = find.text(item);
  expect(entry, findsOneWidget, reason: 'drawer should list "$item"');
  await tester.ensureVisible(entry);
  await tester.pumpAndSettle();
  await tester.tap(entry);
  // Give the route push time to settle before anything is looked up.
  await tester.pumpAndSettle(const Duration(seconds: 3));
  expect(find.byType(Scrollable), findsWidgets,
      reason: '"$item" should have opened a scrollable screen');
}

Future<void> _enterDemo(WidgetTester tester) async {
  await appState.enterDemoMode();
  await tester.pumpAndSettle(const Duration(seconds: 5));
  expect(find.text('CALL GUARDIANS'), findsOneWidget,
      reason: 'demo session should land on the home map');
}

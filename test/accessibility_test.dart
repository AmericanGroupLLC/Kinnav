import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kinnav/app_state.dart';
import 'package:kinnav/main.dart';
import 'package:kinnav/services/storage.dart';

/// UI and UX guarantees, checked with Flutter's own accessibility guidelines.
///
/// A safety app is used one-handed, in a hurry, sometimes by someone with a
/// screen reader on. Tap targets that are too small, controls with no label and
/// text that cannot be read against its background all matter more here than in
/// an ordinary app.
void main() {
  Future<void> bootOnboarding() async {
    SharedPreferences.setMockInitialValues({});
    final storage = await Storage.init();
    appState = AppState(storage);
  }

  Future<void> bootHome() async {
    SharedPreferences.setMockInitialValues({});
    final storage = await Storage.init();
    appState = AppState(storage);
    await appState.enterDemoMode();
  }

  testWidgets('onboarding meets the tap target and labelling guidelines',
      (tester) async {
    await bootOnboarding();
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    handle.dispose();
  });

  testWidgets('the guardian map meets the tap target and labelling guidelines',
      (tester) async {
    await bootHome();
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    handle.dispose();
  });

  testWidgets('the call options screen stays reachable by touch', (tester) async {
    await bootHome();
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('CALL GUARDIANS'));
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    handle.dispose();
  });

  testWidgets('the primary action is announced to a screen reader',
      (tester) async {
    await bootHome();
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    expect(
      find.bySemanticsLabel(RegExp('call guardians', caseSensitive: false)),
      findsAtLeastNWidgets(1),
    );

    handle.dispose();
  });

  testWidgets('the app renders on a small phone without overflowing',
      (tester) async {
    // iPhone SE logical size — the narrowest screen the app targets.
    tester.view.physicalSize = const Size(320 * 2, 568 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await bootHome();
    final errors = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = errors.add;

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    FlutterError.onError = previous;
    final overflows = errors
        .where((e) => e.exceptionAsString().contains('overflowed'))
        .map((e) => '${e.exceptionAsString()} | ${e.context} | ${e.library}')
        .toList();

    expect(overflows, isEmpty);
  });

  testWidgets('the app renders on a tablet without overflowing', (tester) async {
    tester.view.physicalSize = const Size(834 * 2, 1112 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await bootHome();
    final errors = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = errors.add;

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    FlutterError.onError = previous;
    expect(
      errors.where((e) => e.exceptionAsString().contains('overflowed')).toList(),
      isEmpty,
    );
  });

  testWidgets('larger system text does not break the map screen',
      (tester) async {
    await bootHome();
    final errors = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = errors.add;

    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
        child: KinnavApp(),
      ),
    );
    await tester.pumpAndSettle();

    FlutterError.onError = previous;
    expect(
      errors.where((e) => e.exceptionAsString().contains('overflowed')).toList(),
      isEmpty,
      reason: 'text at 150% must still fit',
    );
  });
}

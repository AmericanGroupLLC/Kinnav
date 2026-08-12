import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kinnav/app_state.dart';
import 'package:kinnav/main.dart';
import 'package:kinnav/services/storage.dart';

/// Performance guards.
///
/// Thresholds are deliberately loose — this runs on whatever machine CI gives
/// us, and the point is to catch a regression of the "someone added a
/// synchronous 3-second thing to startup" kind, not to benchmark the device.
void main() {
  Future<void> bootDemo() async {
    SharedPreferences.setMockInitialValues({});
    final storage = await Storage.init();
    appState = AppState(storage);
    await appState.enterDemoMode();
  }

  testWidgets('the first frame renders promptly on a cold start', (tester) async {
    await bootDemo();

    final stopwatch = Stopwatch()..start();
    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();
    stopwatch.stop();

    expect(find.text('CALL GUARDIANS'), findsOneWidget);
    expect(stopwatch.elapsedMilliseconds, lessThan(3000),
        reason: 'cold start took ${stopwatch.elapsedMilliseconds}ms');
  });

  testWidgets('the map screen settles without an animation that never ends',
      (tester) async {
    await bootDemo();
    await tester.pumpWidget(const KinnavApp());

    // pumpAndSettle throws if frames keep being scheduled past the timeout,
    // which is how a runaway repeating animation shows up.
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('opening the call options stays responsive', (tester) async {
    await bootDemo();
    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    final stopwatch = Stopwatch()..start();
    await tester.tap(find.text('CALL GUARDIANS'));
    await tester.pumpAndSettle();
    stopwatch.stop();

    expect(stopwatch.elapsedMilliseconds, lessThan(2000),
        reason: 'call options took ${stopwatch.elapsedMilliseconds}ms to open');
  });

  test('bundled assets stay under 5 MB', () {
    final dir = Directory('assets');
    final bytes = dir
        .listSync(recursive: true)
        .whereType<File>()
        .fold<int>(0, (sum, f) => sum + f.lengthSync());

    expect(bytes, lessThan(5 * 1024 * 1024),
        reason: '${(bytes / 1024 / 1024).toStringAsFixed(1)}MB of assets ship in the binary');
  });

  test('no single asset is larger than 2 MB', () {
    final oversized = Directory('assets')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.lengthSync() > 2 * 1024 * 1024)
        .map((f) => '${f.path} ${(f.lengthSync() / 1024).round()}KB')
        .toList();

    expect(oversized, isEmpty);
  });

  test('data-driven lists are built lazily', () {
    // Screens that render a collection (guardians, call history) must use a
    // builder so the cost does not scale with the number of items.
    for (final path in ['lib/screens/home_map_screen.dart', 'lib/screens/call_history_screen.dart']) {
      final source = File(path).readAsStringSync();
      expect(source, anyOf(contains('ListView.builder'), contains('ListView.separated')),
          reason: '$path should not build every row up front');
    }
  });
}

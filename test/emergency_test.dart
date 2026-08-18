import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinnav/config/app_config.dart';
import 'package:kinnav/l10n/l10n.dart';
import 'package:kinnav/services/emergency.dart';

/// [Emergency.confirmAndDial] reports whether a call was actually placed.
///
/// It used to return void, so callers could not tell "dialled" from
/// "cancelled". `SafeCallScreen` assumed the former and showed "Police added"
/// either way — the app claiming help was on the way when nobody was called.
void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  // Answer url_launcher so the dial resolves deterministically instead of
  // leaving confirmAndDial suspended on a missing plugin.
  const launcherChannel = MethodChannel('plugins.flutter.io/url_launcher');
  final launched = <String>[];
  setUp(() {
    launched.clear();
    binding.defaultBinaryMessenger
        .setMockMethodCallHandler(launcherChannel, (call) async {
      if (call.method == 'launch') {
        launched.add((call.arguments as Map)['url'] as String);
      }
      return true;
    });
  });
  tearDown(() {
    binding.defaultBinaryMessenger
        .setMockMethodCallHandler(launcherChannel, null);
  });

  Future<bool?> tapAndAnswer(WidgetTester tester, String action) async {
    bool? result;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await Emergency.confirmAndDial(context);
            },
            child: const Text('go'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    // The dialog must appear before anything can be dialled.
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text(action));
    await tester.pumpAndSettle();
    return result;
  }

  testWidgets('returns false when the user cancels', (tester) async {
    expect(await tapAndAnswer(tester, 'Cancel'), isFalse);
  });

  testWidgets('returns true and dials when the user confirms', (tester) async {
    final label = 'Call ${AppConfig.emergencyNumber}';
    expect(await tapAndAnswer(tester, label), isTrue);
    expect(launched, ['tel:${AppConfig.emergencyNumber}']);
  });

  testWidgets('dials nothing when the user cancels', (tester) async {
    await tapAndAnswer(tester, 'Cancel');
    expect(launched, isEmpty);
  });

  testWidgets('asks before dialling, naming the number', (tester) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Emergency.confirmAndDial(context),
            child: const Text('go'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    expect(
      find.text('Call emergency services (${AppConfig.emergencyNumber})?'),
      findsOneWidget,
    );
  });
}

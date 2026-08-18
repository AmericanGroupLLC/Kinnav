import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinnav/l10n/l10n.dart';

/// Guards the localisation setup.
///
/// The failure mode these catch is a locale that silently falls back to
/// English for a handful of strings — the app looks translated until the user
/// reaches the screen that was missed. On a safety app the emergency and
/// disclosure strings are the worst ones to leave in the wrong language.
void main() {
  final arbDir = Directory('lib/l10n');

  Map<String, dynamic> readArb(String locale) =>
      jsonDecode(File('${arbDir.path}/app_$locale.arb').readAsStringSync())
          as Map<String, dynamic>;

  /// Translatable keys only — `@@locale` and `@key` metadata are not strings.
  Set<String> messageKeys(Map<String, dynamic> arb) =>
      arb.keys.where((k) => !k.startsWith('@')).toSet();

  final localeCodes = arbDir
      .listSync()
      .whereType<File>()
      .map((f) => RegExp(r'app_(\w+)\.arb$').firstMatch(f.path)?.group(1))
      .whereType<String>()
      .toList()
    ..sort();

  test('there is more than one locale', () {
    expect(localeCodes, contains('en'));
    expect(localeCodes.length, greaterThan(1),
        reason: 'i18n with a single locale is not internationalised');
  });

  test('every locale translates every key in the English template', () {
    final template = messageKeys(readArb('en'));
    expect(template, isNotEmpty);

    for (final code in localeCodes.where((c) => c != 'en')) {
      final keys = messageKeys(readArb(code));
      expect(template.difference(keys), isEmpty,
          reason: 'app_$code.arb is missing keys present in app_en.arb');
      expect(keys.difference(template), isEmpty,
          reason: 'app_$code.arb has keys that app_en.arb does not define');
    }
  });

  test('no locale has left a value untranslated as an empty string', () {
    for (final code in localeCodes) {
      final arb = readArb(code);
      for (final key in messageKeys(arb)) {
        expect((arb[key] as String).trim(), isNotEmpty,
            reason: '$key is empty in app_$code.arb');
      }
    }
  });

  test('every ARB file is declared in supportedLocales', () {
    final supported =
        AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet();
    expect(supported, containsAll(localeCodes),
        reason: 'add the locale to preferred-supported-locales in l10n.yaml '
            'and re-run `flutter gen-l10n`');
  });

  testWidgets('each locale resolves and renders its own copy', (tester) async {
    final seen = <String, String>{};
    for (final locale in AppLocalizations.supportedLocales) {
      late AppLocalizations strings;
      await tester.pumpWidget(MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(builder: (context) {
          strings = context.l10n;
          return Text(strings.safeCallTitle);
        }),
      ));
      await tester.pumpAndSettle();
      seen[locale.languageCode] = strings.safeCallTitle;

      // The simulated-call disclosure must exist in every language; falling
      // back to English here would bury the one message users must not miss.
      expect(strings.safeCallSimulatedBadge.trim(), isNotEmpty);
    }

    // English and the translations should not all be the same string, which is
    // what a missing delegate or an untranslated ARB would produce.
    expect(seen.values.toSet().length, greaterThan(1),
        reason: 'every locale rendered the same text: $seen');
  });

  testWidgets('Arabic lays out right-to-left', (tester) async {
    late TextDirection direction;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: (context) {
        direction = Directionality.of(context);
        return const SizedBox();
      }),
    ));
    await tester.pumpAndSettle();
    expect(direction, TextDirection.rtl);
  });

  testWidgets('an unsupported locale falls back to English, not to a crash',
      (tester) async {
    late AppLocalizations strings;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('is'), // Icelandic — deliberately not translated
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: (context) {
        strings = context.l10n;
        return const SizedBox();
      }),
    ));
    await tester.pumpAndSettle();
    expect(strings.safeCallTitle, 'Safe Call');
  });
}

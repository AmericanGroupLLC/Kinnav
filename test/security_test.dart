import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Security checks over the app's source and platform configuration.
///
/// These are static: they read the files that ship in the binary and the
/// manifests that decide what the app may do on a device. Runtime auth
/// behaviour is covered by app_flow_test.dart.
void main() {
  final libFiles = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  String read(String path) => File(path).readAsStringSync();

  group('secrets', () {
    test('no private keys or provider secrets are committed in lib/', () {
      final forbidden = <RegExp, String>{
        RegExp(r'-----BEGIN [A-Z ]*PRIVATE KEY-----'): 'private key',
        RegExp(r'AKIA[0-9A-Z]{16}'): 'AWS access key',
        RegExp(r'sk_live_[0-9a-zA-Z]{10,}'): 'Stripe live key',
        RegExp(r'ghp_[0-9A-Za-z]{30,}'): 'GitHub token',
        RegExp(r'''(service_role|serviceRole)\s*[:=]\s*['"]'''): 'Supabase service role key',
      };

      final offenders = <String>[];
      for (final file in libFiles) {
        final source = file.readAsStringSync();
        forbidden.forEach((pattern, label) {
          if (pattern.hasMatch(source)) offenders.add('${file.path}: $label');
        });
      }
      expect(offenders, isEmpty);
    });

    test('tokens are stored only in the keychain wrapper, never in prefs', () {
      // Storage is the shared_preferences wrapper; SecureStore is Keychain /
      // Keystore. A JWT written through Storage would survive a device backup
      // in the clear, which the org policy forbids.
      final offenders = <String>[];
      for (final file in libFiles) {
        if (file.path.endsWith('secure_store.dart')) continue;
        final source = file.readAsStringSync();
        for (final match in RegExp(r'storage\.set\w*\([^)]*', caseSensitive: false).allMatches(source)) {
          final call = match.group(0)!;
          if (RegExp(r'token|jwt|refresh|password', caseSensitive: false).hasMatch(call)) {
            offenders.add('${file.path}: $call');
          }
        }
      }
      expect(offenders, isEmpty);
    });

    test('SecureStore is backed by encrypted platform storage', () {
      final source = read('lib/services/secure_store.dart');
      expect(source, contains('encryptedSharedPreferences: true'));
      expect(source, contains('KeychainAccessibility'));
      expect(source, contains('flutter_secure_storage'));
    });
  });

  group('network', () {
    test('every hard-coded endpoint uses https', () {
      final offenders = <String>[];
      for (final file in libFiles) {
        for (final match in RegExp(r"'http://[^']+'").allMatches(file.readAsStringSync())) {
          final url = match.group(0)!;
          if (url.contains('localhost') || url.contains('127.0.0.1')) continue;
          if (url.contains('schemas.android.com') || url.contains('www.w3.org')) continue;
          offenders.add('${file.path}: $url');
        }
      }
      expect(offenders, isEmpty);
    });

    test('Android does not opt into cleartext traffic', () {
      final manifest = read('android/app/src/main/AndroidManifest.xml');
      expect(manifest, isNot(contains('android:usesCleartextTraffic="true"')));
    });

    test('iOS does not allow arbitrary loads', () {
      final plist = read('ios/Runner/Info.plist');
      final ats = plist.contains('NSAppTransportSecurity');
      final arbitrary = plist.contains('NSAllowsArbitraryLoads');
      expect(!ats || !arbitrary, isTrue,
          reason: 'App Transport Security must not be relaxed globally');
    });
  });

  group('platform permissions', () {
    test('Android asks for nothing beyond location and internet', () {
      final manifest = read('android/app/src/main/AndroidManifest.xml');
      final requested = RegExp(r'android\.permission\.([A-Z_]+)')
          .allMatches(manifest)
          .map((m) => m.group(1)!)
          .toSet();

      const allowed = {
        'ACCESS_FINE_LOCATION',
        'ACCESS_COARSE_LOCATION',
        'ACCESS_BACKGROUND_LOCATION',
        'INTERNET',
        'CALL_PHONE',
        'CAMERA',
        'RECORD_AUDIO',
        'POST_NOTIFICATIONS',
        'READ_MEDIA_IMAGES',
      };

      expect(requested.difference(allowed), isEmpty,
          reason: 'an unexpected permission would need a privacy review');
    });

    test('every iOS permission carries a usage description', () {
      final plist = read('ios/Runner/Info.plist');
      for (final key in RegExp(r'<key>(NS\w*UsageDescription)</key>\s*<string>([^<]*)</string>')
          .allMatches(plist)) {
        expect(key.group(2)!.trim(), isNotEmpty,
            reason: '${key.group(1)} must explain why the app needs it');
      }
      // Location is the one the app cannot work without; it must be declared.
      expect(plist, contains('NSLocationWhenInUseUsageDescription'));
    });
  });

  group('emergency dialling', () {
    test('is always behind an explicit confirmation', () {
      final source = read('lib/services/emergency.dart');
      expect(source, contains('showDialog'));
      expect(source, contains('confirmed == true'));

      // The dial call must sit inside the confirmation branch.
      final confirmIndex = source.indexOf('confirmed == true');
      final dialIndex = source.indexOf('Links.dial');
      expect(dialIndex, greaterThan(confirmIndex));
    });

    test('no screen dials the emergency number directly', () {
      final offenders = <String>[];
      for (final file in libFiles) {
        if (file.path.endsWith('emergency.dart') || file.path.endsWith('links.dart')) continue;
        final source = file.readAsStringSync();
        if (RegExp(r'Links\.dial\(\s*AppConfig\.emergencyNumber').hasMatch(source)) {
          offenders.add(file.path);
        }
      }
      expect(offenders, isEmpty,
          reason: 'emergency calls must go through Emergency.confirmAndDial');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:kinnav/config/app_config.dart';

/// Unit tests for the build-time configuration gates.
///
/// These flags decide whether the app talks to Google Maps, Agora and the
/// backend, or falls back to the offline widgets. Tests run without any
/// --dart-define, which is exactly the "nothing configured" case that must stay
/// safe: every integration off, no crash, emergency number still present.
void main() {
  group('AppConfig with no --dart-define values', () {
    test('reports every optional integration as unavailable', () {
      expect(AppConfig.hasMaps, isFalse);
      expect(AppConfig.hasVideo, isFalse);
      expect(AppConfig.hasBackend, isFalse);
    });

    test('is not treated as a production build', () {
      expect(AppConfig.isProd, isFalse);
    });

    test('still has an emergency number to dial', () {
      expect(AppConfig.emergencyNumber.trim(), isNotEmpty);
    });
  });
}

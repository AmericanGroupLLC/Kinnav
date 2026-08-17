import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinnav/models/guardian.dart';
import 'package:kinnav/services/guardian_service.dart';
import 'package:kinnav/services/services.dart';

/// A stand-in backend, to prove the app reads guardians from the service
/// rather than from the bundled sample list.
class _FakeGuardians implements GuardianService {
  int refreshes = 0;

  static const _people = [
    Guardian(
      name: 'Nadia Rahman',
      distanceMiles: 0.4,
      languages: ['English'],
      online: true,
      color: Color(0xFF7E57C2),
      mapPos: Offset(0.3, 0.3),
    ),
    Guardian(
      name: 'Offline Person',
      distanceMiles: 0.2,
      languages: ['English'],
      online: false,
      color: Color(0xFF5C6BC0),
      mapPos: Offset(0.6, 0.6),
    ),
  ];

  @override
  List<Guardian> all() => _people;

  @override
  List<Guardian> nearby({int limit = 6}) => _people.take(limit).toList();

  @override
  List<Guardian> online({int limit = 4}) =>
      _people.where((g) => g.online).take(limit).toList();

  @override
  Future<void> refresh() async => refreshes++;
}

void main() {
  tearDown(services.reset);

  group('GuardianService', () {
    test('the default implementation serves the bundled sample data', () {
      expect(services.guardians, isA<MockGuardianService>());
      expect(services.guardians.all(), isNotEmpty);
      // Everything on screen today is sample data — this is the flag the app
      // uses to avoid implying the people shown are real responders.
      expect(services.guardiansAreSample, isTrue,
          reason: 'no backend is configured by default');
    });

    test('nearby is ordered by distance and respects the limit', () {
      final near = services.guardians.nearby(limit: 3);
      expect(near, hasLength(3));
      for (var i = 1; i < near.length; i++) {
        expect(near[i].distanceMiles,
            greaterThanOrEqualTo(near[i - 1].distanceMiles));
      }
    });

    test('online never returns someone who is unavailable', () {
      expect(services.guardians.online(limit: 99).every((g) => g.online), isTrue);
    });

    test('swapping the implementation is the only change a backend needs', () {
      // The point of the locator: one override, and every screen follows.
      final fake = _FakeGuardians();
      services.overrideGuardians(fake);

      expect(services.guardians.all().map((g) => g.name),
          contains('Nadia Rahman'));
      expect(services.guardians.all().map((g) => g.name),
          isNot(contains(kGuardians.first.name)));
      // An unavailable guardian must not be offered for a Safe Call.
      expect(services.guardians.online().map((g) => g.name),
          isNot(contains('Offline Person')));
    });

    test('reset restores the default so tests cannot leak into each other', () {
      services.overrideGuardians(_FakeGuardians());
      services.reset();
      expect(services.guardians, isA<MockGuardianService>());
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinnav/models/guardian.dart';
import 'package:kinnav/models/call_type.dart';
import 'package:kinnav/services/call_service.dart';
import 'package:kinnav/services/guardian_service.dart';
import 'package:kinnav/services/supabase_guardian_service.dart';
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
  _callAndBackendTests();

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

/// A call service that claims to be real, to prove the Safe Call disclosure
/// is driven by the service rather than hardcoded.
class _LiveCalls implements CallService {
  @override
  bool get isSimulated => false;
  @override
  Future<String> start(CallType type, Guardian guardian) async => 'ch-1';
  @override
  Future<void> end() async {}
}

void _callAndBackendTests() {
  group('CallService', () {
    tearDown(services.reset);

    test('calls are simulated by default and the app admits it', () {
      expect(services.calls, isA<MockCallService>());
      expect(services.callsAreSimulated, isTrue);
    });

    test('a real implementation clears the demo disclosure', () {
      services.overrideCalls(_LiveCalls());
      expect(services.callsAreSimulated, isFalse,
          reason: 'the Safe Call banner keys off this');
    });

    test('the mock connects nobody but still yields a channel id', () async {
      const svc = MockCallService();
      final id = await svc.start(CallType.voice, kGuardians.first);
      expect(id, startsWith('demo-'));
      await svc.end(); // must not throw when never connected
    });
  });

  group('SupabaseGuardianService', () {
    test('serves sample data until a fetch succeeds, and says so', () {
      final svc = SupabaseGuardianService();
      expect(svc.usingFallback, isTrue);
      expect(svc.all(), isNotEmpty,
          reason: 'a cold start must still draw a map');
    });

    test('a failed fetch leaves the app usable rather than throwing', () async {
      // Supabase is not initialised in a unit test, so this exercises the
      // real failure path: no network, no table, or RLS denial.
      final svc = SupabaseGuardianService();
      await svc.refresh();
      expect(svc.usingFallback, isTrue);
      expect(svc.all(), isNotEmpty);
    });

    test('distance is zero when the user position is unknown', () {
      // Guardians must not vanish just because location is unavailable.
      final svc = SupabaseGuardianService();
      expect(svc.nearby(limit: 1), hasLength(1));
    });
  });
}

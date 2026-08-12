import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinnav/models/call_record.dart';
import 'package:kinnav/models/call_type.dart';
import 'package:kinnav/models/content.dart';
import 'package:kinnav/models/guardian.dart';
import 'package:kinnav/models/safety_contact.dart';

void main() {
  group('Guardian', () {
    test('derives initials from one or two names', () {
      const single = Guardian(
        name: 'Naama',
        distanceMiles: 1,
        languages: ['English'],
        online: true,
        color: Color(0xFF000000),
        mapPos: Offset(0, 0),
      );
      expect(single.initials, 'N');

      const double_ = Guardian(
        name: 'charlotte reyes',
        distanceMiles: 1,
        languages: ['English'],
        online: true,
        color: Color(0xFF000000),
        mapPos: Offset(0, 0),
      );
      expect(double_.initials, 'CR');
    });

    test('the sample network is usable: named, reachable and on the map', () {
      expect(kGuardians, isNotEmpty);
      for (final g in kGuardians) {
        expect(g.name.trim(), isNotEmpty);
        expect(g.languages, isNotEmpty);
        expect(g.distanceMiles, greaterThan(0));
        expect(g.mapPos.dx, inInclusiveRange(0, 1));
        expect(g.mapPos.dy, inInclusiveRange(0, 1));
      }
    });

    test('at least one guardian is online so the map is never empty', () {
      expect(kGuardians.where((g) => g.online), isNotEmpty);
    });
  });

  group('CallRecord', () {
    test('formats duration as mm:ss', () {
      CallRecord withSeconds(int s) => CallRecord(
            typeLabel: 'Voice',
            guardianCount: 1,
            durationSeconds: s,
            policeAdded: false,
            startedAtMs: 0,
          );

      expect(withSeconds(0).durationLabel, '00:00');
      expect(withSeconds(9).durationLabel, '00:09');
      expect(withSeconds(65).durationLabel, '01:05');
      expect(withSeconds(3600).durationLabel, '60:00');
    });

    test('round-trips through json', () {
      const record = CallRecord(
        typeLabel: 'Video',
        guardianCount: 3,
        durationSeconds: 125,
        policeAdded: true,
        startedAtMs: 1700000000000,
      );

      final restored = CallRecord.fromJson(record.toJson());
      expect(restored.typeLabel, record.typeLabel);
      expect(restored.guardianCount, record.guardianCount);
      expect(restored.durationSeconds, record.durationSeconds);
      expect(restored.policeAdded, isTrue);
      expect(restored.startedAtMs, record.startedAtMs);
    });

    test('survives a malformed or partial record from storage', () {
      final restored = CallRecord.fromJson({});
      expect(restored.typeLabel, 'Safe Call');
      expect(restored.guardianCount, 0);
      expect(restored.policeAdded, isFalse);
      expect(restored.durationLabel, '00:00');
    });
  });

  group('SafetyContact', () {
    test('round-trips through json', () {
      const contact = SafetyContact(
        name: 'Mum',
        phone: '+15551234567',
        relation: 'Family',
        colorValue: 0xFF9B59D0,
      );

      final restored = SafetyContact.fromJson(contact.toJson());
      expect(restored.name, 'Mum');
      expect(restored.phone, '+15551234567');
      expect(restored.relation, 'Family');
      expect(restored.color.toARGB32(), 0xFF9B59D0);
    });

    test('falls back rather than crashing on an empty stored record', () {
      final restored = SafetyContact.fromJson({});
      expect(restored.name, '');
      expect(restored.relation, 'Contact');
      expect(restored.initial, '?');
    });

    test('takes its avatar initial from the first letter', () {
      const contact = SafetyContact(name: 'ada', phone: '1', relation: 'Friend', colorValue: 0);
      expect(contact.initial, 'A');
    });
  });

  group('CallType', () {
    test('covers the four ways to reach a guardian', () {
      expect(CallType.values.length, greaterThanOrEqualTo(4));
      expect(CallType.values.map((t) => t.name), containsAll(['voice', 'video', 'text', 'emergency']));
    });
  });

  group('content', () {
    test('every empowerment module is presentable', () {
      expect(kModules, isNotEmpty);
      for (final m in kModules) {
        expect(m.title.trim(), isNotEmpty);
      }
    });

    test('every reward is presentable', () {
      expect(kRewards, isNotEmpty);
      for (final r in kRewards) {
        expect(r.title.trim(), isNotEmpty);
      }
    });
  });
}

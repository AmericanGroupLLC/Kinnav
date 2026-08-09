import 'package:flutter_test/flutter_test.dart';
import 'package:kinnav/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    const p = UserProfile(name: 'Gayatri Pat', birthMonth: 8, birthYear: 1989);

    test('computes age correctly', () {
      expect(p.ageAsOf(DateTime(2026, 9, 1)), 37);
      expect(p.ageAsOf(DateTime(2026, 7, 1)), 36); // before birth month
    });

    test('derives initials', () {
      expect(p.initials, 'GP');
      expect(const UserProfile(name: 'Mia', birthMonth: 1, birthYear: 2000)
          .initials, 'M');
    });

    test('round-trips through json', () {
      final j = p.toJson();
      final back = UserProfile.fromJson(j);
      expect(back.name, p.name);
      expect(back.birthMonth, p.birthMonth);
      expect(back.birthYear, p.birthYear);
    });
  });
}

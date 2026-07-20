import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safer/main.dart';

void main() {
  testWidgets('Home shows CALL GUARDIANS and guardians nearby',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SaferApp());

    expect(find.text('CALL GUARDIANS'), findsOneWidget);
    expect(find.text('Guardians Nearby'), findsOneWidget);
  });
}

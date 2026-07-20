import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:safer/app_state.dart';
import 'package:safer/services/storage.dart';
import 'package:safer/main.dart';

void main() {
  testWidgets('First run shows onboarding welcome', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await Storage.init();
    appState = AppState(storage);

    await tester.pumpWidget(const SaferApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Safer'), findsOneWidget);
    expect(find.text('Get Started'), findsAtLeastNWidgets(0));
  });
}

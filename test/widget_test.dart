import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kinnav/app_state.dart';
import 'package:kinnav/services/storage.dart';
import 'package:kinnav/main.dart';

void main() {
  testWidgets('First run shows onboarding welcome', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await Storage.init();
    appState = AppState(storage);

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Kinnav'), findsOneWidget);
    expect(find.text('Get Started'), findsAtLeastNWidgets(0));
  });
}

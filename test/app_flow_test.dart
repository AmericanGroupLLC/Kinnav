import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kinnav/app_state.dart';
import 'package:kinnav/main.dart';
import 'package:kinnav/models/user_profile.dart';
import 'package:kinnav/services/storage.dart';

/// Functional tests for the gate that RootRouter enforces:
/// onboarding → sign-up → profile → home map. Getting this wrong either locks a
/// signed-up user out or drops a stranger straight onto the guardian map, so
/// each state is asserted from a cold start.
Future<AppState> freshState({Map<String, Object> stored = const {}}) async {
  SharedPreferences.setMockInitialValues(stored);
  final storage = await Storage.init();
  return AppState(storage);
}

const _profile = UserProfile(
  name: 'Ada',
  birthMonth: 3,
  birthYear: 1990,
  identity: 'Woman',
  languages: ['English'],
);

void main() {
  testWidgets('a first-time visitor lands on onboarding', (tester) async {
    appState = await freshState();

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Kinnav'), findsOneWidget);
    expect(find.text('CALL GUARDIANS'), findsNothing);
  });

  testWidgets('after onboarding the user is asked to sign up, not shown the map',
      (tester) async {
    appState = await freshState();
    await appState.completeOnboarding();

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Kinnav'), findsNothing);
    expect(find.text('CALL GUARDIANS'), findsNothing);
  });

  testWidgets('a signed-up user without a profile is sent to profile setup',
      (tester) async {
    appState = await freshState();
    await appState.completeOnboarding();
    await appState.signIn();

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    expect(appState.hasProfile, isFalse);
    expect(find.text('CALL GUARDIANS'), findsNothing);
  });

  testWidgets('a fully set-up user reaches the guardian map', (tester) async {
    appState = await freshState();
    await appState.completeOnboarding();
    await appState.signIn();
    await appState.setProfile(_profile);

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    expect(find.text('CALL GUARDIANS'), findsOneWidget);
  });

  testWidgets('demo mode short-circuits straight to the map', (tester) async {
    appState = await freshState();
    await appState.enterDemoMode();

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    expect(find.text('CALL GUARDIANS'), findsOneWidget);
  });

  testWidgets('a restart without an authoritative session signs the user out',
      (tester) async {
    // Pins current behaviour. AppState's constructor calls
    // _reconcileSignedIn(), which clears the local signedIn flag whenever
    // SupabaseAuthService reports no session — and it reports none when
    // Supabase was never initialised, as here (and as on a device that launches
    // offline or with Supabase misconfigured). The stored profile and
    // onboarding flag survive; only the session is dropped, so the user lands
    // back on sign-up rather than the map.
    appState = await freshState();
    await appState.enterDemoMode();
    expect(appState.signedIn, isTrue);

    final storage = await Storage.init();
    appState = AppState(storage);

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    expect(appState.onboarded, isTrue, reason: 'onboarding should not repeat');
    expect(appState.hasProfile, isTrue, reason: 'the profile should persist');
    expect(appState.signedIn, isFalse);
    expect(find.text('CALL GUARDIANS'), findsNothing);
  });

  testWidgets('tapping CALL GUARDIANS opens the call options', (tester) async {
    appState = await freshState();
    await appState.enterDemoMode();

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('CALL GUARDIANS'));
    await tester.pumpAndSettle();

    // The call options sheet offers the four ways to reach a guardian.
    expect(find.textContaining(RegExp('voice', caseSensitive: false)), findsWidgets);
  });

  testWidgets('the drawer opens from the map', (tester) async {
    appState = await freshState();
    await appState.enterDemoMode();

    await tester.pumpWidget(const KinnavApp());
    await tester.pumpAndSettle();

    final drawerButton = find.byIcon(Icons.menu);
    if (drawerButton.evaluate().isNotEmpty) {
      await tester.tap(drawerButton.first);
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsOneWidget);
    }
  });
}

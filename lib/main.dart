import 'dart:async';
import 'package:flutter/material.dart';
import 'app_state.dart';
import 'services/analytics_service.dart';
import 'services/storage.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/home_map_screen.dart';

Future<void> main() async {
  // Route framework + uncaught errors to the analytics/crash boundary
  // (no-op today; Crashlytics/Sentry in production).
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      analytics.recordError(details.exception, details.stack);
    };
    final storage = await Storage.init();
    appState = AppState(storage);
    analytics.logEvent('app_open');
    runApp(const SaferApp());
  }, (error, stack) => analytics.recordError(error, stack));
}

class SaferApp extends StatelessWidget {
  const SaferApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const RootRouter(),
    );
  }
}

/// Chooses the entry screen based on session state, reacting to changes.
class RootRouter extends StatelessWidget {
  const RootRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        if (!appState.onboarded) return const OnboardingScreen();
        if (!appState.signedIn) return const SignUpScreen();
        if (!appState.hasProfile) return const ProfileSetupScreen();
        return const HomeMapScreen();
      },
    );
  }
}

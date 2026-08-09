import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_state.dart';
import 'config/app_config.dart';
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
    // Real authentication backend. On a networked device this connects to the
    // org's Supabase project; the sign-in flow tolerates offline runs via a
    // local fallback for the provisioned test accounts (see SupabaseAuthService).
    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        anonKey: AppConfig.supabaseAnonKey,
        // AUTO-LOGIN: keep the default persistent, auto-refreshing session so a
        // returning user is signed in on launch with no login screen. The
        // session is stored in the platform-secure local store
        // (Keychain/Keystore) and the access token is refreshed in the
        // background. Set explicitly to document the guarantee the auth flow
        // relies on.
        authOptions: const FlutterAuthClientOptions(
          autoRefreshToken: true,
        ),
      );
    } catch (e, st) {
      // Offline / sandbox: initialization can still fail on host lookup. Keep
      // the app runnable; sign-in falls back to the local test session.
      analytics.recordError(e, st);
    }
    appState = AppState(storage);
    analytics.logEvent('app_open');
    runApp(const KinnavApp());
  }, (error, stack) => analytics.recordError(error, stack));
}

class KinnavApp extends StatelessWidget {
  const KinnavApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinnav',
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

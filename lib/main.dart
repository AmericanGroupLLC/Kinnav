import 'package:flutter/material.dart';
import 'app_state.dart';
import 'services/storage.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/home_map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await Storage.init();
  appState = AppState(storage);
  runApp(const SaferApp());
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

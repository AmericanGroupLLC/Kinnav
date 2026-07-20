import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme/app_theme.dart';

/// First-run walkthrough. Completing it sets the onboarded flag and routes on.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _slides = [
    _Slide(
      icon: Icons.shield_moon_outlined,
      title: 'Welcome to Safer',
      body:
          'A new way of women safety and empowerment — help, anywhere, anytime.',
    ),
    _Slide(
      icon: Icons.touch_app,
      title: 'Press a button',
      body:
          'Tap CALL GUARDIANS and choose voice, video, text or emergency to connect.',
    ),
    _Slide(
      icon: Icons.diversity_1,
      title: 'Guardians stay with you',
      body:
          'Vetted women nearby talk to you until you feel safe — no time limit, no judgment.',
    ),
    _Slide(
      icon: Icons.volunteer_activism,
      title: 'Grow & get rewarded',
      body:
          'Self-care modules and wellness rewards to help you flourish beyond safety.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isLast => _page == _slides.length - 1;

  void _next() {
    if (_isLast) {
      appState.completeOnboarding();
    } else {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => appState.completeOnboarding(),
                child: const Text('Skip',
                    style: TextStyle(color: AppColors.textMuted)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _slides[i],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _slides.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(4),
                    width: i == _page ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _page
                          ? AppColors.primary
                          : AppColors.primaryLight.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: _next,
                  child: Text(_isLast ? 'Get Started' : 'Next',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            // Dev/testing only: skip straight into the app.
            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OutlinedButton.icon(
                  onPressed: () => appState.enterDemoMode(),
                  icon: const Icon(Icons.bolt, size: 18),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    side: const BorderSide(color: AppColors.primaryLight),
                  ),
                  label: const Text('Demo mode (dev) — skip to app'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _Slide({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 64, color: Colors.white),
          ),
          const SizedBox(height: 32),
          Text(title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Text(body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16, color: AppColors.textMuted, height: 1.5)),
        ],
      ),
    );
  }
}

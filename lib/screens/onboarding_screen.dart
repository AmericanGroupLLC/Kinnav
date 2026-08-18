import 'package:flutter/material.dart';
import '../app_state.dart';
import '../config/app_config.dart';
import '../l10n/l10n.dart';
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

  /// Built per-build rather than held in a `const` list: the copy comes from
  /// the active locale, which can change while the app is running.
  static List<_Slide> _slidesFor(AppLocalizations s) => [
        _Slide(
          logoAsset: 'assets/logo/kinnav_icon.png',
          title: s.onboardingWelcomeTitle,
          body: s.onboardingWelcomeBody,
        ),
        _Slide(
          icon: Icons.touch_app,
          title: s.onboardingPressTitle,
          body: s.onboardingPressBody,
        ),
        _Slide(
          icon: Icons.diversity_1,
          title: s.onboardingGuardiansTitle,
          body: s.onboardingGuardiansBody,
        ),
        _Slide(
          icon: Icons.volunteer_activism,
          title: s.onboardingRewardsTitle,
          body: s.onboardingRewardsBody,
        ),
      ];

  /// The page count is fixed even though the copy is not.
  static const _slideCount = 4;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isLast => _page == _slideCount - 1;

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
    final strings = context.l10n;
    final slides = _slidesFor(strings);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => appState.completeOnboarding(),
                child: Text(strings.actionSkip,
                    style: const TextStyle(color: AppColors.textMuted)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => slides[i],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < slides.length; i++)
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
                  child: Text(
                      _isLast ? strings.actionGetStarted : strings.actionNext,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
            // Dev/testing only: skip straight into the app.
            if (AppConfig.showDevShortcuts)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OutlinedButton.icon(
                  onPressed: () => appState.enterDemoMode(),
                  icon: const Icon(Icons.bolt, size: 18),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    side: const BorderSide(color: AppColors.primaryLight),
                  ),
                  label: Text(strings.onboardingDemoMode),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// One walkthrough page. The first shows the Kinnav mark itself, the rest a
/// Material icon, so exactly one of [icon] and [logoAsset] is given.
class _Slide extends StatelessWidget {
  final IconData? icon;
  final String? logoAsset;
  final String title;
  final String body;
  const _Slide({
    this.icon,
    this.logoAsset,
    required this.title,
    required this.body,
  }) : assert((icon == null) != (logoAsset == null),
            'a slide shows either an icon or the logo, not both');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              // The mark is full-colour lavender and gold; on the gradient it
              // would disappear into the background, so it sits on white.
              gradient: logoAsset == null ? AppColors.primaryGradient : null,
              color: logoAsset == null ? null : Colors.white,
              shape: BoxShape.circle,
              border: logoAsset == null
                  ? null
                  : Border.all(color: AppColors.lavenderCard, width: 2),
            ),
            child: logoAsset == null
                ? Icon(icon, size: 64, color: Colors.white)
                : Image.asset(logoAsset!, width: 64, height: 64),
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

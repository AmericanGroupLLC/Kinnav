import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A simple, swipeable "How to use Safer" walkthrough mirroring the reference
/// tutorial ("1. Press a button", "2. Get a video call", …).
class HowToUseScreen extends StatefulWidget {
  const HowToUseScreen({super.key});

  @override
  State<HowToUseScreen> createState() => _HowToUseScreenState();
}

class _HowToUseScreenState extends State<HowToUseScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _steps = [
    _Step(
      icon: Icons.touch_app,
      title: '1. Press a button',
      body: 'Tap CALL GUARDIANS and choose how to connect — voice, video, '
          'text or emergency.',
    ),
    _Step(
      icon: Icons.videocam,
      title: '2. Get a video call',
      body: 'Vetted guardians nearby answer within seconds and can see your '
          'location on the map.',
    ),
    _Step(
      icon: Icons.diversity_1,
      title: '3. Guardians stay with you',
      body: 'They talk to you until you feel safe — no time limit, no judgment. '
          'Add the police any time.',
    ),
    _Step(
      icon: Icons.favorite,
      title: '4. Back to safety',
      body: 'Thank your guardians and end the call. Earn rewards and grow with '
          'self-care modules.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isLast => _page == _steps.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('How to use Safer')),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _steps.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) => _steps[i],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < _steps.length; i++)
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
                onPressed: () {
                  if (_isLast) {
                    Navigator.of(context).maybePop();
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                },
                child: Text(_isLast ? 'Got it' : 'Next',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _Step({required this.icon, required this.title, required this.body});

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
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w700)),
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

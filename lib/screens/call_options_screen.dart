import 'package:flutter/material.dart';
import '../models/call_type.dart';
import '../theme/app_theme.dart';
import 'safe_call_screen.dart';
import 'chat_screen.dart';

/// Choose how to reach guardians (voice / video / text / emergency), then
/// slide down to activate — echoing the "1. Press a button" reference flow.
class CallOptionsScreen extends StatefulWidget {
  const CallOptionsScreen({super.key});

  @override
  State<CallOptionsScreen> createState() => _CallOptionsScreenState();
}

class _CallOptionsScreenState extends State<CallOptionsScreen> {
  CallType _selected = CallType.video;
  double _drag = 0; // 0..1 slide progress

  void _activate() {
    if (_selected == CallType.text) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ChatScreen()),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SafeCallScreen(callType: _selected),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEmergency = _selected == CallType.emergency;
    return Scaffold(
      backgroundColor: const Color(0xFF161421),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const Text('Reach a Guardian',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose how you want to connect, then slide down.',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: [
                  for (final t in CallType.values)
                    _OptionDot(
                      type: t,
                      selected: _selected == t,
                      onTap: () => setState(() => _selected = t),
                    ),
                ],
              ),
              const Spacer(),
              _SlideToActivate(
                progress: _drag,
                color: isEmergency ? AppColors.danger : AppColors.primary,
                label: 'Slide Down',
                onDrag: (v) => setState(() => _drag = v),
                onComplete: _activate,
              ),
              const SizedBox(height: 24),
              const Icon(Icons.keyboard_double_arrow_down,
                  color: Colors.white38, size: 32),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionDot extends StatelessWidget {
  final CallType type;
  final bool selected;
  final VoidCallback onTap;
  const _OptionDot(
      {required this.type, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color =
        type == CallType.emergency ? AppColors.danger : AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            Text(type.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.white54,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                )),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: selected ? color : Colors.white12,
                shape: BoxShape.circle,
                border: Border.all(
                    color: selected ? Colors.white : Colors.white24, width: 2),
              ),
              child: Icon(type.icon,
                  color: selected ? Colors.white : Colors.white54, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}

/// A draggable pill the user pulls down to activate the call.
class _SlideToActivate extends StatelessWidget {
  final double progress;
  final Color color;
  final String label;
  final ValueChanged<double> onDrag;
  final VoidCallback onComplete;

  const _SlideToActivate({
    required this.progress,
    required this.color,
    required this.label,
    required this.onDrag,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    const double travel = 90;
    return GestureDetector(
      onVerticalDragUpdate: (d) {
        final next = (progress + d.delta.dy / travel).clamp(0.0, 1.0);
        onDrag(next);
      },
      onVerticalDragEnd: (_) {
        if (progress >= 0.85) {
          onComplete();
        } else {
          onDrag(0);
        }
      },
      onTap: onComplete, // tapping also activates for accessibility
      child: Transform.translate(
        offset: Offset(0, progress * travel),
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 24,
                  spreadRadius: 4),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

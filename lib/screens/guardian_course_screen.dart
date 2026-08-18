import 'package:flutter/material.dart';
import '../app_state.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';

/// The 40-hour advocacy course guardians complete (virtual, NGO-trained).
/// Modelled as [AppState.totalGuardianCourseSteps] units; completing all
/// verifies the user as a guardian.
class GuardianCourseScreen extends StatelessWidget {
  const GuardianCourseScreen({super.key});

  static const _modules = [
    ('Understanding gender-based violence', 'Foundations & context'),
    ('Trauma-informed listening', 'Hold space without judgment'),
    ('De-escalation techniques', 'Keeping everyone safe'),
    ('Safety planning with survivors', 'Practical protection'),
    ('Boundaries & self-care', 'Sustainable advocacy'),
    ('Legal & reporting basics', 'When and how to involve police'),
    ('Cultural competency', 'Serving all women'),
    ('Certification assessment', 'Final review'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.courseGuardianCourse)),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final step = appState.guardianCourseStep;
          final total = AppState.totalGuardianCourseSteps;
          final complete = appState.isGuardianCourseComplete;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complete
                          ? 'Course complete — you are a verified Guardian! 💜'
                          : '40-hour Advocacy Course',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: step / total,
                        minHeight: 10,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('${appState.guardianCourseHoursDone} / 40 hours',
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < _modules.length; i++)
                _CourseTile(
                  index: i,
                  title: _modules[i].$1,
                  subtitle: _modules[i].$2,
                  done: i < step,
                  current: i == step,
                ),
              const SizedBox(height: 12),
              if (!complete)
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () => appState.advanceGuardianCourse(),
                  child: Text(
                      step == 0 ? 'Start course' : 'Complete next module',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified, color: AppColors.online),
                    const SizedBox(width: 8),
                    Text(context.l10n.courseVerifiedGuardian,
                        style: const TextStyle(
                            color: AppColors.online,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  final bool done;
  final bool current;
  const _CourseTile({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.done,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: current ? AppColors.lavenderCard : Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              done ? AppColors.online : AppColors.lavenderCard,
          child: done
              ? const Icon(Icons.check, color: Colors.white, size: 20)
              : Text('${index + 1}',
                  style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700)),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: current
            ? const Icon(Icons.play_circle_fill, color: AppColors.primary)
            : null,
      ),
    );
  }
}

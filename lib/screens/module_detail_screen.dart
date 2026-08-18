import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/content.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';

/// Detail for a Self Care & Empowerment module: lessons + completion tracking.
class ModuleDetailScreen extends StatelessWidget {
  final Module module;
  const ModuleDetailScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final lessons = module.lessons.isEmpty
        ? ['Introduction', 'Core practice', 'Putting it into action']
        : module.lessons;
    return Scaffold(
      appBar: AppBar(title: Text(module.title)),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final done = appState.isModuleComplete(module.title);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Icon(module.icon, color: Colors.white, size: 40),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(module.subtitle,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(context.l10n.moduleDetailLessons,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              for (int i = 0; i < lessons.length; i++)
                Card(
                  elevation: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.lavenderCard,
                      child: Text('${i + 1}',
                          style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700)),
                    ),
                    title: Text(lessons[i]),
                    trailing: const Icon(Icons.play_circle_outline,
                        color: AppColors.primary),
                  ),
                ),
              const SizedBox(height: 20),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor:
                      done ? AppColors.online : AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () => appState.toggleModuleComplete(module.title),
                icon: Icon(done ? Icons.check_circle : Icons.flag_outlined),
                label: Text(done ? 'Completed' : 'Mark as complete',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ],
          );
        },
      ),
    );
  }
}

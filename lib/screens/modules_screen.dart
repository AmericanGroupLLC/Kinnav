import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/content.dart';
import '../theme/app_theme.dart';
import 'module_detail_screen.dart';

/// Self Care & Empowerment Modules, from the app menu spec.
class ModulesScreen extends StatelessWidget {
  const ModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Self Care')),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final doneCount = kModules
              .where((m) => appState.isModuleComplete(m.title))
              .length;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Empowerment modules to help you grow, heal and thrive · '
                  '$doneCount of ${kModules.length} complete',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 15),
                ),
              ),
              for (final m in kModules)
                _ModuleTile(
                  module: m,
                  complete: appState.isModuleComplete(m.title),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  final Module module;
  final bool complete;
  const _ModuleTile({required this.module, required this.complete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.lavenderCard,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(module.icon, color: AppColors.primaryDark),
        ),
        title: Text(module.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text(module.subtitle,
            style: const TextStyle(color: AppColors.textMuted)),
        trailing: complete
            ? const Icon(Icons.check_circle, color: AppColors.online)
            : const Icon(Icons.chevron_right, color: AppColors.textMuted),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ModuleDetailScreen(module: module)),
        ),
      ),
    );
  }
}

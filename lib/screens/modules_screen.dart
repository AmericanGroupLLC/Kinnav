import 'package:flutter/material.dart';
import '../models/content.dart';
import '../theme/app_theme.dart';

/// Self Care & Empowerment Modules, from the app menu spec.
class ModulesScreen extends StatelessWidget {
  const ModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Self Care')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Empowerment modules to help you grow, heal and thrive.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 15),
            ),
          ),
          for (final m in kModules) _ModuleTile(module: m),
        ],
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  final Module module;
  const _ModuleTile({required this.module});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
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
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        children: module.lessons.isEmpty
            ? [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text('Guided lessons coming to your dashboard.',
                        style: TextStyle(color: AppColors.textMuted)),
                  ),
                )
              ]
            : [
                for (final l in module.lessons)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.check_circle_outline,
                        color: AppColors.primary, size: 20),
                    title: Text(l),
                  ),
              ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/guardian.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar.dart';
import '../widgets/primary_button.dart';

/// Shows nearby guardians and the path to becoming one.
class GuardiansScreen extends StatelessWidget {
  const GuardiansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guardians')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Become a Guardian',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Vetted women complete a 40-hour advocacy course, trained '
                  'virtually by local non-profits. Speak to women in need until '
                  'they feel safe — no time limit, no judgment.',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'APPLY TO BECOME A GUARDIAN',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Application started — check your email.'),
                        backgroundColor: AppColors.primaryDark,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('Guardians near you',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          for (final g in kGuardians) _GuardianTile(guardian: g),
        ],
      ),
    );
  }
}

class _GuardianTile extends StatelessWidget {
  final Guardian guardian;
  const _GuardianTile({required this.guardian});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            InitialsAvatar(
              initials: guardian.initials,
              color: guardian.color,
              size: 52,
              showOnlineDot: true,
              online: guardian.online,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(guardian.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                    '${guardian.distanceMiles} mi · ${guardian.languages.join(", ")}',
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            Text(
              guardian.online ? 'Available' : 'Offline',
              style: TextStyle(
                color: guardian.online ? AppColors.online : AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

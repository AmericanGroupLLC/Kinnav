import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/guardian.dart';
import '../services/services.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar.dart';
import 'guardian_course_screen.dart';

/// Guardian hub: become-a-guardian path (40h course), guardian dashboard when
/// verified, and the directory of nearby guardians.
class GuardiansScreen extends StatelessWidget {
  const GuardiansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.guardiansGuardians)),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final verified = appState.isGuardianCourseComplete;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              verified ? _dashboard(context) : _becomeCard(context),
              const SizedBox(height: 22),
              Text(context.l10n.guardiansNearYou,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              for (final g in services.guardians.all()) _GuardianTile(guardian: g),
            ],
          );
        },
      ),
    );
  }

  Widget _becomeCard(BuildContext context) {
    final step = appState.guardianCourseStep;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.guardiansBecomeGuardian,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            context.l10n.guardiansBecomeBlurb,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const GuardianCourseScreen())),
              child: Text(
                  step == 0
                      ? 'Start 40-hour course'
                      : 'Continue course (${appState.guardianCourseHoursDone}/40h)',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified, color: AppColors.online),
              const SizedBox(width: 8),
              Text(context.l10n.guardiansVerifiedGuardian,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.primary,
            value: appState.guardianAvailable,
            onChanged: (v) => appState.setGuardianAvailable(v),
            title: Text(context.l10n.guardiansAvailableHelp),
            subtitle: Text(appState.guardianAvailable
                ? 'You may receive Safe Call requests'
                : 'You are offline'),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Stat(label: context.l10n.guardiansCalls, value: '0'),
              _Stat(label: context.l10n.guardiansHours, value: '0'),
              _Stat(label: context.l10n.guardiansEarnings, value: '\$0'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.guardiansPayoutNote,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark)),
        Text(label, style: const TextStyle(color: AppColors.textMuted)),
      ],
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

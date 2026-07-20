import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar.dart';

/// The member's profile, backed by persisted [AppState].
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _months = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final UserProfile? p = appState.profile;
          if (p == null) {
            return const Center(child: Text('No profile'));
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        InitialsAvatar(
                          initials: p.initials,
                          color: AppColors.primary,
                          size: 110,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryDark,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(p.isGuardian ? 'Guardian' : 'Community Member',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _field('Name', p.name),
              _field('Month and year of birth',
                  '${_months[p.birthMonth]} ${p.birthYear}'),
              _field('I define myself as', p.identity),
              _field('Spoken Languages', p.languages.join(', ')),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Profile edit request sent for review.'),
                        backgroundColor: AppColors.primaryDark),
                  ),
                  child: const Text('REQUEST PROFILE EDIT',
                      style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => _confirmDelete(context),
                  child: const Text('DELETE ACCOUNT',
                      style: TextStyle(
                          color: AppColors.danger,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
            'This permanently removes your profile and data from this device.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Pop back to root; RootRouter will show onboarding.
              Navigator.of(context).popUntil((r) => r.isFirst);
              appState.deleteAccount();
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

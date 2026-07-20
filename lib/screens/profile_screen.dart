import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar.dart';

/// The member's profile, mirroring the reference "My Profile" screen.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    const InitialsAvatar(
                      initials: 'GP',
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
                const Text('Community Member',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _field('Name', 'Gayatri Pat'),
          _field('Month and year of birth', '08 / 1989'),
          _field('I define myself as', 'Woman'),
          _field('Spoken Languages', 'English, Hindi'),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('REQUEST PROFILE EDIT',
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('DELETE ACCOUNT',
                  style: TextStyle(
                      color: AppColors.danger, fontWeight: FontWeight.w700)),
            ),
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

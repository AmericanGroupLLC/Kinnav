import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../app_state.dart';
import '../models/user_profile.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar.dart';
import 'profile_edit_screen.dart';

/// The member's profile, backed by persisted [AppState].
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _months = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  final ImagePicker _picker = ImagePicker();
  bool _pickingAvatar = false;

  Future<void> _pickAvatar() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(context.l10n.profileChooseFromLibrary),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(context.l10n.profileTakePhoto),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    setState(() => _pickingAvatar = true);
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        imageQuality: 85,
      );
      final profile = appState.profile;
      if (picked != null && profile != null) {
        await appState.setProfile(profile.copyWith(avatarPath: picked.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not update photo: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _pickingAvatar = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileMyProfile)),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final UserProfile? p = appState.profile;
          if (p == null) {
            return Center(child: Text(context.l10n.profileNoProfile));
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
                          imagePath: p.avatarPath,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Material(
                            color: AppColors.primaryDark,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _pickingAvatar ? null : _pickAvatar,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: _pickingAvatar
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2),
                                      )
                                    : const Icon(Icons.camera_alt,
                                        color: Colors.white, size: 18),
                              ),
                            ),
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
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const ProfileEditScreen()),
                  ),
                  child: Text(context.l10n.profileEditAction,
                      style: const TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => _confirmDelete(context),
                  child: Text(context.l10n.profileDeleteAction,
                      style: const TextStyle(
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
        title: Text(context.l10n.profileDeleteConfirmTitle),
        content: Text(
            context.l10n.profileDeleteConfirmBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.l10n.actionCancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Pop back to root; RootRouter will show onboarding.
              Navigator.of(context).popUntil((r) => r.isFirst);
              appState.deleteAccount();
            },
            child: Text(context.l10n.profileDelete,
                style: const TextStyle(color: AppColors.danger)),
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

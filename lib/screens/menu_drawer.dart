import 'package:flutter/material.dart';
import '../app_state.dart';
import '../config/app_config.dart';
import '../services/links.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar.dart';
import 'profile_screen.dart';
import 'guardians_screen.dart';
import 'modules_screen.dart';
import 'rewards_screen.dart';
import 'about_screen.dart';
import 'how_to_use_screen.dart';
import 'safety_contacts_screen.dart';
import 'feedback_screen.dart';
import 'subscription_screen.dart';
import 'call_history_screen.dart';

/// The slide-in navigation menu mirroring the app's information architecture.
class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.lavenderBg,
      child: SafeArea(
        child: ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            final p = appState.profile;
            final name = p?.name ?? 'Community Member';
            final initials = p?.initials ?? 'S';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Row(
                    children: [
                      InitialsAvatar(
                          initials: initials,
                          color: AppColors.primary,
                          size: 56),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            Text(
                              appState.isSubscribed
                                  ? 'Kinnav member'
                                  : (p?.isGuardian == true
                                      ? 'Guardian'
                                      : 'Community Member'),
                              style: const TextStyle(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _item(context, Icons.person_add_alt, 'Invite a Friend',
                          onTap: () => Links.sms('', context,
                              body:
                                  'Join me on Kinnav — a women\'s safety app. https://kinnav.com')),
                      _item(context, Icons.shield_outlined, 'Become a Guardian',
                          page: const GuardiansScreen()),
                      const Divider(),
                      _item(context, Icons.person_outline, 'My Profile',
                          page: const ProfileScreen()),
                      _item(context, Icons.group_outlined, 'My Safety Contacts',
                          page: const SafetyContactsScreen()),
                      _item(context, Icons.history, 'Safe Call History',
                          page: const CallHistoryScreen()),
                      _item(context, Icons.school_outlined,
                          'Self Care & Empowerment',
                          page: const ModulesScreen()),
                      _item(context, Icons.card_giftcard, 'Rewards',
                          page: const RewardsScreen()),
                      _item(context, Icons.workspace_premium_outlined,
                          'Membership',
                          page: const SubscriptionScreen()),
                      const Divider(),
                      _item(context, Icons.help_outline, 'How to use Kinnav',
                          page: const HowToUseScreen()),
                      _item(context, Icons.mail_outline, 'Contact Us',
                          onTap: () => Links.email(AppConfig.supportEmail,
                              context,
                              subject: 'Kinnav app enquiry')),
                      _item(context, Icons.edit_outlined, 'Feedback',
                          page: const FeedbackScreen()),
                      _item(context, Icons.info_outline, 'About Us',
                          page: const AboutScreen()),
                    ],
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _item(context, Icons.logout, 'Log out',
                          color: AppColors.primaryDark, onTap: () {
                        Navigator.of(context).popUntil((r) => r.isFirst);
                        appState.logOut();
                      }),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Text('Version 1.0.0',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label,
      {Widget? page, VoidCallback? onTap, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textDark),
      title: Text(label,
          style: TextStyle(
              color: color ?? AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.of(context).pop();
        if (page != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
        } else {
          onTap?.call();
        }
      },
    );
  }
}

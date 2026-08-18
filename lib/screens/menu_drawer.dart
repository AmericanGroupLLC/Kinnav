import 'package:flutter/material.dart';
import '../app_state.dart';
import '../config/app_config.dart';
import '../services/links.dart';
import '../l10n/l10n.dart';
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
                                  ? context.l10n.drawerKinnavMember
                                  : (p?.isGuardian == true
                                      ? context.l10n.drawerGuardian
                                      : context.l10n.drawerCommunityMember),
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
                      _item(context, Icons.person_add_alt, context.l10n.drawerInviteFriend,
                          onTap: () => Links.sms('', context,
                              body:
                                  context.l10n.drawerInviteBody)),
                      _item(context, Icons.shield_outlined, context.l10n.guardiansBecomeGuardian,
                          page: const GuardiansScreen()),
                      const Divider(),
                      _item(context, Icons.person_outline, context.l10n.profileMyProfile,
                          page: const ProfileScreen()),
                      _item(context, Icons.group_outlined, context.l10n.safetyContactsTitle,
                          page: const SafetyContactsScreen()),
                      _item(context, Icons.history, context.l10n.callHistoryTitle,
                          page: const CallHistoryScreen()),
                      _item(context, Icons.school_outlined,
                          context.l10n.drawerSelfCare,
                          page: const ModulesScreen()),
                      _item(context, Icons.card_giftcard, context.l10n.rewardsRewards,
                          page: const RewardsScreen()),
                      _item(context, Icons.workspace_premium_outlined,
                          context.l10n.drawerMembership,
                          page: const SubscriptionScreen()),
                      const Divider(),
                      _item(context, Icons.help_outline, context.l10n.howToHowUseKinnav,
                          page: const HowToUseScreen()),
                      _item(context, Icons.mail_outline, context.l10n.drawerContactUs,
                          onTap: () => Links.email(AppConfig.supportEmail,
                              context,
                              subject: context.l10n.drawerContactSubject)),
                      _item(context, Icons.edit_outlined, context.l10n.feedbackFeedback,
                          page: const FeedbackScreen()),
                      _item(context, Icons.info_outline, context.l10n.aboutAboutUs,
                          page: const AboutScreen()),
                    ],
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _item(context, Icons.logout, context.l10n.drawerLogOut,
                          color: AppColors.primaryDark, onTap: () {
                        Navigator.of(context).popUntil((r) => r.isFirst);
                        appState.logOut();
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(context.l10n.drawerVersion,
                          style: const TextStyle(
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

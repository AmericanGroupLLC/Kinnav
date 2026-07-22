import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Renders Legal Terms or Privacy Policy. Content here is a plain-language
/// placeholder — final documents require legal review before launch (Phase 7).
class LegalScreen extends StatelessWidget {
  final String title;
  final List<(String, String)> sections;

  const LegalScreen._(this.title, this.sections);

  factory LegalScreen.terms() => const LegalScreen._('Legal Terms', [
        (
          'Acceptance of Terms',
          'By using Safer you agree to these Terms. Safer connects you with '
              'trained volunteer guardians and is not a replacement for emergency '
              'services. In a life-threatening emergency, always call your local '
              'emergency number (e.g. 911).'
        ),
        (
          'Nature of the Service',
          'Guardians are vetted volunteers, not licensed security, medical or '
              'legal professionals. Safer does not guarantee response times or '
              'outcomes.'
        ),
        (
          'Eligibility',
          'You must be 18 or older to use Safer or to become a Guardian.'
        ),
        (
          'Acceptable Use',
          'Do not misuse Safe Calls, harass guardians, or use the service for '
              'unlawful purposes. Accounts may be suspended for abuse.'
        ),
        (
          'Subscriptions',
          'Paid memberships renew automatically until cancelled. Manage or '
              'cancel through your app store account.'
        ),
        (
          'Limitation of Liability',
          'To the maximum extent permitted by law, Safer is provided "as is" '
              'without warranties. This is placeholder text pending legal review.'
        ),
      ]);

  factory LegalScreen.privacy() => const LegalScreen._('Privacy Policy', [
        (
          'What we collect',
          'Account details (name, contact, age confirmation), profile info, '
              'approximate and precise location during Safe Calls, safety '
              'contacts you add, and app usage.'
        ),
        (
          'How we use it',
          'To connect you with nearby guardians, share your live location with '
              'your chosen safety contacts during a call, and improve the service.'
        ),
        (
          'Location',
          'Location is used only to provide safety features. You control '
              'permissions in your device settings and can revoke them anytime.'
        ),
        (
          'Sharing',
          'We share your live location with guardians and your safety contacts '
              'during an active Safe Call. We do not sell your personal data.'
        ),
        (
          'Your rights',
          'You can view, edit or delete your data from within the app. Deleting '
              'your account removes your data from this device. GDPR/CCPA rights '
              'apply where relevant.'
        ),
        (
          'Contact',
          'Questions? Email saferapp3@gmail.com. This is placeholder text '
              'pending legal review.'
        ),
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryLight),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline,
                    size: 20, color: AppColors.primaryDark),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Template only — this is placeholder wording pending legal '
                    'review and is not the final, binding document.',
                    style:
                        TextStyle(fontSize: 13, color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
          ),
          for (final (heading, body) in sections)
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(heading,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(body,
                      style: const TextStyle(fontSize: 15, height: 1.5)),
                ],
              ),
            ),
          const Text('Last updated: 2026',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }
}

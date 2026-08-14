import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../services/links.dart';
import '../theme/app_theme.dart';

/// Renders Legal Terms or Privacy Policy as a plain-language summary.
///
/// The binding documents are the ones published on kinnav.com — those are what
/// the App Store and Play listings point their policy URLs at, so this screen
/// links out to them rather than pretending to be authoritative.
class LegalScreen extends StatelessWidget {
  final String title;
  final List<(String, String)> sections;

  /// The published document this screen summarises.
  final String canonicalUrl;

  const LegalScreen._(this.title, this.canonicalUrl, this.sections);

  factory LegalScreen.terms() =>
      const LegalScreen._('Legal Terms', 'https://kinnav.com/terms', [
        (
          'Acceptance of Terms',
          'By using Kinnav you agree to these Terms. Kinnav connects you with '
              'trained volunteer guardians and is not a replacement for emergency '
              'services. In a life-threatening emergency, always call your local '
              'emergency number (e.g. 911).'
        ),
        (
          'Nature of the Service',
          'Guardians are vetted volunteers, not licensed security, medical or '
              'legal professionals. Kinnav does not guarantee response times or '
              'outcomes.'
        ),
        (
          'Eligibility',
          'You must be 18 or older to use Kinnav or to become a Guardian.'
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
          'To the maximum extent permitted by law, Kinnav is provided "as is" '
              'without warranties. See the full Terms on kinnav.com for the '
              'binding wording.'
        ),
      ]);

  factory LegalScreen.privacy() =>
      const LegalScreen._('Privacy Policy', 'https://kinnav.com/privacy', [
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
          'Questions about your data? Email ${AppConfig.supportEmail} and we '
              'will respond within 1–2 business days.'
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
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 20, color: AppColors.primaryDark),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'A plain-language summary. The full $title is published on '
                    'kinnav.com — open it below for the binding version.',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.primaryDark),
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
          // The store listings point their policy URLs at these same pages,
          // so what a reviewer reads and what the app shows cannot drift.
          OutlinedButton.icon(
            onPressed: () => Links.web(canonicalUrl, context),
            icon: const Icon(Icons.open_in_new, size: 18),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryDark,
              side: const BorderSide(color: AppColors.primaryLight),
            ),
            label: Text('Read the full $title on kinnav.com'),
          ),
          const SizedBox(height: 16),
          const Text('Last updated: 2026',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }
}

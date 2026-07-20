import 'package:flutter/material.dart';
import '../services/links.dart';
import '../theme/app_theme.dart';
import 'legal_screen.dart';

/// About Us — mission, community roles, partners, socials and legal, from the
/// deck and reference screens.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const Text(
            'A new way of women safety and empowerment.',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark),
          ),
          const SizedBox(height: 8),
          const Text(
            'Safer helps women in unsafe situations, anywhere, anytime — '
            'connecting them to vetted guardians within a 10-mile radius, '
            'and building a community where all women feel free to flourish.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),
          const _Section(
            title: 'Becoming a Community Manager',
            body:
                'A community is only as strong as its members. As a Community '
                'Manager you lead in strengthening your local community by '
                'creating strong bonds, bringing women together, and improving '
                'their sense of belonging and confidence.',
          ),
          const _Section(
            title: 'Becoming a Campus Ambassador',
            body:
                'Bring Safer to your university and create a space where all '
                'women feel free and confident to flourish and pursue their '
                'dreams. Plan and execute creative, strategic events.',
          ),
          const _Section(
            title: 'Becoming a Rewards Provider',
            body:
                'Partner with Safer to offer exclusive wellness, lifestyle and '
                'empowerment deals to a values-driven community of women.',
          ),
          const _Section(
            title: 'Becoming a Partner',
            body:
                'Does our mission speak to your business values? We offer '
                'training, customized packages, safety-management insights and '
                'more. Together we can change women\'s reality one step at a time.',
          ),
          const _Team(),
          const SizedBox(height: 20),
          const Text('Spreading the word',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text(
            'Have questions, suggestions, or just want to let friends and family '
            'know we exist? Follow and share us:',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 12),
          _social(context, Icons.camera_alt_outlined, 'Instagram',
              '@getsaferapp', 'https://instagram.com'),
          _social(context, Icons.facebook, 'Facebook',
              'facebook.com/getsaferapp', 'https://facebook.com'),
          _social(context, Icons.alternate_email, 'Twitter / X',
              '@getsaferapp', 'https://twitter.com'),
          _social(context, Icons.language, 'Website',
              'getsaferapp.webflow.io', 'https://getsaferapp.webflow.io'),
          _social(context, Icons.mail_outline, 'Email', 'saferapp3@gmail.com',
              'mailto:saferapp3@gmail.com'),
          const SizedBox(height: 20),
          const Text('Legal',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          _link(context, 'Legal Terms', LegalScreen.terms()),
          _link(context, 'Privacy Policy', LegalScreen.privacy()),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'It\'s easier to look forward when you don\'t have to watch your back.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _social(BuildContext context, IconData icon, String label,
      String handle, String url) {
    return InkWell(
      onTap: () => Links.web(url, context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryDark),
            const SizedBox(width: 12),
            Text('$label:  ',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Expanded(
              child: Text(handle,
                  style: const TextStyle(color: AppColors.primary)),
            ),
            const Icon(Icons.open_in_new, size: 16, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _link(BuildContext context, String label, Widget page) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
        minimumSize: const Size(0, 36),
      ),
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => page)),
      child: Text(label,
          style: const TextStyle(
              color: AppColors.primary, fontWeight: FontWeight.w600)),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(fontSize: 15, height: 1.5)),
        ],
      ),
    );
  }
}

class _Team extends StatelessWidget {
  const _Team();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lavenderCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Our Team',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          SizedBox(height: 8),
          Text('Shivani — Founder & Survivor'),
          Text('Vishal — Full Stack Engineer'),
          Text('Vanshika — Marketing & Digital Native'),
        ],
      ),
    );
  }
}

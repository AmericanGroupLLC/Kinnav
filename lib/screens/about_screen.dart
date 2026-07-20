import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// About Us — mission, community roles and contact, from the deck.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: const [
          Text(
            'A new way of women safety and empowerment.',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark),
          ),
          SizedBox(height: 8),
          Text(
            'Safer helps women in unsafe situations, anywhere, anytime — '
            'connecting them to vetted guardians within a 10-mile radius, '
            'and building a community where all women feel free to flourish.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          SizedBox(height: 24),
          _Section(
            title: 'Becoming a Community Manager',
            body:
                'A community is only as strong as its members. As a Community '
                'Manager you lead in strengthening your local community by '
                'creating strong bonds, bringing women together, and improving '
                'their sense of belonging and confidence.',
          ),
          _Section(
            title: 'Becoming a Campus Ambassador',
            body:
                'Bring Safer to your university and create a space where all '
                'women feel free and confident to flourish and pursue their '
                'dreams. Plan and execute creative, strategic events.',
          ),
          _Section(
            title: 'Becoming a Rewards Provider',
            body:
                'Partner with Safer to offer exclusive wellness, lifestyle and '
                'empowerment deals to a values-driven community of women.',
          ),
          SizedBox(height: 16),
          _Team(),
          SizedBox(height: 16),
          Text('Contact: saferapp3@gmail.com',
              style: TextStyle(color: AppColors.textMuted)),
        ],
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
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

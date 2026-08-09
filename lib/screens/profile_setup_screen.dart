import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';

/// Collects the member's profile after sign-in, then routes to Home.
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameCtrl = TextEditingController();
  int _month = 1;
  int _year = 2000;
  String _identity = 'Woman';
  final Set<String> _languages = {'English'};
  String? _error;

  static const _identities = ['Woman', 'Non-binary', 'Prefer not to say'];
  static const _allLanguages = [
    'English', 'Spanish', 'Hindi', 'French', 'Arabic',
    'Mandarin', 'Portuguese', 'Hebrew', 'Vietnamese', 'Italian',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Please enter your name.');
      return;
    }
    if (_languages.isEmpty) {
      setState(() => _error = 'Select at least one language.');
      return;
    }
    appState.setProfile(UserProfile(
      name: _nameCtrl.text.trim(),
      birthMonth: _month,
      birthYear: _year,
      identity: _identity,
      languages: _languages.toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final years = [for (int y = 2010; y >= 1940; y--) y];
    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const Text('Tell us a bit about you',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              labelText: 'Name',
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Month and year of birth',
              style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _month,
                  decoration: _dropDecoration('Month'),
                  items: [
                    for (int m = 1; m <= 12; m++)
                      DropdownMenuItem(
                          value: m, child: Text(m.toString().padLeft(2, '0'))),
                  ],
                  onChanged: (v) => setState(() => _month = v ?? _month),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _year,
                  decoration: _dropDecoration('Year'),
                  items: [
                    for (final y in years)
                      DropdownMenuItem(value: y, child: Text('$y')),
                  ],
                  onChanged: (v) => setState(() => _year = v ?? _year),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _identity,
            decoration: _dropDecoration('I define myself as'),
            items: [
              for (final i in _identities)
                DropdownMenuItem(value: i, child: Text(i)),
            ],
            onChanged: (v) => setState(() => _identity = v ?? _identity),
          ),
          const SizedBox(height: 16),
          const Text('Spoken languages',
              style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final lang in _allLanguages)
                FilterChip(
                  label: Text(lang),
                  selected: _languages.contains(lang),
                  selectedColor: AppColors.primaryLight.withValues(alpha: 0.4),
                  checkmarkColor: AppColors.primaryDark,
                  onSelected: (sel) => setState(() {
                    if (sel) {
                      _languages.add(lang);
                    } else {
                      _languages.remove(lang);
                    }
                  }),
                ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: AppColors.danger)),
          ],
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: _save,
            child: const Text('Continue to Kinnav',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  InputDecoration _dropDecoration(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      );
}

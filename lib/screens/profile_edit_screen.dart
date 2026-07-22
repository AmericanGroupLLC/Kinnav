import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';

/// Edit the member's profile (name, birth month/year, identity, languages) and
/// persist the changes locally via [AppState].
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late final TextEditingController _nameCtrl;
  late int _month;
  late int _year;
  late String _identity;
  late Set<String> _languages;
  String? _error;

  static const _identities = ['Woman', 'Non-binary', 'Prefer not to say'];
  static const _allLanguages = [
    'English', 'Spanish', 'Hindi', 'French', 'Arabic',
    'Mandarin', 'Portuguese', 'Hebrew', 'Vietnamese', 'Italian',
  ];

  @override
  void initState() {
    super.initState();
    final p = appState.profile;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _month = p?.birthMonth ?? 1;
    _year = p?.birthYear ?? 2000;
    _identity =
        _identities.contains(p?.identity) ? p!.identity : _identities.first;
    _languages = {...?p?.languages};
    if (_languages.isEmpty) _languages = {'English'};
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Please enter your name.');
      return;
    }
    if (_languages.isEmpty) {
      setState(() => _error = 'Select at least one language.');
      return;
    }
    final current = appState.profile;
    await appState.setProfile(
      (current ??
              UserProfile(
                name: _nameCtrl.text.trim(),
                birthMonth: _month,
                birthYear: _year,
              ))
          .copyWith(
        name: _nameCtrl.text.trim(),
        birthMonth: _month,
        birthYear: _year,
        identity: _identity,
        languages: _languages.toList(),
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Profile updated.'),
          backgroundColor: AppColors.primaryDark),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final years = [for (int y = 2010; y >= 1940; y--) y];
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const SizedBox(height: 12),
          TextField(
            controller: _nameCtrl,
            decoration: _dec('Name'),
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
                  decoration: _dec('Month'),
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
                  initialValue: years.contains(_year) ? _year : years.first,
                  decoration: _dec('Year'),
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
            decoration: _dec('I define myself as'),
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
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: _save,
            child: const Text('Save changes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      );
}

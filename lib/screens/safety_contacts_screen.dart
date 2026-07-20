import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar.dart';

class _Contact {
  final String name;
  final String phone;
  final String relation;
  final Color color;
  const _Contact(this.name, this.phone, this.relation, this.color);
}

/// Personal safety contacts who are notified alongside guardians.
class SafetyContactsScreen extends StatefulWidget {
  const SafetyContactsScreen({super.key});

  @override
  State<SafetyContactsScreen> createState() => _SafetyContactsScreenState();
}

class _SafetyContactsScreenState extends State<SafetyContactsScreen> {
  final List<_Contact> _contacts = [
    const _Contact('Mom', '+1 (555) 010-2233', 'Family', Color(0xFFAB47BC)),
    const _Contact('Emma', '+1 (555) 887-6655', 'Best friend', Color(0xFF5C6BC0)),
  ];

  void _addContact() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add safety contact',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary),
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  if (name.isEmpty) return;
                  setState(() => _contacts.add(_Contact(
                        name,
                        phoneCtrl.text.trim().isEmpty
                            ? 'No number'
                            : phoneCtrl.text.trim(),
                        'Contact',
                        AppColors.primary,
                      )));
                  Navigator.of(ctx).pop();
                },
                child: const Text('Add contact'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Safety Contacts')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: _addContact,
        icon: const Icon(Icons.person_add_alt),
        label: const Text('Add'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'These trusted people are notified with your live location when '
              'you start a Safe Call.',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          for (int i = 0; i < _contacts.length; i++)
            Card(
              elevation: 0,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: InitialsAvatar(
                  initials: _contacts[i].name.characters.first.toUpperCase(),
                  color: _contacts[i].color,
                  size: 46,
                ),
                title: Text(_contacts[i].name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                    '${_contacts[i].relation} · ${_contacts[i].phone}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.textMuted),
                  onPressed: () => setState(() => _contacts.removeAt(i)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

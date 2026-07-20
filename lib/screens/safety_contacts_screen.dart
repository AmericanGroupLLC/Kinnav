import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/safety_contact.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar.dart';

/// Personal safety contacts (persisted) notified with the user's live location.
class SafetyContactsScreen extends StatelessWidget {
  const SafetyContactsScreen({super.key});

  void _addContact(BuildContext context) {
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
                  labelText: 'Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  labelText: 'Phone', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style:
                    FilledButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  if (name.isEmpty) return;
                  appState.addContact(SafetyContact(
                    name: name,
                    phone: phoneCtrl.text.trim().isEmpty
                        ? 'No number'
                        : phoneCtrl.text.trim(),
                    relation: 'Contact',
                    colorValue: 0xFF9B59D0,
                  ));
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
        onPressed: () => _addContact(context),
        icon: const Icon(Icons.person_add_alt),
        label: const Text('Add'),
      ),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final contacts = appState.contacts;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'These trusted people are notified with your live location '
                  'when you start a Safe Call.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
              if (contacts.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text('No contacts yet. Tap Add to invite someone.',
                        style: TextStyle(color: AppColors.textMuted)),
                  ),
                ),
              for (int i = 0; i < contacts.length; i++)
                Card(
                  elevation: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: InitialsAvatar(
                      initials: contacts[i].initial,
                      color: contacts[i].color,
                      size: 46,
                    ),
                    title: Text(contacts[i].name,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle:
                        Text('${contacts[i].relation} · ${contacts[i].phone}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.textMuted),
                      onPressed: () => appState.removeContactAt(i),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

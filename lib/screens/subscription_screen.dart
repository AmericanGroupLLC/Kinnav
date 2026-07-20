import 'package:flutter/material.dart';
import '../app_state.dart';
import '../theme/app_theme.dart';

/// Subscription plans ($3.99/mo, $39.99/yr). UI + local state only — real IAP
/// (App Store / Play) lands in Phase 6.
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionPlan _selected = SubscriptionPlan.annual;

  @override
  void initState() {
    super.initState();
    if (appState.plan != SubscriptionPlan.none) _selected = appState.plan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safer Membership')),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final active = appState.plan;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              const Text('Join the Safer community',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text(
                'Unlimited Safe Calls, self-care modules and exclusive wellness '
                'rewards.',
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              _PlanCard(
                title: 'Annual',
                price: '\$39.99 / year',
                note: 'Best value · ~\$3.33/mo',
                selected: _selected == SubscriptionPlan.annual,
                active: active == SubscriptionPlan.annual,
                onTap: () =>
                    setState(() => _selected = SubscriptionPlan.annual),
              ),
              _PlanCard(
                title: 'Monthly',
                price: '\$3.99 / month',
                note: 'Cancel anytime',
                selected: _selected == SubscriptionPlan.monthly,
                active: active == SubscriptionPlan.monthly,
                onTap: () =>
                    setState(() => _selected = SubscriptionPlan.monthly),
              ),
              const SizedBox(height: 12),
              ..._benefits(),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  appState.setPlan(_selected);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Membership active. Welcome! 💜'),
                        backgroundColor: AppColors.primaryDark),
                  );
                },
                child: Text(
                    active == _selected ? 'Current plan' : 'Start membership',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              if (active != SubscriptionPlan.none)
                Center(
                  child: TextButton(
                    onPressed: () => appState.setPlan(SubscriptionPlan.none),
                    child: const Text('Cancel membership',
                        style: TextStyle(color: AppColors.textMuted)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _benefits() {
    const items = [
      'Unlimited Safe Calls with guardians',
      'Self-care & empowerment modules',
      'Exclusive wellness & lifestyle rewards',
      'Priority support',
    ];
    return [
      for (final b in items)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.check_circle,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(b)),
            ],
          ),
        ),
    ];
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String note;
  final bool selected;
  final bool active;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.note,
    required this.selected,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE4DAEF),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                      if (active) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.online,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('ACTIVE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(note,
                      style: const TextStyle(color: AppColors.textMuted)),
                ],
              ),
            ),
            Text(price,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark)),
          ],
        ),
      ),
    );
  }
}

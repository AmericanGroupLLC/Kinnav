import 'package:flutter/material.dart';
import '../app_state.dart';
import '../services/purchase_service.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';

/// Subscription plans ($3.99/mo, $39.99/yr). UI + local state only — real IAP
/// (App Store / Play) lands in Phase 6.
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final PurchaseService _purchases = MockPurchaseService();
  SubscriptionPlan _selected = SubscriptionPlan.annual;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (appState.plan != SubscriptionPlan.none) _selected = appState.plan;
  }

  Future<void> _buy() async {
    setState(() => _busy = true);
    final ok = await _purchases.buy(_selected);
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      await appState.setPlan(_selected);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(context.l10n.subscriptionActivated),
            backgroundColor: AppColors.primaryDark),
      );
    }
  }

  Future<void> _restore() async {
    final plan = await _purchases.restore();
    if (!mounted) return;
    if (plan != null) {
      await appState.setPlan(plan);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.subscriptionNoPreviousPurchasesFound)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.subscriptionKinnavMembership)),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final active = appState.plan;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              const _DemoBanner(),
              const SizedBox(height: 12),
              Text(context.l10n.subscriptionJoinKinnavCommunity,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(
                context.l10n.subscriptionBlurb,
                style: const TextStyle(color: AppColors.textMuted),
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
                onPressed: (_busy || active == _selected) ? null : _buy,
                child: _busy
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text(
                        active == _selected
                            ? 'Current plan'
                            : 'Start membership',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              Center(
                child: TextButton(
                  onPressed: _restore,
                  child: Text(context.l10n.subscriptionRestorePurchases,
                      style: const TextStyle(color: AppColors.textMuted)),
                ),
              ),
              if (active != SubscriptionPlan.none)
                Center(
                  child: TextButton(
                    onPressed: () => appState.setPlan(SubscriptionPlan.none),
                    child: Text(context.l10n.subscriptionCancelMembership,
                        style: const TextStyle(color: AppColors.textMuted)),
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

/// Makes clear that billing here is simulated (no real App Store / Play IAP).
class _DemoBanner extends StatelessWidget {
  const _DemoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 20, color: AppColors.primaryDark),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.subscriptionDemoNotice,
              style: const TextStyle(fontSize: 13, color: AppColors.primaryDark),
            ),
          ),
        ],
      ),
    );
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
            color: selected ? AppColors.primary : AppColors.lavenderCard,
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
                          child: Text(context.l10n.subscriptionActive,
                              style: const TextStyle(
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

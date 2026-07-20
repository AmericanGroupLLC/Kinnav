import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/content.dart';
import '../theme/app_theme.dart';

/// Wellness & lifestyle rewards; redemptions persist via [AppState].
class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.card_giftcard,
                        color: Colors.white, size: 40),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Get safe. Get rewarded.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(
                            '${appState.redeemedRewards.length} of ${kRewards.length} offers redeemed',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              for (final r in kRewards)
                _RewardTile(
                  reward: r,
                  redeemed: appState.isRedeemed(r.title),
                  onRedeem: () {
                    appState.redeemReward(r.title);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Redeemed: ${r.offer} from ${r.partner}'),
                          backgroundColor: AppColors.primaryDark),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  final Reward reward;
  final bool redeemed;
  final VoidCallback onRedeem;
  const _RewardTile(
      {required this.reward, required this.redeemed, required this.onRedeem});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: reward.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(reward.icon, color: reward.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reward.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('${reward.partner} · ${reward.offer}',
                      style: const TextStyle(color: AppColors.textMuted)),
                ],
              ),
            ),
            redeemed
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            color: AppColors.online, size: 20),
                        SizedBox(width: 4),
                        Text('Redeemed',
                            style: TextStyle(
                                color: AppColors.online,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ],
                    ),
                  )
                : TextButton(
                    onPressed: onRedeem,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.lavenderCard,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Redeem',
                        style: TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600)),
                  ),
          ],
        ),
      ),
    );
  }
}

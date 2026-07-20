import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../theme/app_theme.dart';
import 'links.dart';

/// Emergency dialing with an explicit confirmation step, so it can never fire
/// accidentally. Dials the region's configured emergency number.
class Emergency {
  Emergency._();

  static Future<void> confirmAndDial(BuildContext context) async {
    final number = AppConfig.emergencyNumber;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.local_police_outlined,
            color: AppColors.danger, size: 36),
        title: Text('Call emergency services ($number)?'),
        content: const Text(
            'This will place a real phone call to emergency services and keep '
            'your guardians on the Safe Call.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Call $number'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await Links.dial(number, context);
    }
  }
}

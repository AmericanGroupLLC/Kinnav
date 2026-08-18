import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import 'links.dart';

/// Emergency dialing with an explicit confirmation step, so it can never fire
/// accidentally. Dials the region's configured emergency number.
class Emergency {
  Emergency._();

  /// Asks for confirmation and dials. Returns true only when the call was
  /// actually placed.
  ///
  /// Callers must not assume a dial happened: this used to return void, so
  /// `SafeCallScreen` flipped its "Police added" badge on even when the user
  /// tapped Cancel. Telling someone the police are on a Safe Call when nobody
  /// was dialled is the worst failure this app can have, so the outcome is now
  /// reported back.
  static Future<bool> confirmAndDial(BuildContext context) async {
    final number = AppConfig.emergencyNumber;
    final strings = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.local_police_outlined,
            color: AppColors.danger, size: 36),
        title: Text(strings.emergencyConfirmTitle(number)),
        content: Text(strings.emergencyConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(strings.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(strings.emergencyConfirmAction(number)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await Links.dial(number, context);
      return true;
    }
    return false;
  }
}

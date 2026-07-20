import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A rounded, purple-outlined speech bubble used for the in-app coach marks /
/// tips seen across the reference screens (e.g. "Add the police to the call").
class CoachBubble extends StatelessWidget {
  final String text;
  final VoidCallback? onDismiss;

  const CoachBubble({super.key, required this.text, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryDark, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textDark,
                height: 1.3,
              ),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(Icons.close,
                  size: 18, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A self-contained circular avatar that renders initials on a colored disc.
/// Avoids bundling image assets so the app runs offline in any simulator.
class InitialsAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final double size;
  final bool showOnlineDot;
  final bool online;
  final double borderWidth;
  final Color borderColor;

  const InitialsAvatar({
    super.key,
    required this.initials,
    required this.color,
    this.size = 44,
    this.showOnlineDot = false,
    this.online = true,
    this.borderWidth = 0,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.85), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: borderWidth > 0
                  ? Border.all(color: borderColor, width: borderWidth)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: size * 0.36,
              ),
            ),
          ),
          if (showOnlineDot)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.28,
                height: size * 0.28,
                decoration: BoxDecoration(
                  color: online ? AppColors.online : AppColors.textMuted,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/guardian.dart';
import '../services/services.dart';
import '../theme/app_theme.dart';
import 'avatar.dart';

/// A stylised, offline map that mimics the reference screens (road grid, parks,
/// highways) without needing a Google Maps API key. Guardian pins and the user
/// location are laid out using normalized coordinates.
class MapView extends StatelessWidget {
  final bool showUserPhoto;
  /// Null means "ask the guardian service" — a const default cannot call it,
  /// and hardcoding kGuardians here hid a second data source behind the map.
  final List<Guardian>? pins;
  final bool showGuardianAvatars; // true = Safe Call style avatars on map

  const MapView({
    super.key,
    this.pins,
    this.showUserPhoto = true,
    this.showGuardianAvatars = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        // Keep markers fully on-screen by clamping their anchor points.
        double clampX(double v, double half) =>
            (v * w).clamp(half, w - half);
        double clampY(double v, double topPad, double bottomPad) =>
            (v * h).clamp(topPad, h - bottomPad);

        return Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _MapPainter())),
            for (final g in (pins ?? services.guardians.nearby(limit: 6)))
              if (showGuardianAvatars)
                Positioned(
                  left: clampX(g.mapPos.dx, 40) - 22,
                  top: clampY(g.mapPos.dy, 22, 60) - 22,
                  child: _AvatarMarker(guardian: g),
                )
              else
                Positioned(
                  left: clampX(g.mapPos.dx, 20) - 20,
                  top: clampY(g.mapPos.dy, 44, 20) - 44,
                  child: const GuardianGlyphPin(),
                ),
            // User location, centered.
            Positioned(
              left: w * 0.5 - 30,
              top: h * 0.5 - 66,
              child: _UserMarker(showPhoto: showUserPhoto),
            ),
          ],
        );
      },
    );
  }
}

/// The branded guardian marker: a purple disc with a "community" glyph and a
/// pointer, matching the reference map pins.
class GuardianGlyphPin extends StatelessWidget {
  const GuardianGlyphPin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: const Icon(Icons.diversity_1, color: Colors.white, size: 22),
        ),
        Transform.translate(
          offset: const Offset(0, -6),
          child: Icon(Icons.arrow_drop_down,
              color: AppColors.primary.withValues(alpha: 0.9), size: 26),
        ),
      ],
    );
  }
}

class _AvatarMarker extends StatelessWidget {
  final Guardian guardian;
  const _AvatarMarker({required this.guardian});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InitialsAvatar(
          initials: guardian.initials,
          color: guardian.color,
          size: 44,
          borderWidth: 3,
        ),
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 1)),
            ],
          ),
          child: Text(
            guardian.name.split(' ').first,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _UserMarker extends StatelessWidget {
  final bool showPhoto;
  const _UserMarker({required this.showPhoto});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            color: AppColors.primaryDark,
            shape: BoxShape.circle,
          ),
          child: const InitialsAvatar(
            initials: 'Me',
            color: AppColors.primary,
            size: 48,
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -6),
          child: const Icon(Icons.arrow_drop_down,
              color: AppColors.primaryDark, size: 34),
        ),
      ],
    );
  }
}

/// Paints a light, Google-Maps-like backdrop: parks, water, roads and highways.
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFF3F1EC);
    canvas.drawRect(Offset.zero & size, bg);

    // Parks / green areas.
    final park = Paint()..color = const Color(0xFFD8E8CE);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.02, size.height * 0.60,
            size.width * 0.26, size.height * 0.30),
        const Radius.circular(12),
      ),
      park,
    );
    canvas.drawCircle(
        Offset(size.width * 0.34, size.height * 0.34), size.width * 0.08, park);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.70, size.height * 0.05,
            size.width * 0.28, size.height * 0.18),
        const Radius.circular(12),
      ),
      park,
    );

    // Water.
    final water = Paint()..color = const Color(0xFFAFD3E8);
    final waterPath = Path()
      ..moveTo(0, size.height * 0.08)
      ..lineTo(size.width * 0.10, size.height * 0.02)
      ..lineTo(size.width * 0.16, size.height * 0.20)
      ..lineTo(0, size.height * 0.30)
      ..close();
    canvas.drawPath(waterPath, water);

    // Minor road grid.
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    for (int i = 1; i < 7; i++) {
      final dx = size.width * i / 7;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), road);
    }
    for (int i = 1; i < 12; i++) {
      final dy = size.height * i / 12;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), road);
    }

    // Highways (yellow).
    final hwy = Paint()
      ..color = const Color(0xFFF6D06B)
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final h1 = Path()
      ..moveTo(0, size.height * 0.22)
      ..cubicTo(size.width * 0.3, size.height * 0.18, size.width * 0.6,
          size.height * 0.30, size.width, size.height * 0.24);
    canvas.drawPath(h1, hwy);
    final h2 = Path()
      ..moveTo(size.width * 0.46, 0)
      ..cubicTo(size.width * 0.50, size.height * 0.4, size.width * 0.40,
          size.height * 0.7, size.width * 0.52, size.height);
    canvas.drawPath(h2, hwy);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

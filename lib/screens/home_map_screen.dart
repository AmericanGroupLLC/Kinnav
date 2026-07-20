import 'package:flutter/material.dart';
import '../models/guardian.dart';
import '../services/location_service.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar.dart';
import '../widgets/coach_bubble.dart';
import '../widgets/live_map.dart';
import '../widgets/primary_button.dart';
import 'call_options_screen.dart';
import 'chat_screen.dart';
import 'menu_drawer.dart';

/// The primary screen: a live map showing guardians nearby, the CALL GUARDIANS
/// action, and the row of nearby guardian avatars.
class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  bool _showIntro = true;
  final LocationService _location = GeoLocationService();
  LatLng? _coords;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final pos = await _location.current();
    if (mounted) setState(() => _coords = pos);
  }

  @override
  Widget build(BuildContext context) {
    final nearby = kGuardians.take(6).toList();
    // Reference screens show a large community ("+63"); reflect that here.
    final more = 63;

    return Scaffold(
      drawer: const MenuDrawer(),
      body: Stack(
        children: [
          Positioned.fill(child: LiveMap(center: _coords)),
          // Top controls: menu + chat, floating over the map.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => _CircleIconButton(
                      icon: Icons.menu,
                      semanticLabel: 'Open menu',
                      onTap: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  _CircleIconButton(
                    icon: Icons.chat_bubble_outline,
                    semanticLabel: 'Open support chat',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ChatScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Live-location status pill.
          Positioned(
            top: MediaQuery.of(context).padding.top + 56,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _coords == null ? Icons.location_searching : Icons.my_location,
                      size: 16,
                      color: _coords == null
                          ? AppColors.textMuted
                          : AppColors.online,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _coords == null ? 'Locating…' : 'Live location on',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Intro coach mark over the map.
          if (_showIntro)
            Align(
              alignment: const Alignment(0, 0.25),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CoachBubble(
                  text: 'You will see yourself and nearby guardians on the map',
                  onDismiss: () => setState(() => _showIntro = false),
                ),
              ),
            ),
          // Bottom sheet: call button + nearby guardians.
          Align(
            alignment: Alignment.bottomCenter,
            child: _BottomPanel(nearby: nearby, more: more),
          ),
        ],
      ),
    );
  }
}

class _BottomPanel extends StatelessWidget {
  final List<Guardian> nearby;
  final int more;
  const _BottomPanel({required this.nearby, required this.more});

  static const double _btnHeight = 56;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // The white sheet.
        Container(
          margin: const EdgeInsets.only(top: _btnHeight / 2),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 20, offset: Offset(0, -4)),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, _btnHeight / 2 + 14, 16, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 56,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: nearby.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, i) {
                        if (i == nearby.length) {
                          return Center(
                            child: Text(
                              '+$more',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMuted,
                              ),
                            ),
                          );
                        }
                        final g = nearby[i];
                        return InitialsAvatar(
                          initials: g.initials,
                          color: g.color,
                          size: 52,
                          showOnlineDot: true,
                          online: g.online,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Guardians Nearby',
                    style: TextStyle(fontSize: 16, color: AppColors.textDark),
                  ),
                ],
              ),
            ),
          ),
        ),
        // The CALL GUARDIANS button, overlapping the top edge of the sheet.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: PrimaryButton(
            label: 'CALL GUARDIANS',
            icon: Icons.call,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CallOptionsScreen()),
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;
  const _CircleIconButton(
      {required this.icon, required this.onTap, this.semanticLabel = ''});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 3,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: AppColors.textDark, size: 24),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/guardian.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar.dart';
import '../widgets/map_view.dart';
import '../widgets/primary_button.dart';
import 'safe_call_screen.dart';
import 'chat_screen.dart';
import 'menu_drawer.dart';

/// The primary screen: a live map showing guardians nearby, the CALL GUARDIANS
/// action, and the row of nearby guardian avatars.
class HomeMapScreen extends StatelessWidget {
  const HomeMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nearby = kGuardians.take(6).toList();
    final more = kGuardians.length - nearby.length;

    return Scaffold(
      drawer: const MenuDrawer(),
      body: Stack(
        children: [
          const Positioned.fill(child: MapView()),
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
                      onTap: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  _CircleIconButton(
                    icon: Icons.chat_bubble_outline,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ChatScreen()),
                    ),
                  ),
                ],
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: const Offset(0, -46),
                child: PrimaryButton(
                  label: 'CALL GUARDIANS',
                  icon: Icons.call,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SafeCallScreen()),
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -30),
                child: Column(
                  children: [
                    SizedBox(
                      height: 56,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: nearby.length + (more > 0 ? 1 : 0),
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
                    const SizedBox(height: 6),
                    const Text(
                      'guardians nearby',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
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
    );
  }
}

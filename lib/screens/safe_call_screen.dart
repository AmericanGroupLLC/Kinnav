import 'dart:async';
import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/call_record.dart';
import '../models/call_type.dart';
import '../models/guardian.dart';
import '../services/emergency.dart';
import '../theme/app_theme.dart';
import '../widgets/avatar.dart';
import '../widgets/coach_bubble.dart';
import '../widgets/map_view.dart';

/// The Safe Call experience: guardians join, you see them on the map or switch
/// to a video grid, can add the police, and control audio/video.
class SafeCallScreen extends StatefulWidget {
  final CallType callType;
  const SafeCallScreen({super.key, this.callType = CallType.video});

  @override
  State<SafeCallScreen> createState() => _SafeCallScreenState();
}

class _SafeCallScreenState extends State<SafeCallScreen> {
  static const _connectDelay = Duration(seconds: 2);

  Timer? _timer;
  int _seconds = 0;
  bool _connecting = true;
  bool _videoMode = false;
  bool _videoOn = false;
  bool _speakerOn = false;
  bool _policeAdded = false;

  // Guided coach marks shown once during the call.
  final List<String> _coach = const [
    'Add the police to the call, if needed',
    'Simply switch between map and video',
    'Back to safety? Thank your guardians and end the call',
  ];
  int _coachStep = 0;
  int _startedAtMs = 0;

  late final List<Guardian> _onCall =
      kGuardians.where((g) => g.online).take(4).toList();

  @override
  void initState() {
    super.initState();
    // Emergency & video calls begin in video, and emergency auto-adds police.
    _videoOn = widget.callType.startsVideo;
    _videoMode = widget.callType.startsVideo;
    _policeAdded = widget.callType == CallType.emergency;
    _startedAtMs = DateTime.now().millisecondsSinceEpoch;

    Future.delayed(_connectDelay, () {
      if (!mounted) return;
      setState(() => _connecting = false);
      final n = appState.contacts.length;
      if (n > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '$n safety contact${n == 1 ? '' : 's'} notified with your live location'),
            backgroundColor: AppColors.primaryDark,
          ),
        );
      }
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _seconds++);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _clock {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _hangUp() {
    // Record the call to persisted history before leaving.
    appState.addCallRecord(CallRecord(
      typeLabel: widget.callType.label,
      guardianCount: _onCall.length,
      durationSeconds: _seconds,
      policeAdded: _policeAdded,
      startedAtMs: _startedAtMs,
    ));
    Navigator.of(context).maybePop();
  }

  void _nextCoach() => setState(() => _coachStep++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _videoMode
                ? _VideoGrid(guardians: _onCall)
                : MapView(pins: _onCall, showGuardianAvatars: true),
          ),
          _buildHeader(context),
          _buildModeToggle(),
          if (_connecting) _buildConnecting(),
          _buildControls(),
          if (!_connecting && _coachStep < _coach.length) _buildCoach(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Safe Call',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: _videoMode ? Colors.white : AppColors.textDark,
                      shadows: const [
                        Shadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                  ),
                  Text(
                    _connecting ? 'connecting…' : _clock,
                    style: TextStyle(
                      fontSize: 15,
                      color: _videoMode ? Colors.white70 : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            _AddPoliceButton(
              added: _policeAdded,
              onTap: () async {
                await Emergency.confirmAndDial(context);
                if (mounted) setState(() => _policeAdded = true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnecting() {
    return Container(
      color: Colors.black.withValues(alpha: 0.55),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 42,
            height: 42,
            child: CircularProgressIndicator(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Connecting you to ${_onCall.length} guardians…',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 70,
      right: 16,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => setState(() => _videoMode = !_videoMode),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_videoMode ? Icons.map_outlined : Icons.videocam_outlined,
                    size: 18, color: AppColors.primaryDark),
                const SizedBox(width: 6),
                Text(
                  _videoMode ? 'Map' : 'Video',
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Positions the current coach bubble near the control it explains.
  Widget _buildCoach() {
    final topPad = MediaQuery.of(context).padding.top;
    late Alignment align;
    late EdgeInsets pad;
    switch (_coachStep) {
      case 0: // add police (top-right)
        align = Alignment.topRight;
        pad = EdgeInsets.only(top: topPad + 60, right: 16, left: 60);
        break;
      case 1: // mode toggle (upper-right, below toggle)
        align = Alignment.topRight;
        pad = EdgeInsets.only(top: topPad + 120, right: 16, left: 60);
        break;
      default: // end call (bottom-center)
        align = Alignment.bottomCenter;
        pad = const EdgeInsets.only(bottom: 140, left: 40, right: 40);
    }
    return Positioned.fill(
      child: GestureDetector(
        onTap: _nextCoach,
        child: Container(
          color: Colors.black.withValues(alpha: 0.15),
          child: Align(
            alignment: align,
            child: Padding(
              padding: pad,
              child: CoachBubble(text: _coach[_coachStep], onDismiss: _nextCoach),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CallControl(
                  icon: _videoOn ? Icons.videocam : Icons.videocam_off,
                  label: _videoOn ? 'Stop Video' : 'Start Video',
                  onTap: () => setState(() {
                    _videoOn = !_videoOn;
                    if (_videoOn) _videoMode = true;
                  }),
                ),
                _HangUpButton(onTap: _hangUp),
                _CallControl(
                  icon: _speakerOn ? Icons.volume_up : Icons.volume_off,
                  label: _speakerOn ? 'Turn Off Speaker' : 'Turn On Speaker',
                  onTap: () => setState(() => _speakerOn = !_speakerOn),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoGrid extends StatelessWidget {
  final List<Guardian> guardians;
  const _VideoGrid({required this.guardians});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio:
          MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
      children: [
        for (final g in guardians)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  g.color.withValues(alpha: 0.9),
                  g.color.withValues(alpha: 0.6)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Stack(
              children: [
                Center(
                  child: InitialsAvatar(
                    initials: g.initials,
                    color: g.color,
                    size: 96,
                    borderWidth: 3,
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      g.name.split(' ').first,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AddPoliceButton extends StatelessWidget {
  final bool added;
  final VoidCallback onTap;
  const _AddPoliceButton({required this.added, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: added ? AppColors.danger : AppColors.primaryDark,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: added ? null : onTap,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.local_police_outlined,
                  color: Colors.white, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          added ? 'Police added' : 'Add police',
          style: const TextStyle(fontSize: 11, color: AppColors.textDark),
        ),
      ],
    );
  }
}

class _CallControl extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _CallControl(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: const Color(0xFFEFEFEF),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(icon, color: AppColors.textDark, size: 26),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
        ],
      ),
    );
  }
}

class _HangUpButton extends StatelessWidget {
  final VoidCallback onTap;
  const _HangUpButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: AppColors.danger,
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Icon(Icons.call_end, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}

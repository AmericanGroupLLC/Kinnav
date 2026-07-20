import 'package:flutter/material.dart';

/// The ways a user can reach guardians from the CALL GUARDIANS action.
enum CallType {
  voice('Voice Call', Icons.call, false),
  video('Video Call', Icons.videocam, true),
  text('Text Message', Icons.chat_bubble_outline, false),
  emergency('Emergency', Icons.warning_amber_rounded, true);

  const CallType(this.label, this.icon, this.startsVideo);

  final String label;
  final IconData icon;
  final bool startsVideo;
}

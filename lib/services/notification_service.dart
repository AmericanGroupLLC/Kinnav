import 'package:flutter/material.dart';

/// Notification boundary. The mock surfaces messages in-app; swap in FCM/APNs
/// (push to off-app guardians and safety contacts) in Phase 5 production.
abstract class NotificationService {
  Future<void> notifyGuardians(String message);
  Future<void> notifyContacts(String message);
}

class MockNotificationService implements NotificationService {
  MockNotificationService(this._messengerKey);
  final GlobalKey<ScaffoldMessengerState>? _messengerKey;

  void _show(String message) {
    _messengerKey?.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Future<void> notifyGuardians(String message) async => _show(message);

  @override
  Future<void> notifyContacts(String message) async => _show(message);
}

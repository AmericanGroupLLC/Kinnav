import '../models/call_type.dart';
import '../models/guardian.dart';

/// Represents an active Safe Call session.
class CallSession {
  final CallType type;
  final List<Guardian> guardians;
  bool policeAdded;

  CallSession({
    required this.type,
    required this.guardians,
    this.policeAdded = false,
  });
}

/// Real-time call boundary. Mock connects to bundled online guardians after a
/// short delay; swap in Agora/Twilio/WebRTC in Phase 4 behind this interface.
abstract class CallService {
  Future<CallSession> connect(CallType type);
  Future<void> addPolice(CallSession session);
  Future<void> end(CallSession session);
}

class MockCallService implements CallService {
  @override
  Future<CallSession> connect(CallType type) async {
    await Future.delayed(const Duration(seconds: 2));
    final online = kGuardians.where((g) => g.online).take(4).toList();
    return CallSession(
      type: type,
      guardians: online,
      policeAdded: type == CallType.emergency,
    );
  }

  @override
  Future<void> addPolice(CallSession session) async {
    session.policeAdded = true;
  }

  @override
  Future<void> end(CallSession session) async {}
}

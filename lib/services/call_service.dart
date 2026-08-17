import '../models/call_type.dart';
import '../models/guardian.dart';

/// Connecting a user to a guardian.
///
/// Nothing implements this for real yet. The Safe Call screen is a mockup and
/// used to say so with a hardcoded banner, which meant the banner could not
/// disappear when the feature arrived — someone would have had to remember to
/// delete it. It is now driven by [CallService.isSimulated], so the screen
/// tells the truth automatically in either state.
///
/// A real implementation needs three things this repo does not have:
///   * an RTC package (`agora_rtc_engine` is not in pubspec)
///   * an Agora App ID — `AppConfig.agoraAppId`, currently empty and read by
///     nothing
///   * somewhere to mint per-channel tokens; they cannot be shipped in the
///     client
abstract class CallService {
  /// Whether calls are pretend. The UI must disclose this — the app is a
  /// safety app, and implying a call connects when it does not is the most
  /// harmful thing it could do.
  bool get isSimulated;

  /// Opens a channel with [guardian]. Returns the channel id.
  Future<String> start(CallType type, Guardian guardian);

  /// Leaves the current channel. Safe to call when not in one.
  Future<void> end();
}

/// The shipping implementation: it connects nobody.
class MockCallService implements CallService {
  const MockCallService();

  @override
  bool get isSimulated => true;

  @override
  Future<String> start(CallType type, Guardian guardian) async =>
      'demo-${type.name}-${guardian.name.hashCode.abs()}';

  @override
  Future<void> end() async {}
}

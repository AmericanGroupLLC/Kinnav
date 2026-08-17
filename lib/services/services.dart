import '../config/app_config.dart';
import 'call_service.dart';
import 'guardian_service.dart';
import 'supabase_guardian_service.dart';

/// The one place implementations are chosen.
///
/// `AGENTS.md` has described this file for a while; it did not exist, so each
/// screen picked its own data source. Swapping the app from sample data to a
/// real network is now a single edit here rather than a hunt through `lib/`.
///
/// Selection is driven by [AppConfig], so a build flag decides — no code
/// change:
///
///   flutter run --dart-define=BACKEND=americangroupllc
class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator instance = ServiceLocator._();

  GuardianService? _guardians;
  CallService? _calls;

  /// Guardians shown on the map and pickers.
  ///
  /// With a backend configured this reads the Supabase `guardians` table; see
  /// [SupabaseGuardianService] for the schema. Otherwise it serves the bundled
  /// sample list, which keeps the app runnable offline and in demos.
  GuardianService get guardians => _guardians ??= AppConfig.hasBackend
      ? SupabaseGuardianService()
      : const MockGuardianService();

  /// Connecting to a guardian. Simulated until an RTC implementation exists.
  CallService get calls => _calls ??= const MockCallService();

  /// True when the guardians on screen are sample data rather than real
  /// responders. The UI uses this to be honest about what it is showing.
  ///
  /// A configured backend that has not answered yet still counts as sample:
  /// what matters is what is on the screen, not what was intended.
  bool get guardiansAreSample {
    final g = _guardians ?? guardians;
    if (g is SupabaseGuardianService) return g.usingFallback;
    return true;
  }

  /// True while a "call" connects nobody. Drives the Safe Call disclosure.
  bool get callsAreSimulated => calls.isSimulated;

  /// Test seam: replace an implementation, then [reset] afterwards.
  // ignore: use_setters_to_change_properties
  void overrideGuardians(GuardianService service) => _guardians = service;

  // ignore: use_setters_to_change_properties
  void overrideCalls(CallService service) => _calls = service;

  void reset() {
    _guardians = null;
    _calls = null;
  }
}

/// Short accessor, mirroring the `appState` and `analytics` globals.
final services = ServiceLocator.instance;

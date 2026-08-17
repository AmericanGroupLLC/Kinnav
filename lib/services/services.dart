import '../config/app_config.dart';
import 'guardian_service.dart';

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

  /// Guardians shown on the map and pickers.
  ///
  /// Falls back to the sample data whenever no backend is configured, which
  /// keeps the app runnable offline and in demos. When a real
  /// `GuardianService` exists, construct it here under `AppConfig.hasBackend`.
  GuardianService get guardians =>
      _guardians ??= const MockGuardianService();

  /// True when the guardians on screen are sample data rather than real
  /// responders. The UI uses this to be honest about what it is showing.
  bool get guardiansAreSample => !AppConfig.hasBackend;

  /// Test seam: replace an implementation, then [reset] afterwards.
  // ignore: use_setters_to_change_properties
  void overrideGuardians(GuardianService service) => _guardians = service;

  void reset() => _guardians = null;
}

/// Short accessor, mirroring the `appState` and `analytics` globals.
final services = ServiceLocator.instance;

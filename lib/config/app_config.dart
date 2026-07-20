/// Build-time configuration, supplied via --dart-define (or a --dart-define-from-file
/// JSON). Feature flags derive from whether the relevant credential is present,
/// so the app runs fully today and lights up real integrations once keys land.
///
/// Example:
///   flutter run --dart-define=MAPS_API_KEY=xxx --dart-define=AGORA_APP_ID=yyy \
///     --dart-define=BACKEND=firebase --dart-define=FLAVOR=prod
class AppConfig {
  AppConfig._();

  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  static const String mapsApiKey =
      String.fromEnvironment('MAPS_API_KEY', defaultValue: '');

  static const String agoraAppId =
      String.fromEnvironment('AGORA_APP_ID', defaultValue: '');

  /// 'mock' | 'firebase' | 'rest'
  static const String backend =
      String.fromEnvironment('BACKEND', defaultValue: 'mock');

  /// Base URL for a custom REST backend (when BACKEND=rest).
  static const String apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  /// Emergency number dialled by the "Add police" / Emergency actions.
  /// Override per region (e.g. 112 in the EU) via --dart-define.
  static const String emergencyNumber =
      String.fromEnvironment('EMERGENCY_NUMBER', defaultValue: '911');

  // Feature flags.
  static bool get hasMaps => mapsApiKey.isNotEmpty;
  static bool get hasVideo => agoraAppId.isNotEmpty;
  static bool get hasBackend => backend != 'mock';
  static bool get isProd => flavor == 'prod';

  /// A one-line banner of what's live, useful in debug/settings.
  static String get summary =>
      'flavor=$flavor backend=$backend maps=${hasMaps ? 'on' : 'off'} '
      'video=${hasVideo ? 'on' : 'off'}';
}

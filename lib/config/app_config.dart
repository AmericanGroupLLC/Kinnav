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

  /// 'mock' | 'americangroupllc' (AmericanGroupLLC API Gateway)
  /// Default 'mock' keeps the app usable offline (e.g. this sandbox / demos);
  /// pass --dart-define=BACKEND=americangroupllc to use the live gateway.
  static const String backend =
      String.fromEnvironment('BACKEND', defaultValue: 'mock');

  // ── AmericanGroupLLC backend (per AmericanGroupLLC_Developer_Docs) ──
  /// The ONLY URL the app should call.
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL',
      defaultValue: 'https://api.americangroupllc.com/api/v1');
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL',
      defaultValue: 'https://smvvjivvlprjhzhoizym.supabase.co');
  static const String supabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: 'sb_publishable_nqtYGp48NKiRF53zivkpsQ_bRiqDSfc');
  static const String firebaseProjectId = String.fromEnvironment(
      'FIREBASE_PROJECT_ID',
      defaultValue: 'americangroupllc-5bdfc');
  static const String googleClientId = String.fromEnvironment('GOOGLE_CLIENT_ID',
      defaultValue:
          '146431650883-blpfddrf32ureu4ucqlp3oku9jo07luq.apps.googleusercontent.com');
  static const String appleClientId = String.fromEnvironment('APPLE_CLIENT_ID',
      defaultValue: 'TLH7Z3G27A.com.americangroupllc.app');
  static const String supportEmail = 'support@safecodeg.com';

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

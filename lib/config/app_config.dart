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
      defaultValue:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNtdnZqaXZ2bHByamh6aG9penltIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAyMDIxMDMsImV4cCI6MjA5NTc3ODEwM30.csC-AHt-nI6BaZd6yt7imxbpAkS5tEOjqcpetZGWkF0');
  static const String firebaseProjectId = String.fromEnvironment(
      'FIREBASE_PROJECT_ID',
      defaultValue: 'americangroupllc-5bdfc');
  static const String googleClientId = String.fromEnvironment('GOOGLE_CLIENT_ID',
      defaultValue:
          '146431650883-blpfddrf32ureu4ucqlp3oku9jo07luq.apps.googleusercontent.com');
  static const String appleClientId = String.fromEnvironment('APPLE_CLIENT_ID',
      defaultValue: 'TLH7Z3G27A.com.americangroupllc.app');
  static const String supportEmail = 'support@safecodeg.com';

  // ── Native OAuth client identifiers ────────────────────────────────────────
  // These are PUBLIC OAuth client IDs (safe to ship in the client binary — they
  // are not secrets). The native Google / Apple SDKs and Supabase use them to
  // mint and verify the ID tokens exchanged in the Supabase-native token flow.

  /// Google **web / server** OAuth client id. Required as `serverClientId` so
  /// the native sign-in returns an `idToken` whose audience Supabase's Google
  /// provider trusts. Must match the "Client ID (for OAuth)" configured in the
  /// Supabase dashboard → Auth → Providers → Google. Overridable at build time
  /// via `--dart-define=GOOGLE_SERVER_CLIENT_ID=...`.
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue:
        '146431650883-blpfddrf32ureu4ucqlp3oku9jo07luq.apps.googleusercontent.com',
  );

  /// Google **iOS** OAuth client id (from `GoogleService-Info.plist`). Optional:
  /// when empty the native SDK falls back to the reversed-client-id URL scheme
  /// wired in `Info.plist`. Overridable via `--dart-define=GOOGLE_IOS_CLIENT_ID=...`.
  static const String googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: '',
  );

  /// Apple Services ID (bundle/service identifier) and Developer Team ID used
  /// for "Sign in with Apple". The Services ID must be registered as the Apple
  /// provider's Client ID in the Supabase dashboard. On a real iOS device the
  /// native token flow uses the app's bundle id; these back the web/redirect
  /// fallback and the Supabase dashboard configuration.
  static const String appleServiceId = 'com.americangroupllc.app';
  static const String appleTeamId = 'TLH7Z3G27A';

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

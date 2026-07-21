import '../config/app_config.dart';
import 'call_service.dart';
import 'guardian_service.dart';
import 'location_service.dart';
import 'notification_service.dart';
import 'purchase_service.dart';

/// Central service locator — the single place implementations are chosen based
/// on [AppConfig]. Screens depend on the interfaces via `Services.x`, so wiring
/// real backends (Firebase, Agora) is a one-line change here, not a UI refactor.
///
/// Authentication is handled directly by [SupabaseAuthService] (real Supabase
/// backend); the remaining slots below still choose implementations by config.
///
/// To go live (see requirements/specs/PRODUCTION.md):
///   • AGORA_APP_ID set → return AgoraCallService()
///   • Real push        → return FcmNotificationService()
///   • Real IAP         → return StoreKitPurchaseService()
class Services {
  Services._();

  static final GuardianService guardians = AppConfig.hasBackend
      ? MockGuardianService() // TODO: FirestoreGuardianService()
      : MockGuardianService();

  static final CallService call = AppConfig.hasVideo
      ? MockCallService() // TODO: AgoraCallService(AppConfig.agoraAppId)
      : MockCallService();

  static final LocationService location = GeoLocationService();

  static final PurchaseService purchases = MockPurchaseService();

  static NotificationService? notifications; // set at app start with a messenger
}

import '../config/app_config.dart';
import 'auth_service.dart';
import 'call_service.dart';
import 'guardian_service.dart';
import 'location_service.dart';
import 'notification_service.dart';
import 'purchase_service.dart';

/// Central service locator — the single place implementations are chosen based
/// on [AppConfig]. Screens depend on the interfaces via `Services.x`, so wiring
/// real backends (Firebase, Agora) is a one-line change here, not a UI refactor.
///
/// To go live (see docs/PRODUCTION.md):
///   • BACKEND=firebase → return FirebaseAuthService()/FirestoreGuardianService()
///   • AGORA_APP_ID set  → return AgoraCallService()
///   • Real push         → return FcmNotificationService()
///   • Real IAP          → return StoreKitPurchaseService()
class Services {
  Services._();

  static final AuthService auth = AppConfig.backend == 'firebase'
      ? MockAuthService() // TODO: FirebaseAuthService() once configured
      : MockAuthService();

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

import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  // Explicit engine so registered plugins share the same engine as the
  // FlutterViewController we create programmatically.
  private let flutterEngine = FlutterEngine(name: "safer_engine")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Google Maps: reads the key from Info.plist (GMSApiKey). Harmless when empty
    // — the app falls back to the offline painted map.
    if let key = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String,
       !key.isEmpty {
      GMSServices.provideAPIKey(key)
    }

    flutterEngine.run()
    GeneratedPluginRegistrant.register(with: flutterEngine)

    // Set up the Flutter window programmatically instead of via Main.storyboard.
    // This build environment cannot run ibtool to compile storyboards, so we
    // avoid storyboards entirely.
    let flutterViewController = FlutterViewController(
      engine: flutterEngine, nibName: nil, bundle: nil)
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = flutterViewController
    window.makeKeyAndVisible()
    self.window = window

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

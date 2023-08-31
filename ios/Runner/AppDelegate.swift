import UIKit
import Flutter
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Use Firebase library to configure APIs
    FirebaseApp.configure()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// Auth.auth().signInAnonymously { authResult, error in
//   // ...
// }

// guard let user = authResult?.user else { return }
// let isAnonymous = user.isAnonymous  // true
// let uid = user.uid
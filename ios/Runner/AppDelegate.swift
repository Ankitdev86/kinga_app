import UIKit
import Flutter
import GoogleMaps


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
//    GMSPlacesClient.provideAPIKey("AIzaSyAHK0oNURLIdEjB59KQXVemT0JsoJQHfg8")
    GMSServices.provideAPIKey("AIzaSyAHK0oNURLIdEjB59KQXVemT0JsoJQHfg8")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

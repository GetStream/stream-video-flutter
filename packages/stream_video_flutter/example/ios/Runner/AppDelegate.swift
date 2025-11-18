import Flutter
import UIKit
import stream_video_push_notification

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    StreamVideoPKDelegateManager.shared.registerForPushNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

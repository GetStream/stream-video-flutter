import UIKit
import Flutter
import stream_video_push_notification

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // Register for push notifications.
        StreamVideoPKDelegateManager.shared.registerForPushNotifications()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

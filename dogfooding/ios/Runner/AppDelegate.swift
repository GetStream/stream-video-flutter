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
        UNUserNotificationCenter.current().delegate = self
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // This method will be called when notification is received
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         willPresent notification: UNNotification,
                                         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let streamDict = notification.request.content.userInfo["stream"] as? [String: Any]
        if(streamDict?["sender"] as? String != "stream.video") {
            return completionHandler([])
        }
        
        if #available(iOS 14.0, *) {
            completionHandler([.list, .banner, .sound])
        } else {
            completionHandler([.alert])
        }
    }
    
    
}

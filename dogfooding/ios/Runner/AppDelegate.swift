import UIKit
import Flutter
import PushKit
import stream_video
import flutter_callkit_incoming

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      let mainQueue = DispatchQueue.main
      let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
      voipRegistry.delegate = self
      voipRegistry.desiredPushTypes = [PKPushType.voIP]
      SwiftStreamVideoPlugin.setDevicePushTokenVoIP(deviceToken: "deviceToken")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
            print(credentials.token)
            let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
            print(deviceToken)
            //Save deviceToken to your server
            SwiftStreamVideoPlugin.setDevicePushTokenVoIP(deviceToken: deviceToken)
        }
        
}

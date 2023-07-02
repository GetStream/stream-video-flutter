import UIKit
import Flutter
import PushKit
import stream_video_push_notification
import flutter_callkit_incoming
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
      
    let mainQueue = DispatchQueue.main
    let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
    voipRegistry.delegate = self
    voipRegistry.desiredPushTypes = [PKPushType.voIP]
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print(credentials.token)
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print(deviceToken)
        SwiftStreamVideoPushNotificationPlugin.setDevicePushTokenVoIP(deviceToken: deviceToken)
    }

    func pushRegistry(
        _ registry: PKPushRegistry,
        didReceiveIncomingPushWith payload: PKPushPayload,
        for type: PKPushType,
        completion: @escaping () -> Void
    ) {
        let aps = payload.dictionaryPayload["aps"] as? [String: Any]
        let streamDict = payload.dictionaryPayload["stream"] as? [String: Any]
        let createdCallerName = streamDict?["created_by_display_name"] as? String ?? ""
        let callCid = streamDict?["call_cid"] as? String ?? ""

        let id = UUID().uuidString
        let isVideo = payload.dictionaryPayload["isVideo"] as? Bool ?? false

        if((SwiftFlutterCallkitIncomingPlugin.sharedInstance?.activeCalls().count ?? 0) >= 1){
            return;
        }

        let data = flutter_callkit_incoming.Data(id: id, nameCaller: callCid, handle: createdCallerName, type: isVideo ? 1 : 0)
        data.extra = ["incomingCallCid": callCid, "platform": "ios"]
        
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            completion()
        }
    }
}

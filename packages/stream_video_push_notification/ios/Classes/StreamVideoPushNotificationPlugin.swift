import Flutter
import UIKit
import flutter_callkit_incoming

public class StreamVideoPushNotificationPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        // no-op
    }
    
    @objc public static func setDevicePushTokenVoIP(deviceToken: String) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }
    
    @objc public static func startOutgoingCall(
        uuid: String,
        callCid: String,
        avatar: String? = nil,
        handle: String? = nil,
        nameCaller: String? = nil,
        hasVideo: Bool = true,
        fromPushKit: Bool
    ) {
        let defaultCallText = "Unknown Caller"
        
        let data = flutter_callkit_incoming.Data(
            id: uuid,
            nameCaller: nameCaller ?? defaultCallText,
            handle: handle ?? defaultCallText,
            type: hasVideo ? 1 : 0
        )
        data.extra = ["callCid": callCid]
        
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.startCall(data, fromPushKit: fromPushKit)
    }
    
    @objc public static func showIncomingCall(
        uuid: String,
        callCid: String,
        avatar: String? = nil,
        handle: String? = nil,
        nameCaller: String? = nil,
        hasVideo: Bool = true,
        fromPushKit: Bool
    ) {
        let defaultCallText = "Unknown Caller"
        
        let data = flutter_callkit_incoming.Data(
            id: uuid,
            nameCaller: nameCaller ?? defaultCallText,
            handle: handle ?? defaultCallText,
            type: hasVideo ? 1 : 0
        )
        data.extra = ["callCid": callCid]
        
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: fromPushKit)
    }
    
    @objc public static func activeCalls() -> [[String: Any]]? {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.activeCalls();
    }
}

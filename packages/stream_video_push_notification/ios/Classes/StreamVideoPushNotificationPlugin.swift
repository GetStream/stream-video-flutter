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

    @objc public static func startCall(_ data: flutter_callkit_incoming.Data, fromPushKit: Bool) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.startCall(data, fromPushKit: fromPushKit)
    }

    @objc public static func showCallKitIncoming(_ data: flutter_callkit_incoming.Data, fromPushKit: Bool) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: fromPushKit)
    }

    @objc public static func activeCalls() -> [[String: Any]]? {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.activeCalls();
    }
}
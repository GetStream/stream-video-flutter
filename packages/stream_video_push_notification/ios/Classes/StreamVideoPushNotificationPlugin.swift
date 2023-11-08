import Flutter
import UIKit
import flutter_callkit_incoming

public class StreamVideoPushNotificationPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "stream_video_push_notifications", binaryMessenger: registrar.messenger())
        let instance = StreamVideoPushNotificationPlugin()

        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "initData":
                if let arguments = call.arguments as? [String: Any] {
                    StreamVideoPKDelegateManager.shared.initData(data: arguments)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid argument", details: nil))
                }
            default:
                result(FlutterMethodNotImplemented)
        }
    }       
    
    @objc public static func setDevicePushTokenVoIP(deviceToken: String) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }
    
    @objc public static func startOutgoingCall(
        data: flutter_callkit_incoming.Data,
        fromPushKit: Bool
    ) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.startCall(data, fromPushKit: fromPushKit)
    }
    
    @objc public static func showIncomingCall(
        data: flutter_callkit_incoming.Data,
        fromPushKit: Bool
    ) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: fromPushKit)
    }
    
    @objc public static func activeCalls() -> [[String: Any]]? {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.activeCalls();
    }
}

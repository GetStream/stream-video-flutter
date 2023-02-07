import Flutter
import UIKit

public class SwiftStreamVideoPushNotificationPlugin: NSObject, FlutterPlugin {
  private static let voipPushTokenKey = "stream.video.voip.token"
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "stream_video_push_notification", binaryMessenger: registrar.messenger())
    let instance = SwiftStreamVideoPushNotificationPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public static func setDevicePushTokenVoIP(deviceToken: String) {
      UserDefaults.standard.set(deviceToken, forKey: voipPushTokenKey)
      // TODO: Store this device on SwiftFlutterCallkitIncomingPlugin
      // SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
          case "getPlatformVersion":
              result("iOS " + UIDevice.current.systemVersion)
              break
          case "getDevicePushTokenVoIP":
              result(UserDefaults.standard.value(forKey: voipPushTokenKey) as? String)
              break
          default:
              result(FlutterMethodNotImplemented)
      }
    }
}

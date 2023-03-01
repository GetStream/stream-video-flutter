import Flutter
import UIKit
import flutter_callkit_incoming

public class SwiftStreamVideoPushNotificationPlugin: NSObject, FlutterPlugin {
  private static let voipPushTokenKey = "stream.video.voip.token"
  @objc public static var sharedInstance: SwiftStreamVideoPushNotificationPlugin? = nil
  private var channel: FlutterMethodChannel? = nil
  private var eventChannel: FlutterEventChannel? = nil
  private var eventCallbackHandler: EventCallbackHandler? = nil

  public static func sharePluginWithRegister(with registrar: FlutterPluginRegistrar) -> SwiftStreamVideoPushNotificationPlugin {
      if(sharedInstance == nil){
          sharedInstance = SwiftStreamVideoPushNotificationPlugin()
      }
      sharedInstance!.channel = FlutterMethodChannel(name: "stream_video_push_notification", binaryMessenger: registrar.messenger())
      sharedInstance!.eventChannel = FlutterEventChannel(name: "stream_video_push_notification_events", binaryMessenger: registrar.messenger())
      sharedInstance!.eventCallbackHandler = EventCallbackHandler()
      sharedInstance!.eventChannel?.setStreamHandler(sharedInstance!.eventCallbackHandler as? FlutterStreamHandler & NSObjectProtocol)
      return sharedInstance!
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = sharePluginWithRegister(with: registrar)
    if let channel = instance.channel {
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
  }

  public static func setDevicePushTokenVoIP(deviceToken: String) {
      UserDefaults.standard.set(deviceToken, forKey: voipPushTokenKey)
      SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }

  public func handleIncomingCall(callCid: String) {
    eventCallbackHandler?.send("ACTION_INCOMING_CALL", [ "call_cid": callCid ])
  }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
          case "getDevicePushTokenVoIP":
              result(UserDefaults.standard.value(forKey: SwiftStreamVideoPushNotificationPlugin.voipPushTokenKey) as? String)
              break
          default:
              result(FlutterMethodNotImplemented)
      }
    }
}


class EventCallbackHandler: FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    public func send(_ event: String, _ body: Any) {
        let data: [String : Any] = [
            "event": event,
            "body": body
        ]
        eventSink?(data)
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
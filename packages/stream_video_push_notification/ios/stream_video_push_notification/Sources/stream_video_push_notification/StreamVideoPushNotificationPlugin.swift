import Flutter
import UIKit

public class StreamVideoPushNotificationPlugin: NSObject, FlutterPlugin {
    private static let devicePushTokenVoIPKey = "DevicePushTokenVoIP"

    let persistentState: UserDefaults = UserDefaults.standard

    @objc public private(set) static var sharedInstance: StreamVideoPushNotificationPlugin?

    private var callKitManager: StreamVideoCallkitManager

    private override init() {
        self.callKitManager = StreamVideoCallkitManager.shared
        super.init()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let mainChannel = FlutterMethodChannel(
            name: "stream_video_push_notification", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(
            name: "stream_video_push_notification_events", binaryMessenger: registrar.messenger())

        let eventsHandler = EventCallbackHandler()
        eventChannel.setStreamHandler(eventsHandler)

        StreamVideoCallkitManager.shared.setEventHandler(eventsHandler)

        sharedInstance = StreamVideoPushNotificationPlugin()
        registrar.addMethodCallDelegate(sharedInstance!, channel: mainChannel)

        StreamVideoPKDelegateManager.shared.initChannel(mainChannel: mainChannel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initData":
            if let arguments = call.arguments as? [String: Any] {
                if let iosData = arguments["ios"] as? [String: Any],
                    let iconName = iosData["iconName"] as? String
                {
                    persistentState.set(iconName, forKey: "callKit_iconName")
                }

                StreamVideoPKDelegateManager.shared.initData(data: arguments)
                callKitManager.initCallkitProvider(CallData(args: arguments))
                result(nil)
            } else {
                result(
                    FlutterError(
                        code: "INVALID_ARGUMENT", message: "Invalid argument", details: nil))
            }
        case "getDevicePushTokenVoIP":
            result(self.getDevicePushTokenVoIP())
            break
        default:
            callKitManager.handle(call, result: result)
        }
    }

    @objc public static func setDevicePushTokenVoIP(deviceToken: String) {
        sharedInstance?.setDevicePushTokenVoIP(deviceToken: deviceToken)
    }

    @objc public static func startOutgoingCall(
        data: CallData,
        fromPushKit: Bool
    ) {
        StreamVideoCallkitManager.shared.startCall(data, fromPushKit: fromPushKit)
    }

    @objc public static func showIncomingCall(
        data: CallData,
        fromPushKit: Bool
    ) {
        StreamVideoCallkitManager.shared.showIncomingCall(
            data, fromPushKit: fromPushKit)
    }

    @objc public static func activeCalls() -> [[String: Any]]? {
        return StreamVideoCallkitManager.shared.activeCalls()
    }

    @objc public func setDevicePushTokenVoIP(deviceToken: String) {
        persistentState.set(deviceToken, forKey: Self.devicePushTokenVoIPKey)
    }

    @objc public func getDevicePushTokenVoIP() -> String {
        return persistentState.string(forKey: Self.devicePushTokenVoIPKey) ?? ""
    }
}

public class EventCallbackHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    public func send(_ event: String, _ body: Any) {
        let data: [String: Any] = [
            "event": event,
            "body": body,
        ]

        DispatchQueue.main.async { [weak self] in
            self?.eventSink?(data)
        }
    }

    public func onListen(
        withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink
    )
        -> FlutterError?
    {
        self.eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}

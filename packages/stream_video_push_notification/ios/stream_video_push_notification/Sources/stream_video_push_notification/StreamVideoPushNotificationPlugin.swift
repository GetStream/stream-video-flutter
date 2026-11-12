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

        let eventsHandler = EventCallbackHandler(sink: StreamVideoCallkitManager.shared.eventSink)
        eventChannel.setStreamHandler(eventsHandler)

        StreamVideoCallkitManager.shared.setEventHandler(eventsHandler)

        sharedInstance = StreamVideoPushNotificationPlugin()
        registrar.addMethodCallDelegate(sharedInstance!, channel: mainChannel)

        VoIPPushRegistryHandler.shared.initChannel(mainChannel: mainChannel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch PushMethodCallRouter.command(for: call) {
        case .initData(let arguments):
            if let arguments = arguments {
                if let iosData = arguments["ios"] as? [String: Any],
                    let iconName = iosData["iconName"] as? String
                {
                    persistentState.set(iconName, forKey: "callKit_iconName")
                }

                // Kept for the cold-start VoIP push path, where no Dart code has run yet.
                StreamVideoPushConfiguration(args: arguments).persist()

                VoIPPushRegistryHandler.shared.initData(data: arguments)
                callKitManager.initCallkitProvider(CallData(args: arguments))
                result(nil)
            } else {
                result(
                    FlutterError(
                        code: "INVALID_ARGUMENT", message: "Invalid argument", details: nil))
            }
        case .getDevicePushTokenVoIP:
            result(self.getDevicePushTokenVoIP())
        case let command:
            callKitManager.handle(command, result: result)
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

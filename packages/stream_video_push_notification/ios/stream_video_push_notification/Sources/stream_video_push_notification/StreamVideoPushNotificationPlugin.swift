import Flutter
import UIKit

public class StreamVideoPushNotificationPlugin: NSObject, FlutterPlugin {
    private static let devicePushTokenVoIPKey = "DevicePushTokenVoIP"

    /// The token kind in `getPushToken` for the PushKit VoIP token.
    static let voipTokenKind = "voip"

    let persistentState: UserDefaults = UserDefaults.standard

    private(set) static var sharedInstance: StreamVideoPushNotificationPlugin?

    private var callKitManager: StreamVideoCallkitManager

    /// Where this registration hands the APNs token and `registerApnDeviceToken`.
    var apnsTokens: RemoteNotificationTokenHandler = .shared

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

        let instance = StreamVideoPushNotificationPlugin()
        sharedInstance = instance
        registrar.addMethodCallDelegate(instance, channel: mainChannel)
        // For the APNs token: Flutter's app delegate forwards its remote notification
        // callbacks to the plugins that registered as application delegates.
        registrar.addApplicationDelegate(instance)

        VoIPPushRegistryHandler.shared.initChannel(mainChannel: mainChannel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch PushCommand(call) {
        case .initData(let arguments):
            if let arguments = arguments {
                if let iosData = arguments["ios"] as? [String: Any],
                    let iconName = iosData["iconName"] as? String
                {
                    persistentState.set(iconName, forKey: "callKit_iconName")
                }

                // Kept for the cold-start VoIP push path, where no Dart code has run yet.
                let configuration = StreamVideoPushConfiguration(args: arguments)
                configuration.persist()
                callKitManager.audio.ringingConfiguration =
                    configuration.ringingAudioConfiguration

                VoIPPushRegistryHandler.shared.initData(data: arguments)
                callKitManager.initCallkitProvider(CallData(args: arguments))
                apnsTokens.configure(with: arguments)
                result(nil)
            } else {
                result(
                    FlutterError(
                        code: "INVALID_ARGUMENT", message: "Invalid argument", details: nil))
            }
        case .getDevicePushTokenVoIP:
            result(self.getDevicePushTokenVoIP())
        case .getPushToken(let kind):
            result(self.pushToken(kind: kind))
        case let command:
            callKitManager.handle(command, result: result)
        }
    }

    /// Stores `deviceToken` as this device's PushKit VoIP token and tells Dart it changed. An
    /// empty token means PushKit invalidated the last one.
    ///
    /// Works before the plugin registers, as when an app delegate registers PushKit in
    /// `application(_:didFinishLaunchingWithOptions:)`: the token is stored straight away, and
    /// the event is held until Dart listens. While Dart has silenced events, the event is dropped
    /// like any other; the stored token is still registered the next time the device is.
    @objc public static func setDevicePushTokenVoIP(deviceToken: String) {
        setDevicePushTokenVoIP(
            deviceToken,
            in: UserDefaults.standard,
            notifying: StreamVideoCallkitManager.shared.eventSink)
    }

    static func setDevicePushTokenVoIP(
        _ deviceToken: String, in defaults: UserDefaults, notifying sink: RingingEventSink
    ) {
        defaults.set(deviceToken, forKey: devicePushTokenVoIPKey)
        sink.send(
            StreamVideoIncomingCallConstants.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP,
            ["deviceTokenVoIP": deviceToken])
    }

    static func devicePushTokenVoIP(in defaults: UserDefaults) -> String {
        return defaults.string(forKey: devicePushTokenVoIPKey) ?? ""
    }

    /// Asks CallKit to start `data` as an outgoing call.
    @objc public static func startOutgoingCall(data: CallData) {
        StreamVideoCallkitManager.shared.startCall(data)
    }

    /// Asks CallKit to start `data` as an outgoing call. `fromPushKit` is ignored.
    @available(*, deprecated, renamed: "startOutgoingCall(data:)", message: "fromPushKit is ignored.")
    @objc public static func startOutgoingCall(
        data: CallData,
        fromPushKit: Bool
    ) {
        startOutgoingCall(data: data)
    }

    /// Reports an incoming call to CallKit.
    @objc public static func showIncomingCall(data: CallData) {
        StreamVideoCallkitManager.shared.showIncomingCall(data)
    }

    /// Reports an incoming call to CallKit. `fromPushKit` is ignored.
    @available(*, deprecated, renamed: "showIncomingCall(data:)", message: "fromPushKit is ignored.")
    @objc public static func showIncomingCall(
        data: CallData,
        fromPushKit: Bool
    ) {
        showIncomingCall(data: data)
    }

    /// Reports an incoming call to CallKit, and runs `completion` once CallKit accepted or
    /// refused it, or straight away when it could not be reported. An app with its own PushKit
    /// delegate can call PushKit's completion from it.
    @objc public static func showIncomingCall(
        data: CallData,
        completion: @escaping () -> Void
    ) {
        StreamVideoCallkitManager.shared.showIncomingCall(data, completion: completion)
    }

    @objc public static func activeCalls() -> [[String: Any]]? {
        return StreamVideoCallkitManager.shared.activeCalls()
    }

    func getDevicePushTokenVoIP() -> String {
        return Self.devicePushTokenVoIP(in: persistentState)
    }

    func pushToken(kind: String) -> String {
        return Self.pushToken(kind: kind, voipIn: persistentState, apns: apnsTokens)
    }

    /// The stored token of `kind`, `voip` or `apns`; empty for a kind iOS has no token of, or
    /// one not issued yet.
    static func pushToken(
        kind: String, voipIn defaults: UserDefaults, apns: RemoteNotificationTokenHandler
    ) -> String {
        switch kind {
        case voipTokenKind:
            return devicePushTokenVoIP(in: defaults)
        case RemoteNotificationTokenHandler.kind:
            return apns.token
        default:
            return ""
        }
    }

    // MARK: - Remote notifications

    public func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        apnsTokens.didRegister(deviceToken: deviceToken)
    }

    public func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        apnsTokens.didFailToRegister(error: error)
    }
}

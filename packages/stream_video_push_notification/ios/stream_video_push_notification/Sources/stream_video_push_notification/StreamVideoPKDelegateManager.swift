import Flutter
import Foundation
import PushKit

public class StreamVideoPKDelegateManager: NSObject, PKPushRegistryDelegate,
    UNUserNotificationCenterDelegate
{
    public static let shared = StreamVideoPKDelegateManager()

    private var pushRegistry: PKPushRegistry?
    private var defaultConfiguration: StreamVideoPushConfiguration?
    private var mainChannel: FlutterMethodChannel?

    private override init() {
        super.init()
    }

    @objc public func registerForPushNotifications() {
        pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry?.delegate = self
        pushRegistry?.desiredPushTypes = [.voIP]
    }

    public func initChannel(mainChannel: FlutterMethodChannel) {
        self.mainChannel = mainChannel
    }

    public func initData(data: [String: Any]) {
        defaultConfiguration = StreamVideoPushConfiguration(args: data)
    }

    /// The configuration to build the incoming call with.
    ///
    /// A VoIP push can arrive before Dart has had a chance to call `initData`, most notably on a
    /// cold start, so fall back to the copy persisted by the last run instead of silently using
    /// defaults and losing the configured ringtone and Recents behaviour.
    private func resolveConfiguration() -> StreamVideoPushConfiguration? {
        if let defaultConfiguration = defaultConfiguration {
            return defaultConfiguration
        }

        let persisted = StreamVideoPushConfiguration.loadPersisted()
        defaultConfiguration = persisted
        return persisted
    }

    // MARK: - PKPushRegistryDelegate
    @objc public func pushRegistry(
        _ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials,
        for type: PKPushType
    ) {
        let deviceToken = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
        return StreamVideoPushNotificationPlugin.setDevicePushTokenVoIP(deviceToken: deviceToken)
    }

    @objc public func pushRegistry(
        _ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType
    ) {
        return StreamVideoPushNotificationPlugin.setDevicePushTokenVoIP(deviceToken: "")
    }

    @objc public func pushRegistry(
        _ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload,
        for type: PKPushType, completion: @escaping () -> Void
    ) {
        // Return if type is not voIP.
        guard type == .voIP else {
            return completion()
        }

        var streamDict = payload.dictionaryPayload["stream"] as? [String: Any]
        handleIncomingCall(
            streamDict: streamDict, state: UIApplication.shared.applicationState,
            completion: completion)
    }

    func handleIncomingCall(
        streamDict: [String: Any]?, state: UIApplication.State, completion: @escaping () -> Void
    ) {
        let defaultCallText = "Unknown Caller"

        let callCid = streamDict?["call_cid"] as? String ?? ""
        let createdByName = streamDict?["created_by_display_name"] as? String
        let callDisplayName = streamDict?["call_display_name"] as? String
        let createdById = streamDict?["created_by_id"] as? String
        let videoIncluded = streamDict?["video"] as? String
        let videoData = videoIncluded == "false" ? 0 : 1

        var callUUID = UUID().uuidString

        let configuration = self.resolveConfiguration()

        let data: CallData
        if let configuration = configuration {
            data = CallData.init(args: configuration.toJSON())
        } else {
            data = CallData.init(args: [String: Any]())
        }

        let nonEmptyString: (String?) -> String? = { str in
            return str?.isEmpty == false ? str : nil
        }

        data.uuid = callUUID
        data.callerName =
            nonEmptyString(callDisplayName) ?? nonEmptyString(createdByName) ?? defaultCallText
        data.handle = createdById ?? defaultCallText

        data.type = videoData
        data.extra = ["callCid": callCid]
        data.iconName =
            UserDefaults.standard.string(forKey: "callKit_iconName") ?? configuration?
            .iconName ?? data.iconName

        // Show call incoming notification.
        StreamVideoPushNotificationPlugin.showIncomingCall(
            data: data,
            fromPushKit: true
        )

        completion()
    }

}

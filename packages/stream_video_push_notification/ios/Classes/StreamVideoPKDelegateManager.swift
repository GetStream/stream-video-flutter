import Foundation
import PushKit
import flutter_callkit_incoming

public class StreamVideoPKDelegateManager: NSObject, PKPushRegistryDelegate {
    public static let shared = StreamVideoPKDelegateManager()
    
    private var pushRegistry: PKPushRegistry?
    private var defaultData: [String: Any]?
    
    private override init() {
        super.init()
    }
    
    @objc public func registerForPushNotifications() {
        pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry?.delegate = self
        pushRegistry?.desiredPushTypes = [.voIP]
    }

    public func initData(data: [String: Any]) {
        defaultData = data
    }
    
    // MARK: - PKPushRegistryDelegate
    @objc public func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let deviceToken = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
        return StreamVideoPushNotificationPlugin.setDevicePushTokenVoIP(deviceToken: deviceToken)
    }
    
    @objc public func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        return StreamVideoPushNotificationPlugin.setDevicePushTokenVoIP(deviceToken: "")
    }
    
    @objc public func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        // Return if type is not voIP.
        guard type == .voIP else {
            return completion()
        }

        let defaultCallText = "Unknown Caller"

        // Prepare call kit incoming notification.
        let streamDict = payload.dictionaryPayload["stream"] as? [String: Any]
        let callCid = streamDict?["call_cid"] as? String ?? ""

        let createdByName = streamDict?["created_by_display_name"] as? String
        let createdById = streamDict?["created_by_id"] as? String

        let data: flutter_callkit_incoming.Data
        if let jsonData = defaultData {
            data = try! flutter_callkit_incoming.Data(args: jsonData)
        } else {
            data = try! flutter_callkit_incoming.Data(args: [String: Any]())
        }

        let displayNameOverride = data.extra["display_name_override"] as? String

        data.uuid = UUID().uuidString
        data.nameCaller = displayNameOverride ?? createdByName ?? defaultCallText
        data.handle = createdById ?? defaultCallText
        data.type = 1 //video
        data.extra = ["callCid": callCid]

        // Show call incoming notification.
        StreamVideoPushNotificationPlugin.showIncomingCall(
            data: data,
            fromPushKit: true
        )
        
        // Complete after a delay to ensure that the incoming call notification
        // is displayed before completing the push notification handling.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            completion()
        }
    }
}

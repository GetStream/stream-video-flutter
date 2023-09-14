import Foundation
import PushKit
import flutter_callkit_incoming

public class StreamVideoVoIPPushService: NSObject, PKPushRegistryDelegate {

    private let queue: DispatchQueue
    private let registry: PKPushRegistry

    override public init() {
        print("Init StreamVideoVoIPPushService")
        self.queue = DispatchQueue(label: "io.getstream.voip")
        self.registry = PKPushRegistry(queue: queue)
    }

    @objc public func registerForVoIPPushes() {
        print("Register for VoIP pushes")
        self.registry.delegate = self
        self.registry.desiredPushTypes = [.voIP]
    }

    @objc public func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        print("Did update push credentials")
        let deviceToken = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
        print("Token: \(deviceToken)")
        return StreamVideoPushNotificationPlugin.setDevicePushTokenVoIP(deviceToken: deviceToken)
    }

    @objc public func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("Did invalidate push token for type: \(type)")
        return StreamVideoPushNotificationPlugin.setDevicePushTokenVoIP(deviceToken: "")
    }


    @objc public func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> ()) {
        print("Did receive incoming push with payload: \(payload)")

        // Return if type is not voIP.
        guard type == .voIP else {
            return
        }

        let defaultCallText = "Unknown Caller"

        // Prepare notification data.
        let uuid = UUID().uuidString
        let streamDict = payload.dictionaryPayload["stream"] as? [String: Any]
        let callCid = streamDict?["call_cid"] as? String ?? "unknown"
        let createdByName = streamDict?["created_by_display_name"] as? String ?? defaultCallText
        let createdById = streamDict?["created_by_id"] as? String ?? defaultCallText

        let data = flutter_callkit_incoming.Data(id: uuid, nameCaller: createdByName, handle: createdById, type: 1)
        data.extra = ["incomingCallCid": callCid]

        // Show call incoming notification.
        StreamVideoPushNotificationPlugin.showCallKitIncoming(data, fromPushKit: true)

        // Complete after a delay to ensure that the incoming call notification
        // is displayed before completing the push notification handling.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            completion()
        }
    }
}

import Foundation

extension StreamVideoCallkitManager {

    /// Makes `handler`, the stream handler of the latest event channel, the one events go to.
    public func setEventHandler(_ handler: EventCallbackHandler) {
        eventSink.attach(handler)
    }

    func sendEvent(_ event: String, _ body: [String: Any?]?) {
        eventSink.send(event, body ?? [:])
    }

    @objc public func sendEventCustom(_ event: String, body: NSDictionary?) {
        // Convert NSDictionary to [String: Any?] for queueing if needed
        let bodyDict = body as? [String: Any?]
        sendEvent(event, bodyDict)
    }

    func sendMuteEvent(_ id: String, _ isMuted: Bool) {
        self.sendEvent(
            StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_MUTE,
            ["id": id, "isMuted": isMuted])
    }

    func sendHoldEvent(_ id: String, _ isOnHold: Bool) {
        self.sendEvent(
            StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_HOLD,
            ["id": id, "isOnHold": isOnHold])
    }
}

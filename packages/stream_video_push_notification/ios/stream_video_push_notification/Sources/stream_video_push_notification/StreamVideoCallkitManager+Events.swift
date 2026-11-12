import Foundation

extension StreamVideoCallkitManager {

    /// Makes `handler`, the stream handler of the latest event channel, the one events go to.
    public func setEventHandler(_ handler: EventCallbackHandler) {
        eventSink.attach(handler)
    }

    func sendEvent(_ event: String, _ body: [String: Any?]?) {
        eventSink.send(event, body ?? [:])
    }

    /// Carries out the effects of a store transition, in order.
    func apply(_ effects: [CallKitEffect]) {
        for effect in effects {
            switch effect {
            case .send(let event, let body):
                sendEvent(event, body)
            case .reportStartedConnecting(let uuid, let date):
                sharedProvider?.reportOutgoingCall(with: uuid, startedConnectingAt: date)
            case .reportConnected(let uuid, let date):
                sharedProvider?.reportOutgoingCall(with: uuid, connectedAt: date)
            case .postAudioInterruptionEnded:
                audio.postInterruptionEnded(object: self)
            }
        }
    }

    @objc public func sendEventCustom(_ event: String, body: NSDictionary?) {
        // Convert NSDictionary to [String: Any?] for queueing if needed
        let bodyDict = body as? [String: Any?]
        sendEvent(event, bodyDict)
    }
}

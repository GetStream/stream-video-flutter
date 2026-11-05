import CallKit
import Foundation

@available(iOS 10.0, *)
class StreamCallKitCallController: NSObject {

    private let callController = CXCallController(queue: .main)
    private var sharedProvider: CXProvider? = nil
    private(set) var calls = [Call]()

    /// Data of outgoing calls whose start action CallKit has not performed yet, by call uuid.
    private var pendingOutgoingCalls = [UUID: CallData]()

    func setSharedProvider(_ sharedProvider: CXProvider) {
        self.sharedProvider = sharedProvider
    }

    /// Every call CallKit knows about on the device, this app's and other apps' alike.
    var observedCalls: [CXCall] {
        callController.callObserver.calls
    }

    /// Delivers `observedCalls` changes to `delegate` on the main queue.
    func setCallObserverDelegate(_ delegate: CXCallObserverDelegate) {
        callController.callObserver.setDelegate(delegate, queue: nil)
    }

    /// `uuid` is the CallKit uuid to start the call with; by default the one in `data`.
    /// Requests the start of a call from CallKit. `completion` reports whether CallKit took the
    /// transaction; the call itself is created when CallKit performs the start action.
    func startCall(
        _ data: CallData, uuid explicitUUID: UUID? = nil, completion: ((Bool) -> Void)? = nil
    ) {
        let handle = CXHandle(
            type: self.getHandleType(data.handleType), value: data.getEncryptHandle())

        guard let uuid = explicitUUID ?? UUID(uuidString: data.uuid) else {
            print("Error: Invalid UUID string: \(data.uuid)")
            completion?(false)
            return
        }

        let startCallAction = CXStartCallAction(call: uuid, handle: handle)
        startCallAction.isVideo = data.type > 0

        let callTransaction = CXTransaction()
        callTransaction.addAction(startCallAction)

        if self.pendingOutgoingCalls[uuid] == nil {
            self.pendingOutgoingCalls[uuid] = data
        }

        self.requestCall(
            callTransaction, action: "startCall",
            completion: { started in
                guard started else {
                    if self.pendingOutgoingCalls[uuid] === data {
                        self.pendingOutgoingCalls[uuid] = nil
                    }
                    completion?(false)
                    return
                }

                let callUpdate = CXCallUpdate()
                callUpdate.remoteHandle = handle
                callUpdate.supportsDTMF = data.supportsDTMF
                callUpdate.supportsHolding = data.supportsHolding
                callUpdate.supportsGrouping = data.supportsGrouping
                callUpdate.supportsUngrouping = data.supportsUngrouping
                callUpdate.hasVideo = data.type > 0 ? true : false
                callUpdate.localizedCallerName = data.callerName
                self.sharedProvider?.reportCall(with: uuid, updated: callUpdate)
                completion?(true)
            })
    }

    func muteCall(call: Call, isMuted: Bool) {
        let muteAction = CXSetMutedCallAction(call: call.uuid, muted: isMuted)

        let callTransaction = CXTransaction()
        callTransaction.addAction(muteAction)

        self.requestCall(callTransaction, action: "muteCall")
    }

    func holdCall(call: Call, onHold: Bool) {
        let onHoldAction = CXSetHeldCallAction(call: call.uuid, onHold: onHold)

        let callTransaction = CXTransaction()
        callTransaction.addAction(onHoldAction)

        self.requestCall(callTransaction, action: "holdCall")
    }

    func endCall(call: Call) {
        let endCallAction = CXEndCallAction(call: call.uuid)

        let callTransaction = CXTransaction()
        callTransaction.addAction(endCallAction)

        self.requestCall(callTransaction, action: "endCall")
    }

    /// Tells CallKit the call is connected, so the ringing UI becomes an in-call one.
    ///
    /// Deliberately not recovered automatically, unlike a refused end. There is no safe move here:
    /// the app's own state is not known at this layer, and ending the call to clear the stale ring
    /// would dismiss a ring the user may still be able to answer.
    ///
    /// Only an incoming call this plugin is tracking is answered; marking an outgoing call
    /// connected already reports it to CallKit.
    func connectedCall(call: Call, completion: ((Bool) -> Void)? = nil) {
        guard let callItem = self.callWithUUID(uuid: call.uuid) else {
            completion?(false)
            return
        }
        if !callItem.hasConnected {
            callItem.connectedCall(completion: nil)
        }

        if callItem.isOutGoing {
            completion?(true)
            return
        }

        let answerAction = CXAnswerCallAction(call: call.uuid)
        let transaction = CXTransaction(action: answerAction)

        self.requestCall(transaction, action: "connectedCall", completion: completion)
    }

    func endAllCalls() {
        let calls = callController.callObserver.calls
        for call in calls {
            let endCallAction = CXEndCallAction(call: call.uuid)

            let callTransaction = CXTransaction()
            callTransaction.addAction(endCallAction)

            self.requestCall(callTransaction, action: "endAllCalls")
        }
    }

    func activeCalls() -> [[String: Any]] {
        let calls = callController.callObserver.calls
        var json = [[String: Any]]()
        for call in calls {
            let callItem = self.callWithUUID(uuid: call.uuid)
            if callItem != nil {
                var item: [String: Any] = callItem!.data.toJSON()
                item["accepted"] = callItem?.hasConnected
                json.append(item)
            } else {
                let item: [String: String] = ["id": self.reportedId(for: call.uuid)]
                json.append(item)
            }
        }
        return json
    }

    private func requestCall(
        _ transaction: CXTransaction, action: String, completion: ((Bool) -> Void)? = nil
    ) {
        callController.request(transaction) { [weak self] error in
            if let error = error {
                NSLog("CallKit transaction '\(action)' failed: \(error.localizedDescription)")
                self?.clearCallsAfterFailedEnd(transaction, action: action)
                completion?(false)
                return
            }

            NSLog("CallKit transaction '\(action)' succeeded")
            completion?(true)
        }
    }

    /// Last resort for an end transaction the call controller refused.
    ///
    /// A rejected `CXEndCallAction` used to be logged and dropped. Nothing retries it and nothing
    /// else ends the call, so the CallKit screen stayed up for a call that had already ended
    /// everywhere else. Reporting the call as ended goes through the provider instead of the call
    /// controller, so it still clears the UI when the controller will not take the transaction.
    ///
    /// Only the provider that reported a call can end it this way, so this cannot rescue a call
    /// left behind by an earlier process — it covers a call this process knows about whose end
    /// transaction was refused.
    private func clearCallsAfterFailedEnd(_ transaction: CXTransaction, action: String) {
        guard action == "endCall" || action == "endAllCalls" else { return }

        for callAction in transaction.actions.compactMap({ $0 as? CXCallAction }) {
            NSLog("Reporting call \(callAction.callUUID) as ended after the failed \(action)")
            sharedProvider?.reportCall(
                with: callAction.callUUID, endedAt: Date(), reason: .remoteEnded)

            // Drop our own bookkeeping too: reporting a call as ended does not run the
            // `CXEndCallAction` delegate that normally does it.
            if let call = callWithUUID(uuid: callAction.callUUID) {
                removeCall(call)
            }
        }
    }

    private func getHandleType(_ handleType: String?) -> CXHandle.HandleType {
        var typeDefault = CXHandle.HandleType.generic
        switch handleType {
        case "number":
            typeDefault = CXHandle.HandleType.phoneNumber
            break
        case "email":
            typeDefault = CXHandle.HandleType.emailAddress
        default:
            typeDefault = CXHandle.HandleType.generic
        }
        return typeDefault
    }

    static let callsChangedNotification = Notification.Name("CallsChangedNotification")
    var callsChangedHandler: (() -> Void)?

    /// Returns and forgets the data `startCall` was called with for `uuid`.
    func takePendingOutgoingCall(uuid: UUID) -> CallData? {
        return self.pendingOutgoingCalls.removeValue(forKey: uuid)
    }
  
    /// The id the call was started or shown with, or the lowercased uuid if this plugin does not track that call.
    func reportedId(for uuid: UUID) -> String {
        let fallback = uuid.uuidString.lowercased()
        guard let call = self.callWithUUID(uuid: uuid) else { return fallback }
        if let reportedId = call.reportedId {
            return reportedId
        }
        guard call.data.uuid.lowercased() == fallback else { return fallback }
        return call.data.uuid
    }

    /// The call CallKit knows by `uuid`, or the one the app still knows by it after a second
    /// registration with CallKit.
    func callWithUUID(uuid: UUID) -> Call? {
        if let call = calls.first(where: { $0.uuid == uuid }) { return call }
        return calls.first(where: { $0.originalUUID == uuid })
    }

    func addCall(_ call: Call) {
        calls.append(call)
        call.stateDidChange = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.callsChangedHandler?()
            strongSelf.postCallNotification()
        }
        callsChangedHandler?()
        postCallNotification()
    }

    func removeCall(_ call: Call) {
        guard let idx = calls.firstIndex(where: { $0 === call }) else { return }
        calls.remove(at: idx)
        callsChangedHandler?()
        postCallNotification()
    }

    func removeAllCalls() {
        calls.removeAll()
        pendingOutgoingCalls.removeAll()
        callsChangedHandler?()
        postCallNotification()
    }

    private func postCallNotification() {
        NotificationCenter.default.post(name: type(of: self).callsChangedNotification, object: self)
    }

}

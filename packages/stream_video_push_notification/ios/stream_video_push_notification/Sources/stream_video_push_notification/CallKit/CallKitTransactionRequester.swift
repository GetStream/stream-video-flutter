import CallKit
import Foundation

/// Asks CallKit, through `CXCallController`, to start, answer, mute, hold or end calls.
final class CallKitTransactionRequester {

    private let callController = CXCallController(queue: .main)

    /// Called with each call an end transaction was refused for.
    var onEndRefused: ((UUID) -> Void)?

    /// The uuids of the calls CallKit knows, from this app and any earlier process of it.
    var systemCallUUIDs: [UUID] {
        callController.callObserver.calls.map { $0.uuid }
    }

    func start(uuid: UUID, handle: CXHandle, isVideo: Bool, completion: @escaping (Bool) -> Void) {
        let startCallAction = CXStartCallAction(call: uuid, handle: handle)
        startCallAction.isVideo = isVideo

        let callTransaction = CXTransaction()
        callTransaction.addAction(startCallAction)

        self.requestCall(callTransaction, action: "startCall", completion: completion)
    }

    func mute(uuid: UUID, isMuted: Bool) {
        let muteAction = CXSetMutedCallAction(call: uuid, muted: isMuted)

        let callTransaction = CXTransaction()
        callTransaction.addAction(muteAction)

        self.requestCall(callTransaction, action: "muteCall")
    }

    func hold(uuid: UUID, onHold: Bool, completion: ((Bool) -> Void)? = nil) {
        let onHoldAction = CXSetHeldCallAction(call: uuid, onHold: onHold)

        let callTransaction = CXTransaction()
        callTransaction.addAction(onHoldAction)

        self.requestCall(callTransaction, action: "holdCall", completion: completion)
    }

    func end(uuid: UUID) {
        let endCallAction = CXEndCallAction(call: uuid)

        let callTransaction = CXTransaction()
        callTransaction.addAction(endCallAction)

        self.requestCall(callTransaction, action: "endCall")
    }

    /// Tells CallKit the call is connected, so the ringing UI becomes an in-call one. A refused
    /// answer is logged and nothing else happens.
    func answer(uuid: UUID, completion: ((Bool) -> Void)? = nil) {
        let answerAction = CXAnswerCallAction(call: uuid)
        let transaction = CXTransaction(action: answerAction)

        self.requestCall(transaction, action: "connectedCall", completion: completion)
    }

    func endAll() {
        for uuid in systemCallUUIDs {
            let endCallAction = CXEndCallAction(call: uuid)

            let callTransaction = CXTransaction()
            callTransaction.addAction(endCallAction)

            self.requestCall(callTransaction, action: "endAllCalls")
        }
    }

    private func requestCall(
        _ transaction: CXTransaction, action: String, completion: ((Bool) -> Void)? = nil
    ) {
        callController.request(transaction) { [weak self] error in
            if let error = error {
                NSLog("CallKit transaction '\(action)' failed: \(error.localizedDescription)")
                self?.reportRefusedEnd(transaction, action: action)
                completion?(false)
                return
            }

            NSLog("CallKit transaction '\(action)' succeeded")
            completion?(true)
        }
    }

    /// Hands each call of a refused end transaction to `onEndRefused`.
    private func reportRefusedEnd(_ transaction: CXTransaction, action: String) {
        guard action == "endCall" || action == "endAllCalls" else { return }

        for callAction in transaction.actions.compactMap({ $0 as? CXCallAction }) {
            NSLog("Reporting call \(callAction.callUUID) as ended after the failed \(action)")
            onEndRefused?(callAction.callUUID)
        }
    }
}

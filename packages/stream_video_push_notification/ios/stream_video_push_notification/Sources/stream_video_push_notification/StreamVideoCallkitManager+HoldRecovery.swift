import CallKit
import Foundation

extension StreamVideoCallkitManager: HoldRecoveryActions {

    func requestUnhold(_ uuid: UUID, completion: @escaping (Bool) -> Void) {
        transactions.hold(uuid: uuid, onHold: false, completion: completion)
    }

    /// Reports `call` as ended. Dart is not told: the call goes on under its app id.
    func endForReRegistration(_ call: CallKitCall) {
        suppressRecentsIfRegisteredAgain(call)
        sharedProvider?.reportCall(with: call.identity.callKitUUID, endedAt: nil, reason: .remoteEnded)
    }

    func startReRegistration(
        _ call: CallKitCall, as uuid: UUID, completion: @escaping (Bool) -> Void
    ) {
        transactions.start(
            uuid: uuid, handle: handle(call.options), isVideo: call.options.type > 0,
            completion: completion)
    }

    func reRegistrationAbandoned(_ call: CallKitCall) {
        endReRegisteringCall(call, reason: .failed, notifyDart: true)
    }

    /// Ends `call`, which CallKit already took as ended, before it is registered again. A start
    /// CallKit performs for it later is failed.
    func endReRegisteringCall(_ call: CallKitCall, reason: CXCallEndedReason?, notifyDart: Bool) {
        let effects = store.reRegisteringCallEnded(call, reason: reason)
        if notifyDart {
            apply(effects)
        }
        callsRemoved()
    }

    /// CallKit performed the start action of `call`, which is registered again under its new
    /// uuid. The call is reported connected straight away, with its details.
    func reRegistrationStarted(_ call: CallKitCall) {
        let uuid = call.identity.callKitUUID
        let now = Date()
        sharedProvider?.reportOutgoingCall(with: uuid, startedConnectingAt: now)
        sharedProvider?.reportOutgoingCall(with: uuid, connectedAt: now)
        sharedProvider?.reportCall(with: uuid, updated: callUpdate(call.options))
        NSLog("[StreamCallKit] \(call.identity.appId) is registered with CallKit as \(uuid)")
        holdRecovery.reRegistrationStarted(call)
    }

    /// Turns Recents off, until no call is left, when `call` is about to end under a uuid it was
    /// registered with again.
    ///
    /// CallKit reads the flag when a call ends, after the code reporting the end has returned.
    /// So the end of the call as first reported is listed, and the end of each registration
    /// made since is not. Nothing changes for options that keep calls out of Recents anyway.
    func suppressRecentsIfRegisteredAgain(_ call: CallKitCall?) {
        guard let call = call, !call.identity.previousCallKitUUIDs.isEmpty,
            call.options.includesCallsInRecents, recentsSuppressedFor == nil
        else { return }
        recentsSuppressedFor = call.options
        sharedProvider?.configuration = createConfiguration(
            call.options, includesCallsInRecents: false)
    }

    /// Calls in the store ended or were removed; allows the audio engine once none is left.
    func callsRemoved() {
        audio.callsRemoved(store)
    }

    /// Turns Recents back on once no call is left. Called when CallKit deactivates the audio
    /// session or resets, which come after CallKit has listed the last call's end: turning it
    /// on while the end action runs would list the call.
    func restoreRecentsIfNoCallLeft() {
        guard !store.hasOngoingCall, let options = recentsSuppressedFor else { return }
        recentsSuppressedFor = nil
        sharedProvider?.configuration = createConfiguration(options)
    }
}

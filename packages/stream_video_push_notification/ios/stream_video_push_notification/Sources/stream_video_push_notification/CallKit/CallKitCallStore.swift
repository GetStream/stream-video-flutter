import CallKit
import Foundation

/// Something a transition of `CallKitCallStore` asks the plugin to do.
enum CallKitEffect {
    /// Send `event` to Dart.
    case send(event: String, body: [String: Any?]?)
    /// Tell CallKit the outgoing call started connecting.
    case reportStartedConnecting(UUID, Date)
    /// Tell CallKit the call connected.
    case reportConnected(UUID, Date)
}

/// What CallKit's end action resolves to.
struct CallKitEndOutcome {
    /// Whether the action is fulfilled; it fails for a call the store does not track.
    let fulfills: Bool
    let effects: [CallKitEffect]
}

/// Every call the plugin tracks, looked up by app id or CallKit uuid.
///
/// Transitions change the store and return the effects to carry out, in order. The store
/// itself never talks to CallKit or Dart.
final class CallKitCallStore {

    private(set) var calls: [CallKitCall] = []

    /// The options of outgoing calls whose start action CallKit has not performed yet.
    private var pendingOutgoingOptions: [UUID: CallData] = [:]

    /// The options of the call the plugin was last given. Set by Dart's `showIncomingCall` and
    /// `startCall`, by its `endCall` and `callConnected` while `isFromPushKit` is false, and by a
    /// call shown or started from PushKit. Events use it where no tracked call matches.
    var lastOptions: CallData?

    /// True from a call shown or started from PushKit until Dart ends or connects a call, the
    /// app shows or starts another, or all calls are ended natively. While true, Dart's
    /// `endCall` and `callConnected` act on `lastOptions` whatever id they name.
    var isFromPushKit = false

    /// The call CallKit last answered. Cleared when CallKit ends any tracked call while this or
    /// `outgoingCall` is set.
    private(set) var answeredCall: CallKitCall?

    /// The call CallKit last started. Never cleared.
    private(set) var outgoingCall: CallKitCall?

    // MARK: - Lookups

    func call(forCallKit uuid: UUID) -> CallKitCall? {
        calls.first { $0.identity.callKitUUID == uuid }
    }

    func call(forAppId id: String) -> CallKitCall? {
        guard let uuid = UUID(uuidString: id) else { return nil }
        return call(forCallKit: uuid)
    }

    /// The id events report the call CallKit knows as `uuid` by: see
    /// `CallKitCallIdentity.reportedId`, or the lowercased uuid for a call the store does not
    /// track.
    func reportedId(for uuid: UUID) -> String {
        call(forCallKit: uuid)?.identity.reportedId ?? uuid.uuidString.lowercased()
    }

    /// The options of the call `args` names: the last options when they name it, else the
    /// tracked call's, else a call built from `args`.
    func options(for args: [String: Any]) -> CallData {
        guard let id = args["id"] as? String else {
            return CallData(args: args)
        }
        if let lastOptions = lastOptions, lastOptions.uuid.lowercased() == id.lowercased() {
            return lastOptions
        }
        if let call = call(forAppId: id) {
            return call.options
        }
        return CallData(args: args)
    }

    /// The `activeCalls` payload for the calls CallKit knows, in its order.
    func activeCalls(systemCallUUIDs: [UUID]) -> [[String: Any]] {
        systemCallUUIDs.map { uuid in
            guard let call = call(forCallKit: uuid) else {
                return ["id": reportedId(for: uuid)]
            }
            var item = call.options.toJSON()
            item["accepted"] = call.connectedAt != nil
            return item
        }
    }

    // MARK: - Calls the plugin is asked for

    /// The app or a push asked to show `options` as an incoming call.
    func showRequested(_ options: CallData, fromPushKit: Bool) {
        isFromPushKit = fromPushKit
        if fromPushKit {
            lastOptions = options
        }
    }

    /// The app or a push asked to start `options` as an outgoing call.
    func startRequested(_ options: CallData, fromPushKit: Bool) {
        showRequested(options, fromPushKit: fromPushKit)
    }

    func registerPendingOutgoing(_ options: CallData, uuid: UUID) {
        if pendingOutgoingOptions[uuid] == nil {
            pendingOutgoingOptions[uuid] = options
        }
    }

    /// Forgets the pending options of `uuid` when they are still `options`.
    func dropPendingOutgoing(uuid: UUID, ifStill options: CallData) {
        if pendingOutgoingOptions[uuid] === options {
            pendingOutgoingOptions[uuid] = nil
        }
    }

    // MARK: - Transitions

    /// CallKit accepted the incoming call `options` describes, as `uuid`.
    func incomingReported(
        _ options: CallData, uuid: UUID, source: CallKitCall.Source
    ) -> [CallKitEffect] {
        let call = CallKitCall(
            identity: CallKitCallIdentity(appId: options.uuid, callKitUUID: uuid),
            direction: .incoming, source: source, options: options, phase: .ringing)
        calls.append(call)
        return [.send(event: StreamVideoIncomingCallConstants.ACTION_CALL_INCOMING, body: options.toJSON())]
    }

    /// Whether the ring of the call `appId` names times out now: it is still tracked and no
    /// call is answered or outgoing.
    func shouldTimeOut(appId: String) -> Bool {
        call(forAppId: appId) != nil && answeredCall == nil && outgoingCall == nil
    }

    /// The ring of `options` timed out and was reported to CallKit as unanswered.
    func timedOut(_ options: CallData) -> [CallKitEffect] {
        guard let call = call(forAppId: options.uuid) else { return [] }
        call.move(to: .ended(.unanswered))
        return [.send(event: StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT, body: options.toJSON())]
    }

    /// CallKit performed the start action for `uuid`. Nil when there are no options to start it
    /// with.
    func startPerformed(uuid: UUID) -> (call: CallKitCall, effects: [CallKitEffect])? {
        guard let options = pendingOutgoingOptions.removeValue(forKey: uuid) ?? lastOptions else {
            return nil
        }
        let call = CallKitCall(
            identity: CallKitCallIdentity(appId: options.uuid, callKitUUID: uuid),
            direction: .outgoing, source: isFromPushKit ? .pushKit : .app, options: options,
            phase: .starting)
        call.reportsConnection = true
        outgoingCall = call
        calls.append(call)
        return (call, [.send(event: StreamVideoIncomingCallConstants.ACTION_CALL_START, body: options.toJSON())])
    }

    /// CallKit performed the answer action for `uuid`. Nil for a call the store does not track.
    ///
    /// Marks both the call's options and the last options accepted.
    func answerPerformed(uuid: UUID) -> [CallKitEffect]? {
        guard let call = call(forCallKit: uuid) else { return nil }
        call.reportsConnection = true
        lastOptions?.isAccepted = true
        call.options.isAccepted = true
        call.move(to: .answering)
        answeredCall = call
        return [.send(event: StreamVideoIncomingCallConstants.ACTION_CALL_ACCEPT, body: call.options.toJSON())]
    }

    /// CallKit performed the end action for `uuid`.
    func endPerformed(uuid: UUID) -> CallKitEndOutcome {
        let noActiveCall = answeredCall == nil && outgoingCall == nil
        guard let call = call(forCallKit: uuid) else {
            let event =
                noActiveCall
                ? StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT
                : StreamVideoIncomingCallConstants.ACTION_CALL_ENDED
            return CallKitEndOutcome(
                fulfills: false, effects: [.send(event: event, body: lastOptions?.toJSON())])
        }
        call.move(to: .ended(nil))
        remove(call)
        if noActiveCall {
            return CallKitEndOutcome(
                fulfills: true,
                effects: [.send(event: StreamVideoIncomingCallConstants.ACTION_CALL_DECLINE, body: call.options.toJSON())])
        }
        answeredCall = nil
        return CallKitEndOutcome(
            fulfills: true,
            effects: [.send(event: StreamVideoIncomingCallConstants.ACTION_CALL_ENDED, body: call.options.toJSON())])
    }

    /// CallKit performed the hold action for `uuid`. Nil for a call the store does not track.
    func holdPerformed(uuid: UUID, onHold: Bool) -> [CallKitEffect]? {
        guard let call = call(forCallKit: uuid) else { return nil }
        call.isOnHold = onHold
        call.isMuted = onHold
        return [holdEvent(call, onHold)]
    }

    /// CallKit performed the mute action for `uuid`. Nil for a call the store does not track.
    func mutePerformed(uuid: UUID, muted: Bool) -> [CallKitEffect]? {
        guard let call = call(forCallKit: uuid) else { return nil }
        call.isMuted = muted
        return [muteEvent(call, muted)]
    }

    /// CallKit performed the group action for `uuid`. Nil for a call the store does not track.
    func groupPerformed(uuid: UUID, groupWith: UUID?) -> [CallKitEffect]? {
        guard call(forCallKit: uuid) != nil else { return nil }
        return [
            .send(
                event: StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_GROUP,
                body: [
                    "id": reportedId(for: uuid),
                    "callUUIDToGroupWith": groupWith.map { reportedId(for: $0) },
                ])
        ]
    }

    /// CallKit performed the DTMF action for `uuid`. Nil for a call the store does not track.
    func dtmfPerformed(uuid: UUID, digits: String, type: Int) -> [CallKitEffect]? {
        guard call(forCallKit: uuid) != nil else { return nil }
        return [
            .send(
                event: StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_DTMF,
                body: [
                    "id": reportedId(for: uuid),
                    "digits": digits,
                    "type": type,
                ])
        ]
    }

    /// Whether the answered or the outgoing call already connected, in which case an audio
    /// session activation only restarts audio.
    var hasConnectedCall: Bool {
        answeredCall?.connectedAt != nil || outgoingCall?.connectedAt != nil
    }

    /// Whether the outgoing or the answered call is on hold.
    var hasHeldCall: Bool {
        outgoingCall?.isOnHold == true || answeredCall?.isOnHold == true
    }

    /// CallKit activated the audio session while neither the answered nor the outgoing call is
    /// connected.
    func audioActivated(at date: Date = Date()) -> [CallKitEffect] {
        var effects: [CallKitEffect] = []
        if let outgoing = outgoingCall {
            outgoing.startedConnectingAt = date
            outgoing.move(to: .active)
            effects.append(.reportStartedConnecting(outgoing.identity.callKitUUID, date))
        }
        if let answered = answeredCall {
            answered.startedConnectingAt = date
            answered.move(to: .active)
        }
        return effects
    }

    /// The app reported the call CallKit knows as `uuid` connected. Nil for a call the store does
    /// not track.
    func connected(uuid: UUID, at date: Date = Date()) -> (call: CallKitCall, effects: [CallKitEffect])? {
        guard let call = call(forCallKit: uuid) else { return nil }
        guard call.connectedAt == nil else { return (call, []) }
        call.connectedAt = date
        let effects: [CallKitEffect] =
            call.reportsConnection ? [.reportConnected(call.identity.callKitUUID, date)] : []
        return (call, effects)
    }

    /// The app reported to CallKit how the call CallKit knows as `uuid` ended.
    func endReported(uuid: UUID, reason: CXCallEndedReason) {
        call(forCallKit: uuid)?.move(to: .ended(reason))
    }

    /// The app ended all calls natively.
    func allCallsEndRequested() {
        isFromPushKit = false
    }

    /// CallKit reset the provider: every tracked call and pending outgoing call is gone.
    func reset() {
        calls.forEach { $0.move(to: .ended(nil)) }
        calls.removeAll()
        pendingOutgoingOptions.removeAll()
    }

    func remove(_ call: CallKitCall) {
        calls.removeAll { $0 === call }
    }

    func remove(uuid: UUID) {
        if let call = call(forCallKit: uuid) {
            remove(call)
        }
    }

    // MARK: - Events

    func muteEvent(_ call: CallKitCall, _ isMuted: Bool) -> CallKitEffect {
        .send(
            event: StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_MUTE,
            body: ["id": call.identity.reportedId, "isMuted": isMuted])
    }

    func holdEvent(_ call: CallKitCall, _ isOnHold: Bool) -> CallKitEffect {
        .send(
            event: StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_HOLD,
            body: ["id": call.identity.reportedId, "isOnHold": isOnHold])
    }
}

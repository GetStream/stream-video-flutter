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
    /// Post an ended audio interruption that asks audio code to resume.
    case postAudioInterruptionEnded
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

    /// Every uuid a call was asked to be registered again as.
    private var reRegistrationUUIDs: Set<UUID> = []

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

    /// The call whose app id is `id`, in any case, else the call CallKit knows as `id`.
    func call(forAppId id: String) -> CallKitCall? {
        let lowercasedId = id.lowercased()
        if let call = calls.first(where: { $0.identity.appId.lowercased() == lowercasedId }) {
            return call
        }
        guard let uuid = UUID(uuidString: id) else { return nil }
        return call(forCallKit: uuid)
    }

    /// The uuid CallKit knows the call `id` names by: the tracked call's current uuid, else `id`
    /// itself when it is a uuid.
    func callKitUUID(forAppId id: String) -> UUID? {
        call(forAppId: id)?.identity.callKitUUID ?? UUID(uuidString: id)
    }

    /// The call being registered again as `uuid`.
    func call(reRegisteringAs uuid: UUID) -> CallKitCall? {
        calls.first {
            if case .reRegistering(let newUUID, _) = $0.phase { return newUUID == uuid }
            return false
        }
    }

    /// Whether `uuid` was handed out to register a call again, whatever became of that call.
    func isReRegistrationUUID(_ uuid: UUID) -> Bool {
        reRegistrationUUIDs.contains(uuid)
    }

    /// Whether `uuid` names a tracked call: as CallKit knows it now, knew it before, or is about
    /// to know it after a re-registration.
    func isTracked(callKitUUID uuid: UUID) -> Bool {
        calls.contains { $0.identity.isKnown(as: uuid) } || call(reRegisteringAs: uuid) != nil
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

    /// The `activeCalls` payload for the calls CallKit knows, in its order. A uuid a tracked call
    /// was known by before, or is being registered again as, is left out.
    func activeCalls(systemCallUUIDs: [UUID]) -> [[String: Any]] {
        systemCallUUIDs.compactMap { uuid in
            guard let call = call(forCallKit: uuid) else {
                if isTracked(callKitUUID: uuid) || isReRegistrationUUID(uuid) {
                    return nil
                }
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

    /// Whether the ring of the call `appId` names times out now: it is still tracked, has not
    /// ended, and no call is answered or outgoing.
    func shouldTimeOut(appId: String) -> Bool {
        guard let call = call(forAppId: appId), !call.phase.isEnded else { return false }
        return answeredCall == nil && outgoingCall == nil
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
    /// Marks the call's options accepted, and the last options too when they name this call.
    func answerPerformed(uuid: UUID) -> [CallKitEffect]? {
        guard let call = call(forCallKit: uuid) else { return nil }
        call.reportsConnection = true
        if let last = lastOptions, last.uuid.lowercased() == call.identity.appId.lowercased() {
            last.isAccepted = true
        }
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
    ///
    /// Holding moves the call to `.held(origin)`; taking a held call off hold moves it to
    /// `.resumed(activated: false)`. Either way the call is muted while on hold.
    func holdPerformed(
        uuid: UUID, onHold: Bool, origin: CallKitHoldOrigin = .requested
    ) -> [CallKitEffect]? {
        guard let call = call(forCallKit: uuid) else { return nil }
        if onHold {
            call.move(to: .held(origin))
            call.reRegistrationsSinceHold = 0
        } else if call.isOnHold {
            call.move(to: .resumed(activated: false))
        }
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

    /// Whether the outgoing or the answered call is on hold.
    var hasHeldCall: Bool {
        outgoingCall?.isOnHold == true || answeredCall?.isOnHold == true
    }

    /// Whether a tracked call has not ended.
    var hasOngoingCall: Bool {
        calls.contains { !$0.phase.isEnded }
    }

    /// The answered call, else the outgoing call, that has not ended.
    var liveCall: CallKitCall? {
        callsUsingAudio.first
    }

    /// The answered and the outgoing call, when they have not ended.
    private var callsUsingAudio: [CallKitCall] {
        [answeredCall, outgoingCall].compactMap { $0 }.filter { !$0.phase.isEnded }
    }

    /// The answered and the outgoing call, when CallKit has not activated the audio session for
    /// them yet.
    var callsAwaitingFirstActivation: [CallKitCall] {
        callsUsingAudio.filter { !$0.hasActivatedAudioSession }
    }

    /// Whether an activation now is the first for a call: the answered or the outgoing call has
    /// not had the audio session activated, or neither is live.
    var isFirstAudioActivation: Bool {
        callsUsingAudio.isEmpty || !callsAwaitingFirstActivation.isEmpty
    }

    /// CallKit activated the audio session for the answered and the outgoing call. A resumed
    /// call is marked activated.
    func audioSessionActivated() {
        for call in callsUsingAudio {
            call.hasActivatedAudioSession = true
            if call.phase.isResumed {
                call.move(to: .resumed(activated: true))
            }
        }
    }

    /// The answered and the outgoing call start connecting on their first audio session
    /// activation. A call whose session was activated before, such as a held one, is left as it
    /// is.
    func audioActivated(at date: Date = Date()) -> [CallKitEffect] {
        var effects: [CallKitEffect] = []
        for call in callsAwaitingFirstActivation {
            call.startedConnectingAt = date
            call.move(to: .active)
            if call.direction == .outgoing {
                effects.append(.reportStartedConnecting(call.identity.callKitUUID, date))
            }
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

    /// CallKit refused to end the call it knows as `uuid`, so the call was reported as ended
    /// remotely instead.
    func endRefused(uuid: UUID) {
        if let call = call(forCallKit: uuid) {
            call.move(to: .ended(.remoteEnded))
            remove(call)
        }
    }

    // MARK: - Registering a call again

    /// `call` was reported to CallKit as ended and is being started again as `uuid`.
    func reRegistrationRequested(_ call: CallKitCall, as uuid: UUID) {
        reRegistrationUUIDs.insert(uuid)
        call.reRegistrationsSinceHold += 1
        call.move(to: .reRegistering(as: uuid, attempt: 0))
    }

    /// CallKit refused to start the call being registered again as `uuid`, and it is asked
    /// again.
    func reRegistrationRefused(uuid: UUID) {
        guard let call = call(reRegisteringAs: uuid),
            case .reRegistering(_, let attempt) = call.phase
        else { return }
        call.move(to: .reRegistering(as: uuid, attempt: attempt + 1))
    }

    /// CallKit performed the start action of the call being registered again as `uuid`. The call
    /// keeps its app id and waits for CallKit to activate its audio session. Nil when no call is
    /// being registered as `uuid`.
    func reRegistrationPerformed(uuid: UUID) -> CallKitCall? {
        guard let call = call(reRegisteringAs: uuid) else { return nil }
        call.rebind(to: uuid)
        call.move(to: .resumed(activated: false))
        return call
    }

    /// `call`, which CallKit already took as ended, is ended before it was registered again:
    /// CallKit kept refusing to start it, or the app ended it.
    func reRegisteringCallEnded(
        _ call: CallKitCall, reason: CXCallEndedReason?
    ) -> [CallKitEffect] {
        call.move(to: .ended(reason))
        remove(call)
        if answeredCall === call {
            answeredCall = nil
        }
        return [.send(event: StreamVideoIncomingCallConstants.ACTION_CALL_ENDED, body: call.options.toJSON())]
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

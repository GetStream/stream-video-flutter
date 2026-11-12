import CallKit
import XCTest

@testable import stream_video_push_notification

/// Pins the store's transitions as event sequences, without CallKit: what each step emits and
/// what the store holds afterwards.
final class CallKitCallStoreTests: XCTestCase {

    private var store: CallKitCallStore!

    override func setUp() {
        super.setUp()
        store = CallKitCallStore()
    }

    private func options(_ id: String) -> CallData {
        CallData(args: ["id": id, "extra": ["callCid": "default:\(id)"]])
    }

    private func names(_ effects: [CallKitEffect]?) -> [String] {
        (effects ?? []).compactMap {
            if case .send(let event, _) = $0 { return event }
            return nil
        }
    }

    private func sentIds(_ effects: [CallKitEffect]?) -> [String?] {
        (effects ?? []).compactMap {
            if case .send(_, let body) = $0 { return body?["id"] as? String }
            return nil
        }
    }

    /// Reports `id` as a ringing incoming call CallKit knows as a new uuid.
    @discardableResult
    private func ring(_ id: String, source: CallKitCall.Source = .app) -> CallKitCall {
        let uuid = UUID()
        _ = store.incomingReported(options(id), uuid: uuid, source: source)
        return store.call(forCallKit: uuid)!
    }

    // MARK: - Identity

    func testACallIsFoundByItsCallKitUUIDAndByItsAppIdInAnyCase() {
        let uuid = UUID()
        _ = store.incomingReported(options(uuid.uuidString), uuid: uuid, source: .app)

        XCTAssertNotNil(store.call(forCallKit: uuid))
        XCTAssertTrue(store.call(forAppId: uuid.uuidString.lowercased()) === store.call(forCallKit: uuid))
        XCTAssertNil(store.call(forAppId: "not a uuid"))
        XCTAssertNil(store.call(forCallKit: UUID()))
    }

    func testEventsReportTheAppIdAsGivenOrTheLowercasedUUID() {
        let uuid = UUID()
        _ = store.incomingReported(options(uuid.uuidString), uuid: uuid, source: .app)
        let unrelated = ring("not-the-uuid")

        XCTAssertEqual(store.reportedId(for: uuid), uuid.uuidString)
        XCTAssertEqual(
            store.reportedId(for: unrelated.identity.callKitUUID),
            unrelated.identity.callKitUUID.uuidString.lowercased())
        let untracked = UUID()
        XCTAssertEqual(store.reportedId(for: untracked), untracked.uuidString.lowercased())
    }

    func testRebindingKeepsTheAppIdAndRemembersTheOldUUID() {
        let call = ring("call")
        let first = call.identity.callKitUUID
        let second = UUID()

        call.rebind(to: second)

        XCTAssertEqual(call.identity.appId, "call")
        XCTAssertEqual(call.identity.callKitUUID, second)
        XCTAssertEqual(call.identity.previousCallKitUUIDs, [first])
        XCTAssertTrue(store.call(forCallKit: second) === call)
    }

    // MARK: - Incoming, answered from the CallKit UI, connected, hung up

    func testAnsweredIncomingCall() {
        let uuid = UUID()
        XCTAssertEqual(
            names(store.incomingReported(options("a"), uuid: uuid, source: .app)),
            [StreamVideoIncomingCallConstants.ACTION_CALL_INCOMING])
        let call = store.call(forCallKit: uuid)!
        XCTAssertEqual(call.phase, .ringing)
        XCTAssertEqual(call.direction, .incoming)

        let accept = store.answerPerformed(uuid: uuid)
        XCTAssertEqual(names(accept), [StreamVideoIncomingCallConstants.ACTION_CALL_ACCEPT])
        XCTAssertEqual(call.phase, .answering)
        XCTAssertTrue(call.options.isAccepted)
        XCTAssertTrue(store.answeredCall === call)

        XCTAssertTrue(store.audioActivated().isEmpty)
        XCTAssertEqual(call.phase, .active)
        XCTAssertNotNil(call.startedConnectingAt)

        let date = Date()
        let connected = store.connected(uuid: uuid, at: date)
        XCTAssertTrue(connected?.call === call)
        guard case .reportConnected(let reported, let at)? = connected?.effects.first else {
            return XCTFail("the connection is not reported to CallKit")
        }
        XCTAssertEqual(reported, uuid)
        XCTAssertEqual(at, date)
        XCTAssertEqual(call.connectedAt, date)

        let end = store.endPerformed(uuid: uuid)
        XCTAssertTrue(end.fulfills)
        XCTAssertEqual(names(end.effects), [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertEqual(sentIds(end.effects), ["a"])
        XCTAssertEqual(call.phase, .ended(nil))
        XCTAssertNil(store.answeredCall)
        XCTAssertTrue(store.calls.isEmpty)
    }

    func testAConnectionIsReportedOnceAndOnlyForACallCallKitAnsweredOrStarted() {
        let ringing = ring("ringing")
        XCTAssertEqual(store.connected(uuid: ringing.identity.callKitUUID)?.effects.count, 0)

        let answered = ring("answered")
        _ = store.answerPerformed(uuid: answered.identity.callKitUUID)
        XCTAssertEqual(store.connected(uuid: answered.identity.callKitUUID)?.effects.count, 1)
        XCTAssertEqual(store.connected(uuid: answered.identity.callKitUUID)?.effects.count, 0)

        XCTAssertNil(store.connected(uuid: UUID()))
    }

    // MARK: - Shown from PushKit

    func testAPushKitCallSetsTheFlagAndTheLastOptions() {
        let pushed = options("pushed")

        store.showRequested(pushed, fromPushKit: true)
        let call = ring("pushed", source: .pushKit)

        XCTAssertTrue(store.isFromPushKit)
        XCTAssertTrue(store.lastOptions === pushed)
        XCTAssertEqual(call.source, .pushKit)
    }

    func testShowingFromTheAppClearsThePushKitFlagAndKeepsTheLastOptions() {
        let pushed = options("pushed")
        store.showRequested(pushed, fromPushKit: true)

        store.showRequested(options("from-the-app"), fromPushKit: false)

        XCTAssertFalse(store.isFromPushKit)
        XCTAssertTrue(store.lastOptions === pushed)
    }

    func testEndingAllCallsNativelyClearsThePushKitFlag() {
        store.showRequested(options("pushed"), fromPushKit: true)

        store.allCallsEndRequested()

        XCTAssertFalse(store.isFromPushKit)
    }

    // MARK: - Declined from the CallKit UI

    func testDeclinedIncomingCall() {
        let call = ring("a")

        let end = store.endPerformed(uuid: call.identity.callKitUUID)

        XCTAssertTrue(end.fulfills)
        XCTAssertEqual(names(end.effects), [StreamVideoIncomingCallConstants.ACTION_CALL_DECLINE])
        XCTAssertEqual(sentIds(end.effects), ["a"])
        XCTAssertTrue(store.calls.isEmpty)
    }

    func testAnUntrackedEndFailsAndCarriesTheLastOptions() {
        store.lastOptions = options("last")

        let end = store.endPerformed(uuid: UUID())

        XCTAssertFalse(end.fulfills)
        XCTAssertEqual(names(end.effects), [StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT])
        XCTAssertEqual(sentIds(end.effects), ["last"])
    }

    // MARK: - The ring times out

    func testATrackedRingTimesOutSendingTimeoutAndStaysTracked() {
        let uuid = UUID()
        let shown = options(uuid.uuidString)
        _ = store.incomingReported(shown, uuid: uuid, source: .app)
        XCTAssertTrue(store.shouldTimeOut(appId: shown.uuid))

        let effects = store.timedOut(shown)

        XCTAssertEqual(names(effects), [StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT])
        XCTAssertEqual(sentIds(effects), [uuid.uuidString])
        XCTAssertEqual(store.call(forCallKit: uuid)?.phase, .ended(.unanswered))
    }

    func testAnUntrackedRingSendsNothingWhenItTimesOut() {
        XCTAssertEqual(names(store.timedOut(options(UUID().uuidString))), [])
    }

    func testARingDoesNotTimeOutOnceItIsGoneOrAnotherCallIsAnswered() {
        XCTAssertFalse(store.shouldTimeOut(appId: UUID().uuidString))

        let ringing = ring("ringing")
        let answered = ring("answered")
        _ = store.answerPerformed(uuid: answered.identity.callKitUUID)

        XCTAssertFalse(store.shouldTimeOut(appId: ringing.identity.callKitUUID.uuidString))
    }

    func testARingThatEndedDoesNotTimeOut() {
        let call = ring("ended")
        store.endReported(uuid: call.identity.callKitUUID, reason: .remoteEnded)

        XCTAssertFalse(store.shouldTimeOut(appId: "ended"))
    }

    // MARK: - Two calls at once

    func testEachTransitionCarriesItsOwnCallsOptions() {
        let first = ring("first")
        let second = ring("second")
        store.lastOptions = second.options

        XCTAssertEqual(sentIds(store.answerPerformed(uuid: first.identity.callKitUUID)), ["first"])
        XCTAssertTrue(first.options.isAccepted)
        XCTAssertFalse(second.options.isAccepted, "the last options belong to another call")
        XCTAssertEqual(
            sentIds(store.endPerformed(uuid: first.identity.callKitUUID).effects), ["first"])
    }

    func testMuteAndHoldEventsNameTheirCall() {
        let uuid = UUID()
        _ = store.incomingReported(options(uuid.uuidString), uuid: uuid, source: .app)

        XCTAssertEqual(sentIds(store.mutePerformed(uuid: uuid, muted: true)), [uuid.uuidString])
        XCTAssertTrue(store.call(forCallKit: uuid)!.isMuted)
        XCTAssertEqual(sentIds(store.holdPerformed(uuid: uuid, onHold: true)), [uuid.uuidString])
        XCTAssertTrue(store.call(forCallKit: uuid)!.isOnHold)
        XCTAssertFalse(store.hasHeldCall, "only the answered or outgoing call counts")
        XCTAssertNil(store.mutePerformed(uuid: UUID(), muted: true))
        XCTAssertNil(store.holdPerformed(uuid: UUID(), onHold: true))
    }

    func testHoldingLeavesTheMuteAsTheUserSetIt() {
        let call = ring("a")
        _ = store.mutePerformed(uuid: call.identity.callKitUUID, muted: true)

        _ = store.holdPerformed(uuid: call.identity.callKitUUID, onHold: true)
        _ = store.holdPerformed(uuid: call.identity.callKitUUID, onHold: false)
        XCTAssertTrue(call.isMuted)

        _ = store.mutePerformed(uuid: call.identity.callKitUUID, muted: false)
        _ = store.holdPerformed(uuid: call.identity.callKitUUID, onHold: true)
        XCTAssertFalse(call.isMuted)
    }

    func testTheAnsweredCallOnHoldCountsAsHeld() {
        let call = ring("a")
        _ = store.answerPerformed(uuid: call.identity.callKitUUID)

        _ = store.holdPerformed(uuid: call.identity.callKitUUID, onHold: true)

        XCTAssertTrue(store.hasHeldCall)
    }

    func testHoldingAndResumingMoveTheAnsweredCallThroughItsHoldPhases() {
        let call = ring("a")
        let uuid = call.identity.callKitUUID
        _ = store.answerPerformed(uuid: uuid)
        _ = store.audioActivated()

        _ = store.holdPerformed(uuid: uuid, onHold: true, origin: .otherCall)
        XCTAssertEqual(call.phase, .held(.otherCall))
        XCTAssertTrue(call.isOnHold)

        _ = store.holdPerformed(uuid: uuid, onHold: false)
        XCTAssertEqual(call.phase, .resumed(activated: false))
        XCTAssertFalse(call.isOnHold)

        store.audioSessionActivated()
        XCTAssertEqual(call.phase, .resumed(activated: true))

        _ = store.holdPerformed(uuid: uuid, onHold: false)
        XCTAssertEqual(call.phase, .resumed(activated: true), "a call not on hold stays as it is")
    }

    func testACallRegisteredAgainKeepsItsAppIdAndAllItsUUIDs() {
        let first = UUID()
        _ = store.incomingReported(options(first.uuidString), uuid: first, source: .pushKit)
        _ = store.answerPerformed(uuid: first)
        let call = store.call(forCallKit: first)!
        _ = store.holdPerformed(uuid: first, onHold: true, origin: .otherCall)
        _ = store.holdPerformed(uuid: first, onHold: false)
        let second = UUID()

        store.reRegistrationRequested(call, as: second)
        XCTAssertTrue(store.call(reRegisteringAs: second) === call)
        XCTAssertTrue(store.isTracked(callKitUUID: second))
        XCTAssertNil(store.reRegistrationPerformed(uuid: UUID()))

        XCTAssertTrue(store.reRegistrationPerformed(uuid: second) === call)
        XCTAssertEqual(call.phase, .resumed(activated: false))
        XCTAssertEqual(call.reRegistrationsSinceHold, 1)
        XCTAssertTrue(store.call(forAppId: first.uuidString.lowercased()) === call)
        XCTAssertEqual(store.callKitUUID(forAppId: first.uuidString), second)
        XCTAssertEqual(call.identity.reportedId, first.uuidString)
        XCTAssertEqual(
            sentIds(store.holdPerformed(uuid: second, onHold: true)), [first.uuidString])
        XCTAssertTrue(store.isTracked(callKitUUID: first))
        XCTAssertFalse(store.isTracked(callKitUUID: UUID()))
        XCTAssertEqual(call.reRegistrationsSinceHold, 0, "a hold starts the count again")
    }

    func testACallKnownByAnotherUUIDKeepsReportingItsFirstUUID() {
        let call = ring("not-a-uuid")
        let first = call.identity.callKitUUID

        call.rebind(to: UUID())

        XCTAssertEqual(call.identity.reportedId, first.uuidString.lowercased())
    }

    func testActiveCallsLeaveOutTheOtherUUIDsOfACall() {
        let first = UUID()
        _ = store.incomingReported(options(first.uuidString), uuid: first, source: .pushKit)
        let call = store.call(forCallKit: first)!
        let second = UUID()
        let third = UUID()
        store.reRegistrationRequested(call, as: second)
        _ = store.reRegistrationPerformed(uuid: second)
        store.reRegistrationRequested(call, as: third)
        let unrelated = UUID()

        let ids = store.activeCalls(systemCallUUIDs: [first, second, third, unrelated])
            .map { $0["id"] as? String }

        XCTAssertEqual(ids, [first.uuidString, unrelated.uuidString.lowercased()])
    }

    func testARefusedReRegistrationCountsItsAttempts() {
        let call = ring("a")
        let uuid = UUID()
        store.reRegistrationRequested(call, as: uuid)

        store.reRegistrationRefused(uuid: uuid)
        store.reRegistrationRefused(uuid: uuid)

        XCTAssertEqual(call.phase, .reRegistering(as: uuid, attempt: 2))
    }

    func testAnAbandonedReRegistrationEndsTheCallAndTellsDart() {
        let call = ring("a")
        _ = store.answerPerformed(uuid: call.identity.callKitUUID)
        store.reRegistrationRequested(call, as: UUID())

        let effects = store.reRegisteringCallEnded(call, reason: .failed)

        XCTAssertEqual(names(effects), [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertEqual(call.phase, .ended(.failed))
        XCTAssertTrue(store.calls.isEmpty)
        XCTAssertNil(store.answeredCall)
        XCTAssertFalse(store.hasOngoingCall)
    }

    func testAnsweringMarksTheLastOptionsAcceptedOnlyWhenTheyNameTheAnsweredCall() {
        let call = ring("a")
        let sameCall = options("A")
        store.lastOptions = sameCall

        _ = store.answerPerformed(uuid: call.identity.callKitUUID)

        XCTAssertTrue(sameCall.isAccepted)

        let other = ring("b")
        let otherLast = options("c")
        store.lastOptions = otherLast
        _ = store.answerPerformed(uuid: other.identity.callKitUUID)

        XCTAssertFalse(otherLast.isAccepted)
    }

    func testAnsweringOneOfTwoRingsReportsOnlyThatOneAsAccepted() {
        let answered = ring("answered")
        let ringing = ring("ringing")
        store.lastOptions = ringing.options

        _ = store.answerPerformed(uuid: answered.identity.callKitUUID)

        let active = store.activeCalls(
            systemCallUUIDs: [ringing.identity.callKitUUID, answered.identity.callKitUUID])
        XCTAssertEqual(active.filter { $0["isAccepted"] as? Bool == true }.map { $0["id"] as? String }, ["answered"])
    }

    func testAnEndedCallStaysEnded() {
        let uuid = UUID()
        let shown = options(uuid.uuidString)
        _ = store.incomingReported(shown, uuid: uuid, source: .app)
        _ = store.timedOut(shown)

        _ = store.answerPerformed(uuid: uuid)
        XCTAssertEqual(store.call(forCallKit: uuid)?.phase, .ended(.unanswered))

        store.endReported(uuid: uuid, reason: .remoteEnded)
        XCTAssertEqual(store.call(forCallKit: uuid)?.phase, .ended(.remoteEnded))
    }

    // MARK: - The outgoing call is never cleared

    func testAnEndedOutgoingCallIsKeptButNoLongerCountsForTheAudioSession() {
        let uuid = UUID()
        store.registerPendingOutgoing(options("outgoing"), uuid: uuid)
        let call = store.startPerformed(uuid: uuid)!.call
        _ = store.connected(uuid: uuid)
        store.audioSessionActivated()
        XCTAssertFalse(store.isFirstAudioActivation)

        _ = store.endPerformed(uuid: uuid)

        XCTAssertTrue(store.outgoingCall === call)
        XCTAssertEqual(call.phase, .ended(nil))
        XCTAssertTrue(store.isFirstAudioActivation)
    }

    func testACallWhoseEndWasRefusedIsEndedAndNoLongerCountsForTheAudioSession() {
        let call = ring("a")
        _ = store.answerPerformed(uuid: call.identity.callKitUUID)
        store.audioSessionActivated()

        store.endRefused(uuid: call.identity.callKitUUID)

        XCTAssertEqual(call.phase, .ended(.remoteEnded))
        XCTAssertTrue(store.calls.isEmpty)
        XCTAssertFalse(store.hasOngoingCall)
        XCTAssertTrue(store.isFirstAudioActivation)
    }

    func testAnActivationAfterAnOutgoingCallEndedDoesNotReportIt() {
        let uuid = UUID()
        store.registerPendingOutgoing(options("outgoing"), uuid: uuid)
        let call = store.startPerformed(uuid: uuid)!.call
        _ = store.endPerformed(uuid: uuid)

        XCTAssertTrue(store.audioActivated().isEmpty)
        XCTAssertEqual(call.phase, .ended(nil))
    }

    func testOnlyACallWithoutAnActivationYetStartsConnecting() {
        let answered = ring("answered")
        _ = store.answerPerformed(uuid: answered.identity.callKitUUID)
        _ = store.audioActivated()
        store.audioSessionActivated()
        let firstStart = answered.startedConnectingAt
        let uuid = UUID()
        store.registerPendingOutgoing(options("outgoing"), uuid: uuid)
        let outgoing = store.startPerformed(uuid: uuid)!.call

        XCTAssertTrue(store.isFirstAudioActivation)
        XCTAssertEqual(store.callsAwaitingFirstActivation.map { $0 === outgoing }, [true])
        guard case .reportStartedConnecting(let reported, _)? = store.audioActivated().first else {
            return XCTFail("the new outgoing call is not reported")
        }
        XCTAssertEqual(reported, uuid)
        XCTAssertEqual(outgoing.phase, .active)
        XCTAssertEqual(answered.startedConnectingAt, firstStart)
    }

    func testAGroupEventCarriesANullPeerWhenUngrouping() {
        let call = ring("a")

        let effects = store.groupPerformed(uuid: call.identity.callKitUUID, groupWith: nil)

        guard case .send(_, let body)? = effects?.first else { return XCTFail("no event") }
        XCTAssertEqual(body?.keys.sorted(), ["callUUIDToGroupWith", "id"])
        XCTAssertNil(body?["callUUIDToGroupWith"] ?? nil)
        XCTAssertNil(store.groupPerformed(uuid: UUID(), groupWith: nil))
    }

    // MARK: - Outgoing call started by the app

    func testOutgoingCall() {
        let uuid = UUID()
        let started = options(uuid.uuidString)
        store.startRequested(started, fromPushKit: false)
        store.registerPendingOutgoing(started, uuid: uuid)

        let start = store.startPerformed(uuid: uuid)
        XCTAssertEqual(names(start?.effects), [StreamVideoIncomingCallConstants.ACTION_CALL_START])
        let call = start!.call
        XCTAssertEqual(call.direction, .outgoing)
        XCTAssertEqual(call.phase, .starting)
        XCTAssertTrue(store.outgoingCall === call)

        let activation = Date()
        guard case .reportStartedConnecting(let reported, let at)? = store.audioActivated(at: activation).first
        else {
            return XCTFail("starting to connect is not reported to CallKit")
        }
        XCTAssertEqual(reported, uuid)
        XCTAssertEqual(at, activation)
        XCTAssertEqual(call.phase, .active)

        XCTAssertEqual(store.connected(uuid: uuid)?.effects.count, 1)
        XCTAssertNotNil(call.connectedAt)
    }

    func testAStartUsesThePendingOptionsThenTheLastOnesThenFails() {
        XCTAssertNil(store.startPerformed(uuid: UUID()))

        store.lastOptions = options("last")
        XCTAssertEqual(store.startPerformed(uuid: UUID())?.call.options.uuid, "last")

        let uuid = UUID()
        store.registerPendingOutgoing(options("pending"), uuid: uuid)
        XCTAssertEqual(store.startPerformed(uuid: uuid)?.call.options.uuid, "pending")
    }

    func testARefusedStartForgetsItsPendingOptionsOnlyWhenTheyAreStillThere() {
        let uuid = UUID()
        let first = options("first")
        store.registerPendingOutgoing(first, uuid: uuid)
        store.registerPendingOutgoing(options("second"), uuid: uuid)

        store.dropPendingOutgoing(uuid: uuid, ifStill: options("first"))
        XCTAssertEqual(store.startPerformed(uuid: uuid)?.call.options.uuid, "first")

        store.registerPendingOutgoing(first, uuid: uuid)
        store.dropPendingOutgoing(uuid: uuid, ifStill: first)
        XCTAssertNil(store.startPerformed(uuid: uuid))
    }

    // MARK: - What Dart reads back

    func testOptionsForArgsPreferTheLastOptionsThenTheTrackedCall() {
        let uuid = UUID()
        _ = store.incomingReported(options(uuid.uuidString), uuid: uuid, source: .app)
        store.lastOptions = options("last")

        XCTAssertTrue(store.options(for: ["id": "LAST"]) === store.lastOptions)
        XCTAssertTrue(
            store.options(for: ["id": uuid.uuidString]) === store.call(forCallKit: uuid)!.options)
        XCTAssertEqual(store.options(for: ["id": "other", "callerName": "Ada"]).callerName, "Ada")
        XCTAssertEqual(store.options(for: ["callerName": "Ada"]).uuid, "")
    }

    func testActiveCallsKeepTheirShape() {
        let tracked = UUID()
        _ = store.incomingReported(options(tracked.uuidString), uuid: tracked, source: .app)
        _ = store.answerPerformed(uuid: tracked)
        _ = store.connected(uuid: tracked)
        let untracked = UUID()

        let calls = store.activeCalls(systemCallUUIDs: [tracked, untracked])

        XCTAssertEqual(calls.count, 2)
        XCTAssertEqual(calls[0]["id"] as? String, tracked.uuidString)
        XCTAssertEqual(calls[0]["accepted"] as? Bool, true)
        XCTAssertEqual(calls[0]["isAccepted"] as? Bool, true)
        XCTAssertNotNil(calls[0]["ios"])
        XCTAssertEqual(calls[1] as? [String: String], ["id": untracked.uuidString.lowercased()])
    }

    func testAResetForgetsEveryCallButNotTheAnsweredOrOutgoingOnes() {
        let answered = ring("answered")
        _ = store.answerPerformed(uuid: answered.identity.callKitUUID)
        let pending = UUID()
        store.registerPendingOutgoing(options("pending"), uuid: pending)

        store.reset()

        XCTAssertTrue(store.calls.isEmpty)
        XCTAssertEqual(answered.phase, .ended(nil))
        XCTAssertTrue(store.answeredCall === answered)
        XCTAssertNil(store.startPerformed(uuid: pending))
    }
}

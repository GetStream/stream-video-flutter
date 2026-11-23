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
    private func ring(_ id: String) -> CallKitCall {
        let uuid = UUID()
        _ = store.incomingReported(options(id), uuid: uuid)
        return store.call(forCallKit: uuid)!
    }

    // MARK: - Identity

    func testACallIsFoundByItsCallKitUUIDAndByItsAppIdInAnyCase() {
        let uuid = UUID()
        _ = store.incomingReported(options(uuid.uuidString), uuid: uuid)

        XCTAssertNotNil(store.call(forCallKit: uuid))
        XCTAssertTrue(store.call(forAppId: uuid.uuidString.lowercased()) === store.call(forCallKit: uuid))
        XCTAssertNil(store.call(forAppId: "not a uuid"))
        XCTAssertNil(store.call(forCallKit: UUID()))
    }

    func testEventsReportTheAppIdAsGivenOrTheLowercasedUUID() {
        let uuid = UUID()
        _ = store.incomingReported(options(uuid.uuidString), uuid: uuid)
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
            names(store.incomingReported(options("a"), uuid: uuid)),
            [StreamVideoIncomingCallConstants.ACTION_CALL_INCOMING])
        let call = store.call(forCallKit: uuid)!
        XCTAssertEqual(call.phase, .ringing)
        XCTAssertEqual(call.direction, .incoming)

        let accept = store.answerPerformed(uuid: uuid)
        XCTAssertTrue(accept?.call === call)
        XCTAssertEqual(names(accept?.effects), [StreamVideoIncomingCallConstants.ACTION_CALL_ACCEPT])
        XCTAssertEqual(call.phase, .answering)
        XCTAssertTrue(call.options.isAccepted)
        XCTAssertTrue(store.answeredCall === call)

        XCTAssertTrue(store.audioSessionActivated().isEmpty)
        XCTAssertEqual(call.phase, .active)

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

    // MARK: - Declined from the CallKit UI

    func testDeclinedIncomingCall() {
        let call = ring("a")

        let end = store.endPerformed(uuid: call.identity.callKitUUID)

        XCTAssertTrue(end.fulfills)
        XCTAssertEqual(names(end.effects), [StreamVideoIncomingCallConstants.ACTION_CALL_DECLINE])
        XCTAssertEqual(sentIds(end.effects), ["a"])
        XCTAssertTrue(store.calls.isEmpty)
    }

    func testAnUntrackedEndFailsAndCarriesOnlyItsOwnId() {
        _ = ring("another")
        let uuid = UUID()

        let end = store.endPerformed(uuid: uuid)

        XCTAssertFalse(end.fulfills)
        XCTAssertEqual(names(end.effects), [StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT])
        guard case .send(_, let body)? = end.effects.first else {
            return XCTFail("no event is sent")
        }
        XCTAssertEqual(body as? [String: String], ["id": uuid.uuidString.lowercased()])
    }

    // MARK: - The ring times out

    func testATrackedRingTimesOutSendingTimeoutAndStaysTracked() {
        let uuid = UUID()
        let shown = options(uuid.uuidString)
        _ = store.incomingReported(shown, uuid: uuid)
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

    /// However the answered call ends, it no longer keeps a later ring from timing out, or a
    /// decline of that ring from being sent as declined.
    func testTheAnsweredCallStopsCountingOnceItEndsInAnyWay() {
        let ends: [(String, (CallKitCall) -> Void)] = [
            ("end action", { _ = self.store.endPerformed(uuid: $0.identity.callKitUUID) }),
            ("reported end", { self.store.endReported(uuid: $0.identity.callKitUUID, reason: .remoteEnded) }),
            ("refused end", { self.store.endRefused(uuid: $0.identity.callKitUUID) }),
            ("reset", { _ in self.store.reset() }),
        ]
        for (name, end) in ends {
            store = CallKitCallStore()
            let answered = ring("answered")
            _ = store.answerPerformed(uuid: answered.identity.callKitUUID)
            _ = store.holdPerformed(uuid: answered.identity.callKitUUID, onHold: true)

            end(answered)

            XCTAssertNil(store.answeredCall, name)
            XCTAssertFalse(store.hasHeldCall, name)
            let uuid = UUID()
            _ = store.incomingReported(options(uuid.uuidString), uuid: uuid)
            XCTAssertTrue(store.shouldTimeOut(appId: uuid.uuidString), name)
            XCTAssertEqual(
                names(store.endPerformed(uuid: uuid).effects),
                [StreamVideoIncomingCallConstants.ACTION_CALL_DECLINE], name)
        }
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

        XCTAssertEqual(sentIds(store.answerPerformed(uuid: first.identity.callKitUUID)?.effects), ["first"])
        XCTAssertTrue(first.options.isAccepted)
        XCTAssertFalse(second.options.isAccepted)
        XCTAssertEqual(
            sentIds(store.endPerformed(uuid: first.identity.callKitUUID).effects), ["first"])
    }

    func testMuteAndHoldEventsNameTheirCall() {
        let uuid = UUID()
        _ = store.incomingReported(options(uuid.uuidString), uuid: uuid)

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
        _ = store.audioSessionActivated()

        _ = store.holdPerformed(uuid: uuid, onHold: true, origin: .otherCall)
        XCTAssertEqual(call.phase, .held(.otherCall))
        XCTAssertTrue(call.isOnHold)

        _ = store.holdPerformed(uuid: uuid, onHold: false)
        XCTAssertEqual(call.phase, .resumed(activated: false))
        XCTAssertFalse(call.isOnHold)

        _ = store.audioSessionActivated()
        XCTAssertEqual(call.phase, .resumed(activated: true))

        _ = store.holdPerformed(uuid: uuid, onHold: false)
        XCTAssertEqual(call.phase, .resumed(activated: true), "a call not on hold stays as it is")
    }

    func testACallRegisteredAgainKeepsItsAppIdAndAllItsUUIDs() {
        let first = UUID()
        _ = store.incomingReported(options(first.uuidString), uuid: first)
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
        _ = store.incomingReported(options(first.uuidString), uuid: first)
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

    func testAnsweringOneOfTwoRingsReportsOnlyThatOneAsAccepted() {
        let answered = ring("answered")
        let ringing = ring("ringing")

        _ = store.answerPerformed(uuid: answered.identity.callKitUUID)

        let active = store.activeCalls(
            systemCallUUIDs: [ringing.identity.callKitUUID, answered.identity.callKitUUID])
        XCTAssertEqual(active.filter { $0["isAccepted"] as? Bool == true }.map { $0["id"] as? String }, ["answered"])
    }

    func testAnEndedCallStaysEnded() {
        let uuid = UUID()
        let shown = options(uuid.uuidString)
        _ = store.incomingReported(shown, uuid: uuid)
        _ = store.timedOut(shown)

        _ = store.answerPerformed(uuid: uuid)
        XCTAssertEqual(store.call(forCallKit: uuid)?.phase, .ended(.unanswered))

        store.endReported(uuid: uuid, reason: .remoteEnded)
        XCTAssertEqual(store.call(forCallKit: uuid)?.phase, .ended(.remoteEnded))
    }

    // MARK: - The outgoing call ends

    func testAnEndedOutgoingCallIsForgottenAndNoLongerCountsForTheAudioSession() {
        let uuid = UUID()
        store.registerPendingOutgoing(options("outgoing"), uuid: uuid)
        let call = store.startPerformed(uuid: uuid)!.call
        _ = store.connected(uuid: uuid)
        _ = store.audioSessionActivated()
        XCTAssertTrue(call.hasActivatedAudioSession)

        let outcome = store.endPerformed(uuid: uuid)

        XCTAssertEqual(names(outcome.effects), [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertNil(store.outgoingCall)
        XCTAssertEqual(call.phase, .ended(nil))
        XCTAssertFalse(store.hasOngoingCall)
    }

    func testARingAfterAnEndedOutgoingCallTimesOutAndIsDeclined() {
        let uuid = UUID()
        store.registerPendingOutgoing(options("outgoing"), uuid: uuid)
        _ = store.startPerformed(uuid: uuid)
        _ = store.endPerformed(uuid: uuid)

        let ringing = ring("ringing")

        XCTAssertTrue(store.shouldTimeOut(appId: "ringing"))
        let outcome = store.endPerformed(uuid: ringing.identity.callKitUUID)
        XCTAssertEqual(names(outcome.effects), [StreamVideoIncomingCallConstants.ACTION_CALL_DECLINE])
    }

    func testARingDuringARingingOutgoingCallTimesOutAndIsDeclined() {
        let uuid = UUID()
        store.registerPendingOutgoing(options("outgoing"), uuid: uuid)
        _ = store.startPerformed(uuid: uuid)

        let ringing = ring("ringing")

        XCTAssertTrue(store.shouldTimeOut(appId: "ringing"))
        let outcome = store.endPerformed(uuid: ringing.identity.callKitUUID)
        XCTAssertEqual(names(outcome.effects), [StreamVideoIncomingCallConstants.ACTION_CALL_DECLINE])
        XCTAssertNotNil(store.outgoingCall)
    }

    func testARingDuringAConnectedOutgoingCallDoesNotTimeOutAndIsEnded() {
        let uuid = UUID()
        store.registerPendingOutgoing(options("outgoing"), uuid: uuid)
        _ = store.startPerformed(uuid: uuid)
        _ = store.connected(uuid: uuid)

        let ringing = ring("ringing")

        XCTAssertFalse(store.shouldTimeOut(appId: "ringing"))
        let outcome = store.endPerformed(uuid: ringing.identity.callKitUUID)
        XCTAssertEqual(names(outcome.effects), [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
    }

    func testEndingAnOutgoingCallThatNeverConnectedIsSentAsEnded() {
        let uuid = UUID()
        store.registerPendingOutgoing(options("outgoing"), uuid: uuid)
        _ = store.startPerformed(uuid: uuid)

        let outcome = store.endPerformed(uuid: uuid)

        XCTAssertEqual(names(outcome.effects), [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
    }

    func testAStartCallKitRefusedNamesNoCallToEndAndCannotBePerformed() {
        let refused = options(UUID().uuidString)
        let uuid = UUID(uuidString: refused.uuid)!
        store.registerPendingOutgoing(refused, uuid: uuid)
        _ = ring("ringing")

        store.startRefused(uuid: uuid, options: refused)

        XCTAssertNil(store.callKitUUID(endingDartId: refused.uuid))
        XCTAssertNil(store.startPerformed(uuid: uuid))
    }

    func testAResetForgetsTheOutgoingCall() {
        let uuid = UUID()
        store.registerPendingOutgoing(options("outgoing"), uuid: uuid)
        _ = store.startPerformed(uuid: uuid)

        store.reset()

        XCTAssertNil(store.outgoingCall)
    }

    func testACallWhoseEndWasRefusedIsEndedAndNoLongerCountsForTheAudioSession() {
        let call = ring("a")
        _ = store.answerPerformed(uuid: call.identity.callKitUUID)
        _ = store.audioSessionActivated()

        store.endRefused(uuid: call.identity.callKitUUID)

        XCTAssertEqual(call.phase, .ended(.remoteEnded))
        XCTAssertTrue(store.calls.isEmpty)
        XCTAssertFalse(store.hasOngoingCall)
    }

    func testAnActivationAfterAnOutgoingCallEndedDoesNotReportIt() {
        let uuid = UUID()
        store.registerPendingOutgoing(options("outgoing"), uuid: uuid)
        let call = store.startPerformed(uuid: uuid)!.call
        _ = store.endPerformed(uuid: uuid)

        XCTAssertTrue(store.audioSessionActivated().isEmpty)
        XCTAssertEqual(call.phase, .ended(nil))
    }

    func testOnlyACallWithoutAnActivationYetStartsConnecting() {
        let answered = ring("answered")
        _ = store.answerPerformed(uuid: answered.identity.callKitUUID)
        _ = store.audioSessionActivated()
        let uuid = UUID()
        store.registerPendingOutgoing(options("outgoing"), uuid: uuid)
        let outgoing = store.startPerformed(uuid: uuid)!.call

        let effects = store.audioSessionActivated()
        guard case .reportStartedConnecting(let reported, _)? = effects.first else {
            return XCTFail("the new outgoing call is not reported")
        }
        XCTAssertEqual(reported, uuid)
        XCTAssertEqual(outgoing.phase, .active)
    }

    // MARK: - Outgoing call started by the app

    private func startOutgoing(_ id: String) -> CallKitCall {
        let uuid = UUID()
        store.registerPendingOutgoing(options(id), uuid: uuid)
        return store.startPerformed(uuid: uuid)!.call
    }

    func testAnEarlierOutgoingCallStillCountsOnceALaterOneEnded() {
        let first = startOutgoing("first")
        let second = startOutgoing("second")
        XCTAssertTrue(store.outgoingCall === second)

        _ = store.endPerformed(uuid: second.identity.callKitUUID)

        XCTAssertTrue(store.outgoingCall === first)
        let outcome = store.endPerformed(uuid: first.identity.callKitUUID)
        XCTAssertEqual(names(outcome.effects), [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertNil(store.outgoingCall)
    }

    // MARK: - The call Dart asks to end

    func testDartEndsATrackedCallByItsAppIdOrItsCallKitUUID() {
        let outgoing = startOutgoing("outgoing")
        let ringing = ring("Ringing")
        let uuid = outgoing.identity.callKitUUID

        XCTAssertEqual(store.callKitUUID(endingDartId: "outgoing"), uuid)
        XCTAssertEqual(store.callKitUUID(endingDartId: uuid.uuidString.lowercased()), uuid)
        XCTAssertEqual(
            store.callKitUUID(endingDartId: "ringing"),
            ringing.identity.callKitUUID)
    }

    func testDartEndsAnOutgoingCallCallKitHasNotStartedYet() {
        let uuid = UUID()
        store.registerPendingOutgoing(options(uuid.uuidString), uuid: uuid)

        XCTAssertEqual(store.callKitUUID(endingDartId: uuid.uuidString), uuid)
    }

    func testAnIdNamingNoCallEndsNothing() {
        _ = ring("ringing")

        XCTAssertNil(store.callKitUUID(endingDartId: "unknown"))
        XCTAssertNil(store.callKitUUID(endingDartId: UUID().uuidString))
        XCTAssertNil(store.callKitUUID(endingDartId: ""))
    }

    func testOutgoingCall() {
        let uuid = UUID()
        let started = options(uuid.uuidString)
        store.registerPendingOutgoing(started, uuid: uuid)

        let start = store.startPerformed(uuid: uuid)
        XCTAssertEqual(names(start?.effects), [StreamVideoIncomingCallConstants.ACTION_CALL_START])
        let call = start!.call
        XCTAssertEqual(call.direction, .outgoing)
        XCTAssertEqual(call.phase, .starting)
        XCTAssertTrue(store.outgoingCall === call)

        let activation = Date()
        guard case .reportStartedConnecting(let reported, let at)? = store.audioSessionActivated(at: activation).first
        else {
            return XCTFail("starting to connect is not reported to CallKit")
        }
        XCTAssertEqual(reported, uuid)
        XCTAssertEqual(at, activation)
        XCTAssertEqual(call.phase, .active)

        XCTAssertEqual(store.connected(uuid: uuid)?.effects.count, 1)
        XCTAssertNotNil(call.connectedAt)
    }

    func testAStartUsesThePendingOptionsElseFails() {
        XCTAssertNil(store.startPerformed(uuid: UUID()))

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

    func testActiveCallsKeepTheirShape() {
        let tracked = UUID()
        _ = store.incomingReported(options(tracked.uuidString), uuid: tracked)
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

    func testAResetForgetsEveryCallThePendingOutgoingOnesAndTheReRegistrations() {
        let answered = ring("answered")
        _ = store.answerPerformed(uuid: answered.identity.callKitUUID)
        let pending = UUID()
        store.registerPendingOutgoing(options("pending"), uuid: pending)
        let held = ring("held")
        let reRegistration = UUID()
        store.reRegistrationRequested(held, as: reRegistration)

        store.reset()

        XCTAssertTrue(store.calls.isEmpty)
        XCTAssertEqual(answered.phase, .ended(nil))
        XCTAssertNil(store.answeredCall)
        XCTAssertNil(store.startPerformed(uuid: pending))
        XCTAssertFalse(store.isReRegistrationUUID(reRegistration))
    }
}

/// Pins which refused CallKit requests reach `onEndRefused`.
final class CallKitTransactionRequesterTests: XCTestCase {

    /// Answers every request with `error`, and reports `callUUIDs` as CallKit's calls.
    private final class FakeCallController: CallKitCallControlling {
        var error: Error?
        var callUUIDs: [UUID] = []
        private(set) var requested: [CXTransaction] = []

        func request(_ transaction: CXTransaction, completion: @escaping (Error?) -> Void) {
            requested.append(transaction)
            completion(error)
        }
    }

    private struct Refused: Error {}

    private var controller: FakeCallController!
    private var requester: CallKitTransactionRequester!
    private var refused: [UUID] = []

    override func setUp() {
        super.setUp()
        controller = FakeCallController()
        requester = CallKitTransactionRequester(callController: controller)
        refused = []
        requester.onEndRefused = { [weak self] in self?.refused.append($0) }
    }

    func testARefusedEndReportsItsCall() {
        controller.error = Refused()
        let uuid = UUID()

        requester.end(uuid: uuid)

        XCTAssertEqual(refused, [uuid])
    }

    func testARefusedEndOfAllCallsReportsEachCall() {
        controller.error = Refused()
        controller.callUUIDs = [UUID(), UUID()]

        requester.endAll()

        XCTAssertEqual(refused, controller.callUUIDs)
    }

    func testAnEndCallKitPerformsReportsNothing() {
        requester.end(uuid: UUID())

        XCTAssertEqual(controller.requested.count, 1)
        XCTAssertTrue(refused.isEmpty)
    }

    func testOtherRefusedRequestsReportNothing() {
        controller.error = Refused()
        let uuid = UUID()
        var answered: Bool?

        requester.mute(uuid: uuid, isMuted: true)
        requester.hold(uuid: uuid, onHold: true)
        requester.answer(uuid: uuid) { answered = $0 }
        requester.start(uuid: uuid, handle: CXHandle(type: .generic, value: "x"), isVideo: false) {
            _ in
        }

        XCTAssertEqual(controller.requested.count, 4)
        XCTAssertEqual(answered, false)
        XCTAssertTrue(refused.isEmpty)
    }
}

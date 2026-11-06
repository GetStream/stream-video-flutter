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
        XCTAssertTrue(store.hasConnectedCall)

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

    // MARK: - Two calls at once

    func testEachTransitionCarriesItsOwnCallsOptions() {
        let first = ring("first")
        let second = ring("second")
        store.lastOptions = second.options

        XCTAssertEqual(sentIds(store.answerPerformed(uuid: first.identity.callKitUUID)), ["first"])
        XCTAssertTrue(first.options.isAccepted)
        // Current behaviour, pinned: the last options are marked accepted too, whichever call
        // they belong to.
        XCTAssertTrue(second.options.isAccepted)
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

    func testHoldingAlsoMutesAndResumingUnmutes() {
        let call = ring("a")

        _ = store.holdPerformed(uuid: call.identity.callKitUUID, onHold: true)
        XCTAssertTrue(call.isMuted)
        _ = store.holdPerformed(uuid: call.identity.callKitUUID, onHold: false)
        XCTAssertFalse(call.isMuted)
    }

    func testTheAnsweredCallOnHoldCountsAsHeld() {
        let call = ring("a")
        _ = store.answerPerformed(uuid: call.identity.callKitUUID)

        _ = store.holdPerformed(uuid: call.identity.callKitUUID, onHold: true)

        XCTAssertTrue(store.hasHeldCall)
    }

    func testAnsweringAlsoMarksTheLastOptionsAccepted() {
        let call = ring("a")
        let last = options("last")
        store.lastOptions = last

        _ = store.answerPerformed(uuid: call.identity.callKitUUID)

        XCTAssertTrue(last.isAccepted)
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

    func testAConnectedOutgoingCallStillCountsAsConnectedAfterItEnds() {
        let uuid = UUID()
        store.registerPendingOutgoing(options("outgoing"), uuid: uuid)
        let call = store.startPerformed(uuid: uuid)!.call
        _ = store.connected(uuid: uuid)

        _ = store.endPerformed(uuid: uuid)

        XCTAssertTrue(store.outgoingCall === call)
        XCTAssertTrue(store.hasConnectedCall)
        XCTAssertEqual(call.phase, .ended(nil))
    }

    func testAnActivationAfterAnUnconnectedOutgoingCallEndedStillReportsIt() {
        let uuid = UUID()
        store.registerPendingOutgoing(options("outgoing"), uuid: uuid)
        let call = store.startPerformed(uuid: uuid)!.call
        _ = store.endPerformed(uuid: uuid)

        let effects = store.audioActivated()

        guard case .reportStartedConnecting(let reported, _)? = effects.first else {
            return XCTFail("the ended call is not reported")
        }
        XCTAssertEqual(reported, uuid)
        XCTAssertEqual(call.phase, .ended(nil))
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
        XCTAssertTrue(store.hasConnectedCall)
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

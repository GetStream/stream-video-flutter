import AVFoundation
import CallKit
import Flutter
import XCTest

@testable import stream_video_push_notification

/// Pins the manager's event path, from a call into the manager to Dart's listener: events sent
/// before Dart listens are held and delivered in order, `silenceEvents` drops them, and which
/// event the CallKit end action sends for each kind of call.
final class StreamVideoCallkitManagerTests: XCTestCase {

    private let manager = StreamVideoCallkitManager.shared
    private let provider = CXProvider(configuration: CXProviderConfiguration())

    private var savedEventHandler: EventCallbackHandler?
    private var savedStore: CallKitCallStore!
    private var savedAudio: CallKitAudioSessionCoordinator!
    private var session: FakeAudioSession!
    private var gate: FakeAudioEngineGate!
    private var savedSilenced = false
    private var received: [[String: Any]] = []

    override func setUp() {
        super.setUp()
        // The manager is a singleton the host app also uses, so its state is saved and restored.
        savedEventHandler = manager.eventSink.handler
        savedStore = manager.store
        savedAudio = manager.audio
        savedSilenced = manager.eventSink.isSilenced

        discardHeldEvents()
        // An attached handler Dart does not listen on yet, so events are held.
        manager.setEventHandler(EventCallbackHandler(sink: manager.eventSink))
        manager.store = CallKitCallStore()
        session = FakeAudioSession()
        gate = FakeAudioEngineGate()
        manager.audio = CallKitAudioSessionCoordinator(session: session, gate: gate)
        manager.eventSink.isSilenced = false
        received = []
    }

    override func tearDown() {
        discardHeldEvents()
        if let savedEventHandler = savedEventHandler {
            manager.setEventHandler(savedEventHandler)
        }
        manager.store = savedStore
        manager.audio = savedAudio
        manager.eventSink.isSilenced = savedSilenced
        super.tearDown()
    }

    /// Hands whatever the sink holds to a listener that drops it.
    private func discardHeldEvents() {
        drainMainQueue()
        let handler = EventCallbackHandler(sink: manager.eventSink)
        _ = handler.onListen(withArguments: nil) { _ in }
        manager.setEventHandler(handler)
    }

    /// Sets a handler that already has a listener, so every event it gets is recorded.
    private func listen() {
        let handler = EventCallbackHandler(sink: manager.eventSink)
        _ = handler.onListen(withArguments: nil) { [weak self] event in
            if let event = event as? [String: Any] {
                self?.received.append(event)
            }
        }
        manager.setEventHandler(handler)
    }

    /// `EventCallbackHandler.send` hops to the main queue; this waits for what is queued so far.
    private func drainMainQueue() {
        let drained = expectation(description: "main queue drained")
        DispatchQueue.main.async { drained.fulfill() }
        wait(for: [drained], timeout: 1)
    }

    private var receivedNames: [String?] {
        received.map { $0["event"] as? String }
    }

    private func receivedId(at index: Int) -> String? {
        (received[index]["body"] as? [String: Any])?["id"] as? String
    }

    /// A ringing incoming call CallKit accepted. Its INCOMING event is not sent.
    private func track(id: String) -> CallKitCall {
        let uuid = UUID()
        _ = manager.store.incomingReported(CallData(args: ["id": id]), uuid: uuid, source: .app)
        return manager.store.call(forCallKit: uuid)!
    }

    /// Answers `call` in the store. Its ACCEPT event is not sent.
    private func answer(_ call: CallKitCall) {
        _ = manager.store.answerPerformed(uuid: call.identity.callKitUUID)
    }

    /// An outgoing call CallKit started. Its START event is not sent.
    private func startOutgoing(id: String) -> CallKitCall {
        let uuid = UUID()
        manager.store.registerPendingOutgoing(CallData(args: ["id": id]), uuid: uuid)
        return manager.store.startPerformed(uuid: uuid)!.call
    }

    private func end(_ uuid: UUID) {
        manager.provider(provider, perform: CXEndCallAction(call: uuid))
        drainMainQueue()
    }

    // MARK: - Pending events

    func testEventsSentBeforeDartListensAreDeliveredInOrder() {
        manager.sendEventCustom("first", body: ["id": "1"])
        manager.sendEventCustom("second", body: nil)
        drainMainQueue()
        XCTAssertTrue(received.isEmpty)

        listen()
        drainMainQueue()

        XCTAssertEqual(receivedNames, ["first", "second"])
        XCTAssertEqual(receivedId(at: 0), "1")
    }

    func testEventsSentWhileDartListensGoStraightThrough() {
        listen()

        manager.sendEventCustom("live", body: nil)
        drainMainQueue()

        XCTAssertEqual(receivedNames, ["live"])
    }

    func testSilencedEventsAreDroppedRatherThanHeld() {
        manager.handle(FlutterMethodCall(methodName: "silenceEvents", arguments: true)) { _ in }
        manager.sendEventCustom("dropped", body: nil)
        drainMainQueue()

        listen()
        manager.handle(FlutterMethodCall(methodName: "silenceEvents", arguments: false)) { _ in }
        manager.sendEventCustom("kept", body: nil)
        drainMainQueue()

        XCTAssertEqual(receivedNames, ["kept"])
    }

    // MARK: - CXEndCallAction

    func testEndingAnUntrackedCallWithNoActiveCallSendsTimeoutWithTheLastOptions() {
        listen()
        manager.store.lastOptions = CallData(args: ["id": "last-shown"])

        end(UUID())

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT])
        XCTAssertEqual(receivedId(at: 0), "last-shown")
    }

    func testEndingAnUntrackedCallWhileAnotherIsAnsweredSendsEnded() {
        listen()
        answer(track(id: "answered"))

        end(UUID())

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
    }

    func testEndingATrackedUnansweredCallSendsDeclineAndRemovesIt() {
        listen()
        let call = track(id: "ringing")

        end(call.identity.callKitUUID)

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_DECLINE])
        XCTAssertEqual(receivedId(at: 0), "ringing")
        XCTAssertEqual(call.phase, .ended(nil))
        XCTAssertNil(manager.store.call(forCallKit: call.identity.callKitUUID))
    }

    func testDeclineCarriesTheEndedCallsOptionsNotTheLastOnes() {
        listen()
        let call = track(id: "ringing")
        manager.store.lastOptions = CallData(args: ["id": "last-shown"])

        end(call.identity.callKitUUID)

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_DECLINE])
        XCTAssertEqual(receivedId(at: 0), "ringing")
    }

    func testEndingTheAnsweredCallSendsEndedWithItsOwnDataAndClearsIt() {
        listen()
        let call = track(id: "answered")
        answer(call)
        manager.store.lastOptions = CallData(args: ["id": "last-shown"])

        end(call.identity.callKitUUID)

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertEqual(receivedId(at: 0), "answered")
        XCTAssertNil(manager.store.answeredCall)
        XCTAssertNil(manager.store.call(forCallKit: call.identity.callKitUUID))
    }

    func testEndingATrackedCallWhileAnOutgoingCallExistsSendsEndedAndKeepsTheOutgoingCall() {
        listen()
        let outgoing = startOutgoing(id: "outgoing")
        let call = track(id: "other")

        end(call.identity.callKitUUID)

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertTrue(manager.store.outgoingCall === outgoing)
    }

    func testTheOutgoingCallIsKeptAfterItEnds() {
        // Current behaviour, pinned: so every later end is sent as ENDED and no ring times out.
        listen()
        let outgoing = startOutgoing(id: "outgoing")

        end(outgoing.identity.callKitUUID)

        XCTAssertTrue(manager.store.outgoingCall === outgoing)
        let ringing = track(id: "ringing")
        XCTAssertFalse(manager.store.shouldTimeOut(appId: ringing.identity.appId))
    }

    /// Current behaviour, pinned: declining a second ringing call during an answered one is sent
    /// as ENDED and forgets the answered call, so hanging that one up later is sent as DECLINE,
    /// and the answered call's end never reaches Dart as ENDED.
    func testDecliningASecondCallDuringAnAnsweredOneForgetsTheAnsweredCall() {
        listen()
        let answered = track(id: "answered")
        answer(answered)
        let ringing = track(id: "ringing")

        end(ringing.identity.callKitUUID)

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertEqual(receivedId(at: 0), "ringing")
        XCTAssertNil(manager.store.answeredCall)

        end(answered.identity.callKitUUID)

        XCTAssertEqual(
            receivedNames,
            [
                StreamVideoIncomingCallConstants.ACTION_CALL_ENDED,
                StreamVideoIncomingCallConstants.ACTION_CALL_DECLINE,
            ])
        XCTAssertEqual(receivedId(at: 1), "answered")
        XCTAssertNil(manager.store.call(forCallKit: answered.identity.callKitUUID))
    }

    func testEndingAnUntrackedCallWhileAnOutgoingCallExistsSendsEnded() {
        listen()
        _ = startOutgoing(id: "outgoing")

        end(UUID())

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
    }

    // MARK: - Answer

    func testAnswerSendsAcceptWithTheAnsweredCallEvenWithoutLastOptions() {
        listen()
        let call = track(id: "ringing")
        XCTAssertNil(manager.store.lastOptions)

        manager.provider(provider, perform: CXAnswerCallAction(call: call.identity.callKitUUID))
        drainMainQueue()

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ACCEPT])
        XCTAssertEqual(receivedId(at: 0), "ringing")
        XCTAssertTrue(manager.store.answeredCall === call)
    }

    func testGetAcceptedCallReturnsTheLastOptionsOnlyWhenTheyNameTheAnsweredCall() {
        let uuid = UUID()
        let shown = CallData(args: ["id": uuid.uuidString])
        manager.store.lastOptions = shown
        _ = manager.store.incomingReported(shown, uuid: uuid, source: .app)
        XCTAssertNil(manager.getAcceptedCall())

        _ = manager.store.answerPerformed(uuid: uuid)
        XCTAssertTrue(manager.getAcceptedCall() === shown)

        manager.store.lastOptions = CallData(args: ["id": UUID().uuidString])
        XCTAssertNil(manager.getAcceptedCall())
    }

    // MARK: - Audio session

    private var receivedIsActive: Bool? {
        (received.last?["body"] as? [String: Any])?["isActive"] as? Bool
    }

    func testTheFirstActivationConfiguresTheSessionAndReportsItActive() {
        listen()
        let call = track(id: "answered")
        answer(call)

        manager.provider(provider, didActivate: AVAudioSession.sharedInstance())
        drainMainQueue()

        XCTAssertEqual(
            receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION])
        XCTAssertEqual(receivedIsActive, true)
        XCTAssertEqual(call.phase, .active)
        XCTAssertFalse(session.calls.isEmpty)
        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: true)])
    }

    func testALaterActivationReportsTheSessionActiveAndLeavesItAsItIs() {
        listen()
        let call = track(id: "answered")
        answer(call)
        _ = manager.store.connected(uuid: call.identity.callKitUUID)
        manager.provider(provider, didActivate: AVAudioSession.sharedInstance())
        let configured = session.calls

        manager.provider(provider, didActivate: AVAudioSession.sharedInstance())
        drainMainQueue()

        XCTAssertEqual(
            receivedNames,
            [
                StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION,
                StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION,
            ])
        XCTAssertEqual(session.calls, configured)
    }

    func testACallConnectedInTheAppBeforeItsAnswerBecomesActiveOnItsFirstActivation() {
        // Accepting in the app reports the call connected before the answer transaction runs.
        let call = track(id: "answered")
        _ = manager.store.connected(uuid: call.identity.callKitUUID)
        manager.provider(provider, perform: CXAnswerCallAction(call: call.identity.callKitUUID))

        manager.provider(provider, didActivate: AVAudioSession.sharedInstance())

        XCTAssertEqual(call.phase, .active)
        XCTAssertNotNil(call.startedConnectingAt)
        XCTAssertEqual(gate.updates.last, .init(available: true, callKitSessionActive: true))
    }

    func testEndingTheActiveCallWhileAnotherRingsStopsTheEngineUntilTheRingEnds() {
        let active = track(id: "active")
        answer(active)
        let ringing = track(id: "ringing")
        manager.provider(provider, didActivate: AVAudioSession.sharedInstance())

        end(active.identity.callKitUUID)
        manager.provider(provider, didDeactivate: AVAudioSession.sharedInstance())
        end(ringing.identity.callKitUUID)

        XCTAssertEqual(
            gate.updates,
            [
                .init(available: true, callKitSessionActive: true),
                .init(available: false, callKitSessionActive: false),
                .init(available: true, callKitSessionActive: nil),
            ])
    }

    func testEndingTheLastCallAllowsTheAudioEngine() {
        let call = track(id: "ringing")

        end(call.identity.callKitUUID)

        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: nil)])
    }

    func testEndingACallWhileAnotherIsLeftKeepsTheAudioEngineAsItIs() {
        _ = track(id: "left")
        let call = track(id: "ended")

        end(call.identity.callKitUUID)

        XCTAssertTrue(gate.updates.isEmpty)
    }

    func testReportingTheLastCallEndedAllowsTheAudioEngine() {
        let uuid = UUID()
        _ = manager.store.incomingReported(
            CallData(args: ["id": uuid.uuidString]), uuid: uuid, source: .app)

        manager.saveEndCall(uuid.uuidString, 2)

        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: nil)])
    }

    func testTheLastRingTimingOutAllowsTheAudioEngine() {
        let uuid = UUID()
        let shown = CallData(args: ["id": uuid.uuidString])
        _ = manager.store.incomingReported(shown, uuid: uuid, source: .app)

        manager.callEndTimeout(shown)

        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: nil)])
    }

    func testAProviderResetAllowsTheAudioEngine() {
        _ = track(id: "ringing")

        manager.providerDidReset(provider)

        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: nil)])
    }

    func testARefusedEndOfTheLastCallAllowsTheAudioEngine() {
        let call = track(id: "ringing")

        manager.transactions.onEndRefused?(call.identity.callKitUUID)

        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: nil)])
        XCTAssertEqual(call.phase, .ended(.remoteEnded))
    }

    func testAnActivationPostsAnEndedInterruptionFromTheManager() {
        answer(track(id: "answered"))
        var posted: [Notification] = []
        let observer = NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification, object: manager, queue: nil
        ) { posted.append($0) }
        defer { NotificationCenter.default.removeObserver(observer) }

        manager.provider(provider, didActivate: AVAudioSession.sharedInstance())

        XCTAssertEqual(posted.count, 1)
        XCTAssertEqual(
            posted.first?.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
            AVAudioSession.InterruptionType.ended.rawValue)
    }

    func testADeactivationReportsTheSessionInactiveUnlessTheAnsweredCallIsHeld() {
        listen()
        let call = track(id: "answered")
        answer(call)

        manager.provider(provider, didDeactivate: AVAudioSession.sharedInstance())
        drainMainQueue()
        XCTAssertEqual(
            receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION])
        XCTAssertEqual(receivedIsActive, false)

        _ = manager.store.holdPerformed(uuid: call.identity.callKitUUID, onHold: true)
        manager.provider(provider, didDeactivate: AVAudioSession.sharedInstance())
        drainMainQueue()
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(
            gate.updates,
            [
                .init(available: false, callKitSessionActive: false),
                .init(available: false, callKitSessionActive: false),
            ])
    }

    // MARK: - Calls from Dart

    func testDartEndCallWhileThePushKitFlagIsSetSendsEndedForThePushKitCall() {
        listen()
        let pushed = CallData(args: ["id": UUID().uuidString])
        manager.store.showRequested(pushed, fromPushKit: true)

        manager.handle(.endCall(["id": UUID().uuidString])) { _ in }
        drainMainQueue()

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertEqual(receivedId(at: 0), pushed.uuid)
        XCTAssertFalse(manager.store.isFromPushKit)
    }

    func testDartCallConnectedWhileThePushKitFlagIsSetConnectsThePushKitCall() {
        let uuid = UUID()
        let pushed = CallData(args: ["id": uuid.uuidString])
        manager.store.showRequested(pushed, fromPushKit: true)
        _ = manager.store.incomingReported(pushed, uuid: uuid, source: .pushKit)

        manager.handle(.callConnected(["id": UUID().uuidString])) { _ in }

        XCTAssertNotNil(manager.store.call(forCallKit: uuid)?.connectedAt)
        XCTAssertFalse(manager.store.isFromPushKit)
    }

    func testDartEndCallWithNoArgumentsWhileThePushKitFlagIsSetEndsThePushKitCall() {
        listen()
        let pushed = CallData(args: ["id": UUID().uuidString])
        manager.store.showRequested(pushed, fromPushKit: true)

        manager.handle(.endCall(nil)) { _ in }
        drainMainQueue()

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertEqual(receivedId(at: 0), pushed.uuid)
        XCTAssertFalse(manager.store.isFromPushKit)
    }

    func testDartCallConnectedWithNoArgumentsWhileThePushKitFlagIsSetConnectsThePushKitCall() {
        let uuid = UUID()
        let pushed = CallData(args: ["id": uuid.uuidString])
        manager.store.showRequested(pushed, fromPushKit: true)
        _ = manager.store.incomingReported(pushed, uuid: uuid, source: .pushKit)

        manager.handle(.callConnected(nil)) { _ in }

        XCTAssertNotNil(manager.store.call(forCallKit: uuid)?.connectedAt)
        XCTAssertFalse(manager.store.isFromPushKit)
    }

    func testDartEndCallWithoutPushKitUsesTheTrackedCallsOptions() {
        let uuid = UUID()
        _ = manager.store.incomingReported(
            CallData(args: ["id": uuid.uuidString, "callerName": "Tracked"]), uuid: uuid,
            source: .app)
        let call = manager.store.call(forCallKit: uuid)!

        manager.handle(.endCall(["id": uuid.uuidString])) { _ in }

        XCTAssertTrue(manager.store.lastOptions === call.options)
        XCTAssertEqual(manager.store.lastOptions?.callerName, "Tracked")
    }

    func testDartCallConnectedWithoutPushKitConnectsTheTrackedCall() {
        let uuid = UUID()
        _ = manager.store.incomingReported(
            CallData(args: ["id": uuid.uuidString]), uuid: uuid, source: .app)
        let call = manager.store.call(forCallKit: uuid)!

        manager.handle(.callConnected(["id": uuid.uuidString.lowercased()])) { _ in }

        XCTAssertTrue(manager.store.lastOptions === call.options)
        XCTAssertNotNil(call.connectedAt)
    }

    func testARingTheAppEndedDoesNotTimeOutLater() {
        let uuid = UUID()
        let shown = CallData(args: ["id": uuid.uuidString])
        _ = manager.store.incomingReported(shown, uuid: uuid, source: .app)

        manager.saveEndCall(uuid.uuidString, 2)
        XCTAssertFalse(manager.store.shouldTimeOut(appId: shown.uuid))
    }

    func testDartMuteOrHoldThatMatchesTheCallSendsTheEvent() {
        listen()
        let uuid = UUID()
        _ = manager.store.incomingReported(
            CallData(args: ["id": uuid.uuidString]), uuid: uuid, source: .app)

        manager.muteCall(uuid.uuidString, isMuted: false)
        manager.holdCall(uuid.uuidString, onHold: false)
        drainMainQueue()

        XCTAssertEqual(
            receivedNames,
            [
                StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_MUTE,
                StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_HOLD,
            ])
        XCTAssertEqual(receivedId(at: 0), uuid.uuidString)
    }

    func testATimedOutRingIsMarkedUnansweredAndSendsTimeout() {
        listen()
        let uuid = UUID()
        let shown = CallData(args: ["id": uuid.uuidString])
        _ = manager.store.incomingReported(shown, uuid: uuid, source: .app)

        manager.callEndTimeout(shown)
        drainMainQueue()

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT])
        XCTAssertEqual(manager.store.call(forCallKit: uuid)?.phase, .ended(.unanswered))
    }

    func testARefusedEndDropsTheCall() {
        let call = track(id: "ringing")

        manager.transactions.onEndRefused?(call.identity.callKitUUID)

        XCTAssertNil(manager.store.call(forCallKit: call.identity.callKitUUID))
    }
}

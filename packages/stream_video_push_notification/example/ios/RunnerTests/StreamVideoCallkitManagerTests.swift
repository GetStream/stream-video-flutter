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

    private var savedEventSink: RingingEventSink!
    private var savedStore: CallKitCallStore!
    private var savedAudio: CallKitAudioSessionCoordinator!
    private var savedProvider: CXProvider?
    private var savedRecentsSuppressedFor: CallData?
    private var session: FakeAudioSession!
    private var gate: FakeAudioEngineGate!
    private var savedReconfigureDelay: DispatchTimeInterval = .never
    private var savedGracePeriod: CallEndGracePeriod!
    private var backgroundTasks: FakeBackgroundTasks!
    private var received: [[String: Any]] = []

    override func setUp() {
        super.setUp()
        // The manager is a singleton the host app also uses, so its state is saved and restored.
        // Each test gets a sink of its own, which leaves the host's handler and held events alone.
        savedEventSink = manager.eventSink
        savedStore = manager.store
        savedAudio = manager.audio
        savedProvider = manager.sharedProvider
        savedRecentsSuppressedFor = manager.recentsSuppressedFor
        savedReconfigureDelay = manager.reconfigureAfterAnswerDelay
        savedGracePeriod = manager.callEndGracePeriod

        backgroundTasks = FakeBackgroundTasks()
        manager.callEndGracePeriod = CallEndGracePeriod(
            tasks: backgroundTasks, scheduler: FakeHoldRecoveryScheduler())
        manager.eventSink = RingingEventSink()
        // An attached handler Dart does not listen on yet, so events are held.
        manager.setEventHandler(EventCallbackHandler(sink: manager.eventSink))
        manager.store = CallKitCallStore()
        session = FakeAudioSession()
        gate = FakeAudioEngineGate()
        manager.audio = CallKitAudioSessionCoordinator(session: session, gate: gate)
        manager.reconfigureAfterAnswerDelay = .milliseconds(20)
        received = []
    }

    override func tearDown() {
        // Lets events still on their way to this test's sink arrive there.
        drainMainQueue()
        manager.eventSink = savedEventSink
        manager.store = savedStore
        manager.audio = savedAudio
        if let installed = manager.sharedProvider, installed !== savedProvider {
            // A provider a test installed has the manager as its delegate. Released, CallKit
            // resets it later, which would reset whatever store a later test is using.
            installed.setDelegate(nil, queue: nil)
            installed.invalidate()
        }
        manager.sharedProvider = savedProvider
        manager.recentsSuppressedFor = savedRecentsSuppressedFor
        manager.reconfigureAfterAnswerDelay = savedReconfigureDelay
        manager.callEndGracePeriod = savedGracePeriod
        super.tearDown()
    }

    // MARK: - A VoIP push ringing during an outgoing call

    /// A ring PushKit showed, which sets `isFromPushKit` and the last options.
    private func ringFromPushKit(id: String) -> CallKitCall {
        manager.store.showRequested(CallData(args: ["id": id]), fromPushKit: true)
        return track(id: id)
    }

    func testConnectingTheOutgoingCallDuringAPushKitRingConnectsItAndLeavesTheRing() {
        listen()
        let outgoing = startOutgoing(id: "outgoing")
        let ringing = ringFromPushKit(id: "pushkit")

        manager.handle(.callConnected(["id": "outgoing"])) { _ in }
        drainMainQueue()

        XCTAssertNotNil(outgoing.connectedAt)
        XCTAssertNil(ringing.connectedAt)
        XCTAssertEqual(ringing.phase, .ringing)
        XCTAssertTrue(manager.store.isFromPushKit)
        XCTAssertEqual(manager.store.lastOptions?.uuid, "pushkit")
    }

    func testDecliningARingWhileTheOutgoingCallStillRingsSendsDecline() {
        listen()
        _ = startOutgoing(id: "outgoing")
        let ringing = track(id: "ringing")

        end(ringing.identity.callKitUUID)

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_DECLINE])
        XCTAssertTrue(manager.store.shouldTimeOut(appId: track(id: "next").identity.appId))
    }

    func testDartEndAndConnectionOfAStartCallKitRefusedLeaveAPushKitRingAlone() {
        listen()
        let refused = CallData(args: ["id": UUID().uuidString])
        let refusedUUID = UUID(uuidString: refused.uuid)!
        manager.store.registerPendingOutgoing(refused, uuid: refusedUUID)
        manager.store.startRefused(uuid: refusedUUID, options: refused)
        let ringing = ringFromPushKit(id: "pushkit")

        manager.handle(.callConnected(["id": refused.uuid])) { _ in }
        manager.handle(.endCall(["id": refused.uuid])) { _ in }
        drainMainQueue()

        XCTAssertTrue(receivedNames.isEmpty)
        XCTAssertEqual(ringing.phase, .ringing)
        XCTAssertNil(ringing.connectedAt)
        XCTAssertTrue(manager.store.isFromPushKit)
    }

    func testEndingTheOutgoingCallDuringAPushKitRingLeavesTheRing() {
        listen()
        _ = startOutgoing(id: "outgoing")
        let ringing = ringFromPushKit(id: "pushkit")

        manager.handle(.endCall(["id": "outgoing"])) { _ in }
        drainMainQueue()

        // The ring's end is not sent to Dart, and the ring is still the PushKit call.
        XCTAssertTrue(receivedNames.isEmpty)
        XCTAssertEqual(ringing.phase, .ringing)
        XCTAssertTrue(manager.store.isFromPushKit)
        XCTAssertEqual(manager.store.lastOptions?.uuid, "pushkit")
    }

    func testDuringAPushKitRingAnIdNoCallHasStillEndsTheRing() {
        listen()
        _ = ringFromPushKit(id: "pushkit")

        manager.handle(.endCall(["id": "unknown"])) { _ in }
        drainMainQueue()

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertFalse(manager.store.isFromPushKit)
    }

    // MARK: - Time for Dart after a CallKit end

    func testACallKitEndKeepsTheAppRunningForDart() {
        listen()
        let outgoing = startOutgoing(id: "outgoing")

        manager.provider(provider, perform: CXEndCallAction(call: outgoing.identity.callKitUUID))

        XCTAssertEqual(backgroundTasks.begun, 1)
        XCTAssertTrue(manager.callEndGracePeriod.isRunning)
        drainMainQueue()
        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
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
        _ = manager.store.incomingReported(CallData(args: ["id": id]), uuid: uuid)
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
        manager.sendEvent("first", ["id": "1"])
        manager.sendEvent("second", nil)
        drainMainQueue()
        XCTAssertTrue(received.isEmpty)

        listen()
        drainMainQueue()

        XCTAssertEqual(receivedNames, ["first", "second"])
        XCTAssertEqual(receivedId(at: 0), "1")
    }

    func testEventsSentWhileDartListensGoStraightThrough() {
        listen()

        manager.sendEvent("live", nil)
        drainMainQueue()

        XCTAssertEqual(receivedNames, ["live"])
    }

    func testSilencedEventsAreDroppedRatherThanHeld() {
        manager.handle(FlutterMethodCall(methodName: "silenceEvents", arguments: true)) { _ in }
        manager.sendEvent("dropped", nil)
        drainMainQueue()

        listen()
        manager.handle(FlutterMethodCall(methodName: "silenceEvents", arguments: false)) { _ in }
        manager.sendEvent("kept", nil)
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

    func testEndingATrackedCallWhileAConnectedOutgoingCallExistsSendsEndedAndKeepsIt() {
        listen()
        let outgoing = startOutgoing(id: "outgoing")
        _ = manager.store.connected(uuid: outgoing.identity.callKitUUID)
        let call = track(id: "other")

        end(call.identity.callKitUUID)

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertTrue(manager.store.outgoingCall === outgoing)
    }

    func testTheOutgoingCallIsForgottenOnceItEnds() {
        listen()
        let outgoing = startOutgoing(id: "outgoing")

        end(outgoing.identity.callKitUUID)

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertEqual(receivedId(at: 0), "outgoing")
        XCTAssertNil(manager.store.outgoingCall)
        let ringing = track(id: "ringing")
        XCTAssertTrue(manager.store.shouldTimeOut(appId: ringing.identity.appId))
    }

    /// Declining a second ringing call during an answered one is sent as ENDED, as before, and
    /// keeps the answered call, so hanging that one up later is sent as ENDED too.
    func testDecliningASecondCallDuringAnAnsweredOneKeepsTheAnsweredCall() {
        listen()
        let answered = track(id: "answered")
        answer(answered)
        let ringing = track(id: "ringing")

        end(ringing.identity.callKitUUID)

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertEqual(receivedId(at: 0), "ringing")
        XCTAssertTrue(manager.store.answeredCall === answered)

        end(answered.identity.callKitUUID)

        XCTAssertEqual(
            receivedNames,
            [
                StreamVideoIncomingCallConstants.ACTION_CALL_ENDED,
                StreamVideoIncomingCallConstants.ACTION_CALL_ENDED,
            ])
        XCTAssertEqual(receivedId(at: 1), "answered")
        XCTAssertNil(manager.store.answeredCall)
        XCTAssertNil(manager.store.call(forCallKit: answered.identity.callKitUUID))
    }

    /// After a waiting call is declined, holding the answered call does not tell Dart the session
    /// went inactive, and resuming it does not configure the session again.
    func testHoldAndResumeAfterDecliningAWaitingCallKeepTheSessionAsItIs() {
        listen()
        let answered = track(id: "answered")
        answer(answered)
        manager.provider(provider, didActivate: AVAudioSession.sharedInstance())
        end(track(id: "waiting").identity.callKitUUID)
        received = []
        let configured = session.calls

        let uuid = answered.identity.callKitUUID
        manager.provider(provider, perform: CXSetHeldCallAction(call: uuid, onHold: true))
        manager.provider(provider, didDeactivate: AVAudioSession.sharedInstance())
        manager.provider(provider, perform: CXSetHeldCallAction(call: uuid, onHold: false))
        manager.provider(provider, didActivate: AVAudioSession.sharedInstance())
        drainMainQueue()

        XCTAssertEqual(session.calls, configured, "the resume configured the session")
        XCTAssertEqual(
            receivedNames,
            [
                StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_HOLD,
                StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_HOLD,
                StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION,
            ])
        XCTAssertEqual(receivedIsActive, true)
    }

    func testEndingAnUntrackedCallWhileAConnectedOutgoingCallExistsSendsEnded() {
        listen()
        let outgoing = startOutgoing(id: "outgoing")
        _ = manager.store.connected(uuid: outgoing.identity.callKitUUID)

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
        _ = manager.store.incomingReported(shown, uuid: uuid)
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

    /// Waits until the reconfiguration scheduled after an answer has had its turn.
    private func waitPastTheReconfigureAfterAnswer() {
        let waited = expectation(description: "past the reconfigure")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { waited.fulfill() }
        wait(for: [waited], timeout: 1)
    }

    func testTheAnsweredCallIsConfiguredAgainShortlyAfterTheAnswer() {
        let call = track(id: "answered")
        manager.provider(provider, perform: CXAnswerCallAction(call: call.identity.callKitUUID))
        let configuredOnAnswer = session.calls

        waitPastTheReconfigureAfterAnswer()

        XCTAssertFalse(configuredOnAnswer.isEmpty)
        XCTAssertEqual(session.calls, configuredOnAnswer + configuredOnAnswer)
    }

    func testOnlyTheLastAnsweredCallIsConfiguredAgainAfterItsAnswer() {
        let first = UUID()
        _ = manager.store.incomingReported(
            CallData(args: ["id": "first", "audioSessionMode": "videoChat"]), uuid: first)
        let second = UUID()
        _ = manager.store.incomingReported(
            CallData(args: ["id": "second", "audioSessionMode": "gameChat"]), uuid: second)
        manager.provider(provider, perform: CXAnswerCallAction(call: first))
        manager.provider(provider, perform: CXAnswerCallAction(call: second))
        let configuredOnAnswers = session.calls.count

        waitPastTheReconfigureAfterAnswer()

        let reconfigured = Array(session.calls.dropFirst(configuredOnAnswers))
        XCTAssertTrue(reconfigured.contains("mode \(AVAudioSession.Mode.gameChat.rawValue)"))
        XCTAssertFalse(
            reconfigured.contains("mode \(AVAudioSession.Mode.videoChat.rawValue)"),
            "the first call's options were applied again after the second was answered")
    }

    func testACallThatEndedBeforeTheReconfigureAfterItsAnswerIsNotConfiguredAgain() {
        let call = track(id: "answered")
        manager.provider(provider, perform: CXAnswerCallAction(call: call.identity.callKitUUID))
        end(call.identity.callKitUUID)
        let configured = session.calls

        waitPastTheReconfigureAfterAnswer()

        XCTAssertEqual(session.calls, configured)
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
            CallData(args: ["id": uuid.uuidString]), uuid: uuid)

        manager.saveEndCall(uuid.uuidString, 2)

        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: nil)])
    }

    func testTheLastRingTimingOutAllowsTheAudioEngine() {
        let uuid = UUID()
        let shown = CallData(args: ["id": uuid.uuidString])
        _ = manager.store.incomingReported(shown, uuid: uuid)

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

    func testTheStartOfACallBeingRegisteredAgainIsNotANewCall() {
        listen()
        let first = UUID()
        let call = track(id: first.uuidString)
        answer(call)
        let second = UUID()
        manager.store.reRegistrationRequested(call, as: second)

        manager.provider(
            provider,
            perform: CXStartCallAction(call: second, handle: CXHandle(type: .generic, value: "x")))
        drainMainQueue()

        XCTAssertEqual(received.count, 0, "Dart is not told about the new uuid")
        XCTAssertEqual(manager.store.calls.count, 1)
        XCTAssertEqual(call.identity.callKitUUID, second)

        end(second)
        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertEqual(receivedId(at: 0), first.uuidString)
    }

    /// Ends the call CallKit knows as `uuid`, without waiting for the main queue: a real
    /// provider's configuration can be refreshed from CallKit there, so the Recents flag is read
    /// in the same turn it was set.
    private func endWithoutWaiting(_ uuid: UUID) {
        manager.provider(provider, perform: CXEndCallAction(call: uuid))
    }

    /// Ends `call` with CallKit and starts it again as a new uuid, through the manager.
    private func registerAgain(_ call: CallKitCall) -> UUID {
        manager.endForReRegistration(call)
        let uuid = UUID()
        manager.store.reRegistrationRequested(call, as: uuid)
        manager.provider(
            provider,
            perform: CXStartCallAction(call: uuid, handle: CXHandle(type: .generic, value: "x")))
        return uuid
    }

    func testRecentsListsTheFirstEndOfACallAndNotTheEndsOfItsRegistrationsAgain() {
        let recents = CXProvider(configuration: CXProviderConfiguration())
        manager.sharedProvider = recents
        manager.recentsSuppressedFor = nil
        let call = track(id: UUID().uuidString)
        answer(call)

        _ = registerAgain(call)
        XCTAssertTrue(
            recents.configuration.includesCallsInRecents, "the call as first reported is listed")

        let third = registerAgain(call)
        XCTAssertFalse(
            recents.configuration.includesCallsInRecents, "a registration again is not listed")

        manager.initCallkitProvider(call.options)
        XCTAssertFalse(recents.configuration.includesCallsInRecents, "a refresh keeps it off")

        endWithoutWaiting(third)
        XCTAssertFalse(recents.configuration.includesCallsInRecents)
        XCTAssertNotNil(manager.recentsSuppressedFor, "still off while CallKit lists the end")

        manager.provider(provider, didDeactivate: AVAudioSession.sharedInstance())
        XCTAssertTrue(recents.configuration.includesCallsInRecents)
        XCTAssertNil(manager.recentsSuppressedFor)
    }

    func testTheEndOfARegistrationAgainIsNotListed() {
        let recents = CXProvider(configuration: CXProviderConfiguration())
        manager.sharedProvider = recents
        manager.recentsSuppressedFor = nil
        let call = track(id: UUID().uuidString)
        answer(call)
        let second = registerAgain(call)
        XCTAssertTrue(recents.configuration.includesCallsInRecents)

        endWithoutWaiting(second)

        XCTAssertFalse(recents.configuration.includesCallsInRecents)
        XCTAssertNotNil(manager.recentsSuppressedFor)
    }

    func testANewCallAfterARegistrationAgainTurnsRecentsBackOn() {
        let recents = CXProvider(configuration: CXProviderConfiguration())
        manager.sharedProvider = recents
        manager.recentsSuppressedFor = nil
        let call = track(id: UUID().uuidString)
        answer(call)
        endWithoutWaiting(registerAgain(call))
        XCTAssertFalse(recents.configuration.includesCallsInRecents)

        manager.initCallkitProvider(CallData(args: ["id": UUID().uuidString]))

        XCTAssertTrue(recents.configuration.includesCallsInRecents)
    }

    func testEndingACallBeingRegisteredAgainEndsItAndFailsItsStart() {
        listen()
        let first = UUID()
        let call = track(id: first.uuidString)
        answer(call)
        let second = UUID()
        manager.store.reRegistrationRequested(call, as: second)

        manager.endCall(CallData(args: ["id": first.uuidString]))
        drainMainQueue()
        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertEqual(receivedId(at: 0), first.uuidString)
        XCTAssertTrue(manager.store.calls.isEmpty)
        XCTAssertEqual(gate.updates.last, .init(available: true, callKitSessionActive: nil))

        manager.provider(
            provider,
            perform: CXStartCallAction(call: second, handle: CXHandle(type: .generic, value: "x")))
        drainMainQueue()
        XCTAssertEqual(received.count, 1, "the late start is not a new call")
        XCTAssertTrue(manager.store.calls.isEmpty)
    }

    func testTheAcceptedCallIsFoundAfterItIsRegisteredAgain() {
        let first = UUID()
        let call = track(id: first.uuidString)
        answer(call)
        manager.store.lastOptions = call.options
        let second = UUID()
        manager.store.reRegistrationRequested(call, as: second)
        _ = manager.store.reRegistrationPerformed(uuid: second)

        XCTAssertTrue(manager.getAcceptedCall() === call.options)
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
        _ = manager.store.incomingReported(pushed, uuid: uuid)

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
        _ = manager.store.incomingReported(pushed, uuid: uuid)

        manager.handle(.callConnected(nil)) { _ in }

        XCTAssertNotNil(manager.store.call(forCallKit: uuid)?.connectedAt)
        XCTAssertFalse(manager.store.isFromPushKit)
    }

    func testDartEndCallWithoutPushKitUsesTheTrackedCallsOptions() {
        let uuid = UUID()
        _ = manager.store.incomingReported(
            CallData(args: ["id": uuid.uuidString, "callerName": "Tracked"]), uuid: uuid)
        let call = manager.store.call(forCallKit: uuid)!

        manager.handle(.endCall(["id": uuid.uuidString])) { _ in }

        XCTAssertTrue(manager.store.lastOptions === call.options)
        XCTAssertEqual(manager.store.lastOptions?.callerName, "Tracked")
    }

    func testDartCallConnectedWithoutPushKitConnectsTheTrackedCall() {
        let uuid = UUID()
        _ = manager.store.incomingReported(
            CallData(args: ["id": uuid.uuidString]), uuid: uuid)
        let call = manager.store.call(forCallKit: uuid)!

        manager.handle(.callConnected(["id": uuid.uuidString.lowercased()])) { _ in }

        XCTAssertTrue(manager.store.lastOptions === call.options)
        XCTAssertNotNil(call.connectedAt)
    }

    func testARingTheAppEndedDoesNotTimeOutLater() {
        let uuid = UUID()
        let shown = CallData(args: ["id": uuid.uuidString])
        _ = manager.store.incomingReported(shown, uuid: uuid)

        manager.saveEndCall(uuid.uuidString, 2)
        XCTAssertFalse(manager.store.shouldTimeOut(appId: shown.uuid))
    }

    func testDartMuteOrHoldThatMatchesTheCallSendsTheEvent() {
        listen()
        let uuid = UUID()
        _ = manager.store.incomingReported(
            CallData(args: ["id": uuid.uuidString]), uuid: uuid)

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
        _ = manager.store.incomingReported(shown, uuid: uuid)

        manager.callEndTimeout(shown)
        drainMainQueue()

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT])
        XCTAssertEqual(manager.store.call(forCallKit: uuid)?.phase, .ended(.unanswered))
    }

    func testThePluginRunsTheCompletionOfACallItCannotReport() {
        listen()
        let completed = expectation(description: "completion")

        StreamVideoPushNotificationPlugin.showIncomingCall(
            data: CallData(args: ["id": "not-a-uuid"]), fromPushKit: false
        ) { completed.fulfill() }

        wait(for: [completed], timeout: 1)
        drainMainQueue()
        XCTAssertFalse(
            receivedNames.contains(StreamVideoIncomingCallConstants.ACTION_CALL_INCOMING))
    }

    func testARefusedEndDropsTheCall() {
        let call = track(id: "ringing")

        manager.transactions.onEndRefused?(call.identity.callKitUUID)

        XCTAssertNil(manager.store.call(forCallKit: call.identity.callKitUUID))
    }
}

final class FakeBackgroundTasks: BackgroundTasks {
    private(set) var begun = 0
    private(set) var ended: [UIBackgroundTaskIdentifier] = []
    private(set) var expiration: (() -> Void)?

    func begin(name: String, expiration: @escaping () -> Void) -> UIBackgroundTaskIdentifier {
        begun += 1
        self.expiration = expiration
        return UIBackgroundTaskIdentifier(rawValue: begun)
    }

    func end(_ task: UIBackgroundTaskIdentifier) {
        ended.append(task)
    }
}

/// Pins how long the app is kept running after CallKit ends a call.
final class CallEndGracePeriodTests: XCTestCase {

    private var tasks: FakeBackgroundTasks!
    private var scheduler: FakeHoldRecoveryScheduler!
    private var grace: CallEndGracePeriod!

    override func setUp() {
        super.setUp()
        tasks = FakeBackgroundTasks()
        scheduler = FakeHoldRecoveryScheduler()
        grace = CallEndGracePeriod(duration: 10, tasks: tasks, scheduler: scheduler)
    }

    func testTheTaskEndsWhenTheGracePeriodRunsOut() {
        grace.callEnded()
        XCTAssertEqual(tasks.begun, 1)

        scheduler.advance(by: 9.9)
        XCTAssertTrue(tasks.ended.isEmpty)

        scheduler.advance(by: 0.1)
        XCTAssertEqual(tasks.ended, [UIBackgroundTaskIdentifier(rawValue: 1)])
        XCTAssertFalse(grace.isRunning)
    }

    func testAnotherEndRestartsTheGracePeriodInTheSameTask() {
        grace.callEnded()
        scheduler.advance(by: 6)

        grace.callEnded()
        scheduler.advance(by: 6)

        XCTAssertEqual(tasks.begun, 1)
        XCTAssertTrue(tasks.ended.isEmpty)
        scheduler.advance(by: 4)
        XCTAssertEqual(tasks.ended.count, 1)
    }

    func testTheTaskEndsOnceWhenIOSExpiresIt() {
        grace.callEnded()

        tasks.expiration?()
        scheduler.advance(by: 10)

        XCTAssertEqual(tasks.ended.count, 1)
        XCTAssertFalse(grace.isRunning)
    }

    func testAnEndAfterTheTaskEndedBeginsANewOne() {
        grace.callEnded()
        scheduler.advance(by: 10)

        grace.callEnded()

        XCTAssertEqual(tasks.begun, 2)
        XCTAssertTrue(grace.isRunning)
    }
}

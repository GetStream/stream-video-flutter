import AVFoundation
import XCTest

@testable import stream_video_push_notification

/// Records what the coordinator sets on the audio session.
final class FakeAudioSession: AudioSessionConfiguring {
    private(set) var calls: [String] = []

    func setCategory(
        _ category: AVAudioSession.Category, options: AVAudioSession.CategoryOptions
    ) throws {
        calls.append("category \(category.rawValue)")
    }

    func setMode(_ mode: AVAudioSession.Mode) throws {
        calls.append("mode \(mode.rawValue)")
    }

    func setPreferredSampleRate(_ sampleRate: Double) throws {
        calls.append("sampleRate \(sampleRate)")
    }

    func setPreferredIOBufferDuration(_ duration: TimeInterval) throws {
        calls.append("ioBufferDuration \(duration)")
    }
}

/// Records what the coordinator tells WebRTC.
final class FakeAudioEngineGate: WebRTCAudioEngineGate {
    struct Update: Equatable {
        let available: Bool
        let callKitSessionActive: Bool?
    }

    private(set) var updates: [Update] = []
    var onEngineStartFailed: (() -> Void)?
    /// Called on every update, after it is recorded.
    var onUpdate: (() -> Void)?

    func update(available: Bool, callKitSessionActive: Bool?) {
        updates.append(Update(available: available, callKitSessionActive: callKitSessionActive))
        onUpdate?()
    }
}

/// Pins when the audio session is configured and when WebRTC may use it.
final class CallKitAudioSessionCoordinatorTests: XCTestCase {

    private var session: FakeAudioSession!
    private var gate: FakeAudioEngineGate!
    private var coordinator: CallKitAudioSessionCoordinator!
    private var store: CallKitCallStore!

    override func setUp() {
        super.setUp()
        session = FakeAudioSession()
        gate = FakeAudioEngineGate()
        coordinator = CallKitAudioSessionCoordinator(session: session, gate: gate)
        store = CallKitCallStore()
    }

    @discardableResult
    private func answeredCall(_ args: [String: Any] = [:]) -> CallKitCall {
        let uuid = UUID()
        _ = store.incomingReported(
            CallData(args: args.merging(["id": "answered"]) { $1 }), uuid: uuid, source: .app)
        _ = store.answerPerformed(uuid: uuid)
        return store.call(forCallKit: uuid)!
    }

    private func outgoingCall() -> CallKitCall {
        let uuid = UUID()
        store.registerPendingOutgoing(CallData(args: ["id": "outgoing"]), uuid: uuid)
        return store.startPerformed(uuid: uuid)!.call
    }

    private func kinds(_ effects: [CallKitEffect]) -> [String] {
        effects.map {
            switch $0 {
            case .send(let event, let body):
                return "send \(event) \((body?["isActive"] as? Bool).map { "\($0)" } ?? "")"
            case .reportStartedConnecting: return "reportStartedConnecting"
            case .reportConnected: return "reportConnected"
            case .postAudioInterruptionEnded: return "postAudioInterruptionEnded"
            }
        }
    }

    /// Activates the audio session and says whether that configured it.
    private func activationConfigures() -> Bool {
        let before = session.calls.count
        _ = coordinator.didActivate(store)
        return session.calls.count > before
    }

    private let audioEvent = StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION

    // MARK: - Activation

    func testTheFirstActivationStartsTheCallConfiguresTheSessionAndAllowsTheEngine() {
        let call = outgoingCall()
        var configuredWhenTheEngineWasAllowed: [String] = []
        gate.onUpdate = { [session] in configuredWhenTheEngineWasAllowed = session!.calls }

        let effects = coordinator.didActivate(store)

        XCTAssertEqual(
            kinds(effects),
            ["reportStartedConnecting", "postAudioInterruptionEnded", "send \(audioEvent) true"])
        XCTAssertFalse(session.calls.isEmpty)
        XCTAssertEqual(
            configuredWhenTheEngineWasAllowed, session.calls,
            "the session is configured before WebRTC may start its engine")
        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: true)])
        XCTAssertTrue(call.hasActivatedAudioSession)
        XCTAssertEqual(call.phase, .active)
    }

    func testALaterActivationOnlyAllowsTheEngineAndTellsDart() {
        let call = answeredCall()
        _ = coordinator.didActivate(store)
        let startedConnectingAt = call.startedConnectingAt

        let configuredBefore = session.calls.count
        let effects = coordinator.didActivate(store)

        XCTAssertEqual(
            kinds(effects), ["postAudioInterruptionEnded", "send \(audioEvent) true"])
        XCTAssertEqual(session.calls.count, configuredBefore)
        XCTAssertEqual(gate.updates.last, .init(available: true, callKitSessionActive: true))
        XCTAssertEqual(call.startedConnectingAt, startedConnectingAt)
    }

    func testAConnectedCallIsNotTreatedAsAFirstActivationOnceActivated() {
        let call = answeredCall()
        _ = store.connected(uuid: call.identity.callKitUUID)
        _ = coordinator.didActivate(store)

        XCTAssertFalse(activationConfigures())
    }

    func testANewCallAfterAnEndedAnsweredOneGetsAFirstActivation() {
        let first = answeredCall()
        _ = coordinator.didActivate(store)
        _ = store.endPerformed(uuid: first.identity.callKitUUID)

        answeredCall()

        XCTAssertTrue(activationConfigures())
    }

    func testANewCallAfterAnEndedOutgoingOneGetsAFirstActivation() {
        // The outgoing call stays in the store after it ends.
        let outgoing = outgoingCall()
        _ = coordinator.didActivate(store)
        _ = store.endPerformed(uuid: outgoing.identity.callKitUUID)
        XCTAssertTrue(store.outgoingCall === outgoing)

        let call = answeredCall()

        XCTAssertTrue(activationConfigures())
        XCTAssertTrue(call.hasActivatedAudioSession)
    }

    func testAnsweringASecondCallGivesItAFirstActivationOfItsOwn() {
        // Only the call answered last counts, so the first one's activation does not.
        let first = answeredCall()
        _ = coordinator.didActivate(store)

        let second = answeredCall()

        XCTAssertTrue(activationConfigures())
        XCTAssertTrue(second.hasActivatedAudioSession)
        XCTAssertTrue(first.hasActivatedAudioSession)
    }

    func testTheFirstActivationConfiguresWithTheActivatedCallsOptions() {
        answeredCall(["audioSessionMode": "videoChat"])
        store.lastOptions = CallData(args: ["id": "last", "audioSessionMode": "voiceChat"])

        _ = coordinator.didActivate(store)

        XCTAssertTrue(session.calls.contains("mode \(AVAudioSession.Mode.videoChat.rawValue)"))
        XCTAssertFalse(session.calls.contains("mode \(AVAudioSession.Mode.voiceChat.rawValue)"))
    }

    func testAnActivationWithNoLiveCallConfiguresWithTheLastOptions() {
        store.lastOptions = CallData(args: ["id": "last", "audioSessionMode": "voiceChat"])

        _ = coordinator.didActivate(store)

        XCTAssertTrue(session.calls.contains("mode \(AVAudioSession.Mode.voiceChat.rawValue)"))
    }

    func testANewOutgoingCallDuringAHeldAnsweredCallGetsAFirstActivationOfItsOwn() {
        let held = answeredCall()
        _ = coordinator.didActivate(store)
        _ = store.holdPerformed(uuid: held.identity.callKitUUID, onHold: true)
        _ = coordinator.didDeactivate(store)
        let outgoing = outgoingCall()

        let effects = coordinator.didActivate(store)

        XCTAssertEqual(
            kinds(effects),
            ["reportStartedConnecting", "postAudioInterruptionEnded", "send \(audioEvent) true"])
        XCTAssertEqual(outgoing.phase, .active)
        XCTAssertNotNil(outgoing.startedConnectingAt)
        XCTAssertTrue(outgoing.hasActivatedAudioSession)
    }

    func testAnActivationAfterTheOnlyCallEndedStartsNothing() {
        let outgoing = outgoingCall()
        _ = store.endPerformed(uuid: outgoing.identity.callKitUUID)

        let effects = coordinator.didActivate(store)

        XCTAssertEqual(
            kinds(effects), ["postAudioInterruptionEnded", "send \(audioEvent) true"],
            "an ended call is not reported as connecting")
        XCTAssertEqual(outgoing.phase, .ended(nil))
        XCTAssertNil(outgoing.startedConnectingAt)
        XCTAssertFalse(session.calls.isEmpty, "the session gets the last options or the defaults")
        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: true)])
    }

    // MARK: - Deactivation

    func testADeactivationWithACallLeftStopsTheEngine() {
        answeredCall()

        let effects = coordinator.didDeactivate(store)

        XCTAssertEqual(gate.updates, [.init(available: false, callKitSessionActive: false)])
        XCTAssertEqual(kinds(effects), ["send \(audioEvent) false"])
    }

    func testARepeatedDeactivationIsPassedOnForWebRTCToIgnore() {
        // CallKit can deactivate more than once; the WebRTC control ignores a repeated stop.
        answeredCall()

        _ = coordinator.didDeactivate(store)
        _ = coordinator.didDeactivate(store)

        XCTAssertEqual(
            gate.updates,
            [
                .init(available: false, callKitSessionActive: false),
                .init(available: false, callKitSessionActive: false),
            ])
    }

    func testADeactivationWithNoCallLeftAllowsTheEngine() {
        _ = coordinator.didDeactivate(store)

        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: false)])
    }

    func testADeactivationWhileTheAnsweredCallIsHeldStopsTheEngineAndTellsDartNothing() {
        let call = answeredCall()
        _ = store.holdPerformed(uuid: call.identity.callKitUUID, onHold: true)

        let effects = coordinator.didDeactivate(store)

        XCTAssertEqual(gate.updates, [.init(available: false, callKitSessionActive: false)])
        XCTAssertTrue(effects.isEmpty)
    }

    func testRemovingTheLastCallAllowsTheEngine() {
        let call = answeredCall()
        coordinator.callsRemoved(store)
        XCTAssertTrue(gate.updates.isEmpty)

        _ = store.endPerformed(uuid: call.identity.callKitUUID)
        coordinator.callsRemoved(store)

        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: nil)])
    }

    func testATimedOutRingDoesNotKeepTheEngineStopped() {
        let uuid = UUID()
        let shown = CallData(args: ["id": uuid.uuidString])
        _ = store.incomingReported(shown, uuid: uuid, source: .app)
        _ = store.timedOut(shown)

        coordinator.callsRemoved(store)

        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: nil)])
    }

    // MARK: - Session

    func testConfiguringAppliesTheOptions() {
        let options = CallData(args: [
            "ios": [
                "audioSessionMode": "voiceChat",
                "audioSessionPreferredSampleRate": 48000.0,
                "audioSessionPreferredIOBufferDuration": 0.01,
            ]
        ])

        coordinator.configure(options)

        XCTAssertEqual(
            session.calls,
            [
                "category \(AVAudioSession.Category.playAndRecord.rawValue)",
                "mode \(AVAudioSession.Mode.voiceChat.rawValue)",
                "sampleRate 48000.0",
                "ioBufferDuration 0.01",
            ])
    }

    func testConfiguringWithoutOptionsAppliesTheDefaults() {
        coordinator.configure(nil)

        XCTAssertEqual(
            session.calls,
            [
                "category \(AVAudioSession.Category.playAndRecord.rawValue)",
                "mode \(AVAudioSession.Mode.default.rawValue)",
                "sampleRate 44100.0",
                "ioBufferDuration 0.005",
            ])
    }

    func testConfiguringIsSkippedWhenTheOptionsSaySo() {
        coordinator.configure(CallData(args: ["ios": ["configureAudioSession": false]]))

        XCTAssertTrue(session.calls.isEmpty)
    }
}

/// Pins the NotificationCenter messages the gate exchanges with `stream_webrtc_flutter`.
final class NotificationCenterAudioEngineGateTests: XCTestCase {

    func testAnUpdateIsPostedWithItsKeys() {
        let center = NotificationCenter()
        let gate = NotificationCenterAudioEngineGate(center: center)
        var received: [[AnyHashable: Any]] = []
        let observer = center.addObserver(
            forName: NotificationCenterAudioEngineGate.availabilityNotification, object: nil,
            queue: nil
        ) { received.append($0.userInfo ?? [:]) }
        defer { center.removeObserver(observer) }

        gate.update(available: false, callKitSessionActive: false)
        gate.update(available: true, callKitSessionActive: nil)

        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[0]["available"] as? Bool, false)
        XCTAssertEqual(received[0]["audioSessionActive"] as? Bool, false)
        XCTAssertEqual(received[1]["available"] as? Bool, true)
        XCTAssertNil(received[1]["audioSessionActive"])
    }

    func testAStartFailureFromWebRTCReachesTheCallback() {
        let center = NotificationCenter()
        let gate = NotificationCenterAudioEngineGate(center: center)
        let failed = expectation(description: "start failure forwarded")
        gate.onEngineStartFailed = { failed.fulfill() }

        center.post(name: NotificationCenterAudioEngineGate.engineStartFailedNotification, object: nil)

        wait(for: [failed], timeout: 1)
    }
}

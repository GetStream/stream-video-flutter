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

    func update(available: Bool, callKitSessionActive: Bool?) {
        updates.append(Update(available: available, callKitSessionActive: callKitSessionActive))
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
    private func answeredCall() -> CallKitCall {
        let uuid = UUID()
        _ = store.incomingReported(CallData(args: ["id": "answered"]), uuid: uuid, source: .app)
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
            case .configureAudioSession: return "configureAudioSession"
            }
        }
    }

    private let audioEvent = StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION

    // MARK: - Activation

    func testTheFirstActivationStartsTheCallConfiguresTheSessionAndAllowsTheEngine() {
        let call = outgoingCall()

        let effects = coordinator.didActivate(store)

        XCTAssertEqual(
            kinds(effects),
            [
                "reportStartedConnecting", "postAudioInterruptionEnded", "configureAudioSession",
                "send \(audioEvent) true",
            ])
        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: true)])
        XCTAssertTrue(call.hasActivatedAudioSession)
        XCTAssertEqual(call.phase, .active)
    }

    func testALaterActivationOnlyAllowsTheEngineAndTellsDart() {
        let call = answeredCall()
        _ = coordinator.didActivate(store)
        let startedConnectingAt = call.startedConnectingAt

        let effects = coordinator.didActivate(store)

        XCTAssertEqual(
            kinds(effects), ["postAudioInterruptionEnded", "send \(audioEvent) true"])
        XCTAssertEqual(gate.updates.last, .init(available: true, callKitSessionActive: true))
        XCTAssertEqual(call.startedConnectingAt, startedConnectingAt)
    }

    func testAConnectedCallIsNotTreatedAsAFirstActivationOnceActivated() {
        let call = answeredCall()
        _ = store.connected(uuid: call.identity.callKitUUID)
        _ = coordinator.didActivate(store)

        XCTAssertFalse(kinds(coordinator.didActivate(store)).contains("configureAudioSession"))
    }

    func testANewCallAfterAnEndedAnsweredOneGetsAFirstActivation() {
        let first = answeredCall()
        _ = coordinator.didActivate(store)
        _ = store.endPerformed(uuid: first.identity.callKitUUID)

        answeredCall()

        XCTAssertTrue(kinds(coordinator.didActivate(store)).contains("configureAudioSession"))
    }

    func testANewCallAfterAnEndedOutgoingOneGetsAFirstActivation() {
        // The outgoing call stays in the store after it ends.
        let outgoing = outgoingCall()
        _ = coordinator.didActivate(store)
        _ = store.endPerformed(uuid: outgoing.identity.callKitUUID)
        XCTAssertTrue(store.outgoingCall === outgoing)

        let call = answeredCall()

        XCTAssertTrue(kinds(coordinator.didActivate(store)).contains("configureAudioSession"))
        XCTAssertTrue(call.hasActivatedAudioSession)
    }

    func testAnsweringASecondCallGivesItAFirstActivationOfItsOwn() {
        // Only the call answered last counts, so the first one's activation does not.
        let first = answeredCall()
        _ = coordinator.didActivate(store)

        let second = answeredCall()

        XCTAssertTrue(kinds(coordinator.didActivate(store)).contains("configureAudioSession"))
        XCTAssertTrue(second.hasActivatedAudioSession)
        XCTAssertTrue(first.hasActivatedAudioSession)
    }

    func testTheFirstActivationConfiguresWithTheLastOptions() {
        answeredCall()
        let last = CallData(args: ["id": "last"])
        store.lastOptions = last

        let effects = coordinator.didActivate(store)

        let configured = effects.compactMap { effect -> CallData?? in
            if case .configureAudioSession(let options) = effect { return .some(options) }
            return nil
        }
        XCTAssertEqual(configured.count, 1)
        XCTAssertTrue(configured[0] === last)
    }

    // MARK: - Deactivation

    func testADeactivationWithACallLeftStopsTheEngine() {
        answeredCall()

        let effects = coordinator.didDeactivate(store)

        XCTAssertEqual(gate.updates, [.init(available: false, callKitSessionActive: false)])
        XCTAssertEqual(kinds(effects), ["send \(audioEvent) false"])
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

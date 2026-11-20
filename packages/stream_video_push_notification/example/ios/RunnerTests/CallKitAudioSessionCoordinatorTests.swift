import AVFoundation
import XCTest

@testable import stream_video_push_notification

/// Records the configurations the coordinator applies to the audio session.
final class FakeAudioSession: AudioSessionConfiguring {
    /// Every configuration applied, in order.
    private(set) var applied: [[String: Any]] = []

    /// The category the session reports; an applied configuration's category replaces it.
    var category: AVAudioSession.Category = .soloAmbient

    /// Applying a configuration with one of these categories throws.
    var refusedCategories: Set<String> = []

    /// `applied`, described so tests can compare them.
    var calls: [String] { applied.map(Self.describe) }

    func apply(_ configuration: [String: Any]) throws {
        let name = configuration["appleAudioCategory"] as? String
        if let name = name, refusedCategories.contains(name) {
            throw NSError(domain: "FakeAudioSession", code: 1)
        }
        applied.append(configuration)
        switch name {
        case "playAndRecord": category = .playAndRecord
        case "record": category = .record
        case "playback": category = .playback
        default: break
        }
    }

    static func describe(_ configuration: [String: Any]) -> String {
        let category = configuration["appleAudioCategory"] as? String ?? "-"
        let mode = configuration["appleAudioMode"] as? String ?? "-"
        let options = (configuration["appleAudioCategoryOptions"] as? [String])?.joined(
            separator: ",") ?? "-"
        return "\(category) \(mode) \(options)"
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
        coordinator = CallKitAudioSessionCoordinator(
            session: session, gate: gate, persistedRingingConfiguration: { nil })
        store = CallKitCallStore()
    }

    @discardableResult
    private func answeredCall(_ args: [String: Any] = [:]) -> CallKitCall {
        let uuid = UUID()
        _ = store.incomingReported(
            CallData(args: args.merging(["id": "answered"]) { $1 }), uuid: uuid)
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

    /// A ringing call answered from the CallKit screen, before the app joined it.
    private func ringingCall() -> CallKitCall {
        let uuid = UUID()
        _ = store.incomingReported(CallData(args: ["id": "ringing"]), uuid: uuid)
        return store.call(forCallKit: uuid)!
    }

    private let broadcaster: [String: Any] = [
        "appleAudioCategory": "playAndRecord",
        "appleAudioCategoryOptions": ["mixWithOthers", "allowBluetooth"],
        "appleAudioMode": "voiceChat",
    ]

    private let audioEvent = StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION

    // MARK: - Activation

    func testTheFirstActivationStartsTheCallAndAllowsTheEngineWithoutConfiguring() {
        let call = outgoingCall()

        let effects = coordinator.didActivate(store)

        XCTAssertEqual(
            kinds(effects),
            ["reportStartedConnecting", "postAudioInterruptionEnded", "send \(audioEvent) true"])
        XCTAssertTrue(session.calls.isEmpty, "the start or the answer configured the session")
        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: true)])
        XCTAssertTrue(call.hasActivatedAudioSession)
        XCTAssertEqual(call.phase, .active)
    }

    func testALaterActivationOnlyAllowsTheEngineAndTellsDart() {
        _ = answeredCall()
        _ = coordinator.didActivate(store)

        let effects = coordinator.didActivate(store)

        XCTAssertEqual(
            kinds(effects), ["postAudioInterruptionEnded", "send \(audioEvent) true"])
        XCTAssertTrue(session.calls.isEmpty)
        XCTAssertEqual(gate.updates.last, .init(available: true, callKitSessionActive: true))
    }

    func testANewCallAfterAnEndedOutgoingOneGetsAFirstActivation() {
        let outgoing = outgoingCall()
        _ = coordinator.didActivate(store)
        _ = store.endPerformed(uuid: outgoing.identity.callKitUUID)
        XCTAssertNil(store.outgoingCall)

        let call = answeredCall()
        _ = coordinator.didActivate(store)

        XCTAssertTrue(call.hasActivatedAudioSession)
        XCTAssertEqual(call.phase, .active)
    }

    func testAnsweringASecondCallGivesItAFirstActivationOfItsOwn() {
        let first = answeredCall()
        _ = coordinator.didActivate(store)

        let second = answeredCall()
        _ = coordinator.didActivate(store)

        XCTAssertTrue(second.hasActivatedAudioSession)
        XCTAssertEqual(second.phase, .active)
        XCTAssertTrue(first.hasActivatedAudioSession)
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
        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: true)])
    }

    // MARK: - Deactivation

    func testADeactivationWithACallLeftStopsTheEngine() {
        answeredCall()

        let effects = coordinator.didDeactivate(store)

        XCTAssertEqual(gate.updates, [.init(available: false, callKitSessionActive: false)])
        XCTAssertEqual(kinds(effects), ["send \(audioEvent) false"])
    }

    func testARepeatedDeactivationIsPassedOnToTheGate() {
        // CallKit can deactivate more than once; each one reaches the gate.
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
        _ = store.incomingReported(shown, uuid: uuid)
        _ = store.timedOut(shown)

        coordinator.callsRemoved(store)

        XCTAssertEqual(gate.updates, [.init(available: true, callKitSessionActive: nil)])
    }

    // MARK: - Session

    func testAnsweringARingTheAppHasNotJoinedAppliesTheRingingConfiguration() {
        coordinator.ringingConfiguration = broadcaster

        coordinator.answering(ringingCall())

        XCTAssertEqual(session.calls, [FakeAudioSession.describe(broadcaster)])
    }

    func testAnsweringARingTheAppJoinedKeepsASessionThatCanRecord() {
        coordinator.ringingConfiguration = broadcaster
        session.category = .playAndRecord
        let call = ringingCall()
        _ = store.connected(uuid: call.identity.callKitUUID)

        coordinator.answering(call)

        XCTAssertTrue(session.calls.isEmpty, "the call's own configuration was replaced")
    }

    func testAnsweringARingTheAppJoinedConfiguresASessionThatCannotRecord() {
        coordinator.ringingConfiguration = broadcaster
        session.category = .playback
        let call = ringingCall()
        _ = store.connected(uuid: call.identity.callKitUUID)

        coordinator.answering(call)

        XCTAssertEqual(session.calls, [FakeAudioSession.describe(broadcaster)])
    }

    func testStartingAnOutgoingCallKeepsASessionThatCanRecord() {
        session.category = .playAndRecord

        coordinator.starting()

        XCTAssertTrue(session.calls.isEmpty)
    }

    func testStartingAnOutgoingCallConfiguresASessionThatCannotRecord() {
        coordinator.ringingConfiguration = broadcaster

        coordinator.starting()

        XCTAssertEqual(session.calls, [FakeAudioSession.describe(broadcaster)])
    }

    func testARingingConfigurationThatCannotRecordIsAppliedWithPlayAndRecord() {
        coordinator.ringingConfiguration = [
            "appleAudioCategory": "playback",
            "appleAudioCategoryOptions": ["mixWithOthers"],
            "appleAudioMode": "spokenAudio",
        ]

        coordinator.applyRingingConfiguration()

        XCTAssertEqual(session.calls, ["playAndRecord spokenAudio mixWithOthers"])
    }

    func testARingingConfigurationWithoutACategoryIsAppliedWithPlayAndRecord() {
        coordinator.ringingConfiguration = ["appleAudioMode": "videoChat"]

        coordinator.applyRingingConfiguration()

        XCTAssertEqual(session.calls, ["playAndRecord videoChat -"])
    }

    func testWithoutARingingConfigurationTheDefaultOneIsApplied() {
        coordinator.applyRingingConfiguration()

        XCTAssertEqual(
            session.calls,
            [FakeAudioSession.describe(CallKitAudioSessionCoordinator.defaultConfiguration)])
    }

    func testTheRingingConfigurationFallsBackToThePersistedOne() {
        coordinator = CallKitAudioSessionCoordinator(
            session: session, gate: gate, persistedRingingConfiguration: { [broadcaster] in
                broadcaster
            })

        coordinator.applyRingingConfiguration()

        XCTAssertEqual(session.calls, [FakeAudioSession.describe(broadcaster)])
    }

    func testTheRingingConfigurationDartSentWinsOverThePersistedOne() {
        coordinator = CallKitAudioSessionCoordinator(
            session: session, gate: gate,
            persistedRingingConfiguration: { ["appleAudioMode": "gameChat"] })
        coordinator.ringingConfiguration = broadcaster

        coordinator.applyRingingConfiguration()

        XCTAssertEqual(session.calls, [FakeAudioSession.describe(broadcaster)])
    }

    func testARefusedRingingConfigurationFallsBackToTheDefaultOne() {
        coordinator.ringingConfiguration = [
            "appleAudioCategory": "record", "appleAudioMode": "moviePlayback",
        ]
        session.refusedCategories = ["record"]

        coordinator.applyRingingConfiguration()

        XCTAssertEqual(
            session.calls,
            [FakeAudioSession.describe(CallKitAudioSessionCoordinator.defaultConfiguration)])
    }
}

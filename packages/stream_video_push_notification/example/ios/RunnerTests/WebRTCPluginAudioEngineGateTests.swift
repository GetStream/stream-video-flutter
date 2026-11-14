import XCTest
import stream_webrtc_flutter

@testable import stream_video_push_notification

/// Records what the gate asks of `stream_webrtc_flutter`.
final class FakeAudioEngineControl: NSObject, FlutterWebRTCAudioEngineControl {
    private(set) var calls: [String] = []
    var audioEngineStartFailedHandler: (() -> Void)?

    func setAudioEngineAvailable(_ available: Bool) {
        calls.append("available \(available)")
    }

    func setCallKitAudioSessionActive(_ active: Bool) {
        calls.append("sessionActive \(active)")
    }
}

/// Pins how the gate reaches `stream_webrtc_flutter`'s audio engine control.
final class WebRTCPluginAudioEngineGateTests: XCTestCase {

    private var control: FakeAudioEngineControl!
    private var gate: WebRTCPluginAudioEngineGate!

    override func setUp() {
        super.setUp()
        control = FakeAudioEngineControl()
        gate = WebRTCPluginAudioEngineGate(control: control)
    }

    func testAnActivationReachesTheSessionBeforeTheEngine() {
        gate.update(available: true, callKitSessionActive: true)

        XCTAssertEqual(control.calls, ["sessionActive true", "available true"])
    }

    func testADeactivationReachesTheEngineBeforeTheSession() {
        gate.update(available: false, callKitSessionActive: false)
        gate.update(available: true, callKitSessionActive: nil)

        XCTAssertEqual(
            control.calls, ["available false", "sessionActive false", "available true"])
    }

    func testAStartFailureReachesTheCallbackThroughTheControlsHandler() {
        var failures = 0
        gate.onEngineStartFailed = { failures += 1 }

        control.audioEngineStartFailedHandler?()

        XCTAssertEqual(failures, 1)
    }

    func testTheDefaultGateUsesTheProcessWideControl() {
        let shared = FlutterWebRTCPlugin.audioEngineControl()
        let handler = shared.audioEngineStartFailedHandler
        defer { shared.audioEngineStartFailedHandler = handler }

        let defaultGate = WebRTCPluginAudioEngineGate()

        XCTAssertTrue(defaultGate.control === shared)
        XCTAssertTrue(FlutterWebRTCPlugin.audioEngineControl() === shared)
        XCTAssertNotNil(shared.audioEngineStartFailedHandler)
    }
}

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

/// Pins how the gate reaches `stream_webrtc_flutter`: directly once its plugin is registered,
/// through notifications until then.
final class WebRTCPluginAudioEngineGateTests: XCTestCase {

    private var center: NotificationCenter!
    private var posted: [[AnyHashable: Any]] = []
    private var observer: NSObjectProtocol?
    private var control: FakeAudioEngineControl?
    private var resolutions = 0
    private var gate: WebRTCPluginAudioEngineGate!

    override func setUp() {
        super.setUp()
        center = NotificationCenter()
        posted = []
        control = nil
        resolutions = 0
        observer = center.addObserver(
            forName: NotificationCenterAudioEngineGate.availabilityNotification, object: nil,
            queue: nil
        ) { [weak self] in self?.posted.append($0.userInfo ?? [:]) }
        gate = WebRTCPluginAudioEngineGate(
            fallback: NotificationCenterAudioEngineGate(center: center),
            resolveControl: { [weak self] in
                self?.resolutions += 1
                return self?.control
            })
    }

    override func tearDown() {
        if let observer = observer {
            center.removeObserver(observer)
        }
        super.tearDown()
    }

    func testWithoutThePluginTheUpdateIsPosted() {
        gate.update(available: true, callKitSessionActive: true)

        XCTAssertEqual(posted.count, 1)
        XCTAssertEqual(posted[0]["available"] as? Bool, true)
        XCTAssertEqual(posted[0]["audioSessionActive"] as? Bool, true)
    }

    func testAnActivationReachesTheSessionBeforeTheEngine() {
        let control = FakeAudioEngineControl()
        self.control = control

        gate.update(available: true, callKitSessionActive: true)

        XCTAssertEqual(control.calls, ["sessionActive true", "available true"])
        XCTAssertTrue(posted.isEmpty)
    }

    func testADeactivationReachesTheEngineBeforeTheSession() {
        let control = FakeAudioEngineControl()
        self.control = control

        gate.update(available: false, callKitSessionActive: false)
        gate.update(available: true, callKitSessionActive: nil)

        XCTAssertEqual(
            control.calls, ["available false", "sessionActive false", "available true"])
        XCTAssertTrue(posted.isEmpty)
    }

    func testThePluginIsLookedUpOnEveryUpdate() {
        gate.update(available: false, callKitSessionActive: false)
        let control = FakeAudioEngineControl()
        self.control = control

        gate.update(available: true, callKitSessionActive: true)
        gate.update(available: true, callKitSessionActive: nil)

        XCTAssertEqual(posted.count, 1)
        XCTAssertEqual(control.calls, ["sessionActive true", "available true", "available true"])
        XCTAssertEqual(resolutions, 3)
    }

    func testANewlyRegisteredPluginGetsTheUpdatesAndTheHandler() {
        let first = FakeAudioEngineControl()
        control = first
        gate.update(available: true, callKitSessionActive: true)
        let second = FakeAudioEngineControl()
        control = second
        var failures = 0
        gate.onEngineStartFailed = { failures += 1 }

        gate.update(available: false, callKitSessionActive: nil)
        second.audioEngineStartFailedHandler?()

        XCTAssertEqual(first.calls, ["sessionActive true", "available true"])
        XCTAssertEqual(second.calls, ["available false"])
        XCTAssertEqual(failures, 1)
    }

    func testAStartFailureReachesTheCallbackOnceThroughThePluginsHandler() {
        let control = FakeAudioEngineControl()
        self.control = control
        gate.update(available: true, callKitSessionActive: true)
        var failures = 0
        gate.onEngineStartFailed = { failures += 1 }

        control.audioEngineStartFailedHandler?()
        center.post(name: NotificationCenterAudioEngineGate.engineStartFailedNotification, object: nil)
        drainMainQueue()

        XCTAssertEqual(failures, 1)
    }

    func testAStartFailureReachesTheCallbackThroughTheNotificationBeforeThePluginIsFound() {
        let failed = expectation(description: "start failure forwarded")
        gate.onEngineStartFailed = { failed.fulfill() }

        center.post(name: NotificationCenterAudioEngineGate.engineStartFailedNotification, object: nil)

        wait(for: [failed], timeout: 1)
    }

    func testTheDefaultGateCallsTheRegisteredWebRTCPluginRatherThanPosting() {
        // The example app registers stream_webrtc_flutter.
        let defaultGate = WebRTCPluginAudioEngineGate(
            fallback: NotificationCenterAudioEngineGate(center: center))

        defaultGate.update(available: true, callKitSessionActive: nil)

        XCTAssertNotNil(FlutterWebRTCPlugin.sharedSingleton())
        XCTAssertTrue(posted.isEmpty)
    }

    /// The fallback's observer delivers on the main queue; this waits for it.
    private func drainMainQueue() {
        let drained = expectation(description: "main queue drained")
        DispatchQueue.main.async { drained.fulfill() }
        wait(for: [drained], timeout: 1)
    }
}

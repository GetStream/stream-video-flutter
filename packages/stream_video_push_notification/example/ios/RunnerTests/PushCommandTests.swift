import Flutter
import XCTest

@testable import stream_video_push_notification

/// Pins how each method-channel call is parsed, including what a call with missing arguments
/// is answered with.
///
/// Run with the example's other RunnerTests by `melos run test:native:ios`.
final class PushCommandTests: XCTestCase {

    private func command(_ method: String, _ arguments: Any? = nil) -> PushCommand {
        PushCommand(FlutterMethodCall(methodName: method, arguments: arguments))
    }

    /// The reply of an `.ignored` command, or nil for any other command.
    private func ignoredReply(_ command: PushCommand) -> Any?? {
        if case .ignored(let reply) = command { return .some(reply) }
        return nil
    }

    private func assertIgnored(
        _ command: PushCommand, reply expected: Bool, file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard let reply = ignoredReply(command) else {
            return XCTFail("\(command) is not ignored", file: file, line: line)
        }
        XCTAssertEqual(reply as? Bool, expected, file: file, line: line)
    }

    private let callArgs: [String: Any] = ["id": "call-uuid", "callerName": "Ada"]

    // MARK: - Handled by the plugin

    func testInitData() {
        guard case .initData(let args) = command("initData", callArgs) else {
            return XCTFail("not initData")
        }
        XCTAssertEqual(args?["id"] as? String, "call-uuid")
    }

    func testInitDataWithoutAMapCarriesNoArguments() {
        guard case .initData(let args) = command("initData", "not a map") else {
            return XCTFail("not initData")
        }
        XCTAssertNil(args)
        guard case .initData(let missing) = command("initData") else {
            return XCTFail("not initData")
        }
        XCTAssertNil(missing)
    }

    func testGetDevicePushTokenVoIP() {
        guard case .getDevicePushTokenVoIP = command("getDevicePushTokenVoIP") else {
            return XCTFail("not getDevicePushTokenVoIP")
        }
    }

    // MARK: - Calls

    func testShowIncomingCall() {
        guard case .showIncomingCall(let data) = command("showIncomingCall", callArgs) else {
            return XCTFail("not showIncomingCall")
        }
        XCTAssertEqual(data.uuid, "call-uuid")
        XCTAssertEqual(data.callerName, "Ada")
    }

    func testShowIncomingCallWithoutAMapIsIgnored() {
        assertIgnored(command("showIncomingCall"), reply: true)
        assertIgnored(command("showIncomingCall", "not a map"), reply: true)
    }

    func testStartCall() {
        guard case .startCall(let data) = command("startCall", callArgs) else {
            return XCTFail("not startCall")
        }
        XCTAssertEqual(data.uuid, "call-uuid")
    }

    func testStartCallWithoutAMapIsIgnored() {
        assertIgnored(command("startCall"), reply: true)
        assertIgnored(command("startCall", 1), reply: true)
    }

    func testEndCall() {
        guard case .endCall(let args) = command("endCall", ["id": "call-uuid"]) else {
            return XCTFail("not endCall")
        }
        XCTAssertEqual(args?["id"] as? String, "call-uuid")
    }

    func testEndCallWithArgumentsThatAreNotAMapHasNoId() {
        guard case .endCall(let args) = command("endCall", "call-uuid") else {
            return XCTFail("not endCall")
        }
        XCTAssertNil(args)
    }

    func testEndCallWithoutArgumentsIsIgnored() {
        assertIgnored(command("endCall"), reply: true)
    }

    func testCallConnected() {
        guard case .callConnected(let args) = command("callConnected", ["id": "call-uuid"]) else {
            return XCTFail("not callConnected")
        }
        XCTAssertEqual(args?["id"] as? String, "call-uuid")
    }

    func testCallConnectedWithArgumentsThatAreNotAMapHasNoId() {
        guard case .callConnected(let args) = command("callConnected", "call-uuid") else {
            return XCTFail("not callConnected")
        }
        XCTAssertNil(args)
    }

    func testCallConnectedWithoutArgumentsIsIgnored() {
        assertIgnored(command("callConnected"), reply: true)
    }

    func testMuteCall() {
        guard
            case .muteCall(let id, let isMuted) = command(
                "muteCall", ["id": "call-uuid", "isMuted": true])
        else {
            return XCTFail("not muteCall")
        }
        XCTAssertEqual(id, "call-uuid")
        XCTAssertTrue(isMuted)
    }

    func testMuteCallWithMissingArgumentsIsIgnored() {
        assertIgnored(command("muteCall"), reply: true)
        assertIgnored(command("muteCall", ["id": "call-uuid"]), reply: true)
        assertIgnored(command("muteCall", ["isMuted": true]), reply: true)
    }

    func testIsMuted() {
        guard case .isMuted(let id) = command("isMuted", ["id": "call-uuid"]) else {
            return XCTFail("not isMuted")
        }
        XCTAssertEqual(id, "call-uuid")
    }

    func testIsMutedWithoutAnIdAnswersFalse() {
        assertIgnored(command("isMuted"), reply: false)
        assertIgnored(command("isMuted", ["id": 1]), reply: false)
    }

    func testHoldCall() {
        guard
            case .holdCall(let id, let onHold) = command(
                "holdCall", ["id": "call-uuid", "isOnHold": true])
        else {
            return XCTFail("not holdCall")
        }
        XCTAssertEqual(id, "call-uuid")
        XCTAssertTrue(onHold)
    }

    func testHoldCallWithMissingArgumentsIsIgnored() {
        assertIgnored(command("holdCall"), reply: true)
        assertIgnored(command("holdCall", ["id": "call-uuid"]), reply: true)
        // The key is `isOnHold`, not `onHold`.
        assertIgnored(command("holdCall", ["id": "call-uuid", "onHold": true]), reply: true)
    }

    func testActiveCallsAndEndAllCalls() {
        guard case .activeCalls = command("activeCalls") else {
            return XCTFail("not activeCalls")
        }
        guard case .endAllCalls = command("endAllCalls") else {
            return XCTFail("not endAllCalls")
        }
    }

    func testSilenceEvents() {
        guard case .silenceEvents(let silence) = command("silenceEvents", true) else {
            return XCTFail("not silenceEvents")
        }
        XCTAssertTrue(silence)
    }

    func testSilenceEventsWithoutABoolIsIgnored() {
        assertIgnored(command("silenceEvents"), reply: true)
        assertIgnored(command("silenceEvents", ["silence": true]), reply: true)
    }

    func testReportCallEnded() {
        guard
            case .reportCallEnded(let id, let reason) = command(
                "reportCallEnded", ["id": "call-uuid", "reason": 3])
        else {
            return XCTFail("not reportCallEnded")
        }
        XCTAssertEqual(id, "call-uuid")
        XCTAssertEqual(reason, 3)
    }

    func testReportCallEndedWithMissingArgumentsIsIgnored() {
        assertIgnored(command("reportCallEnded"), reply: true)
        assertIgnored(command("reportCallEnded", ["id": "call-uuid"]), reply: true)
        assertIgnored(command("reportCallEnded", ["reason": 3]), reply: true)
    }

    // MARK: - Not handled on iOS

    func testAndroidOnlyMethodsAreNotImplemented() {
        for method in ["showMissCallNotification", "requestNotificationPermission"] {
            guard case .notImplemented = command(method) else {
                return XCTFail("\(method) is handled")
            }
        }
    }

    func testAnUnknownMethodIsNotImplemented() {
        guard case .notImplemented = command("somethingNew") else {
            return XCTFail("not notImplemented")
        }
    }

    // MARK: - What the manager answers

    func testTheManagerAnswersAnIgnoredCallWithItsReply() {
        var replies: [Any?] = []
        StreamVideoCallkitManager.shared.handle(.ignored(reply: false)) { replies.append($0) }
        StreamVideoCallkitManager.shared.handle(.ignored(reply: true)) { replies.append($0) }

        XCTAssertEqual(replies.map { $0 as? Bool }, [false, true])
    }

    func testTheManagerLeavesInitDataToThePlugin() {
        var reply: Any?
        StreamVideoCallkitManager.shared.handle(.initData([:])) { reply = $0 }

        XCTAssertTrue((reply as? NSObject) === FlutterMethodNotImplemented)
    }

    func testThePluginAnswersInitDataAndTheVoIPTokenItself() throws {
        let plugin = try XCTUnwrap(StreamVideoPushNotificationPlugin.sharedInstance)

        var initDataReply: Any?
        plugin.handle(FlutterMethodCall(methodName: "initData", arguments: "not a map")) {
            initDataReply = $0
        }
        var tokenReply: Any?
        plugin.handle(FlutterMethodCall(methodName: "getDevicePushTokenVoIP", arguments: nil)) {
            tokenReply = $0
        }

        XCTAssertEqual((initDataReply as? FlutterError)?.code, "INVALID_ARGUMENT")
        XCTAssertNotNil(tokenReply as? String)
    }

    func testSilenceEventsFromDartSilencesTheSink() {
        let sink = StreamVideoCallkitManager.shared.eventSink
        let saved = sink.isSilenced
        defer { sink.isSilenced = saved }

        StreamVideoCallkitManager.shared.handle(.silenceEvents(true)) { _ in }
        XCTAssertTrue(sink.isSilenced)
        StreamVideoCallkitManager.shared.handle(.silenceEvents(false)) { _ in }
        XCTAssertFalse(sink.isSilenced)
    }

    // MARK: - The VoIP token

    /// Runs `body` with empty user defaults of its own and a fresh event sink.
    private func withTokenStore(_ body: (UserDefaults, RingingEventSink) -> Void) {
        let suite = "PushCommandTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        body(defaults, RingingEventSink())
    }

    /// Lets the events `send` queued on the main queue run.
    private func drainMainQueue() {
        let drained = expectation(description: "main queue drained")
        DispatchQueue.main.async { drained.fulfill() }
        wait(for: [drained], timeout: 1)
    }

    private func listen(to sink: RingingEventSink) -> () -> [[String: Any]] {
        var received: [[String: Any]] = []
        let handler = EventCallbackHandler(sink: sink)
        sink.attach(handler)
        _ = handler.onListen(withArguments: nil) { event in
            if let event = event as? [String: Any] { received.append(event) }
        }
        return { received }
    }

    func testAVoIPTokenIsStoredAndSentToDart() {
        withTokenStore { defaults, sink in
            StreamVideoPushNotificationPlugin.setDevicePushTokenVoIP(
                "abc123", in: defaults, notifying: sink)

            XCTAssertEqual(
                StreamVideoPushNotificationPlugin.devicePushTokenVoIP(in: defaults), "abc123")

            // Sent before Dart listens, as when PushKit delivers the token from
            // `didFinishLaunching`: held until it does.
            drainMainQueue()
            let received = listen(to: sink)
            XCTAssertEqual(received().count, 1)
            XCTAssertEqual(
                received().first?["event"] as? String,
                "io.getstream.video.DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP")
            XCTAssertEqual(
                (received().first?["body"] as? [String: Any])?["deviceTokenVoIP"] as? String,
                "abc123")
        }
    }

    func testAnInvalidatedVoIPTokenIsClearedAndSentEmpty() {
        withTokenStore { defaults, sink in
            let received = listen(to: sink)
            StreamVideoPushNotificationPlugin.setDevicePushTokenVoIP(
                "abc123", in: defaults, notifying: sink)
            StreamVideoPushNotificationPlugin.setDevicePushTokenVoIP(
                "", in: defaults, notifying: sink)
            drainMainQueue()

            XCTAssertEqual(StreamVideoPushNotificationPlugin.devicePushTokenVoIP(in: defaults), "")
            XCTAssertEqual(
                received().map { ($0["body"] as? [String: Any])?["deviceTokenVoIP"] as? String },
                ["abc123", ""])
        }
    }
}

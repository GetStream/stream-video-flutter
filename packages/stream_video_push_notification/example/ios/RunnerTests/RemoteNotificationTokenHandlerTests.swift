import Flutter
import XCTest

@testable import stream_video_push_notification

/// Pins when the plugin registers with APNs, and how it stores and reports the token APNs
/// issues.
///
/// Run with the example's other RunnerTests by `melos run test:native:ios`.
final class RemoteNotificationTokenHandlerTests: XCTestCase {

    private var suite: String!
    private var defaults: UserDefaults!
    private var sink: RingingEventSink!
    private var registrations = 0
    private var handler: RemoteNotificationTokenHandler!

    override func setUp() {
        super.setUp()
        suite = "RemoteNotificationTokenHandlerTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suite)
        sink = RingingEventSink()
        registrations = 0
        handler = RemoteNotificationTokenHandler(
            defaults: defaults, sink: sink,
            registerForRemoteNotifications: { [unowned self] in self.registrations += 1 })
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suite)
        super.tearDown()
    }

    /// The events the sink delivers to a Dart listener attached now.
    private func listen() -> () -> [[String: Any]] {
        var received: [[String: Any]] = []
        let eventHandler = EventCallbackHandler(sink: sink)
        sink.attach(eventHandler)
        _ = eventHandler.onListen(withArguments: nil) { event in
            if let event = event as? [String: Any] { received.append(event) }
        }
        return { received }
    }

    /// Lets the events `send` queued on the main queue run.
    private func drainMainQueue() {
        let drained = expectation(description: "main queue drained")
        DispatchQueue.main.async { drained.fulfill() }
        wait(for: [drained], timeout: 1)
    }

    private func bodies(_ events: [[String: Any]]) -> [[String: String]] {
        events.map { ($0["body"] as? [String: String]) ?? [:] }
    }

    // MARK: - Registering

    func testRegistersWhenInitDataAsksForTheAPNsToken() {
        handler.configure(with: ["ios": ["registerApnDeviceToken": true]])

        XCTAssertEqual(registrations, 1)
    }

    func testDoesNotRegisterOtherwise() {
        handler.configure(with: [:])
        handler.configure(with: ["ios": [:]])
        handler.configure(with: ["ios": ["registerApnDeviceToken": false]])
        handler.configure(with: ["ios": ["registerApnDeviceToken": "true"]])
        handler.configure(with: ["registerApnDeviceToken": true])

        XCTAssertEqual(registrations, 0)
    }

    // MARK: - The token

    func testHasNoTokenBeforeAPNsIssuesOne() {
        XCTAssertEqual(handler.token, "")
    }

    func testAnIssuedTokenIsStoredAsUppercaseHexAndSentToDart() {
        // Sent before Dart listens, as when APNs answers during launch: held until it does.
        handler.didRegister(deviceToken: Data([0x0a, 0xbc, 0xff]))
        drainMainQueue()
        let received = listen()

        XCTAssertEqual(handler.token, "0ABCFF")
        XCTAssertEqual(
            received().map { $0["event"] as? String },
            ["io.getstream.video.DID_UPDATE_PUSH_TOKEN"])
        XCTAssertEqual(bodies(received()), [["kind": "apns", "token": "0ABCFF"]])
    }

    func testTheSameTokenAgainIsNotSentAgain() {
        let received = listen()

        // Every plugin registration, one per Flutter engine, forwards the same callback.
        handler.didRegister(deviceToken: Data([0x01]))
        handler.didRegister(deviceToken: Data([0x01]))
        drainMainQueue()

        XCTAssertEqual(bodies(received()), [["kind": "apns", "token": "01"]])
    }

    func testAStoredTokenIsSentAgainByTheNextProcess() {
        // The last launch stored it, and its event may never have reached Dart.
        RemoteNotificationTokenHandler(
            defaults: defaults, sink: RingingEventSink(), registerForRemoteNotifications: {}
        ).didRegister(deviceToken: Data([0x01]))
        let nextLaunch = RemoteNotificationTokenHandler(
            defaults: defaults, sink: sink, registerForRemoteNotifications: {})
        let received = listen()

        nextLaunch.didRegister(deviceToken: Data([0x01]))
        drainMainQueue()

        XCTAssertEqual(bodies(received()), [["kind": "apns", "token": "01"]])
    }

    func testATokenIsStoredWhoeverRegistered() {
        // Registered by the app or another plugin, with `registerApnDeviceToken` off.
        handler.configure(with: [:])
        handler.didRegister(deviceToken: Data([0x01]))

        XCTAssertEqual(registrations, 0)
        XCTAssertEqual(handler.token, "01")
    }

    func testANewTokenReplacesTheStoredOne() {
        let received = listen()

        handler.didRegister(deviceToken: Data([0x01]))
        handler.didRegister(deviceToken: Data([0x02]))
        drainMainQueue()

        XCTAssertEqual(handler.token, "02")
        XCTAssertEqual(bodies(received()).map { $0["token"] }, ["01", "02"])
    }

    func testTheTokenIsKeptAcrossHandlers() {
        handler.didRegister(deviceToken: Data([0x01]))

        let next = RemoteNotificationTokenHandler(
            defaults: defaults, sink: sink, registerForRemoteNotifications: {})

        XCTAssertEqual(next.token, "01")
    }

    func testAFailedRegistrationKeepsTheStoredToken() {
        let received = listen()
        handler.didRegister(deviceToken: Data([0x01]))

        handler.didFailToRegister(error: NSError(domain: "APNs", code: 3000))
        drainMainQueue()

        XCTAssertEqual(handler.token, "01")
        XCTAssertEqual(received().count, 1)
    }

    // MARK: - The plugin

    /// Runs `body` with the shared plugin handing its APNs token to this test's handler.
    private func withPlugin(_ body: (StreamVideoPushNotificationPlugin) -> Void) throws {
        let plugin = try XCTUnwrap(StreamVideoPushNotificationPlugin.sharedInstance)
        let shared = plugin.apnsTokens
        plugin.apnsTokens = handler
        defer { plugin.apnsTokens = shared }
        body(plugin)
    }

    func testGetPushTokenAnswersTheTokenOfEachKind() {
        StreamVideoPushNotificationPlugin.setDevicePushTokenVoIP(
            "voip-token", in: defaults, notifying: sink)
        handler.didRegister(deviceToken: Data([0xab]))

        func token(_ kind: String) -> String {
            StreamVideoPushNotificationPlugin.pushToken(kind: kind, voipIn: defaults, apns: handler)
        }
        XCTAssertEqual(token("apns"), "AB")
        XCTAssertEqual(token("voip"), "voip-token")
        XCTAssertEqual(token("fcm"), "")
    }

    func testThePluginAnswersGetPushTokenForTheKindAsked() throws {
        handler.didRegister(deviceToken: Data([0xab]))

        try withPlugin { plugin in
            var apns: Any?
            plugin.handle(
                FlutterMethodCall(methodName: "getPushToken", arguments: ["kind": "apns"])
            ) { apns = $0 }
            var fcm: Any?
            plugin.handle(
                FlutterMethodCall(methodName: "getPushToken", arguments: ["kind": "fcm"])
            ) { fcm = $0 }

            XCTAssertEqual(apns as? String, "AB")
            XCTAssertEqual(fcm as? String, "")
        }

        var managerReply: Any?
        StreamVideoCallkitManager.shared.handle(.getPushToken(kind: "apns")) { managerReply = $0 }
        XCTAssertTrue((managerReply as? NSObject) === FlutterMethodNotImplemented)
    }

    func testThePluginForwardsTheAppDelegatesToken() throws {
        try withPlugin { plugin in
            plugin.application(
                UIApplication.shared, didRegisterForRemoteNotificationsWithDeviceToken: Data([0x0c]))
            plugin.application(
                UIApplication.shared,
                didFailToRegisterForRemoteNotificationsWithError: NSError(domain: "APNs", code: 1))
        }

        XCTAssertEqual(handler.token, "0C")
    }

    func testFlutterAppDelegateHandsTheTokenToThePlugin() throws {
        // The plugin registered as an application delegate, so Flutter's app delegate forwards
        // the callback iOS makes to it.
        let appDelegate = try XCTUnwrap(UIApplication.shared.delegate as? FlutterAppDelegate)

        try withPlugin { _ in
            appDelegate.application(
                UIApplication.shared, didRegisterForRemoteNotificationsWithDeviceToken: Data([0x0d]))
        }

        XCTAssertEqual(handler.token, "0D")
    }
}

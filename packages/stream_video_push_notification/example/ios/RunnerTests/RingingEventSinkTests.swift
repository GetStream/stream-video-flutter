import Flutter
import XCTest

@testable import stream_video_push_notification

/// Pins the one queue between the native side and Dart: events are held in order until Dart
/// listens on the latest attached handler, then delivered; silenced events are dropped.
final class RingingEventSinkTests: XCTestCase {

    private var sink: RingingEventSink!
    private var received: [[String: Any]] = []

    override func setUp() {
        super.setUp()
        sink = RingingEventSink()
        received = []
    }

    /// `send` hops to the main queue; this waits for everything queued so far to run.
    private func drainMainQueue() {
        let drained = expectation(description: "main queue drained")
        DispatchQueue.main.async { drained.fulfill() }
        wait(for: [drained], timeout: 1)
    }

    private func handler() -> EventCallbackHandler {
        EventCallbackHandler(sink: sink)
    }

    private func listen(on handler: EventCallbackHandler, into events: @escaping ([String: Any]) -> Void) {
        _ = handler.onListen(withArguments: nil) { event in
            if let event = event as? [String: Any] {
                events(event)
            }
        }
    }

    private func listen(on handler: EventCallbackHandler) {
        listen(on: handler) { [weak self] in self?.received.append($0) }
    }

    private var receivedNames: [String?] {
        received.map { $0["event"] as? String }
    }

    func testEventsSentBeforeAnyHandlerAreDeliveredInOrderOnceOneListens() {
        sink.send("first", ["id": "1"])
        sink.send("second", ["id": "2"])
        drainMainQueue()

        let handler = handler()
        sink.attach(handler)
        listen(on: handler)

        XCTAssertEqual(receivedNames, ["first", "second"])
        XCTAssertEqual((received[0]["body"] as? [String: Any])?["id"] as? String, "1")
    }

    func testEventsSentBeforeListenAreDeliveredWhenAnAttachedHandlerListens() {
        let handler = handler()
        sink.attach(handler)
        sink.send("first", [:])
        drainMainQueue()
        XCTAssertTrue(received.isEmpty)

        listen(on: handler)

        XCTAssertEqual(receivedNames, ["first"])
    }

    func testAttachingAHandlerThatAlreadyListensDeliversTheHeldEvents() {
        sink.send("first", [:])
        drainMainQueue()
        let handler = handler()
        listen(on: handler)
        XCTAssertTrue(received.isEmpty)

        sink.attach(handler)

        XCTAssertEqual(receivedNames, ["first"])
    }

    func testEventsSentWhileListeningAreDeliveredDirectly() {
        let handler = handler()
        sink.attach(handler)
        listen(on: handler)

        sink.send("live", [:])
        drainMainQueue()

        XCTAssertEqual(receivedNames, ["live"])
    }

    func testDeliveredEventsAreNotDeliveredAgainToALaterListener() {
        let handler = handler()
        sink.attach(handler)
        sink.send("first", [:])
        drainMainQueue()
        listen(on: handler)
        XCTAssertEqual(received.count, 1)

        received = []
        listen(on: handler)

        XCTAssertTrue(received.isEmpty)
    }

    func testEventsAfterCancelAreHeldForTheNextListener() {
        let handler = handler()
        sink.attach(handler)
        listen(on: handler)
        _ = handler.onCancel(withArguments: nil)

        sink.send("while cancelled", [:])
        drainMainQueue()
        XCTAssertTrue(received.isEmpty)

        listen(on: handler)
        XCTAssertEqual(receivedNames, ["while cancelled"])
    }

    func testOnlyTheLatestAttachedHandlerReceivesEvents() {
        let older = handler()
        sink.attach(older)
        var olderReceived: [[String: Any]] = []
        listen(on: older) { olderReceived.append($0) }
        let latest = handler()
        sink.attach(latest)

        sink.send("event", [:])
        drainMainQueue()
        XCTAssertTrue(olderReceived.isEmpty)

        listen(on: latest)
        XCTAssertEqual(receivedNames, ["event"])
        XCTAssertTrue(olderReceived.isEmpty)
    }

    func testSilencedEventsAreDroppedRatherThanHeld() {
        let handler = handler()
        sink.attach(handler)
        sink.isSilenced = true
        sink.send("dropped", [:])
        drainMainQueue()

        sink.isSilenced = false
        listen(on: handler)
        sink.send("kept", [:])
        drainMainQueue()

        XCTAssertEqual(receivedNames, ["kept"])
    }

    func testAnEventSentJustBeforeSilencingIsDropped() {
        let handler = handler()
        sink.attach(handler)
        listen(on: handler)
        drainMainQueue()

        sink.send("sent before silencing", [:])
        sink.isSilenced = true
        drainMainQueue()

        XCTAssertTrue(received.isEmpty)
    }

    func testSilencingKeepsEventsThatAreAlreadyHeld() {
        let handler = handler()
        sink.attach(handler)
        sink.send("held", [:])
        drainMainQueue()

        sink.isSilenced = true
        sink.send("dropped", [:])
        listen(on: handler)
        drainMainQueue()

        XCTAssertEqual(receivedNames, ["held"])
    }

    func testEventsHeldWhenANewHandlerIsAttachedGoToTheNewHandler() {
        let older = handler()
        sink.attach(older)
        sink.send("held", [:])
        drainMainQueue()
        let latest = handler()
        sink.attach(latest)

        var olderReceived: [[String: Any]] = []
        listen(on: older) { olderReceived.append($0) }
        XCTAssertTrue(olderReceived.isEmpty)

        listen(on: latest)
        XCTAssertEqual(receivedNames, ["held"])
    }

    func testEventsSentFromOtherQueuesKeepTheirOrder() {
        let handler = handler()
        sink.attach(handler)
        listen(on: handler)
        let sent = expectation(description: "sent from a background queue")

        DispatchQueue.global().async {
            for index in 0..<50 {
                self.sink.send("event \(index)", [:])
            }
            sent.fulfill()
        }
        wait(for: [sent], timeout: 1)
        drainMainQueue()

        XCTAssertEqual(receivedNames, (0..<50).map { "event \($0)" })
    }

    func testAHandlerSendsToTheAttachedHandlerNotToItself() {
        let attached = handler()
        sink.attach(attached)
        listen(on: attached)
        let notAttached = handler()
        var notAttachedReceived: [[String: Any]] = []
        listen(on: notAttached) { notAttachedReceived.append($0) }

        notAttached.send("from the other handler", ["id": "1"])
        drainMainQueue()

        XCTAssertEqual(receivedNames, ["from the other handler"])
        XCTAssertTrue(notAttachedReceived.isEmpty)
    }
}

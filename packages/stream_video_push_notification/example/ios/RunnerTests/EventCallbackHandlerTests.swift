import XCTest

@testable import stream_video_push_notification

/// Pins that events sent before Dart listens on the event channel are queued and delivered in
/// order once it does: a VoIP push on a cold start reports to CallKit, and the
/// user can answer, before the Flutter side has registered its listener.
final class EventCallbackHandlerTests: XCTestCase {

    private var handler: EventCallbackHandler!
    private var received: [[String: Any]] = []

    override func setUp() {
        super.setUp()
        handler = EventCallbackHandler()
        received = []
    }

    /// `send` hops to the main queue; this waits for everything queued so far to run.
    private func drainMainQueue() {
        let drained = expectation(description: "main queue drained")
        DispatchQueue.main.async { drained.fulfill() }
        wait(for: [drained], timeout: 1)
    }

    private func listen() {
        _ = handler.onListen(withArguments: nil) { [weak self] event in
            if let event = event as? [String: Any] {
                self?.received.append(event)
            }
        }
    }

    func testEventsSentBeforeListenAreDeliveredInOrderOnListen() {
        handler.send("first", ["id": "1"])
        handler.send("second", ["id": "2"])
        drainMainQueue()
        XCTAssertTrue(received.isEmpty)

        listen()

        XCTAssertEqual(received.map { $0["event"] as? String }, ["first", "second"])
        XCTAssertEqual((received[0]["body"] as? [String: Any])?["id"] as? String, "1")
    }

    func testEventsSentAfterListenAreDeliveredDirectly() {
        listen()

        handler.send("live", ["id": "3"])
        drainMainQueue()

        XCTAssertEqual(received.map { $0["event"] as? String }, ["live"])
    }

    func testTheQueueIsEmptiedByTheFirstListener() {
        handler.send("first", [:])
        drainMainQueue()
        listen()
        XCTAssertEqual(received.count, 1)

        // A second listener does not get the already-flushed events again.
        received = []
        listen()
        XCTAssertTrue(received.isEmpty)
    }

    func testEventsAfterCancelAreQueuedForTheNextListener() {
        listen()
        _ = handler.onCancel(withArguments: nil)

        handler.send("while cancelled", [:])
        drainMainQueue()
        XCTAssertTrue(received.isEmpty)

        listen()
        XCTAssertEqual(received.map { $0["event"] as? String }, ["while cancelled"])
    }
}

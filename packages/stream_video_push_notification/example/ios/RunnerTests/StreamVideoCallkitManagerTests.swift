import CallKit
import Flutter
import XCTest

@testable import stream_video_push_notification

/// Pins the manager's own event path: events sent before an `EventCallbackHandler` is set are
/// queued and flushed in order, `silenceEvents` drops them, and which event the CallKit end
/// action sends for each kind of call.
final class StreamVideoCallkitManagerTests: XCTestCase {

    private let manager = StreamVideoCallkitManager.shared
    private let provider = CXProvider(configuration: CXProviderConfiguration())

    private var savedEventHandler: EventCallbackHandler?
    private var savedAnswerCall: Call?
    private var savedOutgoingCall: Call?
    private var savedData: CallData?
    private var savedSilenceEvents = false
    private var trackedCalls: [Call] = []
    private var received: [[String: Any]] = []

    override func setUp() {
        super.setUp()
        // The manager is a singleton the host app also uses, so its state is saved and restored.
        savedEventHandler = manager.eventHandler
        savedAnswerCall = manager.answerCall
        savedOutgoingCall = manager.outgoingCall
        savedData = manager.data
        savedSilenceEvents = manager.silenceEvents

        manager.eventHandler = nil
        manager.pendingEvents = []
        manager.answerCall = nil
        manager.outgoingCall = nil
        manager.data = nil
        manager.silenceEvents = false
        received = []
    }

    override func tearDown() {
        trackedCalls.forEach { manager.callController.removeCall($0) }
        trackedCalls = []
        manager.pendingEvents = []
        manager.eventHandler = savedEventHandler
        manager.answerCall = savedAnswerCall
        manager.outgoingCall = savedOutgoingCall
        manager.data = savedData
        manager.silenceEvents = savedSilenceEvents
        super.tearDown()
    }

    /// Sets a handler that already has a listener, so every event it gets is recorded.
    private func listen() {
        let handler = EventCallbackHandler()
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

    private func track(id: String) -> Call {
        let call = Call(uuid: UUID(), data: CallData(args: ["id": id]))
        manager.callController.addCall(call)
        trackedCalls.append(call)
        return call
    }

    private func end(_ uuid: UUID) {
        manager.provider(provider, perform: CXEndCallAction(call: uuid))
        drainMainQueue()
    }

    // MARK: - Pending events

    func testEventsSentBeforeAHandlerIsSetAreFlushedInOrder() {
        manager.sendEventCustom("first", body: ["id": "1"])
        manager.sendEventCustom("second", body: nil)
        XCTAssertEqual(manager.pendingEvents.map { $0.event }, ["first", "second"])

        listen()
        drainMainQueue()

        XCTAssertEqual(receivedNames, ["first", "second"])
        XCTAssertEqual(receivedId(at: 0), "1")
        XCTAssertTrue(manager.pendingEvents.isEmpty)
    }

    func testEventsSentAfterAHandlerIsSetAreNotQueued() {
        listen()

        manager.sendEventCustom("live", body: nil)
        drainMainQueue()

        XCTAssertEqual(receivedNames, ["live"])
        XCTAssertTrue(manager.pendingEvents.isEmpty)
    }

    func testSilencedEventsAreDroppedRatherThanQueued() {
        manager.handle(FlutterMethodCall(methodName: "silenceEvents", arguments: true)) { _ in }
        manager.sendEventCustom("dropped", body: nil)
        XCTAssertTrue(manager.pendingEvents.isEmpty)

        listen()
        manager.handle(FlutterMethodCall(methodName: "silenceEvents", arguments: false)) { _ in }
        manager.sendEventCustom("kept", body: nil)
        drainMainQueue()

        XCTAssertEqual(receivedNames, ["kept"])
    }

    // MARK: - CXEndCallAction

    func testEndingAnUntrackedCallWithNoActiveCallSendsTimeout() {
        listen()
        manager.data = CallData(args: ["id": "last-shown"])

        end(UUID())

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT])
        XCTAssertEqual(receivedId(at: 0), "last-shown")
    }

    func testEndingAnUntrackedCallWhileAnotherIsAnsweredSendsEnded() {
        listen()
        manager.answerCall = Call(uuid: UUID(), data: CallData(args: ["id": "answered"]))

        end(UUID())

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
    }

    func testEndingATrackedUnansweredCallSendsDeclineAndRemovesIt() {
        listen()
        let call = track(id: "ringing")
        manager.data = call.data

        end(call.uuid)

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_DECLINE])
        XCTAssertEqual(receivedId(at: 0), "ringing")
        XCTAssertTrue(call.hasEnded)
        XCTAssertNil(manager.callController.callWithUUID(uuid: call.uuid))
    }

    func testEndingTheAnsweredCallSendsEndedWithItsOwnDataAndClearsIt() {
        listen()
        let call = track(id: "answered")
        manager.answerCall = call
        manager.data = CallData(args: ["id": "last-shown"])

        end(call.uuid)

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertEqual(receivedId(at: 0), "answered")
        XCTAssertNil(manager.answerCall)
        XCTAssertNil(manager.callController.callWithUUID(uuid: call.uuid))
    }

    func testEndingATrackedCallWhileAnOutgoingCallExistsSendsEndedAndKeepsTheOutgoingCall() {
        listen()
        let outgoing = Call(
            uuid: UUID(), data: CallData(args: ["id": "outgoing"]), isOutGoing: true)
        manager.outgoingCall = outgoing
        let call = track(id: "other")

        end(call.uuid)

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertTrue(manager.outgoingCall === outgoing)
    }

    /// Current behaviour, pinned: declining a second ringing call during an answered one is sent
    /// as ENDED and forgets the answered call, so hanging that one up later is sent as DECLINE
    /// with the second call's data, and the answered call's end never reaches Dart as its own.
    func testDecliningASecondCallDuringAnAnsweredOneForgetsTheAnsweredCall() {
        listen()
        let answered = track(id: "answered")
        manager.answerCall = answered
        let ringing = track(id: "ringing")
        manager.data = ringing.data

        end(ringing.uuid)

        XCTAssertEqual(receivedNames, [StreamVideoIncomingCallConstants.ACTION_CALL_ENDED])
        XCTAssertEqual(receivedId(at: 0), "ringing")
        XCTAssertNil(manager.answerCall)

        end(answered.uuid)

        XCTAssertEqual(
            receivedNames,
            [
                StreamVideoIncomingCallConstants.ACTION_CALL_ENDED,
                StreamVideoIncomingCallConstants.ACTION_CALL_DECLINE,
            ])
        XCTAssertEqual(receivedId(at: 1), "ringing")
        XCTAssertNil(manager.callController.callWithUUID(uuid: answered.uuid))
    }
}

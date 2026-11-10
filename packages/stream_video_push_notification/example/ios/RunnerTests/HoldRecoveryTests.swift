import Foundation
import UIKit
import XCTest

@testable import stream_video_push_notification

/// Runs scheduled work only when the test moves time on.
final class FakeHoldRecoveryScheduler: HoldRecoveryScheduler {

    private final class Timer: HoldRecoveryTimer {
        var isCancelled = false
        func cancel() { isCancelled = true }
    }

    private var pending: [(at: TimeInterval, timer: Timer, work: () -> Void)] = []
    private var now: TimeInterval = 0

    func schedule(after delay: TimeInterval, _ work: @escaping () -> Void) -> HoldRecoveryTimer {
        let timer = Timer()
        pending.append((now + delay, timer, work))
        return timer
    }

    /// Runs, in time order, the work that falls due within `interval`.
    func advance(by interval: TimeInterval) {
        let end = now + interval + 0.000_001
        while let index = pending.indices.filter({ pending[$0].at <= end })
            .min(by: { pending[$0].at < pending[$1].at })
        {
            let next = pending.remove(at: index)
            now = max(now, next.at)
            if !next.timer.isCancelled {
                next.work()
            }
        }
        now = end
    }
}

/// The device's calls, as the test sets them.
final class FakeSystemCallObserver: SystemCallObserver {
    var calls: [SystemCall] = []
    var onCallChanged: ((SystemCall) -> Void)?

    func add(_ uuid: UUID) {
        set(SystemCall(uuid: uuid, hasEnded: false))
    }

    func end(_ uuid: UUID) {
        set(SystemCall(uuid: uuid, hasEnded: true))
    }

    private func set(_ call: SystemCall) {
        calls.removeAll { $0.uuid == call.uuid }
        calls.append(call)
        onCallChanged?(call)
    }
}

/// Records what hold recovery asks of CallKit, and answers when the test says.
final class FakeHoldRecoveryActions: HoldRecoveryActions {
    private(set) var unholds: [UUID] = []
    private(set) var unholdCompletions: [(Bool) -> Void] = []
    private(set) var ended: [UUID] = []
    private(set) var starts: [UUID] = []
    private(set) var startCompletions: [(Bool) -> Void] = []
    private(set) var abandoned: [CallKitCall] = []

    func requestUnhold(_ uuid: UUID, completion: @escaping (Bool) -> Void) {
        unholds.append(uuid)
        unholdCompletions.append(completion)
    }

    func endForReRegistration(_ call: CallKitCall) {
        ended.append(call.identity.callKitUUID)
    }

    func startReRegistration(
        _ call: CallKitCall, as uuid: UUID, completion: @escaping (Bool) -> Void
    ) {
        starts.append(uuid)
        startCompletions.append(completion)
    }

    func reRegistrationAbandoned(_ call: CallKitCall) {
        abandoned.append(call)
    }
}

/// Pins how a call held for another app's call gets its audio back, as R13 (the user ends the
/// other call) and R14 (the other side ends it) sequences, without CallKit.
final class HoldRecoveryTests: XCTestCase {

    private var store: CallKitCallStore!
    private var observer: FakeSystemCallObserver!
    private var scheduler: FakeHoldRecoveryScheduler!
    private var actions: FakeHoldRecoveryActions!
    private var center: NotificationCenter!
    private var isAppActive = true
    private var recovery: HoldRecovery!
    private var call: CallKitCall!
    private let otherCall = UUID()

    override func setUp() {
        super.setUp()
        store = CallKitCallStore()
        observer = FakeSystemCallObserver()
        scheduler = FakeHoldRecoveryScheduler()
        actions = FakeHoldRecoveryActions()
        center = NotificationCenter()
        isAppActive = true
        recovery = HoldRecovery(
            store: { [unowned self] in self.store }, observer: observer, scheduler: scheduler,
            isAppActive: { [unowned self] in self.isAppActive }, notificationCenter: center)
        recovery.actions = actions

        let uuid = UUID()
        _ = store.incomingReported(
            CallData(args: ["id": uuid.uuidString]), uuid: uuid, source: .pushKit)
        _ = store.answerPerformed(uuid: uuid)
        call = store.call(forCallKit: uuid)
        observer.add(uuid)
        _ = store.audioActivated()
        activate()
    }

    // MARK: - Steps

    /// CallKit holds the call, with the origin hold recovery gives it.
    private func hold() {
        let uuid = call.identity.callKitUUID
        _ = store.holdPerformed(uuid: uuid, onHold: true, origin: recovery.holdOrigin(for: uuid))
    }

    /// Another app's call arrives and CallKit holds this one for it.
    private func holdForOtherCall() {
        observer.add(otherCall)
        hold()
    }

    /// CallKit takes the call off hold.
    private func resume() {
        guard case .held(let origin) = call.phase else {
            return XCTFail("the call is not on hold")
        }
        _ = store.holdPerformed(uuid: call.identity.callKitUUID, onHold: false)
        recovery.callResumed(call, heldFor: origin)
    }

    /// CallKit activates the audio session.
    private func activate() {
        store.audioSessionActivated()
        recovery.audioActivated()
    }

    private func appBecomesActive() {
        isAppActive = true
        center.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        let drained = expectation(description: "main queue drained")
        DispatchQueue.main.async { drained.fulfill() }
        wait(for: [drained], timeout: 1)
    }

    /// CallKit performs the start action of the last re-registration.
    private func performLastStart() {
        let uuid = actions.starts.last!
        actions.startCompletions.last!(true)
        XCTAssertTrue(store.reRegistrationPerformed(uuid: uuid) === call)
    }

    // MARK: - Hold origin

    func testAHoldIsForAnotherCallOnlyWhileAnotherAppsCallIsOngoing() {
        let uuid = call.identity.callKitUUID
        XCTAssertEqual(
            recovery.holdOrigin(for: uuid), .requested, "the call's own uuid does not count")

        observer.add(otherCall)
        XCTAssertEqual(recovery.holdOrigin(for: uuid), .otherCall)

        observer.end(otherCall)
        XCTAssertEqual(recovery.holdOrigin(for: uuid), .requested)
    }

    func testAHoldTheAppAskedForIsNotForAnotherCall() {
        let uuid = call.identity.callKitUUID
        observer.add(otherCall)

        recovery.holdRequested(uuid)

        XCTAssertEqual(recovery.holdOrigin(for: uuid), .requested)
        XCTAssertEqual(recovery.holdOrigin(for: uuid), .otherCall, "the request is used once")
    }

    // MARK: - Taking the call off hold

    func testTheCallIsTakenOffHoldOnceTheOtherCallEnds() {
        holdForOtherCall()
        XCTAssertEqual(call.phase, .held(.otherCall))

        observer.end(otherCall)
        scheduler.advance(by: HoldRecovery.unholdDelay / 2)
        XCTAssertEqual(actions.unholds, [])

        scheduler.advance(by: HoldRecovery.unholdDelay / 2)
        XCTAssertEqual(actions.unholds, [call.identity.callKitUUID])

        appBecomesActive()
        scheduler.advance(by: HoldRecovery.unholdDelay)
        XCTAssertEqual(actions.unholds.count, 1, "an unhold is requested once")
    }

    func testTheCallStaysHeldWhileAnotherCallIsLeft() {
        holdForOtherCall()
        let thirdCall = UUID()
        observer.add(thirdCall)

        observer.end(otherCall)
        scheduler.advance(by: HoldRecovery.unholdDelay)

        XCTAssertEqual(actions.unholds, [])
    }

    func testACallHeldOnRequestStaysHeld() {
        hold()
        XCTAssertEqual(call.phase, .held(.requested))

        observer.add(otherCall)
        observer.end(otherCall)
        appBecomesActive()
        scheduler.advance(by: HoldRecovery.unholdDelay)

        XCTAssertEqual(actions.unholds, [])
    }

    func testTheAppBecomingActiveTakesTheCallOffHold() {
        holdForOtherCall()
        // The other call ended while the change was not seen.
        observer.calls = [SystemCall(uuid: otherCall, hasEnded: true)]

        appBecomesActive()
        scheduler.advance(by: HoldRecovery.unholdDelay)

        XCTAssertEqual(actions.unholds, [call.identity.callKitUUID])
    }

    func testARefusedUnholdIsRequestedAgainNextTime() {
        holdForOtherCall()
        observer.end(otherCall)
        scheduler.advance(by: HoldRecovery.unholdDelay)
        actions.unholdCompletions[0](false)

        appBecomesActive()
        scheduler.advance(by: HoldRecovery.unholdDelay)

        XCTAssertEqual(actions.unholds.count, 2)
    }

    // MARK: - Registering again

    func testAResumeWithNoActivationRegistersTheCallAgain() {
        // R14: CallKit takes the call off hold but never activates the session.
        holdForOtherCall()
        observer.end(otherCall)
        let firstUUID = call.identity.callKitUUID
        resume()
        XCTAssertEqual(call.phase, .resumed(activated: false))

        scheduler.advance(by: HoldRecovery.activationWait)

        XCTAssertEqual(actions.ended, [firstUUID])
        XCTAssertEqual(actions.starts.count, 1)
        let newUUID = actions.starts[0]
        XCTAssertEqual(call.phase, .reRegistering(as: newUUID, attempt: 0))
        XCTAssertTrue(store.isTracked(callKitUUID: newUUID))

        performLastStart()
        XCTAssertEqual(call.identity.callKitUUID, newUUID)
        XCTAssertEqual(call.identity.reportedId, firstUUID.uuidString, "Dart keeps its id")
        XCTAssertEqual(call.phase, .resumed(activated: false))

        activate()
        XCTAssertEqual(call.phase, .resumed(activated: true))
    }

    func testAResumeAfterAHoldOnRequestIsNotWatched() {
        hold()
        resume()

        scheduler.advance(by: HoldRecovery.activationWait)

        XCTAssertEqual(actions.starts, [])
        XCTAssertEqual(call.phase, .resumed(activated: false))
    }

    func testACallStartedAgainWithNoActivationIsStartedAgain() {
        holdForOtherCall()
        resume()
        scheduler.advance(by: HoldRecovery.activationWait)
        performLastStart()

        recovery.reRegistrationStarted(call)
        scheduler.advance(by: HoldRecovery.activationWait)

        XCTAssertEqual(actions.starts.count, 2)
    }

    func testAResumeWithAnActivationNeedsNothing() {
        holdForOtherCall()
        resume()
        activate()

        scheduler.advance(by: HoldRecovery.activationWait)

        XCTAssertEqual(actions.starts, [])
        XCTAssertEqual(call.phase, .resumed(activated: true))
    }

    func testAnEngineFailureAfterAResumeRegistersTheCallAgain() {
        // R13 in the foreground: CallKit activates, but the engine cannot start.
        holdForOtherCall()
        resume()
        activate()

        recovery.audioEngineStartFailed()

        XCTAssertEqual(actions.starts.count, 1)
    }

    func testInTheBackgroundTheCallIsRegisteredAgainOnceTheAppIsActive() {
        // R13: the user ends the other call from the lock screen.
        holdForOtherCall()
        isAppActive = false
        resume()
        activate()

        recovery.audioEngineStartFailed()
        XCTAssertEqual(actions.starts, [])

        appBecomesActive()
        XCTAssertEqual(actions.starts.count, 1)
    }

    func testAnEngineFailureOnACallNeverHeldDoesNothing() {
        recovery.audioEngineStartFailed()

        XCTAssertEqual(actions.starts, [])
        XCTAssertEqual(call.phase, .active)
    }

    func testARefusedStartIsRetriedWithBackoffThenTheCallIsEnded() {
        holdForOtherCall()
        resume()
        scheduler.advance(by: HoldRecovery.activationWait)
        let newUUID = actions.starts[0]

        for (attempt, delay) in HoldRecovery.retryDelays.enumerated() {
            actions.startCompletions.last!(false)
            scheduler.advance(by: delay / 2)
            XCTAssertEqual(actions.starts.count, attempt + 1, "not before \(delay) s")
            scheduler.advance(by: delay / 2)
            XCTAssertEqual(actions.starts, Array(repeating: newUUID, count: attempt + 2))
            XCTAssertEqual(call.phase, .reRegistering(as: newUUID, attempt: attempt + 1))
        }
        XCTAssertEqual(actions.abandoned.count, 0)

        actions.startCompletions.last!(false)
        XCTAssertTrue(actions.abandoned.first === call)
    }

    func testACallIsRegisteredAgainAFewTimesPerHold() {
        holdForOtherCall()
        resume()
        for _ in 0..<HoldRecovery.maxReRegistrationsPerHold {
            recovery.audioEngineStartFailed()
            performLastStart()
        }
        recovery.audioEngineStartFailed()
        XCTAssertEqual(actions.starts.count, HoldRecovery.maxReRegistrationsPerHold)

        hold()
        resume()
        recovery.audioEngineStartFailed()
        XCTAssertEqual(actions.starts.count, HoldRecovery.maxReRegistrationsPerHold + 1)
    }
}

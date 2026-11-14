import Foundation
import UIKit

/// Runs work after a delay.
protocol HoldRecoveryScheduler {
    @discardableResult
    func schedule(after delay: TimeInterval, _ work: @escaping () -> Void) -> HoldRecoveryTimer
}

/// Work a scheduler will run, until cancelled.
protocol HoldRecoveryTimer {
    func cancel()
}

/// Schedules on the main queue.
final class MainQueueHoldRecoveryScheduler: HoldRecoveryScheduler {

    private final class Timer: HoldRecoveryTimer {
        let item: DispatchWorkItem
        init(_ item: DispatchWorkItem) { self.item = item }
        func cancel() { item.cancel() }
    }

    func schedule(after delay: TimeInterval, _ work: @escaping () -> Void) -> HoldRecoveryTimer {
        let item = DispatchWorkItem(block: work)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: item)
        return Timer(item)
    }
}

/// What hold recovery asks of CallKit.
protocol HoldRecoveryActions: AnyObject {
    /// Asks CallKit to take the call it knows as `uuid` off hold.
    func requestUnhold(_ uuid: UUID, completion: @escaping (Bool) -> Void)
    /// Reports `call` to CallKit as ended, ahead of starting it again.
    func endForReRegistration(_ call: CallKitCall)
    /// Asks CallKit to start `call` as `uuid`.
    func startReRegistration(
        _ call: CallKitCall, as uuid: UUID, completion: @escaping (Bool) -> Void)
    /// CallKit refused every attempt to start `call` again.
    func reRegistrationAbandoned(_ call: CallKitCall)
    /// Asks CallKit to mute the call it knows as `uuid`.
    func requestMute(_ uuid: UUID)
}

/// Brings a call's audio back after another app's call held it.
///
/// When the other call ends, CallKit takes the held call off hold only if the user ended it on
/// this device; this asks CallKit to do it otherwise. After the call is off hold, CallKit may not
/// hand its audio session back in a usable state: either no activation comes, or the audio engine
/// cannot start on the one that does. Then the call is reported to CallKit as ended and started
/// again under a new uuid, keeping its app id, which makes CallKit activate a new session.
final class HoldRecovery {

    /// How long an activation is waited for after a call comes off hold.
    static let activationWait: TimeInterval = 1.0
    /// How long after another call ends the held call is taken off hold.
    static let unholdDelay: TimeInterval = 0.5
    /// The delays before each new request when CallKit refuses to start a call again.
    static let retryDelays: [TimeInterval] = [0.5, 1, 2]
    /// How many times a call is registered again before it is next put on hold.
    static let maxReRegistrationsPerHold = 3

    weak var actions: HoldRecoveryActions?

    private let store: () -> CallKitCallStore
    private let observer: SystemCallObserver
    private let scheduler: HoldRecoveryScheduler
    private let isAppActive: () -> Bool
    private let notificationCenter: NotificationCenter
    private var didBecomeActiveObserver: NSObjectProtocol?

    private var activationTimer: HoldRecoveryTimer?
    private var unholdTimer: HoldRecoveryTimer?
    /// The calls an unhold was requested for and not answered yet, by CallKit uuid.
    private var requestedUnholds: Set<UUID> = []
    /// The calls the app asked CallKit to hold, by CallKit uuid.
    private var appRequestedHolds: Set<UUID> = []
    /// The call registered again once the app becomes active, if it is still the live call.
    private weak var pendingReRegistration: CallKitCall?

    init(
        store: @escaping () -> CallKitCallStore,
        observer: SystemCallObserver = CXSystemCallObserver(),
        scheduler: HoldRecoveryScheduler = MainQueueHoldRecoveryScheduler(),
        isAppActive: @escaping () -> Bool = { UIApplication.shared.applicationState == .active },
        notificationCenter: NotificationCenter = .default
    ) {
        self.store = store
        self.observer = observer
        self.scheduler = scheduler
        self.isAppActive = isAppActive
        self.notificationCenter = notificationCenter
        observer.onCallChanged = { [weak self] call in
            self?.systemCallChanged(call)
        }
        didBecomeActiveObserver = notificationCenter.addObserver(
            forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main
        ) { [weak self] _ in
            self?.appBecameActive()
        }
    }

    deinit {
        if let didBecomeActiveObserver = didBecomeActiveObserver {
            notificationCenter.removeObserver(didBecomeActiveObserver)
        }
    }

    /// The app asked CallKit to hold the call it knows as `uuid`.
    func holdRequested(_ uuid: UUID) {
        appRequestedHolds.insert(uuid)
    }

    /// CallKit refused the hold the app asked for the call it knows as `uuid`.
    func holdRefused(_ uuid: UUID) {
        appRequestedHolds.remove(uuid)
    }

    /// Why CallKit is holding the call it knows as `uuid` now: as the app asked, else for
    /// another app's call when one is on the device.
    func holdOrigin(for uuid: UUID) -> CallKitHoldOrigin {
        if appRequestedHolds.remove(uuid) != nil {
            return .requested
        }
        return otherCalls.isEmpty ? .requested : .otherCall
    }

    // MARK: - Events

    /// CallKit took `call` off hold. After a hold for another call, waits for an activation.
    func callResumed(_ call: CallKitCall, heldFor origin: CallKitHoldOrigin) {
        requestedUnholds.remove(call.identity.callKitUUID)
        if origin == .otherCall {
            awaitActivation(of: call)
        }
    }

    /// CallKit started `call` again under its new uuid. Waits for an activation, and mutes the
    /// new registration when the user had muted the call, since CallKit starts it unmuted.
    func reRegistrationStarted(_ call: CallKitCall) {
        if call.isMuted {
            actions?.requestMute(call.identity.callKitUUID)
        }
        awaitActivation(of: call)
    }

    private func awaitActivation(of call: CallKitCall) {
        activationTimer?.cancel()
        activationTimer = scheduler.schedule(after: Self.activationWait) { [weak self, weak call] in
            guard let self = self, let call = call else { return }
            self.activationTimer = nil
            if call.phase == .resumed(activated: false) {
                NSLog("[StreamCallKit] no audio session activation for \(call.identity.appId)")
                self.reRegister(call)
            }
        }
    }

    /// CallKit activated the audio session.
    func audioActivated() {
        activationTimer?.cancel()
        activationTimer = nil
    }

    /// WebRTC could not start the audio engine on the session CallKit activated.
    func audioEngineStartFailed() {
        guard let call = store().liveCall, call.phase.isResumed else { return }
        NSLog("[StreamCallKit] the audio engine did not start after \(call.identity.appId) came off hold")
        reRegister(call)
    }

    private func appBecameActive() {
        if let call = pendingReRegistration {
            pendingReRegistration = nil
            if store().liveCall === call {
                reRegister(call)
            }
        }
        scheduleUnhold()
    }

    private func systemCallChanged(_ call: SystemCall) {
        if call.hasEnded && !store().isTracked(callKitUUID: call.uuid) {
            scheduleUnhold()
        }
    }

    // MARK: - Unhold

    /// Ongoing calls the store does not track.
    private var otherCalls: [SystemCall] {
        let store = self.store()
        return observer.calls.filter { !$0.hasEnded && !store.isTracked(callKitUUID: $0.uuid) }
    }

    private func scheduleUnhold() {
        unholdTimer?.cancel()
        unholdTimer = scheduler.schedule(after: Self.unholdDelay) { [weak self] in
            self?.unholdTimer = nil
            self?.unholdIfAlone()
        }
    }

    /// Takes the calls held for another call off hold once no other call is left.
    private func unholdIfAlone() {
        guard otherCalls.isEmpty else { return }
        for call in store().calls where call.phase == .held(.otherCall) {
            let uuid = call.identity.callKitUUID
            guard !requestedUnholds.contains(uuid) else { continue }
            requestedUnholds.insert(uuid)
            NSLog("[StreamCallKit] taking \(call.identity.appId) off hold: the other call ended")
            actions?.requestUnhold(uuid) { [weak self] accepted in
                if !accepted {
                    self?.requestedUnholds.remove(uuid)
                }
            }
        }
    }

    // MARK: - Registering again

    /// Registers `call` with CallKit again now in the foreground, or once the app becomes active.
    private func reRegister(_ call: CallKitCall) {
        guard call.phase.isResumed else { return }
        guard call.reRegistrationsSinceHold < Self.maxReRegistrationsPerHold else {
            NSLog("[StreamCallKit] \(call.identity.appId) was registered again too often; not again")
            return
        }
        guard isAppActive() else {
            pendingReRegistration = call
            return
        }
        let uuid = UUID()
        NSLog("[StreamCallKit] registering \(call.identity.appId) with CallKit again as \(uuid)")
        actions?.endForReRegistration(call)
        store().reRegistrationRequested(call, as: uuid)
        requestStart(call, as: uuid, attempt: 0)
    }

    private func requestStart(_ call: CallKitCall, as uuid: UUID, attempt: Int) {
        actions?.startReRegistration(call, as: uuid) { [weak self] started in
            guard let self = self, !started, self.store().call(reRegisteringAs: uuid) === call
            else { return }
            guard attempt < Self.retryDelays.count else {
                NSLog("[StreamCallKit] CallKit refused to start \(call.identity.appId) again; ending it")
                self.actions?.reRegistrationAbandoned(call)
                return
            }
            self.scheduler.schedule(after: Self.retryDelays[attempt]) { [weak self] in
                guard let self = self, self.store().call(reRegisteringAs: uuid) === call else {
                    return
                }
                self.store().reRegistrationRefused(uuid: uuid)
                self.requestStart(call, as: uuid, attempt: attempt + 1)
            }
        }
    }
}

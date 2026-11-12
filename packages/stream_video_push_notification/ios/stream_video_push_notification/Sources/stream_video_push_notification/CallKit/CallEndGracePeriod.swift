import Foundation
import UIKit

/// Starts and ends background tasks.
protocol BackgroundTasks {
    func begin(name: String, expiration: @escaping () -> Void) -> UIBackgroundTaskIdentifier
    func end(_ task: UIBackgroundTaskIdentifier)
}

final class ApplicationBackgroundTasks: BackgroundTasks {
    func begin(name: String, expiration: @escaping () -> Void) -> UIBackgroundTaskIdentifier {
        UIApplication.shared.beginBackgroundTask(withName: name, expirationHandler: expiration)
    }

    func end(_ task: UIBackgroundTaskIdentifier) {
        UIApplication.shared.endBackgroundTask(task)
    }
}

/// Keeps the app running for a while after CallKit ends a call.
///
/// The end of a call reaches Dart as an event, and Dart then tells the backend: it leaves the
/// call, or cancels the ring of a call the user started. Once CallKit has no call left, nothing
/// keeps an app in the background or behind the lock screen running, and iOS suspends it before
/// Dart gets to send anything. The callee then keeps ringing until the caller opens the app.
///
/// A background task covers that. Each end restarts the grace period, and the task ends when it
/// runs out or when iOS expires it.
final class CallEndGracePeriod {
    static let defaultDuration: TimeInterval = 10

    init(
        duration: TimeInterval = CallEndGracePeriod.defaultDuration,
        tasks: BackgroundTasks = ApplicationBackgroundTasks(),
        scheduler: HoldRecoveryScheduler = MainQueueHoldRecoveryScheduler()
    ) {
        self.duration = duration
        self.tasks = tasks
        self.scheduler = scheduler
    }

    private let duration: TimeInterval
    private let tasks: BackgroundTasks
    private let scheduler: HoldRecoveryScheduler

    private var task = UIBackgroundTaskIdentifier.invalid
    private var timer: HoldRecoveryTimer?

    var isRunning: Bool { task != .invalid }

    /// CallKit ended a call: Dart gets `duration` to act on it.
    func callEnded() {
        if task == .invalid {
            task = tasks.begin(name: "StreamCallKitCallEnded") { [weak self] in
                self?.finish()
            }
        }
        timer?.cancel()
        timer = scheduler.schedule(after: duration) { [weak self] in
            self?.finish()
        }
    }

    private func finish() {
        timer?.cancel()
        timer = nil
        guard task != .invalid else { return }
        tasks.end(task)
        task = .invalid
    }
}

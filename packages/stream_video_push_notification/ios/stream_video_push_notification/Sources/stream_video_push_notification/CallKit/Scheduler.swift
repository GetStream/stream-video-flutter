import Foundation

/// Runs work after a delay.
protocol Scheduler {
    @discardableResult
    func schedule(after delay: TimeInterval, _ work: @escaping () -> Void) -> ScheduledWork
}

/// Work a scheduler will run, until cancelled.
protocol ScheduledWork {
    func cancel()
}

/// Schedules on the main queue.
final class MainQueueScheduler: Scheduler {

    private final class Timer: ScheduledWork {
        let item: DispatchWorkItem
        init(_ item: DispatchWorkItem) { self.item = item }
        func cancel() { item.cancel() }
    }

    func schedule(after delay: TimeInterval, _ work: @escaping () -> Void) -> ScheduledWork {
        let item = DispatchWorkItem(block: work)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: item)
        return Timer(item)
    }
}

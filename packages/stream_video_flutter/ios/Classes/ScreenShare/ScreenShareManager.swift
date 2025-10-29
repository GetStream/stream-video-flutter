import Foundation

/// A lightweight wrapper around `CFNotificationCenter`
final class ScreenShareManager {

    static let shared = ScreenShareManager()

    /// Closure invoked whenever an observed notification is received.
    var onNotification: ((String) -> Void)?

    private let notificationCenter: CFNotificationCenter
    private var observedNames: Set<String> = []
    private let lock = NSLock()

    private init() {
        notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
    }

    deinit {
        removeAllObservers()
    }

    /// Begins listening for notifications with the given name.
    func observeNotification(named name: String) {
        lock.lock()
        defer { lock.unlock() }

        guard !observedNames.contains(name) else { return }
        observedNames.insert(name)

        let observer = Unmanaged.passUnretained(self).toOpaque()
        CFNotificationCenterAddObserver(
            notificationCenter,
            observer,
            ScreenShareManager.notificationCallback,
            name as CFString,
            nil,
            .deliverImmediately
        )
    }

    /// Stops listening for notifications with the specified name.
    func removeObserver(named name: String) {
        lock.lock()
        defer { lock.unlock() }

        guard observedNames.contains(name) else { return }
        observedNames.remove(name)

        let observer = Unmanaged.passUnretained(self).toOpaque()
        CFNotificationCenterRemoveObserver(
            notificationCenter,
            observer,
            CFNotificationName(name as CFString),
            nil
        )
    }

    /// Removes all registered CFNotification observers.
    func removeAllObservers() {
        lock.lock()
        let names = observedNames
        observedNames.removeAll()
        lock.unlock()

        let observer = Unmanaged.passUnretained(self).toOpaque()
        for name in names {
            CFNotificationCenterRemoveObserver(
                notificationCenter,
                observer,
                CFNotificationName(name as CFString),
                nil
            )
        }
    }

    private func handleNotification(named name: String) {
        guard let handler = onNotification else { return }
        DispatchQueue.main.async { handler(name) }
    }

    private static let notificationCallback: CFNotificationCallback = { _, observer, name, _, _ in
        guard
            let observer,
            let rawName = name?.rawValue as String?
        else { return }

        let manager = Unmanaged<ScreenShareManager>
            .fromOpaque(observer)
            .takeUnretainedValue()

        manager.handleNotification(named: rawName)
    }
}

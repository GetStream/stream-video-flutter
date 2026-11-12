import Flutter
import Foundation

/// The one queue between the native side and Dart's event channel.
///
/// Events go to the handler of the most recently registered event channel once Dart listens on
/// it, and are held in order until then, including across a new registration. Events sent while
/// silenced are dropped rather than held; events already held are still delivered.
final class RingingEventSink {

    /// While true, events sent are dropped instead of being delivered or held. It is read when an
    /// event is sent, from any thread: an event sent while silenced is dropped even if silencing
    /// ends before the event would reach Dart, and one sent before silencing is still delivered.
    var isSilenced: Bool {
        get {
            silencedLock.lock()
            defer { silencedLock.unlock() }
            return silenced
        }
        set {
            silencedLock.lock()
            defer { silencedLock.unlock() }
            silenced = newValue
        }
    }

    private var silenced = false
    private let silencedLock = NSLock()

    /// The handler events go to.
    private(set) var handler: EventCallbackHandler?
    private var pending: [[String: Any]] = []

    /// Makes `handler` the one events go to, and hands it the held events if Dart listens already.
    func attach(_ handler: EventCallbackHandler) {
        onMain {
            self.handler = handler
            self.flush()
        }
    }

    /// Drops `event` if events are silenced; otherwise delivers or holds it on the main thread.
    func send(_ event: String, _ body: Any) {
        if isSilenced {
            NSLog("[StreamCallKit] %@ silenced", event)
            return
        }
        let payload: [String: Any] = [
            "event": event,
            "body": body,
        ]
        DispatchQueue.main.async {
            if let listener = self.handler?.listener {
                listener(payload)
            } else {
                self.pending.append(payload)
            }
        }
    }

    /// Called on the main thread when Dart starts listening on `handler`'s channel.
    fileprivate func didListen(_ handler: EventCallbackHandler) {
        guard handler === self.handler else { return }
        flush()
    }

    private func flush() {
        guard let listener = handler?.listener else { return }
        let held = pending
        pending.removeAll()
        held.forEach { listener($0) }
    }

    private func onMain(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}

/// The stream handler of one registration of the event channel.
///
/// It holds no events of its own: `send` goes through the `RingingEventSink` it belongs to,
/// which delivers to whichever handler was attached last and drops events while silenced. A
/// handler that is never attached receives nothing.
final class EventCallbackHandler: NSObject, FlutterStreamHandler {

    private let sink: RingingEventSink
    fileprivate var listener: FlutterEventSink?

    init(sink: RingingEventSink) {
        self.sink = sink
        super.init()
    }

    /// A handler on the shared manager's sink.
    override convenience init() {
        self.init(sink: StreamVideoCallkitManager.shared.eventSink)
    }

    func send(_ event: String, _ body: Any) {
        sink.send(event, body)
    }

    func onListen(
        withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink
    )
        -> FlutterError?
    {
        self.listener = events
        sink.didListen(self)
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.listener = nil
        return nil
    }
}

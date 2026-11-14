import Flutter
import Foundation

/// The one queue between the native side and Dart's event channel.
///
/// Events go to the handler of the most recently registered event channel once Dart listens on
/// it, and are held in order until then, including across a new registration. While silenced,
/// events are dropped rather than held; events already held are still delivered.
final class RingingEventSink {

    /// While true, events are dropped instead of being delivered or held. Set on the main thread.
    var isSilenced = false

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

    /// Delivers or holds `event` on the main thread. Whether events are silenced is read there
    /// too, so an event sent from any thread just before `isSilenced` is set is dropped.
    func send(_ event: String, _ body: Any) {
        let payload: [String: Any] = [
            "event": event,
            "body": body,
        ]
        DispatchQueue.main.async {
            if self.isSilenced {
                print(event, " silenced")
                return
            }
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
public class EventCallbackHandler: NSObject, FlutterStreamHandler {

    private let sink: RingingEventSink
    fileprivate var listener: FlutterEventSink?

    init(sink: RingingEventSink) {
        self.sink = sink
        super.init()
    }

    /// A handler on the shared manager's sink.
    public override convenience init() {
        self.init(sink: StreamVideoCallkitManager.shared.eventSink)
    }

    public func send(_ event: String, _ body: Any) {
        sink.send(event, body)
    }

    public func onListen(
        withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink
    )
        -> FlutterError?
    {
        self.listener = events
        sink.didListen(self)
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.listener = nil
        return nil
    }
}

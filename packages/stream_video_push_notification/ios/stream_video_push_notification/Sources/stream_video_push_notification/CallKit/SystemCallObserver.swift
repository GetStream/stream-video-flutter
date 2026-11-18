import CallKit
import Foundation

/// A call on the device, from this app or any other.
struct SystemCall: Equatable {
    let uuid: UUID
    let hasEnded: Bool
}

/// Every call on the device, including other apps' calls such as cellular ones.
protocol SystemCallObserver: AnyObject {
    /// The calls the device has now.
    var calls: [SystemCall] { get }
    /// Called on the main queue with each call that changed.
    var onCallChanged: ((SystemCall) -> Void)? { get set }
}

/// Reads the device's calls from `CXCallObserver`.
final class CXSystemCallObserver: NSObject, SystemCallObserver, CXCallObserverDelegate {

    private let observer = CXCallObserver()

    var onCallChanged: ((SystemCall) -> Void)?

    override init() {
        super.init()
        observer.setDelegate(self, queue: .main)
    }

    var calls: [SystemCall] {
        observer.calls.map { SystemCall(uuid: $0.uuid, hasEnded: $0.hasEnded) }
    }

    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        onCallChanged?(SystemCall(uuid: call.uuid, hasEnded: call.hasEnded))
    }
}

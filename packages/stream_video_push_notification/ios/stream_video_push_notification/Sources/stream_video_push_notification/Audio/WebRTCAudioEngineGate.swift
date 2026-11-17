import Foundation

/// Lets the WebRTC audio engine run only while the app owns the audio session.
protocol WebRTCAudioEngineGate: AnyObject {

    /// Allows or stops the audio engine. `callKitSessionActive`, when given, tells WebRTC whether
    /// CallKit activated the app's audio session; WebRTC applies it before `available`.
    func update(available: Bool, callKitSessionActive: Bool?)

    /// Called when WebRTC could not start the audio engine on a session CallKit activated.
    var onEngineStartFailed: (() -> Void)? { get set }
}

/// Talks to `stream_webrtc_flutter` through NotificationCenter, so this plugin needs no build
/// dependency on it.
final class NotificationCenterAudioEngineGate: WebRTCAudioEngineGate {

    /// Posted to allow or stop the audio engine; matches
    /// `FlutterWebRTCAudioEngineAvailabilityNotification`.
    static let availabilityNotification = Notification.Name(
        "io.getstream.webrtc.audioEngineAvailability")
    static let availableKey = "available"
    static let audioSessionActiveKey = "audioSessionActive"

    /// Posted by `stream_webrtc_flutter` when the audio engine could not start; matches
    /// `FlutterWebRTCAudioEngineStartFailedNotification`.
    static let engineStartFailedNotification = Notification.Name(
        "io.getstream.webrtc.audioEngineStartFailed")

    var onEngineStartFailed: (() -> Void)?

    private let center: NotificationCenter
    private var startFailedObserver: NSObjectProtocol?

    init(center: NotificationCenter = .default) {
        self.center = center
        startFailedObserver = center.addObserver(
            forName: Self.engineStartFailedNotification, object: nil, queue: .main
        ) { [weak self] _ in
            self?.onEngineStartFailed?()
        }
    }

    deinit {
        if let startFailedObserver = startFailedObserver {
            center.removeObserver(startFailedObserver)
        }
    }

    func update(available: Bool, callKitSessionActive: Bool?) {
        var userInfo: [AnyHashable: Any] = [Self.availableKey: available]
        if let callKitSessionActive = callKitSessionActive {
            userInfo[Self.audioSessionActiveKey] = callKitSessionActive
        }
        center.post(name: Self.availabilityNotification, object: nil, userInfo: userInfo)
    }
}

import Foundation
import stream_webrtc_flutter

/// Lets the WebRTC audio engine run only while the app owns the audio session.
protocol WebRTCAudioEngineGate: AnyObject {

    /// Allows or stops the audio engine. `callKitSessionActive`, when given, tells WebRTC whether
    /// CallKit activated the app's audio session: an activation is applied before `available`,
    /// a deactivation after it.
    func update(available: Bool, callKitSessionActive: Bool?)

    /// Called when WebRTC could not start the audio engine on a session CallKit activated.
    var onEngineStartFailed: (() -> Void)? { get set }
}

/// Talks to `stream_webrtc_flutter` through NotificationCenter, which its plugin observes in
/// every registration.
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

/// Calls the latest registered `stream_webrtc_flutter` plugin directly, and posts the
/// notifications while none is registered.
final class WebRTCPluginAudioEngineGate: WebRTCAudioEngineGate {

    var onEngineStartFailed: (() -> Void)?

    private let fallback: NotificationCenterAudioEngineGate
    private let resolveControl: () -> FlutterWebRTCAudioEngineControl?
    /// The plugin the handler was last registered on.
    private weak var control: FlutterWebRTCAudioEngineControl?

    /// `resolveControl` is asked for the plugin on each update.
    init(
        fallback: NotificationCenterAudioEngineGate = NotificationCenterAudioEngineGate(),
        resolveControl: @escaping () -> FlutterWebRTCAudioEngineControl? = {
            FlutterWebRTCPlugin.sharedSingleton()
        }
    ) {
        self.fallback = fallback
        self.resolveControl = resolveControl
        // The start-failed notification is forwarded only while no plugin has been found.
        fallback.onEngineStartFailed = { [weak self] in
            guard let self = self, self.control == nil else { return }
            self.onEngineStartFailed?()
        }
    }

    func update(available: Bool, callKitSessionActive: Bool?) {
        guard let control = resolvedControl() else {
            fallback.update(available: available, callKitSessionActive: callKitSessionActive)
            return
        }
        if callKitSessionActive == true {
            control.setCallKitAudioSessionActive(true)
        }
        control.setAudioEngineAvailable(available)
        if callKitSessionActive == false {
            control.setCallKitAudioSessionActive(false)
        }
    }

    /// The plugin registered last, with the start-failure handler set on it.
    private func resolvedControl() -> FlutterWebRTCAudioEngineControl? {
        guard let resolved = resolveControl() else { return control }
        if resolved !== control {
            resolved.audioEngineStartFailedHandler = { [weak self] in
                self?.onEngineStartFailed?()
            }
            control = resolved
        }
        return resolved
    }
}

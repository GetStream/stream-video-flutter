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

/// Calls `stream_webrtc_flutter`'s process-wide audio engine control, which reaches every
/// registration of its plugin, including registrations made later.
final class WebRTCPluginAudioEngineGate: WebRTCAudioEngineGate {

    var onEngineStartFailed: (() -> Void)?

    private let control: FlutterWebRTCAudioEngineControl

    /// Sets the control's start-failure handler, which forwards to `onEngineStartFailed`.
    ///
    /// The handler is one slot for the process, so a gate made later on the same control
    /// replaces this one's: keep one gate per control.
    init(control: FlutterWebRTCAudioEngineControl = FlutterWebRTCPlugin.audioEngineControl) {
        self.control = control
        control.audioEngineStartFailedHandler = { [weak self] in
            self?.onEngineStartFailed?()
        }
    }

    func update(available: Bool, callKitSessionActive: Bool?) {
        if callKitSessionActive == true {
            control.setCallKitAudioSessionActive(true)
        }
        control.setAudioEngineAvailable(available)
        if callKitSessionActive == false {
            control.setCallKitAudioSessionActive(false)
        }
    }
}

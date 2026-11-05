import Foundation

/// Constants for Stream Video Ringing actions and events
@available(iOS 10.0, *)
public struct StreamVideoIncomingCallConstants {

    // MARK: - Push Token Events
    public static let ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP =
        "io.getstream.video.DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP"

    // MARK: - Call Events
    public static let ACTION_CALL_INCOMING = "io.getstream.video.ACTION_CALL_INCOMING"
    public static let ACTION_CALL_INCOMING_FAILED =
        "io.getstream.video.ACTION_CALL_INCOMING_FAILED"
    public static let ACTION_CALL_START = "io.getstream.video.ACTION_CALL_START"
    public static let ACTION_CALL_ACCEPT = "io.getstream.video.ACTION_CALL_ACCEPT"
    public static let ACTION_CALL_DECLINE = "io.getstream.video.ACTION_CALL_DECLINE"
    public static let ACTION_CALL_ENDED = "io.getstream.video.ACTION_CALL_ENDED"
    public static let ACTION_CALL_TIMEOUT = "io.getstream.video.ACTION_CALL_TIMEOUT"
    public static let ACTION_CALL_CUSTOM = "io.getstream.video.ACTION_CALL_CUSTOM"
    public static let ACTION_CALL_CONNECTED = "io.getstream.video.ACTION_CALL_CONNECTED"

    // MARK: - Call Control Events
    public static let ACTION_CALL_TOGGLE_HOLD = "io.getstream.video.ACTION_CALL_TOGGLE_HOLD"
    public static let ACTION_CALL_TOGGLE_MUTE = "io.getstream.video.ACTION_CALL_TOGGLE_MUTE"
    public static let ACTION_CALL_TOGGLE_DTMF = "io.getstream.video.ACTION_CALL_TOGGLE_DTMF"
    public static let ACTION_CALL_TOGGLE_GROUP = "io.getstream.video.ACTION_CALL_TOGGLE_GROUP"
    public static let ACTION_CALL_TOGGLE_AUDIO_SESSION =
        "io.getstream.video.ACTION_CALL_TOGGLE_AUDIO_SESSION"

    // MARK: - WebRTC plugin notifications

    /// Gates the audio engine of every `stream_webrtc_flutter` peer-connection factory.
    /// Mirrors `FlutterWebRTCAudioEngineAvailabilityNotification` and
    /// `FlutterWebRTCAudioEngineAvailableKey` there; posted rather than called so this plugin
    /// needs no build dependency on the WebRTC plugin.
    public static let AUDIO_ENGINE_AVAILABILITY_NOTIFICATION = Notification.Name(
        "io.getstream.webrtc.audioEngineAvailability")
    public static let AUDIO_ENGINE_AVAILABLE_KEY = "available"
    public static let AUDIO_SESSION_ACTIVE_KEY = "audioSessionActive"
    /// Posted by the WebRTC plugin when it could not start the audio engine on the session
    /// CallKit activated. Mirrors `FlutterWebRTCAudioEngineStartFailedNotification`.
    public static let AUDIO_ENGINE_START_FAILED_NOTIFICATION = Notification.Name(
        "io.getstream.webrtc.audioEngineStartFailed")
}

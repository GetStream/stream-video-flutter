import Foundation

/// Constants for Stream Video CallKit actions and events
@available(iOS 10.0, *)
public struct StreamVideoIncomingCallConstants {

    // MARK: - Push Token Events
    static let ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP =
        "io.getstream.video.DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP"

    // MARK: - Call Events
    static let ACTION_CALL_INCOMING = "io.getstream.video.ACTION_CALL_INCOMING"
    static let ACTION_CALL_START = "io.getstream.video.ACTION_CALL_START"
    static let ACTION_CALL_ACCEPT = "io.getstream.video.ACTION_CALL_ACCEPT"
    static let ACTION_CALL_DECLINE = "io.getstream.video.ACTION_CALL_DECLINE"
    static let ACTION_CALL_ENDED = "io.getstream.video.ACTION_CALL_ENDED"
    static let ACTION_CALL_TIMEOUT = "io.getstream.video.ACTION_CALL_TIMEOUT"
    static let ACTION_CALL_CUSTOM = "io.getstream.video.ACTION_CALL_CUSTOM"
    static let ACTION_CALL_CONNECTED = "io.getstream.video.ACTION_CALL_CONNECTED"

    // MARK: - Call Control Events
    static let ACTION_CALL_TOGGLE_HOLD = "io.getstream.video.ACTION_CALL_TOGGLE_HOLD"
    static let ACTION_CALL_TOGGLE_MUTE = "io.getstream.video.ACTION_CALL_TOGGLE_MUTE"
    static let ACTION_CALL_TOGGLE_DMTF = "io.getstream.video.ACTION_CALL_TOGGLE_DMTF"
    static let ACTION_CALL_TOGGLE_GROUP = "io.getstream.video.ACTION_CALL_TOGGLE_GROUP"
    static let ACTION_CALL_TOGGLE_AUDIO_SESSION =
        "io.getstream.video.ACTION_CALL_TOGGLE_AUDIO_SESSION"
}

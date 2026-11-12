import Flutter
import Foundation

/// A call from Dart on the `stream_video_push_notification` method channel, arguments parsed.
enum PushCommand {
    /// `nil` when the arguments are missing or not a map.
    case initData([String: Any]?)
    case getDevicePushTokenVoIP
    case showIncomingCall(CallData)
    case startCall(CallData)
    /// `nil` when arguments were sent but are not a map.
    case endCall([String: Any]?)
    case muteCall(id: String, isMuted: Bool)
    case isMuted(id: String)
    case holdCall(id: String, onHold: Bool)
    /// `nil` when arguments were sent but are not a map.
    case callConnected([String: Any]?)
    case activeCalls
    case endAllCalls
    case silenceEvents(Bool)
    case reportCallEnded(id: String, reason: Int)
    /// The arguments the method needs are missing; the call is answered with `reply` and nothing
    /// else happens.
    case ignored(reply: Any?)
    case notImplemented
}

/// Parses method-channel calls into `PushCommand`s.
enum PushMethodCallRouter {

    static func command(for call: FlutterMethodCall) -> PushCommand {
        switch call.method {
        case "initData":
            return .initData(call.arguments as? [String: Any])
        case "getDevicePushTokenVoIP":
            return .getDevicePushTokenVoIP
        case "showIncomingCall":
            guard let args = call.arguments as? [String: Any] else {
                return .ignored(reply: true)
            }
            return .showIncomingCall(CallData(args: args))
        case "startCall":
            guard let args = call.arguments as? [String: Any] else {
                return .ignored(reply: true)
            }
            return .startCall(CallData(args: args))
        case "endCall":
            guard let args = call.arguments else {
                return .ignored(reply: true)
            }
            return .endCall(args as? [String: Any])
        case "muteCall":
            guard let args = call.arguments as? [String: Any],
                let callId = args["id"] as? String,
                let isMuted = args["isMuted"] as? Bool
            else {
                return .ignored(reply: true)
            }
            return .muteCall(id: callId, isMuted: isMuted)
        case "isMuted":
            guard let args = call.arguments as? [String: Any],
                let callId = args["id"] as? String
            else {
                return .ignored(reply: false)
            }
            return .isMuted(id: callId)
        case "holdCall":
            guard let args = call.arguments as? [String: Any],
                let callId = args["id"] as? String,
                let onHold = args["isOnHold"] as? Bool
            else {
                return .ignored(reply: true)
            }
            return .holdCall(id: callId, onHold: onHold)
        case "callConnected":
            guard let args = call.arguments else {
                return .ignored(reply: true)
            }
            return .callConnected(args as? [String: Any])
        case "activeCalls":
            return .activeCalls
        case "endAllCalls":
            return .endAllCalls
        case "silenceEvents":
            guard let silence = call.arguments as? Bool else {
                return .ignored(reply: true)
            }
            return .silenceEvents(silence)
        case "reportCallEnded":
            guard let args = call.arguments as? [String: Any],
                let callId = args["id"] as? String,
                let reason = args["reason"] as? Int
            else {
                return .ignored(reply: true)
            }
            return .reportCallEnded(id: callId, reason: reason)
        default:
            return .notImplemented
        }
    }
}

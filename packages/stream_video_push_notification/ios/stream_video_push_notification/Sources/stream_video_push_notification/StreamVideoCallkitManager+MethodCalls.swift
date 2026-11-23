import Flutter
import Foundation

extension StreamVideoCallkitManager {

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        handle(PushCommand(call), result: result)
    }

    func handle(_ command: PushCommand, result: @escaping FlutterResult) {
        switch command {
        case .showIncomingCall(let data):
            showIncomingCall(data)
            result(true)
        case .startCall(let data):
            self.startCall(data)
            result(true)
        case .endCall(let args):
            if let id = args?["id"] as? String {
                self.endCall(id)
            } else {
                NSLog("[StreamCallKit] endCall without a call id, ignored")
            }
            result(true)
        case .muteCall(let callId, let isMuted):
            self.muteCall(callId, isMuted: isMuted)
            result(true)
        case .isMuted(let callId):
            guard let call = store.call(forAppId: callId) else {
                result(false)
                return
            }
            result(call.isMuted)
        case .holdCall(let callId, let onHold):
            self.holdCall(callId, onHold: onHold)
            result(true)
        case .callConnected(let args):
            if let id = args?["id"] as? String {
                self.connectedCall(id)
            } else {
                NSLog("[StreamCallKit] callConnected without a call id, ignored")
            }
            result(true)
        case .activeCalls:
            result(self.activeCalls())
        case .endAllCalls:
            self.endAllCalls()
            result(true)
        case .silenceEvents(let silence):
            self.eventSink.isSilenced = silence
            result(true)
        case .reportCallEnded(let callId, let reason):
            self.saveEndCall(callId, reason)
            result(true)
        case .ignored(let reply):
            result(reply)
        case .initData, .getDevicePushTokenVoIP, .notImplemented:
            // The plugin answers the first two before the manager sees a call.
            result(FlutterMethodNotImplemented)
        }
    }
}

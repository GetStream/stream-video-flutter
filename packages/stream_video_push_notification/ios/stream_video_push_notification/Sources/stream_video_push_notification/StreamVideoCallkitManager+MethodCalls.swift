import Flutter
import Foundation

extension StreamVideoCallkitManager {

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        handle(PushMethodCallRouter.command(for: call), result: result)
    }

    func handle(_ command: PushCommand, result: @escaping FlutterResult) {
        switch command {
        case .showIncomingCall(let data):
            self.data = data
            showIncomingCall(data, fromPushKit: false)
            result(true)
        case .showMissCallNotification:
            result(true)
        case .startCall(let data):
            self.data = data
            self.startCall(data, fromPushKit: false)
            result(true)
        case .endCall(let args):
            if self.isFromPushKit {
                self.endCall(self.data!)
            } else if let args = args {
                self.data = self.storedCallData(for: args)
                self.endCall(self.data!)
            }
            result(true)
        case .muteCall(let callId, let isMuted):
            self.muteCall(callId, isMuted: isMuted)
            result(true)
        case .isMuted(let callId):
            guard let callUUID = UUID(uuidString: callId),
                let call = self.callController.callWithUUID(uuid: callUUID)
            else {
                result(false)
                return
            }
            result(call.isMuted)
        case .holdCall(let callId, let onHold):
            self.holdCall(callId, onHold: onHold)
            result(true)
        case .callConnected(let args):
            if self.isFromPushKit {
                self.connectedCall(self.data!)
            } else if let args = args {
                self.data = self.storedCallData(for: args)
                self.connectedCall(self.data!)
            }
            result(true)
        case .activeCalls:
            result(self.callController.activeCalls())
        case .endAllCalls:
            self.callController.endAllCalls()
            result(true)
        case .silenceEvents(let silence):
            self.eventSink.isSilenced = silence
            result(true)
        case .reportCallEnded(let callId, let reason):
            self.saveEndCall(callId, reason)
            result(true)
        case .requestNotificationPermission:
            result(true)
        case .ignored(let reply):
            result(reply)
        case .initData, .getDevicePushTokenVoIP, .notImplemented:
            // The plugin answers the first two before the manager sees a call.
            result(FlutterMethodNotImplemented)
        }
    }
}

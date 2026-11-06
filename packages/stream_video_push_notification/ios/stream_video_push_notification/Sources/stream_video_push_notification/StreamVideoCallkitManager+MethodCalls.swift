import Flutter
import Foundation

extension StreamVideoCallkitManager {

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        handle(PushMethodCallRouter.command(for: call), result: result)
    }

    func handle(_ command: PushCommand, result: @escaping FlutterResult) {
        switch command {
        case .showIncomingCall(let data):
            store.lastOptions = data
            showIncomingCall(data, fromPushKit: false)
            result(true)
        case .showMissCallNotification:
            result(true)
        case .startCall(let data):
            store.lastOptions = data
            self.startCall(data, fromPushKit: false)
            result(true)
        case .endCall(let args):
            if store.isFromPushKit {
                self.endCall(store.lastOptions!)
            } else if let args = args {
                store.lastOptions = store.options(for: args)
                self.endCall(store.lastOptions!)
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
            if store.isFromPushKit {
                self.connectedCall(store.lastOptions!)
            } else if let args = args {
                store.lastOptions = store.options(for: args)
                self.connectedCall(store.lastOptions!)
            }
            result(true)
        case .activeCalls:
            result(self.activeCalls())
        case .endAllCalls:
            // Unlike the native `endAllCalls()`, this keeps `isFromPushKit`.
            transactions.endAll()
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

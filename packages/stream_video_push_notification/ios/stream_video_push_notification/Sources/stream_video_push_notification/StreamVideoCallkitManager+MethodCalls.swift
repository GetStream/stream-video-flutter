import Flutter
import Foundation

extension StreamVideoCallkitManager {

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        handle(PushMethodCallRouter.command(for: call), result: result)
    }

    func handle(_ command: PushCommand, result: @escaping FlutterResult) {
        switch command {
        case .showIncomingCall(let data):
            store.lastOptions = data
            showIncomingCall(data, fromPushKit: false)
            result(true)
        case .startCall(let data):
            store.lastOptions = data
            self.startCall(data, fromPushKit: false)
            result(true)
        case .endCall(let args):
            if let id = args?["id"] as? String, store.wasRefusedToStart(appId: id) {
                NSLog("[StreamCallKit] endCall for \(id), which CallKit refused to start, ignored")
            } else if store.actsOnPushKitCall(forAppId: args?["id"] as? String) {
                self.endCall(store.lastOptions!)
            } else if let args = args {
                self.endCall(optionsKeepingThePushKitCall(for: args))
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
            if let id = args?["id"] as? String, store.wasRefusedToStart(appId: id) {
                NSLog("[StreamCallKit] callConnected for \(id), which CallKit refused to start, ignored")
            } else if store.actsOnPushKitCall(forAppId: args?["id"] as? String) {
                self.connectedCall(store.lastOptions!)
            } else if let args = args {
                self.connectedCall(optionsKeepingThePushKitCall(for: args))
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
        case .ignored(let reply):
            result(reply)
        case .initData, .getDevicePushTokenVoIP, .notImplemented:
            // The plugin answers the first two before the manager sees a call.
            result(FlutterMethodNotImplemented)
        }
    }

    /// The options of the call `args` names. They become the last options, unless those are
    /// the call PushKit showed, which Dart may still end or connect by another id.
    private func optionsKeepingThePushKitCall(for args: [String: Any]) -> CallData {
        let options = store.options(for: args)
        if !store.isFromPushKit {
            store.lastOptions = options
        }
        return options
    }
}

import AVFoundation
import CallKit
import Flutter
import UIKit

@available(iOS 10.0, *)
public class StreamVideoCallkitManager: NSObject, CXProviderDelegate {

    @objc public static let shared = StreamVideoCallkitManager()

    /// Every event bound for Dart goes through here.
    let eventSink = RingingEventSink()

    var callController: StreamCallKitCallController

    var sharedProvider: CXProvider? = nil

    var outgoingCall: Call?
    var answerCall: Call?

    var data: CallData?
    var isFromPushKit: Bool = false

    private override init() {
        callController = StreamCallKitCallController()
        super.init()
    }

    @objc public func getAcceptedCall() -> CallData? {
        NSLog(
            "Call data ids \(String(describing: data?.uuid)) \(String(describing: answerCall?.uuid.uuidString))"
        )
        if data?.uuid.lowercased() == answerCall?.uuid.uuidString.lowercased() {
            return data
        }
        return nil
    }

    @objc public func showIncomingCall(_ data: CallData, fromPushKit: Bool) {
        showIncomingCall(data, fromPushKit: fromPushKit, completion: nil)
    }

    /// Reports an incoming call to CallKit.
    ///
    /// `completion` runs once CallKit has accepted or refused the call, or straight away when the
    /// call could not be reported at all.
    @objc public func showIncomingCall(
        _ data: CallData, fromPushKit: Bool, completion: (() -> Void)?
    ) {
        self.isFromPushKit = fromPushKit
        if fromPushKit {
            self.data = data
        }

        var handle: CXHandle?
        handle = CXHandle(type: self.getHandleType(data.handleType), value: data.getEncryptHandle())

        let callUpdate = CXCallUpdate()
        callUpdate.remoteHandle = handle
        callUpdate.supportsDTMF = data.supportsDTMF
        callUpdate.supportsHolding = data.supportsHolding
        callUpdate.supportsGrouping = data.supportsGrouping
        callUpdate.supportsUngrouping = data.supportsUngrouping
        callUpdate.hasVideo = data.type > 0 ? true : false
        callUpdate.localizedCallerName = data.callerName

        initCallkitProvider(data)

        guard let uuid = UUID(uuidString: data.uuid) else {
            sendUnreportableCallEvent(data, "call uuid is not a valid UUID: '\(data.uuid)'")
            completion?()
            return
        }
        guard let provider = self.sharedProvider else {
            sendUnreportableCallEvent(data, "no CallKit provider")
            completion?()
            return
        }

        self.configureAudioSession(data)
        provider.reportNewIncomingCall(with: uuid, update: callUpdate) { error in
            if let error = error {
                self.sendIncomingCallFailedEvent(data, error)
                completion?()
                return
            }

            self.configureAudioSession(data)
            let call = Call(uuid: uuid, data: data)
            call.handle = data.handle
            self.callController.addCall(call)
            self.sendEvent(
                StreamVideoIncomingCallConstants.ACTION_CALL_INCOMING, data.toJSON())
            self.endCallNotExist(data)
            completion?()
        }
    }

    @objc public func startCall(_ data: CallData, fromPushKit: Bool) {
        self.isFromPushKit = fromPushKit
        if fromPushKit {
            self.data = data
        }
        initCallkitProvider(data)
        self.callController.startCall(data)
    }

    @objc public func muteCall(_ callId: String, isMuted: Bool) {
        guard let callId = UUID(uuidString: callId),
            let call = self.callController.callWithUUID(uuid: callId)
        else {
            return
        }
        if call.isMuted == isMuted {
            self.sendMuteEvent(self.callController.reportedId(for: callId), isMuted)
        } else {
            self.callController.muteCall(call: call, isMuted: isMuted)
        }
    }

    @objc public func holdCall(_ callId: String, onHold: Bool) {
        guard let callId = UUID(uuidString: callId),
            let call = self.callController.callWithUUID(uuid: callId)
        else {
            return
        }
        if call.isOnHold == onHold {
            self.sendHoldEvent(self.callController.reportedId(for: callId), onHold)
        } else {
            self.callController.holdCall(call: call, onHold: onHold)
        }
    }

    /// Returns the options already stored for the call that `args` names.
    ///
    /// `callConnected` and `endCall` send only the id, so rebuilding `CallData` from their args
    /// would reset the call's options to defaults.
    func storedCallData(for args: [String: Any]) -> CallData {
        guard let id = args["id"] as? String else {
            return CallData(args: args)
        }
        if let data = self.data, data.uuid.lowercased() == id.lowercased() {
            return data
        }
        if let uuid = UUID(uuidString: id), let call = self.callController.callWithUUID(uuid: uuid) {
            return call.data
        }
        return CallData(args: args)
    }

    @objc public func endCall(_ data: CallData) {
        var call: Call? = nil
        if self.isFromPushKit {
            call = Call(uuid: UUID(uuidString: self.data!.uuid)!, data: data)
            self.isFromPushKit = false
            self.sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_ENDED, data.toJSON())
        } else {
            call = Call(uuid: UUID(uuidString: data.uuid)!, data: data)
        }
        self.callController.endCall(call: call!)
    }

    @objc public func connectedCall(_ data: CallData) {
        var call: Call? = nil
        if self.isFromPushKit {
            call = Call(uuid: UUID(uuidString: self.data!.uuid)!, data: data)
            self.isFromPushKit = false
        } else {
            call = Call(uuid: UUID(uuidString: data.uuid)!, data: data)
        }
        self.callController.connectedCall(call: call!)
    }

    @objc public func activeCalls() -> [[String: Any]] {
        return self.callController.activeCalls()
    }

    @objc public func endAllCalls() {
        self.isFromPushKit = false
        self.callController.endAllCalls()
    }

    /// Reports to CallKit how a call ended, which is what decides how it is listed in Recents.
    ///
    /// `reason` matches the raw values of `CXCallEndedReason`: 1 failed, 2 remoteEnded,
    /// 3 unanswered, 4 answeredElsewhere, 5 declinedElsewhere.
    public func saveEndCall(_ uuid: String, _ reason: Int) {
        guard let callUUID = UUID(uuidString: uuid) else {
            NSLog("saveEndCall: invalid UUID \(uuid)")
            return
        }
        guard let endedReason = CXCallEndedReason(rawValue: reason == 6 ? 2 : reason) else {
            NSLog("saveEndCall: unsupported reason \(reason)")
            return
        }

        self.sharedProvider?.reportCall(with: callUUID, endedAt: Date(), reason: endedReason)
    }

    func endCallNotExist(_ data: CallData) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(data.duration)) {
            let call = self.callController.callWithUUID(uuid: UUID(uuidString: data.uuid)!)
            if call != nil && self.answerCall == nil && self.outgoingCall == nil {
                self.callEndTimeout(data)
            }
        }
    }

    func callEndTimeout(_ data: CallData) {
        self.saveEndCall(data.uuid, 3)
        guard let call = self.callController.callWithUUID(uuid: UUID(uuidString: data.uuid)!) else {
            return
        }
        sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT, data.toJSON())
    }

    func getHandleType(_ handleType: String?) -> CXHandle.HandleType {
        var typeDefault = CXHandle.HandleType.generic
        switch handleType {
        case "number":
            typeDefault = CXHandle.HandleType.phoneNumber
            break
        case "email":
            typeDefault = CXHandle.HandleType.emailAddress
        default:
            typeDefault = CXHandle.HandleType.generic
        }
        return typeDefault
    }

    @objc public func initCallkitProvider(_ data: CallData) {
        if let sharedProvider = self.sharedProvider {
            // The provider outlives individual calls, so refreshing its configuration is the only
            // way a ringtone, icon or Recents setting delivered after the first call takes effect.
            sharedProvider.configuration = createConfiguration(data)
            // Re-assert the delegate: Apple requires it to be set before `reportNewIncomingCall`,
            // and it can be dropped when the provider is carried across a plugin re-registration.
            sharedProvider.setDelegate(self, queue: nil)
        } else {
            let provider = CXProvider(configuration: createConfiguration(data))
            provider.setDelegate(self, queue: nil)
            self.sharedProvider = provider
        }
        self.callController.setSharedProvider(self.sharedProvider!)
    }

    /// Maps a `reportNewIncomingCall` failure onto a stable identifier.
    ///
    /// The values match the names of `IncomingCallFailureReason` on the Dart side, which parses
    /// them by name and falls back to `unknown`.
    func incomingCallErrorCode(_ error: Error) -> String {
        switch (error as NSError).code {
        case CXErrorCodeIncomingCallError.unentitled.rawValue:
            return "unentitled"
        case CXErrorCodeIncomingCallError.callUUIDAlreadyExists.rawValue:
            return "callUuidAlreadyExists"
        case CXErrorCodeIncomingCallError.filteredByDoNotDisturb.rawValue:
            return "filteredByDoNotDisturb"
        case CXErrorCodeIncomingCallError.filteredByBlockList.rawValue:
            return "filteredByBlockList"
        default:
            return "unknown"
        }
    }

    /// Reports a call that was never handed to CallKit at all.
    ///
    /// Distinct from [sendIncomingCallFailedEvent], which reports a call CallKit was asked about
    /// and refused. Here the SDK could not even ask, so there is no `Error` to describe — and
    /// without this the call simply vanished, with nothing in the log and nothing sent to Dart.
    private func sendUnreportableCallEvent(_ data: CallData, _ reason: String) {
        NSLog("showIncomingCall: not reported to CallKit — \(reason)")

        var body = data.toJSON()
        body["error"] = reason
        body["errorCode"] = "invalidCallData"

        self.sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_INCOMING_FAILED, body)
    }

    /// Reports that CallKit refused to display an incoming call.
    ///
    /// Without this the failure was swallowed and no event was ever emitted, so the Dart side never
    /// learned the call existed. Most commonly hit when the call is filtered by Do Not Disturb or
    /// the block list.
    ///
    /// This reports and stops there. It deliberately does not reject the call: rejecting is a
    /// user-level action that ends the ring on every device the user is being called on, so a
    /// phone silently filtering a call under Do Not Disturb would silence the iPad they are
    /// holding. Whether a filtered call should be rejected is a product decision, and the
    /// integrator makes it from `ActionCallIncomingFailed`.
    private func sendIncomingCallFailedEvent(_ data: CallData, _ error: Error) {
        NSLog(
            "reportNewIncomingCall failed for \(data.uuid): \(error.localizedDescription)"
        )

        var body = data.toJSON()
        body["error"] = error.localizedDescription
        body["errorCode"] = incomingCallErrorCode(error)

        self.sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_INCOMING_FAILED, body)
    }

    func createConfiguration(_ data: CallData) -> CXProviderConfiguration {
        let configuration = CXProviderConfiguration()
        configuration.supportsVideo = data.supportsVideo
        configuration.maximumCallGroups = data.maximumCallGroups
        configuration.maximumCallsPerCallGroup = data.maximumCallsPerCallGroup

        configuration.supportedHandleTypes = [
            CXHandle.HandleType.generic,
            CXHandle.HandleType.emailAddress,
            CXHandle.HandleType.phoneNumber,
        ]
        if #available(iOS 11.0, *) {
            configuration.includesCallsInRecents = data.includesCallsInRecents
        }
        if !data.iconName.isEmpty {
            if let image = UIImage(named: data.iconName) {
                configuration.iconTemplateImageData = image.pngData()
            } else {
                print("Unable to load icon \(data.iconName).")
            }
        }
        if !data.ringtonePath.isEmpty && data.ringtonePath != "system_ringtone_default" {
            configuration.ringtoneSound = data.ringtonePath
        }
        return configuration
    }
}

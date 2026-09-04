import AVFoundation
import CallKit
import Flutter
import UIKit

@available(iOS 10.0, *)
public class StreamVideoCallkitManager: NSObject, CXProviderDelegate {

    @objc public static let shared = StreamVideoCallkitManager()

    private var eventHandler: EventCallbackHandler?
    private var pendingEvents: [(event: String, body: [String: Any?]?)] = []

    private var callController: StreamCallKitCallController

    private var sharedProvider: CXProvider? = nil

    private var outgoingCall: Call?
    private var answerCall: Call?

    private var data: CallData?
    private var isFromPushKit: Bool = false
    private var silenceEvents: Bool = false

    private override init() {
        callController = StreamCallKitCallController()
        super.init()
    }

    public func setEventHandler(_ handler: EventCallbackHandler) {
        self.eventHandler = handler
        flushPendingEvents()
    }

    private func flushPendingEvents() {
        guard let eventHandler = eventHandler else { return }

        for pendingEvent in pendingEvents {
            eventHandler.send(pendingEvent.event, pendingEvent.body ?? [:])
        }

        pendingEvents.removeAll()
    }

    private func sendEvent(_ event: String, _ body: [String: Any?]?) {
        if silenceEvents {
            print(event, " silenced")
            return
        }

        guard let eventHandler = eventHandler else {
            pendingEvents.append((event: event, body: body))
            return
        }

        eventHandler.send(event, body ?? [:])
    }

    @objc public func sendEventCustom(_ event: String, body: NSDictionary?) {
        // Convert NSDictionary to [String: Any?] for queueing if needed
        let bodyDict = body as? [String: Any?]
        sendEvent(event, bodyDict)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "showIncomingCall":
            guard let args = call.arguments else {
                result(true)
                return
            }
            if let getArgs = args as? [String: Any] {
                self.data = CallData(args: getArgs)
                showIncomingCall(self.data!, fromPushKit: false)
            }
            result(true)
            break
        case "showMissCallNotification":
            result(true)
            break
        case "startCall":
            guard let args = call.arguments else {
                result(true)
                return
            }
            if let getArgs = args as? [String: Any] {
                self.data = CallData(args: getArgs)
                self.startCall(self.data!, fromPushKit: false)
            }
            result(true)
            break
        case "endCall":
            guard let args = call.arguments else {
                result(true)
                return
            }
            if self.isFromPushKit {
                self.endCall(self.data!)
            } else {
                if let getArgs = args as? [String: Any] {
                    self.data = CallData(args: getArgs)
                    self.endCall(self.data!)
                }
            }
            result(true)
            break
        case "muteCall":
            guard let args = call.arguments as? [String: Any],
                let callId = args["id"] as? String,
                let isMuted = args["isMuted"] as? Bool
            else {
                result(true)
                return
            }

            self.muteCall(callId, isMuted: isMuted)
            result(true)
            break
        case "isMuted":
            guard let args = call.arguments as? [String: Any],
                let callId = args["id"] as? String
            else {
                result(false)
                return
            }
            guard let callUUID = UUID(uuidString: callId),
                let call = self.callController.callWithUUID(uuid: callUUID)
            else {
                result(false)
                return
            }
            result(call.isMuted)
            break
        case "holdCall":
            guard let args = call.arguments as? [String: Any],
                let callId = args["id"] as? String,
                let onHold = args["isOnHold"] as? Bool
            else {
                result(true)
                return
            }
            self.holdCall(callId, onHold: onHold)
            result(true)
            break
        case "callConnected":
            guard let args = call.arguments else {
                result(true)
                return
            }
            if self.isFromPushKit {
                self.connectedCall(self.data!)
            } else {
                if let getArgs = args as? [String: Any] {
                    self.data = CallData(args: getArgs)
                    self.connectedCall(self.data!)
                }
            }
            result(true)
            break
        case "activeCalls":
            result(self.callController.activeCalls())
            break
        case "endAllCalls":
            self.callController.endAllCalls()
            result(true)
            break
        case "silenceEvents":
            guard let silence = call.arguments as? Bool else {
                result(true)
                return
            }

            self.silenceEvents = silence
            result(true)
            break
        case "reportCallEnded":
            guard let args = call.arguments as? [String: Any],
                let callId = args["id"] as? String,
                let reason = args["reason"] as? Int
            else {
                result(true)
                return
            }
            self.saveEndCall(callId, reason)
            result(true)
            break
        case "requestNotificationPermission":
            result(true)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
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
            return
        }
        guard let provider = self.sharedProvider else {
            sendUnreportableCallEvent(data, "no CallKit provider")
            return
        }

        self.configureAudioSession()
        provider.reportNewIncomingCall(with: uuid, update: callUpdate) { error in
            if let error = error {
                self.sendIncomingCallFailedEvent(data, error)
                return
            }

            self.configureAudioSession()
            let call = Call(uuid: uuid, data: data)
            call.handle = data.handle
            self.callController.addCall(call)
            self.sendEvent(
                StreamVideoIncomingCallConstants.ACTION_CALL_INCOMING, data.toJSON())
            self.endCallNotExist(data)
        }
    }

    @objc public func showIncomingCall(
        _ data: CallData, fromPushKit: Bool, completion: @escaping () -> Void
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
            completion()
            return
        }
        guard let provider = self.sharedProvider else {
            sendUnreportableCallEvent(data, "no CallKit provider")
            completion()
            return
        }

        provider.reportNewIncomingCall(with: uuid, update: callUpdate) { error in
            if let error = error {
                self.sendIncomingCallFailedEvent(data, error)
                completion()
                return
            }

            self.configureAudioSession()
            let call = Call(uuid: uuid, data: data)
            call.handle = data.handle
            self.callController.addCall(call)
            self.sendEvent(
                StreamVideoIncomingCallConstants.ACTION_CALL_INCOMING, data.toJSON())
            self.endCallNotExist(data)
            completion()
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
            self.sendMuteEvent(callId.uuidString, isMuted)
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
            self.sendHoldEvent(callId.uuidString, onHold)
        } else {
            self.callController.holdCall(call: call, onHold: onHold)
        }
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
    private func incomingCallErrorCode(_ error: Error) -> String {
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

    func sendDefaultAudioInterruptionNofificationToStartAudioResource() {
        var userInfo: [AnyHashable: Any] = [:]
        let intrepEndeRaw = AVAudioSession.InterruptionType.ended.rawValue
        userInfo[AVAudioSessionInterruptionTypeKey] = intrepEndeRaw
        userInfo[AVAudioSessionInterruptionOptionKey] =
            AVAudioSession.InterruptionOptions.shouldResume.rawValue
        NotificationCenter.default.post(
            name: AVAudioSession.interruptionNotification, object: self, userInfo: userInfo)
    }

    func configureAudioSession() {
        if data?.configureAudioSession != false {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(
                    AVAudioSession.Category.playAndRecord,
                    options: [
                        .allowBluetoothA2DP,
                        .duckOthers,
                        .allowBluetooth,
                    ])

                try session.setMode(self.getAudioSessionMode(data?.audioSessionMode))
                try session.setActive(data?.audioSessionActive ?? true)
                try session.setPreferredSampleRate(data?.audioSessionPreferredSampleRate ?? 44100.0)
                try session.setPreferredIOBufferDuration(
                    data?.audioSessionPreferredIOBufferDuration ?? 0.005)
            } catch {
                print(error)
            }
        }
    }

    func getAudioSessionMode(_ audioSessionMode: String?) -> AVAudioSession.Mode {
        var mode = AVAudioSession.Mode.default
        switch audioSessionMode {
        case "gameChat":
            mode = AVAudioSession.Mode.gameChat
            break
        case "measurement":
            mode = AVAudioSession.Mode.measurement
            break
        case "moviePlayback":
            mode = AVAudioSession.Mode.moviePlayback
            break
        case "spokenAudio":
            mode = AVAudioSession.Mode.spokenAudio
            break
        case "videoChat":
            mode = AVAudioSession.Mode.videoChat
            break
        case "videoRecording":
            mode = AVAudioSession.Mode.videoRecording
            break
        case "voiceChat":
            mode = AVAudioSession.Mode.voiceChat
            break
        case "voicePrompt":
            if #available(iOS 12.0, *) {
                mode = AVAudioSession.Mode.voicePrompt
            } else {
                // Fallback on earlier versions
            }
            break
        default:
            mode = AVAudioSession.Mode.default
        }
        return mode
    }

    //MARK: - CXProviderDelegate
    public func providerDidReset(_ provider: CXProvider) {
        for call in self.callController.calls {
            call.endCall()
        }
        self.callController.removeAllCalls()
    }

    public func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        let call = Call(uuid: action.callUUID, data: self.data!, isOutGoing: true)
        call.handle = action.handle.value
        configureAudioSession()
        call.hasStartedConnectDidChange = { [weak self] in
            self?.sharedProvider?.reportOutgoingCall(
                with: call.uuid, startedConnectingAt: call.connectData)
        }
        call.hasConnectDidChange = { [weak self] in
            self?.sharedProvider?.reportOutgoingCall(
                with: call.uuid, connectedAt: call.connectedData)
        }
        self.outgoingCall = call
        self.callController.addCall(call)
        self.sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_START, self.data?.toJSON())
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard let call = self.callController.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        self.configureAudioSession()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200)) {
            self.configureAudioSession()
        }

        call.hasConnectDidChange = { [weak self] in
            self?.sharedProvider?.reportOutgoingCall(
                with: call.uuid, connectedAt: call.connectedData)
        }
        self.data?.isAccepted = true
        self.answerCall = call
        sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_ACCEPT, self.data?.toJSON())
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        guard let call = self.callController.callWithUUID(uuid: action.callUUID) else {
            if self.answerCall == nil && self.outgoingCall == nil {
                sendEvent(
                    StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT, self.data?.toJSON())
            } else {
                sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_ENDED, self.data?.toJSON())
            }
            action.fail()
            return
        }
        call.endCall()
        self.callController.removeCall(call)
        if self.answerCall == nil && self.outgoingCall == nil {
            sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_DECLINE, self.data?.toJSON())
            action.fulfill()
        } else {
            self.answerCall = nil
            sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_ENDED, call.data.toJSON())
            action.fulfill()
        }
    }

    public func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        guard let call = self.callController.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        call.isOnHold = action.isOnHold
        call.isMuted = action.isOnHold
        self.callController.setHold(call: call, onHold: action.isOnHold)
        sendHoldEvent(action.callUUID.uuidString, action.isOnHold)
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        guard let call = self.callController.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        call.isMuted = action.isMuted
        sendMuteEvent(action.callUUID.uuidString, action.isMuted)
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXSetGroupCallAction) {
        guard (self.callController.callWithUUID(uuid: action.callUUID)) != nil else {
            action.fail()
            return
        }
        self.sendEvent(
            StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_GROUP,
            [
                "id": action.callUUID.uuidString,
                "callUUIDToGroupWith": action.callUUIDToGroupWith?.uuidString,
            ])
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXPlayDTMFCallAction) {
        guard (self.callController.callWithUUID(uuid: action.callUUID)) != nil else {
            action.fail()
            return
        }
        self.sendEvent(
            StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_DTMF,
            [
                "id": action.callUUID.uuidString, "digits": action.digits,
                "type": action.type.rawValue,
            ])
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        guard let call = self.callController.callWithUUID(uuid: action.uuid) else {
            action.fail()
            return
        }
        sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT, self.data?.toJSON())
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        if self.answerCall?.hasConnected ?? false {
            sendDefaultAudioInterruptionNofificationToStartAudioResource()
            return
        }
        if self.outgoingCall?.hasConnected ?? false {
            sendDefaultAudioInterruptionNofificationToStartAudioResource()
            return
        }
        self.outgoingCall?.startCall(withAudioSession: audioSession) { success in
            if success {
                self.callController.addCall(self.outgoingCall!)
                self.outgoingCall?.startAudio()
            }
        }
        self.answerCall?.answerCall(withAudioSession: audioSession) { success in
            if success {
                self.answerCall?.startAudio()
            }
        }
        sendDefaultAudioInterruptionNofificationToStartAudioResource()
        configureAudioSession()

        self.sendEvent(
            StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION, ["isActive": true]
        )
    }

    public func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        if self.outgoingCall?.isOnHold ?? false || self.answerCall?.isOnHold ?? false {
            print("Call is on hold")
            return
        }

        self.sendEvent(
            StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION,
            ["isActive": false])
    }

    private func sendMuteEvent(_ id: String, _ isMuted: Bool) {
        self.sendEvent(
            StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_MUTE,
            ["id": id, "isMuted": isMuted])
    }

    private func sendHoldEvent(_ id: String, _ isOnHold: Bool) {
        self.sendEvent(
            StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_HOLD,
            ["id": id, "isOnHold": isOnHold])
    }

}

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

    /// Calls CallKit put on hold for another call, such as a cellular call the user answered.
    /// They are resumed when that other call ends; holds the app requested are not.
    private var callsHeldForOtherCall = Set<UUID>()
    /// Holds requested through `holdCall`, until CallKit performs them.
    private var appRequestedHolds = Set<UUID>()

    /// Where a call taken off hold stands with its audio session, see `reRegister`.
    private enum ResumeState {
        /// CallKit has not activated a usable session since the resume: none at all, or one the
        /// audio engine could not start on.
        case withoutSession
        /// CallKit activated the session after the resume.
        case activated
    }
    /// Calls taken off hold, until they are held again, ended or registered with CallKit again.
    private var resumes = [UUID: ResumeState]()
    /// Calls being registered with CallKit a second time, by the uuid of the new registration.
    private var reRegistrations = [UUID: Call]()

    private override init() {
        callController = StreamCallKitCallController()
        super.init()
        callController.setCallObserverDelegate(self)
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleApplicationDidBecomeActive(_:)),
            name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleAudioEngineStartFailed(_:)),
            name: StreamVideoIncomingCallConstants.AUDIO_ENGINE_START_FAILED_NOTIFICATION,
            object: nil)
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
                    self.data = self.storedCallData(for: getArgs)
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
                    self.data = self.storedCallData(for: getArgs)
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
            if onHold {
                appRequestedHolds.insert(call.uuid)
            }
            self.callController.holdCall(call: call, onHold: onHold)
        }
    }

    /// Returns the options already stored for the call that `args` names.
    ///
    /// `callConnected` and `endCall` send only the id, so rebuilding `CallData` from their args
    /// would reset the call's options to defaults.
    private func storedCallData(for args: [String: Any]) -> CallData {
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
        let uuidString = self.isFromPushKit ? self.data!.uuid : data.uuid
        if self.isFromPushKit {
            self.isFromPushKit = false
            self.sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_ENDED, data.toJSON())
        }
        guard let uuid = UUID(uuidString: uuidString) else { return }
        // A call registered with CallKit again is ended by the uuid CallKit knows it by.
        let call = self.callController.callWithUUID(uuid: uuid) ?? Call(uuid: uuid, data: data)
        if call.originalUUID != nil {
            setIncludesCallsInRecents(false)
        }
        self.callController.endCall(call: call)
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
        if self.callController.calls.contains(where: { $0.originalUUID != nil }) {
            setIncludesCallsInRecents(false)
        }
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

        // A call registered with CallKit again is reported by the uuid CallKit knows it by.
        let call = self.callController.callWithUUID(uuid: callUUID)
        if call?.originalUUID != nil {
            setIncludesCallsInRecents(false)
        }
        self.sharedProvider?.reportCall(
            with: call?.uuid ?? callUUID, endedAt: Date(), reason: endedReason)
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

    /// Applies `data`'s audio session options, or the stored call's when `data` is nil.
    func configureAudioSession(_ data: CallData? = nil) {
        let data = data ?? self.data
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
                // Not activated here: CallKit activates the session for its calls and reports
                // it through `didActivate`. A session the app activates itself is a plain
                // play-and-record session that keeps CallKit's own from activating.
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
        callsHeldForOtherCall.removeAll()
        appRequestedHolds.removeAll()
        resumes.removeAll()
        reRegistrations.removeAll()
        restoreAudioEngineIfIdle()
        setIncludesCallsInRecents(true)
    }

    public func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        guard
            let data = self.callController.takePendingOutgoingCall(uuid: action.callUUID)
                ?? self.data
        else {
            NSLog("startCall: no call data for \(action.callUUID), failing the start action")
            action.fail()
            return
        }
        if let previous = reRegistrations.removeValue(forKey: action.callUUID) {
            let call = completeReRegistration(
                of: previous, as: action.callUUID, handle: action.handle.value)
            action.fulfill()
            // Reported after the start action, as for any outgoing call.
            self.sharedProvider?.reportOutgoingCall(
                with: call.uuid, startedConnectingAt: call.connectData)
            self.sharedProvider?.reportOutgoingCall(with: call.uuid, connectedAt: call.connectedData)
            return
        }
        let call = Call(uuid: action.callUUID, data: data, isOutGoing: true)
        call.handle = action.handle.value
        configureAudioSession(data)
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
        self.sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_START, data.toJSON())
        action.fulfill()
    }

    // MARK: - Registering a call with CallKit again

    /// The app came to the foreground: resumed calls without a usable audio session are
    /// registered with CallKit again, see `reRegister`.
    @objc private func handleApplicationDidBecomeActive(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.reRegisterResumedCallsWithoutSession()
        }
    }

    /// The WebRTC plugin could not start the audio engine on the session CallKit activated.
    /// That happens when the user ends the phone call on this device: CallKit takes this call
    /// off hold and activates its session at once, while the app is still in the background
    /// behind the phone app, and iOS refuses microphone input to an app in the background. The
    /// engine does not recover from that on its own, nor from a later start on the same
    /// session, so the resumed call is registered with CallKit again for a session it can use.
    @objc private func handleAudioEngineStartFailed(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            for (uuid, state) in self.resumes where state == .activated {
                self.resumes[uuid] = .withoutSession
            }
            self.reRegisterResumedCallsWithoutSession()
        }
    }

    /// Registers the resumed calls without a usable audio session with CallKit again, see
    /// `reRegister`. Only in the foreground, where the engine can start on the new session;
    /// in the background they wait for `handleApplicationDidBecomeActive`.
    private func reRegisterResumedCallsWithoutSession() {
        guard !hasOtherAppsActiveCall, UIApplication.shared.applicationState == .active else {
            return
        }
        for call in self.callController.calls
        where !call.hasEnded && !call.isOnHold && resumes[call.uuid] == .withoutSession {
            reRegister(call)
        }
    }

    /// Ends `call` with CallKit and starts it again as a new, connected outgoing call.
    ///
    /// CallKit activates the audio session for every call it starts. That is the one way left
    /// to get a session with audio for a call CallKit took off hold without one: after the
    /// other party ended the call that interrupted it, CallKit leaves the resumed call's session
    /// inactive, iOS does not post the interruption end at which the app may activate, a
    /// session the app activates at any other moment has no audio hardware behind it, and a
    /// further hold and resume gets no activation either.
    ///
    /// The app is not told: the new registration reports the original id, so hold, mute and
    /// end events keep their id, and requests from the app for the original id resolve to it.
    /// The system call screen shows the call ending and a new one starting; Recents keeps the
    /// original call only, see `setIncludesCallsInRecents`.
    private func reRegister(_ call: Call) {
        let newUUID = UUID()
        NSLog("[StreamCallKit] registering \(call.uuid) with CallKit again as \(newUUID)")
        resumes[call.uuid] = nil
        reRegistrations[newUUID] = call
        self.sharedProvider?.reportCall(with: call.uuid, endedAt: nil, reason: .remoteEnded)
        setIncludesCallsInRecents(false)
        startReRegistration(of: call, as: newUUID, attempt: 0)
    }

    /// Keeps a call registered with CallKit a second time out of the system's Recents list,
    /// where it would show as a second, outgoing call to the same party next to the original
    /// one. The provider's configuration is replaced with the flag off before the new
    /// registration is started, and again before a re-registered call ends, in case CallKit
    /// reads the flag when it writes the entry rather than when the call starts. The app's own
    /// setting is put back once no call is left; a new call's `initCallkitProvider` restores it
    /// as well.
    private func setIncludesCallsInRecents(_ included: Bool) {
        guard #available(iOS 11.0, *), let provider = self.sharedProvider else { return }
        let value = included && (self.data?.includesCallsInRecents ?? true)
        let configuration = provider.configuration
        guard configuration.includesCallsInRecents != value else { return }
        configuration.includesCallsInRecents = value
        provider.configuration = configuration
    }

    /// Requests the start of the new registration, again when CallKit refuses it. Right after
    /// the other app's call ended, CallKit refuses a new call with `maximumCallGroupsReached`:
    /// it still counts that call, and the registration just reported as ended, for a moment.
    private func startReRegistration(of call: Call, as newUUID: UUID, attempt: Int) {
        let delays: [TimeInterval] = [0.5, 1, 2]
        self.callController.startCall(call.data, uuid: newUUID) { [weak self] started in
            DispatchQueue.main.async {
                guard let self, !started, self.reRegistrations[newUUID] === call else { return }
                guard attempt < delays.count, !call.hasEnded else {
                    NSLog(
                        "[StreamCallKit] CallKit refused to register \(call.uuid) again as "
                            + "\(newUUID) \(attempt + 1) times; giving up")
                    self.reRegistrations[newUUID] = nil
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + delays[attempt]) { [weak self] in
                    guard let self, self.reRegistrations[newUUID] === call, !call.hasEnded else {
                        return
                    }
                    NSLog(
                        "[StreamCallKit] registering \(call.uuid) again as \(newUUID), "
                            + "attempt \(attempt + 2)")
                    self.startReRegistration(of: call, as: newUUID, attempt: attempt + 1)
                }
            }
        }
    }

    /// CallKit performed the start of the new registration: `previous` is replaced by a call
    /// that is connected from the start, reports `previous`'s id, and answers to its uuid. The
    /// activation that follows restarts the audio engine; it is not a first activation, so the
    /// audio session is not reconfigured under it.
    private func completeReRegistration(of previous: Call, as uuid: UUID, handle: String) -> Call {
        let call = Call(uuid: uuid, data: previous.data, isOutGoing: true)
        call.handle = handle
        call.originalUUID = previous.originalUUID ?? previous.uuid
        call.reportedId = previous.reportedId
            ?? self.callController.reportedId(for: previous.uuid)
        call.isMuted = previous.isMuted
        call.hasStartedConnecting = true
        call.hasConnected = true
        previous.endCall()
        self.callController.removeCall(previous)
        callsHeldForOtherCall.remove(previous.uuid)
        appRequestedHolds.remove(previous.uuid)
        if self.answerCall === previous {
            self.answerCall = nil
        }
        self.outgoingCall = call
        self.callController.addCall(call)
        NSLog("[StreamCallKit] \(previous.uuid) is now registered as \(uuid)")
        return call
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
        if call.originalUUID != nil {
            setIncludesCallsInRecents(false)
        }
        call.endCall()
        self.callController.removeCall(call)
        callsHeldForOtherCall.remove(call.uuid)
        appRequestedHolds.remove(call.uuid)
        resumes[call.uuid] = nil
        restoreAudioEngineIfIdle()
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
        NSLog("[StreamCallKit] CXSetHeldCallAction \(action.callUUID), isOnHold: \(action.isOnHold)")
        // CallKit is telling the app about a hold it already performs (a cellular call, or a
        // `holdCall` request). Requesting another hold transaction from here made CallKit call
        // this handler again for it, without end: thousands of hold events per second, and a
        // flooded main thread for as long as the call was held.
        call.isOnHold = action.isOnHold
        call.isMuted = action.isOnHold
        // Remember a hold CallKit made for another call, so it is resumed when that call ends.
        // CallKit does not resume a held VoIP call by itself once the other call ends.
        let requestedByApp = appRequestedHolds.remove(call.uuid) != nil
        if action.isOnHold && !requestedByApp && hasOtherAppsActiveCall {
            callsHeldForOtherCall.insert(call.uuid)
        } else {
            callsHeldForOtherCall.remove(call.uuid)
        }
        // CallKit activates the audio session for the resumed call only when the user ended the
        // other call on this device. When the other party ended it, CallKit leaves the session
        // inactive, and no activation the app makes carries audio; see `reRegister`.
        resumes[call.uuid] = action.isOnHold ? nil : .withoutSession
        sendHoldEvent(self.callController.reportedId(for: action.callUUID), action.isOnHold)
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        guard let call = self.callController.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        call.isMuted = action.isMuted
        sendMuteEvent(self.callController.reportedId(for: action.callUUID), action.isMuted)
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
                "id": self.callController.reportedId(for: action.callUUID),
                "callUUIDToGroupWith": action.callUUIDToGroupWith.map {
                    self.callController.reportedId(for: $0)
                },
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
                "id": self.callController.reportedId(for: action.callUUID),
                "digits": action.digits,
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
        // A call resuming from hold is activated again. Only the first activation of a call
        // starts it and applies the default audio session configuration: the SDK configures the
        // session itself once the call is joined, and re-applying the defaults on a resume would
        // change the category, mode and sample rate under the audio engine while it restarts, and
        // drop the output route the user chose. `hasConnected` alone is not enough to tell the
        // two apart, since it is only set by apps that call `setCallConnected`.
        let hasConnected =
            (self.answerCall?.hasConnected ?? false) || (self.outgoingCall?.hasConnected ?? false)
        let hasStartedConnecting =
            (self.answerCall?.hasStartedConnecting ?? false)
            || (self.outgoingCall?.hasStartedConnecting ?? false)
        let isFirstActivation = !hasConnected && !hasStartedConnecting
        NSLog("[StreamCallKit] didActivate audio session, firstActivation: \(isFirstActivation)")
        if isFirstActivation {
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
        }
        for uuid in resumes.keys {
            resumes[uuid] = .activated
        }
        // WebRTC is told first, so its own session state matches before the audio engine is
        // allowed to start on the session.
        postAudioEngineAvailability(true, audioSessionActive: true)
        sendDefaultAudioInterruptionNofificationToStartAudioResource()
        self.sendEvent(
            StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION, ["isActive": true]
        )
        if isFirstActivation {
            configureAudioSession()
        }
    }

    public func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        NSLog("[StreamCallKit] didDeactivate audio session, ongoing calls: \(hasOngoingCalls)")
        // CallKit took the audio session away, for a hold or another call as much as for the end
        // of this one. The WebRTC audio engine must stay down until `didActivate` hands the
        // session back: an engine restarted in between runs on a session the app does not own,
        // plays and records nothing, and never recovers. Once no call is left there is no
        // activation to wait for, so the gate is lifted instead and a call that starts without
        // CallKit is not held back.
        postAudioEngineAvailability(!hasOngoingCalls, audioSessionActive: false)
        if !hasOngoingCalls {
            setIncludesCallsInRecents(true)
        }

        // A deactivation right after a call was taken off hold is CallKit leaving the resumed
        // call without a session, see `reRegister`. With the app in the foreground already,
        // nothing else would trigger the new registration until the user left and came back.
        DispatchQueue.main.async { [weak self] in
            self?.reRegisterResumedCallsWithoutSession()
        }

        self.sendEvent(
            StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION,
            ["isActive": false])
    }

    // MARK: - Audio engine availability

    private var hasOngoingCalls: Bool {
        self.callController.calls.contains { !$0.hasEnded }
    }

    /// Gates the audio engine of every `stream_webrtc_flutter` peer-connection factory, including
    /// the ones built later, and, when `audioSessionActive` is given, tells WebRTC's audio session
    /// that CallKit activated or deactivated the app's audio session. See
    /// `FlutterWebRTCPlugin.setAudioEngineAvailable:` and `setCallKitAudioSessionActive:`.
    private func postAudioEngineAvailability(_ available: Bool, audioSessionActive: Bool? = nil) {
        var userInfo: [AnyHashable: Any] = [
            StreamVideoIncomingCallConstants.AUDIO_ENGINE_AVAILABLE_KEY: available
        ]
        if let audioSessionActive {
            userInfo[StreamVideoIncomingCallConstants.AUDIO_SESSION_ACTIVE_KEY] = audioSessionActive
        }
        NotificationCenter.default.post(
            name: StreamVideoIncomingCallConstants.AUDIO_ENGINE_AVAILABILITY_NOTIFICATION,
            object: self,
            userInfo: userInfo)
    }

    /// Lifts the gate once CallKit has no call left to activate the session for. A call that
    /// ends while the session is already inactive gets no `didDeactivate`, so this runs when
    /// calls are removed as well.
    private func restoreAudioEngineIfIdle() {
        if !hasOngoingCalls {
            postAudioEngineAvailability(true)
        }
    }

    // MARK: - Resuming after another call

    /// Whether a call this app did not report is still going on, such as a cellular call.
    private var hasOtherAppsActiveCall: Bool {
        self.callController.observedCalls.contains {
            !$0.hasEnded && self.callController.callWithUUID(uuid: $0.uuid) == nil
        }
    }

    /// Takes the calls CallKit held for another call off hold once no other call is left.
    /// CallKit performs the hold action with `isOnHold: false`. It activates the audio session
    /// only when the user ended the other call on this device; otherwise the call is registered
    /// with CallKit again, see `reRegister`.
    private func resumeCallsHeldForOtherCall() {
        guard !callsHeldForOtherCall.isEmpty, !hasOtherAppsActiveCall else { return }
        for call in self.callController.calls
        where !call.hasEnded && call.isOnHold && callsHeldForOtherCall.remove(call.uuid) != nil {
            NSLog("[StreamCallKit] resuming \(call.uuid), held for a call that has ended")
            self.callController.holdCall(call: call, onHold: false)
        }
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

@available(iOS 10.0, *)
extension StreamVideoCallkitManager: CXCallObserverDelegate {
    public func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        // Only the end of another app's call matters here: this app's own calls end through
        // the provider's end action.
        guard call.hasEnded, self.callController.callWithUUID(uuid: call.uuid) == nil else {
            return
        }
        NSLog("[StreamCallKit] another app's call \(call.uuid) ended")
        resumeCallsHeldForOtherCall()
    }
}

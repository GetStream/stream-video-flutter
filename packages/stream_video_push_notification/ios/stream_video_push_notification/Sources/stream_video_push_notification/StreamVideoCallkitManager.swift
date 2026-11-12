import AVFoundation
import CallKit
import Flutter
import UIKit

final class StreamVideoCallkitManager: NSObject, CXProviderDelegate {

    static let shared = StreamVideoCallkitManager()

    /// Every event bound for Dart goes through here.
    let eventSink = RingingEventSink()

    /// Every call the plugin tracks.
    var store = CallKitCallStore()

    let transactions = CallKitTransactionRequester()

    /// Configures the audio session and tells WebRTC when it may use it.
    var audio = CallKitAudioSessionCoordinator() {
        didSet { observeEngineStartFailures() }
    }
    /// How long after answering the answered call's audio session options are applied again.
    var reconfigureAfterAnswerDelay: DispatchTimeInterval = .milliseconds(1200)

    /// Brings a call's audio back after another app's call held it.
    var holdRecovery: HoldRecovery!

    /// The options Recents was turned off for, while a call registered again with CallKit is
    /// left. Nil while Recents follows the options.
    var recentsSuppressedFor: CallData?

    /// Keeps the app running while Dart acts on a call CallKit ended.
    var callEndGracePeriod = CallEndGracePeriod()

    var sharedProvider: CXProvider? = nil

    private override init() {
        super.init()
        transactions.onEndRefused = { [weak self] uuid in
            self?.clearCallAfterRefusedEnd(uuid)
        }
        holdRecovery = HoldRecovery(store: { [unowned self] in self.store })
        holdRecovery.actions = self
        observeEngineStartFailures()
    }

    private func observeEngineStartFailures() {
        audio.onEngineStartFailed = { [weak self] in
            self?.holdRecovery.audioEngineStartFailed()
        }
    }

    func getAcceptedCall() -> CallData? {
        let data = store.lastOptions
        let answeredId = store.answeredCall?.identity.appId
        NSLog("Call data ids \(String(describing: data?.uuid)) \(String(describing: answeredId))")
        if data?.uuid.lowercased() == answeredId?.lowercased() {
            return data
        }
        return nil
    }

    func showIncomingCall(_ data: CallData, fromPushKit: Bool) {
        showIncomingCall(data, fromPushKit: fromPushKit, completion: nil)
    }

    /// Reports an incoming call to CallKit.
    ///
    /// `completion` runs once CallKit has accepted or refused the call, or straight away when the
    /// call could not be reported at all.
    func showIncomingCall(
        _ data: CallData, fromPushKit: Bool, completion: (() -> Void)?
    ) {
        store.showRequested(data, fromPushKit: fromPushKit)

        let callUpdate = self.callUpdate(data)

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
            self.apply(
                self.store.incomingReported(
                    data, uuid: uuid, source: fromPushKit ? .pushKit : .app))
            self.endCallNotExist(data)
            completion?()
        }
    }

    func startCall(_ data: CallData, fromPushKit: Bool) {
        store.startRequested(data, fromPushKit: fromPushKit)
        initCallkitProvider(data)
        requestStart(data)
    }

    /// Asks CallKit to start `data` as an outgoing call, and gives CallKit the call's details
    /// once it has.
    private func requestStart(_ data: CallData) {
        let handle = self.handle(data)

        guard let uuid = UUID(uuidString: data.uuid) else {
            print("Error: Invalid UUID string: \(data.uuid)")
            return
        }

        store.registerPendingOutgoing(data, uuid: uuid)

        transactions.start(uuid: uuid, handle: handle, isVideo: data.type > 0) { started in
            guard started else {
                NSLog(
                    "[StreamCallKit] CallKit refused to start the outgoing call \(data.uuid); "
                        + "Dart's end and connection of it are ignored")
                self.store.startRefused(uuid: uuid, options: data)
                return
            }

            self.sharedProvider?.reportCall(with: uuid, updated: self.callUpdate(data))
        }
    }

    func handle(_ data: CallData) -> CXHandle {
        CXHandle(type: getHandleType(data.handleType), value: data.getEncryptHandle())
    }

    /// What CallKit shows and allows for `data`.
    func callUpdate(_ data: CallData) -> CXCallUpdate {
        let callUpdate = CXCallUpdate()
        callUpdate.remoteHandle = handle(data)
        callUpdate.supportsDTMF = data.supportsDTMF
        callUpdate.supportsHolding = data.supportsHolding
        callUpdate.supportsGrouping = data.supportsGrouping
        callUpdate.supportsUngrouping = data.supportsUngrouping
        callUpdate.hasVideo = data.type > 0
        callUpdate.localizedCallerName = data.callerName
        return callUpdate
    }

    func muteCall(_ callId: String, isMuted: Bool) {
        guard let call = store.call(forAppId: callId) else {
            return
        }
        if call.isMuted == isMuted {
            apply([store.muteEvent(call, isMuted)])
        } else {
            transactions.mute(uuid: call.identity.callKitUUID, isMuted: isMuted)
        }
    }

    func holdCall(_ callId: String, onHold: Bool) {
        guard let call = store.call(forAppId: callId) else {
            return
        }
        if call.isOnHold == onHold {
            apply([store.holdEvent(call, onHold)])
        } else {
            let uuid = call.identity.callKitUUID
            if onHold {
                holdRecovery.holdRequested(uuid)
            }
            transactions.hold(uuid: uuid, onHold: onHold) { [weak self] accepted in
                if onHold && !accepted {
                    self?.holdRecovery.holdRefused(uuid)
                }
            }
        }
    }

    func endCall(_ data: CallData) {
        let uuid: UUID
        let sentEnded = store.actsOnPushKitCall(forAppId: data.uuid)
        if sentEnded {
            uuid = store.callKitUUID(forAppId: store.lastOptions!.uuid)!
            store.isFromPushKit = false
            self.sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_ENDED, data.toJSON())
        } else {
            uuid = store.callKitUUID(forAppId: data.uuid)!
        }
        if let call = store.call(forCallKit: uuid), case .reRegistering = call.phase {
            // CallKit already took the call as ended, so an end action would be refused.
            endReRegisteringCall(call, reason: nil, notifyDart: !sentEnded)
            return
        }
        transactions.end(uuid: uuid)
    }

    func connectedCall(_ data: CallData) {
        let uuid: UUID
        if store.actsOnPushKitCall(forAppId: data.uuid) {
            uuid = store.callKitUUID(forAppId: store.lastOptions!.uuid)!
            store.isFromPushKit = false
        } else {
            uuid = store.callKitUUID(forAppId: data.uuid)!
        }
        guard let (call, effects) = store.connected(uuid: uuid) else {
            return
        }
        apply(effects)
        if call.direction == .incoming {
            transactions.answer(uuid: uuid)
        }
    }

    func activeCalls() -> [[String: Any]] {
        return store.activeCalls(systemCallUUIDs: transactions.systemCallUUIDs)
    }

    func endAllCalls() {
        store.allCallsEndRequested()
        transactions.endAll()
    }

    /// Clears the CallKit UI and the store's call after CallKit refused to end it.
    ///
    /// Reporting the call as ended goes through the provider instead of the call controller, so
    /// it clears the UI when the controller will not take the transaction. Only the provider that
    /// reported a call can end it this way, so this covers calls this process knows about.
    private func clearCallAfterRefusedEnd(_ uuid: UUID) {
        suppressRecentsIfRegisteredAgain(store.call(forCallKit: uuid))
        sharedProvider?.reportCall(with: uuid, endedAt: Date(), reason: .remoteEnded)
        // Reporting the end does not run the `CXEndCallAction` delegate, which is what normally
        // removes the call.
        store.endRefused(uuid: uuid)
        callsRemoved()
    }

    /// Reports to CallKit how a call ended, which is what decides how it is listed in Recents.
    ///
    /// `reason` matches the raw values of `CXCallEndedReason`: 1 failed, 2 remoteEnded,
    /// 3 unanswered, 4 answeredElsewhere, 5 declinedElsewhere.
    func saveEndCall(_ uuid: String, _ reason: Int) {
        guard let callUUID = store.callKitUUID(forAppId: uuid) else {
            NSLog("saveEndCall: invalid UUID \(uuid)")
            return
        }
        guard let endedReason = CXCallEndedReason(rawValue: reason == 6 ? 2 : reason) else {
            NSLog("saveEndCall: unsupported reason \(reason)")
            return
        }

        if let call = store.call(forCallKit: callUUID), case .reRegistering = call.phase {
            endReRegisteringCall(call, reason: endedReason, notifyDart: false)
            return
        }
        suppressRecentsIfRegisteredAgain(store.call(forCallKit: callUUID))
        self.sharedProvider?.reportCall(with: callUUID, endedAt: Date(), reason: endedReason)
        store.endReported(uuid: callUUID, reason: endedReason)
        callsRemoved()
    }

    func endCallNotExist(_ data: CallData) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(data.duration)) {
            if self.store.shouldTimeOut(appId: data.uuid) {
                self.callEndTimeout(data)
            }
        }
    }

    func callEndTimeout(_ data: CallData) {
        self.saveEndCall(data.uuid, 3)
        apply(store.timedOut(data))
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

    func initCallkitProvider(_ data: CallData) {
        if !store.hasOngoingCall {
            // No registered-again call is left to keep out of Recents.
            recentsSuppressedFor = nil
        }
        if let sharedProvider = self.sharedProvider {
            // The provider outlives individual calls, so refreshing its configuration is the only
            // way a ringtone, icon or Recents setting delivered after the first call takes effect.
            sharedProvider.configuration = createConfiguration(
                data, includesCallsInRecents: recentsSuppressedFor == nil ? nil : false)
            // Re-assert the delegate: Apple requires it to be set before `reportNewIncomingCall`,
            // and it can be dropped when the provider is carried across a plugin re-registration.
            sharedProvider.setDelegate(self, queue: nil)
        } else {
            let provider = CXProvider(configuration: createConfiguration(data))
            provider.setDelegate(self, queue: nil)
            self.sharedProvider = provider
        }
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

    func createConfiguration(
        _ data: CallData, includesCallsInRecents: Bool? = nil
    ) -> CXProviderConfiguration {
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
            configuration.includesCallsInRecents =
                includesCallsInRecents ?? data.includesCallsInRecents
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

import AVFoundation
import CallKit
import Flutter
import UIKit

@available(iOS 10.0, *)
public class StreamVideoCallkitManager: NSObject, CXProviderDelegate {

    @objc public static let shared = StreamVideoCallkitManager()

    /// Every event bound for Dart goes through here.
    let eventSink = RingingEventSink()

    /// Every call the plugin tracks.
    var store = CallKitCallStore()

    let transactions = CallKitTransactionRequester()

    /// Configures the audio session and tells WebRTC when it may use it.
    var audio = CallKitAudioSessionCoordinator()

    var sharedProvider: CXProvider? = nil

    private override init() {
        super.init()
        transactions.onEndRefused = { [weak self] uuid in
            self?.clearCallAfterRefusedEnd(uuid)
        }
    }

    @objc public func getAcceptedCall() -> CallData? {
        let data = store.lastOptions
        let answeredUUID = store.answeredCall?.identity.callKitUUID
        NSLog(
            "Call data ids \(String(describing: data?.uuid)) \(String(describing: answeredUUID?.uuidString))"
        )
        if data?.uuid.lowercased() == answeredUUID?.uuidString.lowercased() {
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
        store.showRequested(data, fromPushKit: fromPushKit)

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
            self.apply(
                self.store.incomingReported(
                    data, uuid: uuid, source: fromPushKit ? .pushKit : .app))
            self.endCallNotExist(data)
            completion?()
        }
    }

    @objc public func startCall(_ data: CallData, fromPushKit: Bool) {
        store.startRequested(data, fromPushKit: fromPushKit)
        initCallkitProvider(data)
        requestStart(data)
    }

    /// Asks CallKit to start `data` as an outgoing call, and gives CallKit the call's details
    /// once it has.
    private func requestStart(_ data: CallData) {
        let handle = CXHandle(
            type: self.getHandleType(data.handleType), value: data.getEncryptHandle())

        guard let uuid = UUID(uuidString: data.uuid) else {
            print("Error: Invalid UUID string: \(data.uuid)")
            return
        }

        store.registerPendingOutgoing(data, uuid: uuid)

        transactions.start(uuid: uuid, handle: handle, isVideo: data.type > 0) { started in
            guard started else {
                self.store.dropPendingOutgoing(uuid: uuid, ifStill: data)
                return
            }

            let callUpdate = CXCallUpdate()
            callUpdate.remoteHandle = handle
            callUpdate.supportsDTMF = data.supportsDTMF
            callUpdate.supportsHolding = data.supportsHolding
            callUpdate.supportsGrouping = data.supportsGrouping
            callUpdate.supportsUngrouping = data.supportsUngrouping
            callUpdate.hasVideo = data.type > 0 ? true : false
            callUpdate.localizedCallerName = data.callerName
            self.sharedProvider?.reportCall(with: uuid, updated: callUpdate)
        }
    }

    @objc public func muteCall(_ callId: String, isMuted: Bool) {
        guard let call = store.call(forAppId: callId) else {
            return
        }
        if call.isMuted == isMuted {
            apply([store.muteEvent(call, isMuted)])
        } else {
            transactions.mute(uuid: call.identity.callKitUUID, isMuted: isMuted)
        }
    }

    @objc public func holdCall(_ callId: String, onHold: Bool) {
        guard let call = store.call(forAppId: callId) else {
            return
        }
        if call.isOnHold == onHold {
            apply([store.holdEvent(call, onHold)])
        } else {
            transactions.hold(uuid: call.identity.callKitUUID, onHold: onHold)
        }
    }

    @objc public func endCall(_ data: CallData) {
        let uuid: UUID
        if store.isFromPushKit {
            uuid = UUID(uuidString: store.lastOptions!.uuid)!
            store.isFromPushKit = false
            self.sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_ENDED, data.toJSON())
        } else {
            uuid = UUID(uuidString: data.uuid)!
        }
        transactions.end(uuid: uuid)
    }

    @objc public func connectedCall(_ data: CallData) {
        let uuid: UUID
        if store.isFromPushKit {
            uuid = UUID(uuidString: store.lastOptions!.uuid)!
            store.isFromPushKit = false
        } else {
            uuid = UUID(uuidString: data.uuid)!
        }
        guard let (call, effects) = store.connected(uuid: uuid) else {
            return
        }
        apply(effects)
        if call.direction == .incoming {
            transactions.answer(uuid: uuid)
        }
    }

    @objc public func activeCalls() -> [[String: Any]] {
        return store.activeCalls(systemCallUUIDs: transactions.systemCallUUIDs)
    }

    @objc public func endAllCalls() {
        store.allCallsEndRequested()
        transactions.endAll()
    }

    /// Clears the CallKit UI and the store's call after CallKit refused to end it.
    ///
    /// Reporting the call as ended goes through the provider instead of the call controller, so
    /// it clears the UI when the controller will not take the transaction. Only the provider that
    /// reported a call can end it this way, so this covers calls this process knows about.
    private func clearCallAfterRefusedEnd(_ uuid: UUID) {
        sharedProvider?.reportCall(with: uuid, endedAt: Date(), reason: .remoteEnded)
        // Reporting the end does not run the `CXEndCallAction` delegate, which is what normally
        // removes the call.
        store.endRefused(uuid: uuid)
        audio.callsRemoved(store)
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
        store.endReported(uuid: callUUID, reason: endedReason)
        audio.callsRemoved(store)
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

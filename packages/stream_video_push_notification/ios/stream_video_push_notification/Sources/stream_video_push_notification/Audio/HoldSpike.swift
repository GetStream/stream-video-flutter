import CallKit
import Foundation

/// Switches for the hold spike (FLU-1213), read from UserDefaults so the app can turn each one on
/// before a test. Spike code: not for merging.
enum HoldSpike {
    static let deferEngineUntilActiveKey = "io.getstream.holdSpike.deferEngineUntilActive"
    static let activateAfterUnholdKey = "io.getstream.holdSpike.activateAfterUnhold"
    static let reRegisterKey = "io.getstream.holdSpike.reRegister"

    /// 1. A resume activation that arrives while the app is in the background leaves the audio
    /// engine stopped until the app becomes active.
    static var deferEngineUntilActive: Bool {
        UserDefaults.standard.bool(forKey: deferEngineUntilActiveKey)
    }

    /// 2. When CallKit takes a call off hold and no activation follows within `activationWait`,
    /// the app activates the audio session itself.
    static var activateAfterUnhold: Bool {
        UserDefaults.standard.bool(forKey: activateAfterUnholdKey)
    }

    /// 3. When the audio engine fails to start, or an unhold brings no activation, the call is
    /// registered with CallKit again under a new uuid, in the foreground.
    static var reRegister: Bool {
        UserDefaults.standard.bool(forKey: reRegisterKey)
    }

    /// How long an activation is waited for after an unhold.
    static let activationWait: TimeInterval = 1.0

    /// Delays before a refused re-registration is requested again.
    static let reRegistrationRetryDelays: [TimeInterval] = [0.5, 1, 2]

    static func logSwitches() {
        NSLog(
            "[HoldSpike] switches: deferEngineUntilActive \(deferEngineUntilActive), "
                + "activateAfterUnhold \(activateAfterUnhold), reRegister \(reRegister)")
    }
}

extension StreamVideoCallkitManager {

    /// The answered or outgoing call that has not ended.
    private var liveCall: CallKitCall? {
        [store.answeredCall, store.outgoingCall].compactMap { $0 }.first { !$0.phase.isEnded }
    }

    /// Ends the live call with CallKit and starts it again under a new uuid, so CallKit
    /// activates a fresh audio session for it. Dart is not told: the call keeps its app id.
    func reRegisterLiveCall(reason: String) {
        guard let call = liveCall else {
            NSLog("[HoldSpike] no live call to register again (\(reason))")
            return
        }
        guard !holdSpikeReRegistrations.values.contains(where: { $0 === call }) else {
            NSLog("[HoldSpike] \(call.identity.appId) is already being registered again")
            return
        }
        let previous = call.identity.callKitUUID
        let newUUID = UUID()
        NSLog("[HoldSpike] registering \(previous) again as \(newUUID): \(reason)")
        holdSpikeReRegistrations[newUUID] = call
        sharedProvider?.reportCall(with: previous, endedAt: nil, reason: .remoteEnded)
        requestReRegistration(of: call, as: newUUID, attempt: 0)
    }

    private func requestReRegistration(of call: CallKitCall, as newUUID: UUID, attempt: Int) {
        let handle = CXHandle(
            type: getHandleType(call.options.handleType),
            value: call.options.getEncryptHandle())
        transactions.start(uuid: newUUID, handle: handle, isVideo: call.options.type > 0) {
            started in
            DispatchQueue.main.async {
                guard !started, self.holdSpikeReRegistrations[newUUID] === call else { return }
                let delays = HoldSpike.reRegistrationRetryDelays
                guard attempt < delays.count, !call.phase.isEnded else {
                    NSLog("[HoldSpike] CallKit refused \(newUUID) \(attempt + 1) times; giving up")
                    self.holdSpikeReRegistrations[newUUID] = nil
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + delays[attempt]) {
                    guard self.holdSpikeReRegistrations[newUUID] === call else { return }
                    NSLog("[HoldSpike] requesting \(newUUID) again, attempt \(attempt + 2)")
                    self.requestReRegistration(of: call, as: newUUID, attempt: attempt + 1)
                }
            }
        }
    }

    /// Completes a re-registration when CallKit performs its start action. Returns false for any
    /// other start action.
    func completeReRegistration(_ action: CXStartCallAction) -> Bool {
        guard let call = holdSpikeReRegistrations.removeValue(forKey: action.callUUID) else {
            return false
        }
        call.rebind(to: action.callUUID)
        action.fulfill()
        let now = Date()
        sharedProvider?.reportOutgoingCall(with: action.callUUID, startedConnectingAt: now)
        sharedProvider?.reportOutgoingCall(with: action.callUUID, connectedAt: now)
        NSLog("[HoldSpike] \(call.identity.appId) is now registered as \(action.callUUID)")
        return true
    }

    /// The uuid CallKit currently knows the call `id` names by.
    func currentCallKitUUID(forAppId id: String) -> UUID? {
        store.call(forAppId: id)?.identity.callKitUUID ?? UUID(uuidString: id)
    }
}

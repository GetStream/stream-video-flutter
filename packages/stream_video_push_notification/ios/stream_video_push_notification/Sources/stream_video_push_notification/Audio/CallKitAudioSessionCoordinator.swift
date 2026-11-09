import AVFoundation
import Foundation
import UIKit

/// The parts of `AVAudioSession` the coordinator sets.
protocol AudioSessionConfiguring {
    func setCategory(
        _ category: AVAudioSession.Category, options: AVAudioSession.CategoryOptions) throws
    func setMode(_ mode: AVAudioSession.Mode) throws
    func setPreferredSampleRate(_ sampleRate: Double) throws
    func setPreferredIOBufferDuration(_ duration: TimeInterval) throws
}

extension AVAudioSession: AudioSessionConfiguring {}

/// The only code that configures the audio session for CallKit calls, and the one that tells
/// WebRTC when it may use it.
final class CallKitAudioSessionCoordinator {

    private let session: AudioSessionConfiguring
    let gate: WebRTCAudioEngineGate

    // MARK: Hold spike (FLU-1213)

    /// Called to register the live call with CallKit again, with the reason.
    var onRecoveryNeeded: ((String) -> Void)?
    /// Whether a resume activation left the engine stopped until the app becomes active.
    private var isEngineDeferred = false
    /// A re-registration that waits for the app to become active.
    private var pendingRecoveryReason: String?
    /// The wait for an activation after an unhold.
    private var unholdWait: DispatchWorkItem?
    private var didBecomeActiveObserver: NSObjectProtocol?

    init(
        session: AudioSessionConfiguring = AVAudioSession.sharedInstance(),
        gate: WebRTCAudioEngineGate = WebRTCPluginAudioEngineGate()
    ) {
        self.session = session
        self.gate = gate
        self.gate.onEngineStartFailed = { [weak self] in
            NSLog("[StreamCallKit] WebRTC could not start the audio engine")
            if HoldSpike.reRegister {
                self?.requestRecovery("the audio engine did not start")
            }
        }
        didBecomeActiveObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main
        ) { [weak self] _ in
            self?.appDidBecomeActive()
        }
    }

    deinit {
        if let didBecomeActiveObserver = didBecomeActiveObserver {
            NotificationCenter.default.removeObserver(didBecomeActiveObserver)
        }
    }

    private var isAppActive: Bool {
        UIApplication.shared.applicationState == .active
    }

    private func appDidBecomeActive() {
        if isEngineDeferred {
            isEngineDeferred = false
            NSLog("[HoldSpike] app active: allowing the deferred audio engine")
            gate.update(available: true, callKitSessionActive: nil)
        }
        if let reason = pendingRecoveryReason {
            pendingRecoveryReason = nil
            NSLog("[HoldSpike] app active: registering the call again (\(reason))")
            onRecoveryNeeded?(reason)
        }
    }

    /// Registers the live call again now in the foreground, or once the app becomes active.
    private func requestRecovery(_ reason: String) {
        if isAppActive {
            onRecoveryNeeded?(reason)
        } else {
            NSLog("[HoldSpike] in the background: waiting for the app to register again (\(reason))")
            pendingRecoveryReason = reason
        }
    }

    /// CallKit took a call off hold. Starts the wait for an activation when a switch needs it.
    func callResumed() {
        HoldSpike.logSwitches()
        guard HoldSpike.activateAfterUnhold || HoldSpike.reRegister else { return }
        unholdWait?.cancel()
        let wait = DispatchWorkItem { [weak self] in
            self?.noActivationAfterUnhold()
        }
        unholdWait = wait
        DispatchQueue.main.asyncAfter(deadline: .now() + HoldSpike.activationWait, execute: wait)
    }

    private func noActivationAfterUnhold() {
        unholdWait = nil
        NSLog(
            "[HoldSpike] no activation within \(HoldSpike.activationWait) s of the unhold, "
                + "app active: \(isAppActive)")
        if HoldSpike.activateAfterUnhold {
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                NSLog("[HoldSpike] the app activated the audio session")
                gate.update(available: true, callKitSessionActive: true)
            } catch {
                NSLog("[HoldSpike] the app could not activate the audio session: \(error)")
                if HoldSpike.reRegister {
                    requestRecovery("the app could not activate the session")
                }
            }
            return
        }
        if HoldSpike.reRegister {
            requestRecovery("no activation after the unhold")
        }
    }

    // MARK: - CallKit audio session callbacks

    /// CallKit activated the audio session.
    ///
    /// On the first activation of the answered or outgoing call, the call starts connecting and
    /// the session gets `lastOptions`; a later activation, such as a resume, leaves the session
    /// as it is. Every activation allows the audio engine and is reported to Dart.
    func didActivate(_ store: CallKitCallStore) -> [CallKitEffect] {
        let isFirstActivation = store.isFirstAudioActivation
        var effects: [CallKitEffect] = isFirstActivation ? store.audioActivated() : []
        store.audioSessionActivated()

        unholdWait?.cancel()
        unholdWait = nil
        NSLog(
            "[HoldSpike] activation, first: \(isFirstActivation), app active: \(isAppActive)")
        if HoldSpike.deferEngineUntilActive && !isFirstActivation && !isAppActive {
            NSLog("[HoldSpike] resume activation in the background: engine deferred")
            isEngineDeferred = true
            gate.update(available: false, callKitSessionActive: true)
        } else {
            gate.update(available: true, callKitSessionActive: true)
        }
        effects.append(.postAudioInterruptionEnded)
        if isFirstActivation {
            effects.append(.configureAudioSession(store.lastOptions))
        }
        effects.append(
            .send(
                event: StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION,
                body: ["isActive": true]))
        return effects
    }

    /// CallKit deactivated the audio session.
    ///
    /// The audio engine is stopped while a call is left to activate the session again, and
    /// allowed when none is. Dart is told unless the answered or outgoing call is on hold.
    func didDeactivate(_ store: CallKitCallStore) -> [CallKitEffect] {
        isEngineDeferred = false
        NSLog("[HoldSpike] deactivation, app active: \(isAppActive)")
        gate.update(available: !store.hasOngoingCall, callKitSessionActive: false)
        if store.hasHeldCall {
            print("Call is on hold")
            return []
        }
        return [
            .send(
                event: StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_AUDIO_SESSION,
                body: ["isActive": false])
        ]
    }

    /// Calls in `store` ended or were removed; allows the audio engine once none is left.
    func callsRemoved(_ store: CallKitCallStore) {
        if !store.hasOngoingCall {
            gate.update(available: true, callKitSessionActive: nil)
        }
    }

    // MARK: - Session

    /// Applies `data`'s audio session options; nil applies the defaults. The session is left
    /// inactive: CallKit activates it.
    func configure(_ data: CallData?) {
        if data?.configureAudioSession != false {
            do {
                try session.setCategory(
                    AVAudioSession.Category.playAndRecord,
                    options: [
                        .allowBluetoothA2DP,
                        .duckOthers,
                        .allowBluetooth,
                    ])

                try session.setMode(Self.mode(for: data?.audioSessionMode))
                try session.setPreferredSampleRate(data?.audioSessionPreferredSampleRate ?? 44100.0)
                try session.setPreferredIOBufferDuration(
                    data?.audioSessionPreferredIOBufferDuration ?? 0.005)
            } catch {
                print(error)
            }
        }
    }

    /// Posts an ended interruption that asks audio code to resume.
    func postInterruptionEnded(object: Any?) {
        var userInfo: [AnyHashable: Any] = [:]
        let intrepEndeRaw = AVAudioSession.InterruptionType.ended.rawValue
        userInfo[AVAudioSessionInterruptionTypeKey] = intrepEndeRaw
        userInfo[AVAudioSessionInterruptionOptionKey] =
            AVAudioSession.InterruptionOptions.shouldResume.rawValue
        NotificationCenter.default.post(
            name: AVAudioSession.interruptionNotification, object: object, userInfo: userInfo)
    }

    static func mode(for audioSessionMode: String?) -> AVAudioSession.Mode {
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
}

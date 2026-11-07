import AVFoundation
import Foundation

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

    init(
        session: AudioSessionConfiguring = AVAudioSession.sharedInstance(),
        gate: WebRTCAudioEngineGate = NotificationCenterAudioEngineGate()
    ) {
        self.session = session
        self.gate = gate
        self.gate.onEngineStartFailed = {
            NSLog("[StreamCallKit] WebRTC could not start the audio engine")
        }
    }

    // MARK: - CallKit audio session callbacks

    /// CallKit activated the audio session.
    ///
    /// On the first activation of the answered or outgoing call, that call starts connecting and
    /// the session gets its options, or `lastOptions` when no call is live; a later activation,
    /// such as a resume, leaves the session as it is. The session is configured before the audio
    /// engine is allowed, so WebRTC starts its engine on the configured session. Every activation
    /// allows the audio engine and is reported to Dart.
    func didActivate(_ store: CallKitCallStore) -> [CallKitEffect] {
        let isFirstActivation = store.isFirstAudioActivation
        let options = store.callsAwaitingFirstActivation.first?.options ?? store.lastOptions
        var effects: [CallKitEffect] = isFirstActivation ? store.audioActivated() : []
        store.audioSessionActivated()

        if isFirstActivation {
            configure(options)
        }
        gate.update(available: true, callKitSessionActive: true)
        effects.append(.postAudioInterruptionEnded)
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

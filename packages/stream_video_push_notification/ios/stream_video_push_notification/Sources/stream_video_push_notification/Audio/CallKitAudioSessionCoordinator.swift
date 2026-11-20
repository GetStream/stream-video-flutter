import AVFoundation
import Foundation
import stream_webrtc_flutter

/// The parts of the audio session the coordinator reads and sets.
protocol AudioSessionConfiguring {
    /// The session's current category.
    var category: AVAudioSession.Category { get }

    /// Applies an `AppleAudioConfiguration` map, as Dart's `AppleAudioConfiguration.toMap()`
    /// makes it, without activating the session.
    func apply(_ configuration: [String: Any]) throws
}

/// Applies a configuration the way Dart's `Helper.setAppleAudioConfiguration` does, so the
/// session and the configuration WebRTC activates it with stay the same.
///
/// It runs on the queue CallKit calls the provider delegate on, the main queue, since CallKit
/// needs the session configured before the action is fulfilled. `stream_webrtc_flutter` makes
/// its own changes on its audio session queue, so one it makes at the same moment, such as a
/// factory built for a lobby while a ring is answered, is not ordered with this one.
struct WebRTCAudioSession: AudioSessionConfiguring {
    var category: AVAudioSession.Category { AVAudioSession.sharedInstance().category }

    func apply(_ configuration: [String: Any]) throws {
        try AudioUtils.setAppleAudioConfiguration(configuration)
    }
}

/// The only code that configures the audio session for CallKit calls, and the one that tells
/// WebRTC when it may use it.
final class CallKitAudioSessionCoordinator {

    /// The configuration of `BroadcasterAudioPolicy`, the SDK's default policy, used until Dart
    /// sends the ringing calls' configuration.
    static let defaultConfiguration: [String: Any] = [
        "appleAudioCategory": "playAndRecord",
        "appleAudioCategoryOptions": [
            "mixWithOthers", "allowBluetooth", "allowBluetoothA2DP", "allowAirPlay",
        ],
        "appleAudioMode": "voiceChat",
    ]

    private let session: AudioSessionConfiguring
    private let gate: WebRTCAudioEngineGate
    private let center: NotificationCenter
    private let persistedRingingConfiguration: () -> [String: Any]?

    /// Called when WebRTC could not start the audio engine on a session CallKit activated.
    var onEngineStartFailed: (() -> Void)?

    /// The audio configuration of ringing calls Dart sent last, the map of
    /// `StreamVideoOptions.ringingAudioConfigurationPolicy`.
    ///
    /// Until Dart sends one in this process, the one it sent in an earlier run, and
    /// `defaultConfiguration` when it never did.
    var ringingConfiguration: [String: Any]? {
        get { sentRingingConfiguration ?? persistedRingingConfiguration() }
        set { sentRingingConfiguration = newValue }
    }
    private var sentRingingConfiguration: [String: Any]?

    init(
        session: AudioSessionConfiguring = WebRTCAudioSession(),
        gate: WebRTCAudioEngineGate = WebRTCPluginAudioEngineGate(),
        center: NotificationCenter = .default,
        persistedRingingConfiguration: @escaping () -> [String: Any]? = {
            StreamVideoPushConfiguration.loadPersisted()?.ringingAudioConfiguration
        }
    ) {
        self.session = session
        self.gate = gate
        self.center = center
        self.persistedRingingConfiguration = persistedRingingConfiguration
        self.gate.onEngineStartFailed = { [weak self] in
            NSLog("[StreamCallKit] WebRTC could not start the audio engine")
            self?.onEngineStartFailed?()
        }
    }

    // MARK: - CallKit audio session callbacks

    /// CallKit activated the audio session.
    ///
    /// On the first activation of the answered or outgoing call, that call starts connecting. The
    /// session was configured when CallKit answered or started the call, so it is left as it is.
    /// Every activation allows the audio engine and is reported to Dart.
    func didActivate(_ store: CallKitCallStore) -> [CallKitEffect] {
        var effects = store.audioSessionActivated()
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
            NSLog("[StreamCallKit] The audio session was deactivated for a call on hold")
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

    /// CallKit is answering `call`.
    ///
    /// A call the app has not joined yet, such as one answered from the CallKit screen, gets the
    /// ringing calls' configuration, which CallKit needs before it activates the session. A call
    /// the app joined before answering it already has its own, which is kept unless its
    /// category cannot record.
    func answering(_ call: CallKitCall) {
        if call.connectedAt == nil {
            applyRingingConfiguration()
        } else {
            ensureCategoryCanRecord()
        }
    }

    /// CallKit is starting an outgoing call, which the app configures as it joins it.
    ///
    /// The session is left as it is when its category can record, so a call the app joined
    /// keeps its configuration; otherwise it gets the ringing calls' configuration, so CallKit
    /// can activate it.
    func starting() {
        ensureCategoryCanRecord()
    }

    /// Applies the ringing calls' configuration, with `playAndRecord` when its category cannot
    /// record. The session is left inactive: CallKit activates it.
    func applyRingingConfiguration() {
        var configuration = ringingConfiguration ?? Self.defaultConfiguration
        if let category = configuration["appleAudioCategory"] as? String,
            !Self.canRecord(category)
        {
            NSLog(
                "[StreamCallKit] The ringing audio configuration's category \(category) cannot "
                    + "record, so CallKit could not activate the session; using playAndRecord")
            configuration["appleAudioCategory"] = "playAndRecord"
        } else if configuration["appleAudioCategory"] == nil {
            configuration["appleAudioCategory"] = "playAndRecord"
        }

        do {
            try session.apply(configuration)
        } catch {
            NSLog(
                "[StreamCallKit] Could not apply the ringing audio configuration \(configuration): "
                    + "\(error); applying the default one")
            do {
                try session.apply(Self.defaultConfiguration)
            } catch {
                NSLog("[StreamCallKit] Could not apply the default audio configuration: \(error)")
            }
        }
    }

    /// Applies the ringing calls' configuration when the session's category cannot record.
    private func ensureCategoryCanRecord() {
        guard !Self.canRecord(session.category) else { return }
        applyRingingConfiguration()
    }

    /// Posts an ended interruption that asks audio code to resume.
    func postInterruptionEnded(object: Any?) {
        var userInfo: [AnyHashable: Any] = [:]
        let intrepEndeRaw = AVAudioSession.InterruptionType.ended.rawValue
        userInfo[AVAudioSessionInterruptionTypeKey] = intrepEndeRaw
        userInfo[AVAudioSessionInterruptionOptionKey] =
            AVAudioSession.InterruptionOptions.shouldResume.rawValue
        center.post(
            name: AVAudioSession.interruptionNotification, object: object, userInfo: userInfo)
    }

    /// Whether CallKit can activate a session of `category`, by its name in an
    /// `AppleAudioConfiguration` map.
    static func canRecord(_ category: String) -> Bool {
        category == "playAndRecord" || category == "record"
    }

    static func canRecord(_ category: AVAudioSession.Category) -> Bool {
        category == .playAndRecord || category == .record
    }
}

import Foundation

@objc public class StreamVideoPushConfiguration: NSObject {
    @objc public var headers: NSDictionary

    // flattened iOS params
    @objc public var iconName: String
    @objc public var handleType: String
    @objc public var useComplexHandle: Bool
    @objc public var supportsVideo: Bool
    @objc public var maximumCallGroups: Int
    @objc public var audioSessionMode: String
    @objc public var audioSessionPreferredSampleRate: Double
    @objc public var audioSessionPreferredIOBufferDuration: Double
    @objc public var configureAudioSession: Bool

    /// Always true: CallKit activates the audio session when it needs it.
    @available(*, deprecated, message: "Has no effect. CallKit activates the audio session.")
    @objc public var audioSessionActive: Bool {
        get { true }
        set {}
    }
    @objc public var supportsDTMF: Bool
    @objc public var supportsHolding: Bool
    @objc public var ringtonePath: String
    @objc public var includesCallsInRecents: Bool

    /// Always 1: CallKit is never offered a merge of calls.
    @available(*, deprecated, message: "Has no effect. Calls cannot be merged in CallKit.")
    @objc public var maximumCallsPerCallGroup: Int {
        get { 1 }
        set {}
    }

    /// Always false: CallKit is never offered a merge of calls.
    @available(*, deprecated, message: "Has no effect. Calls cannot be merged in CallKit.")
    @objc public var supportsGrouping: Bool {
        get { false }
        set {}
    }

    /// Always false: CallKit is never offered a merge of calls.
    @available(*, deprecated, message: "Has no effect. Calls cannot be merged in CallKit.")
    @objc public var supportsUngrouping: Bool {
        get { false }
        set {}
    }

    /// The default CallKit options: no holding, no keypad and one call group, as the SDK sends
    /// from Dart.
    @objc public convenience init(headers: NSDictionary) {
        let args: [String: Any?] = ["headers": headers]
        self.init(args: args)
    }

    @objc public convenience init(args: NSDictionary) {

        var argsConvert = [String: Any?]()
        for (key, value) in args {
            if let keyString = key as? String {
                argsConvert[keyString] = value
            }
        }
        self.init(args: argsConvert)
    }

    public init(args: [String: Any?]) {
        self.headers = args["headers"] as? NSDictionary ?? [:]

        let options = CallKitOptions(args: args, defaultIconName: "CallKitLogo")
        self.iconName = options.iconName
        self.handleType = options.handleType
        self.useComplexHandle = options.useComplexHandle
        self.supportsVideo = options.supportsVideo
        self.maximumCallGroups = options.maximumCallGroups
        self.supportsDTMF = options.supportsDTMF
        self.supportsHolding = options.supportsHolding
        self.includesCallsInRecents = options.includesCallsInRecents
        self.ringtonePath = options.ringtonePath
        self.configureAudioSession = options.configureAudioSession
        self.audioSessionMode = options.audioSessionMode
        self.audioSessionPreferredSampleRate = options.audioSessionPreferredSampleRate
        self.audioSessionPreferredIOBufferDuration = options.audioSessionPreferredIOBufferDuration
    }

    // MARK: - Persistence

    /// UserDefaults key holding the last configuration received from Dart.
    private static let persistedConfigurationKey = "io.getstream.callKit_configuration"

    /// Persists the configuration so it survives a process restart.
    ///
    /// A VoIP push can wake the app before any Dart code has run, in which case
    /// `initData` has not been called yet and the in-memory configuration is empty. Without a
    /// persisted copy the CallKit provider would be built from defaults, losing the configured
    /// ringtone, icon and Recents behaviour. 
    @objc public func persist() {
        UserDefaults.standard.set(persistedPayload(), forKey: Self.persistedConfigurationKey)
    }

    /// The configuration without `headers`.
    ///
    /// `headers` arrives straight from Dart as an untyped map, so it can hold values UserDefaults
    /// refuses: a Dart `null` becomes `NSNull`, and storing it raises an uncaught
    /// `NSInvalidArgumentException` that would crash the app on every `initData`. Nothing on iOS
    /// reads the headers; they exist for the Android image loader.
    private func persistedPayload() -> [String: Any] {
        var payload = toJSON()
        payload.removeValue(forKey: "headers")
        return payload
    }

    /// Returns the last persisted configuration, or nil when none was stored yet.
    @objc public static func loadPersisted() -> StreamVideoPushConfiguration? {
        guard
            let stored = UserDefaults.standard.dictionary(forKey: persistedConfigurationKey)
        else {
            return nil
        }
        return StreamVideoPushConfiguration(args: stored)
    }

    open func toJSON() -> [String: Any] {
        let ios: [String: Any] = [
            "iconName": iconName,
            "handleType": handleType,
            "useComplexHandle": useComplexHandle,
            "supportsVideo": supportsVideo,
            "maximumCallGroups": maximumCallGroups,
            "audioSessionMode": audioSessionMode,
            "audioSessionPreferredSampleRate": audioSessionPreferredSampleRate,
            "audioSessionPreferredIOBufferDuration": audioSessionPreferredIOBufferDuration,
            "configureAudioSession": configureAudioSession,
            "supportsDTMF": supportsDTMF,
            "supportsHolding": supportsHolding,
            "ringtonePath": ringtonePath,
            "includesCallsInRecents": includesCallsInRecents,
        ]

        let result: [String: Any] = [
            "headers": headers,
            "ios": ios,
        ]

        return result
    }
}

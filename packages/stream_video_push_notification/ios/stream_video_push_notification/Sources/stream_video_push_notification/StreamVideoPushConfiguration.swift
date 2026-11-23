import Foundation

/// The CallKit options Dart last sent, kept for VoIP pushes that arrive before Dart runs.
final class StreamVideoPushConfiguration: NSObject {
    var headers: NSDictionary

    // flattened iOS params
    var iconName: String
    var handleType: String
    var useComplexHandle: Bool
    var supportsVideo: Bool
    var maximumCallGroups: Int

    var supportsDTMF: Bool
    var supportsHolding: Bool
    var ringtonePath: String
    var includesCallsInRecents: Bool

    /// The `AppleAudioConfiguration` map of `StreamVideoOptions.ringingAudioConfigurationPolicy`,
    /// which CallKit calls configure the audio session with. Nil until Dart sends one.
    var ringingAudioConfiguration: [String: Any]?

    /// The default CallKit options: no holding, no keypad and one call group, as the SDK sends
    /// from Dart.
    convenience init(headers: NSDictionary) {
        let args: [String: Any?] = ["headers": headers]
        self.init(args: args)
    }

    convenience init(args: NSDictionary) {

        var argsConvert = [String: Any?]()
        for (key, value) in args {
            if let keyString = key as? String {
                argsConvert[keyString] = value
            }
        }
        self.init(args: argsConvert)
    }

    init(args: [String: Any?]) {
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
        let ios = args["ios"] as? [String: Any]
        self.ringingAudioConfiguration =
            (ios ?? [:])["ringingAudioConfiguration"] as? [String: Any]
            ?? args["ringingAudioConfiguration"] as? [String: Any]
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
    func persist() {
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
    static func loadPersisted() -> StreamVideoPushConfiguration? {
        guard
            let stored = UserDefaults.standard.dictionary(forKey: persistedConfigurationKey)
        else {
            return nil
        }
        return StreamVideoPushConfiguration(args: stored)
    }

    func toJSON() -> [String: Any] {
        var ios: [String: Any] = [
            "iconName": iconName,
            "handleType": handleType,
            "useComplexHandle": useComplexHandle,
            "supportsVideo": supportsVideo,
            "maximumCallGroups": maximumCallGroups,
            "supportsDTMF": supportsDTMF,
            "supportsHolding": supportsHolding,
            "ringtonePath": ringtonePath,
            "includesCallsInRecents": includesCallsInRecents,
        ]
        if let ringingAudioConfiguration = ringingAudioConfiguration {
            ios["ringingAudioConfiguration"] = ringingAudioConfiguration
        }

        let result: [String: Any] = [
            "headers": headers,
            "ios": ios,
        ]

        return result
    }
}

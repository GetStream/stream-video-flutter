import Foundation
import UIKit

/// The APNs device token of this device, which Stream sends missed-call pushes to when the app
/// turns on `registerApnDeviceToken`.
///
/// The plugin forwards the app delegate's remote notification callbacks here, whoever asked iOS
/// to register: the plugin, when `registerApnDeviceToken` is on, or the app or another plugin.
/// The token is stored next to the VoIP token and sent to Dart once per process: every
/// registration of the plugin, one per Flutter engine, forwards the same callback, and iOS hands
/// the token over again on every registration. An event that was dropped, because Dart had
/// silenced events or the process ended before Dart listened, is sent again on the next launch;
/// the stored token can be read at any time with `getPushToken`.
final class RemoteNotificationTokenHandler {

    static let shared = RemoteNotificationTokenHandler(
        defaults: .standard,
        sink: StreamVideoCallkitManager.shared.eventSink,
        registerForRemoteNotifications: {
            UIApplication.shared.registerForRemoteNotifications()
        })

    /// The token kind in `getPushToken` and in the token event's body.
    static let kind = "apns"

    private static let tokenKey = "DevicePushTokenAPNs"

    private let defaults: UserDefaults
    private let sink: RingingEventSink
    private let registerForRemoteNotifications: () -> Void

    /// The last token sent to Dart by this process. Only touched on the main thread, where iOS
    /// calls the app delegate.
    private var sentToken: String?

    init(
        defaults: UserDefaults,
        sink: RingingEventSink,
        registerForRemoteNotifications: @escaping () -> Void
    ) {
        self.defaults = defaults
        self.sink = sink
        self.registerForRemoteNotifications = registerForRemoteNotifications
    }

    /// The stored token, or empty when APNs has not issued one.
    var token: String {
        return defaults.string(forKey: Self.tokenKey) ?? ""
    }

    /// Registers with APNs when the push configuration Dart sends in `initData` sets
    /// `ios.registerApnDeviceToken`. An app that leaves it off gets no registration from the
    /// plugin.
    func configure(with arguments: [String: Any]) {
        guard Self.registersToken(arguments) else { return }
        registerForRemoteNotifications()
    }

    static func registersToken(_ arguments: [String: Any]) -> Bool {
        let ios = arguments["ios"] as? [String: Any]
        return ios?["registerApnDeviceToken"] as? Bool == true
    }

    /// Stores `deviceToken`, as hex, and tells Dart, unless this process already sent it.
    func didRegister(deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02x", $0) }.joined()
        guard token != sentToken else { return }

        sentToken = token
        defaults.set(token, forKey: Self.tokenKey)
        sink.send(
            StreamVideoIncomingCallConstants.ACTION_DID_UPDATE_PUSH_TOKEN,
            ["kind": Self.kind, "token": token])
    }

    /// Logs why APNs refused to register. The stored token, if any, is kept.
    func didFailToRegister(error: Error) {
        NSLog("[StreamCallKit] APNs registration failed: %@", error.localizedDescription)
    }
}

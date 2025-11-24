import Flutter
import UIKit
import stream_webrtc_flutter

public class StreamVideoFlutterPlugin: NSObject, FlutterPlugin {
    static let broadcastStartedNotification = "io.getstream.video.screen_sharing.broadcastStarted"
    static let broadcastStoppedNotification = "io.getstream.video.screen_sharing.broadcastStopped"

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "stream_video_flutter", binaryMessenger: registrar.messenger())
        let instance = StreamVideoFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        let factory = StreamPictureInPictureNativeViewFactory(messenger: registrar.messenger())
        registrar.register(
            factory,
            withId: "stream-pip-view")

        ScreenShareManager.shared.observeNotification(named: broadcastStartedNotification)
        ScreenShareManager.shared.observeNotification(named: broadcastStoppedNotification)
        ScreenShareManager.shared.onNotification = { name in
            DispatchQueue.main.async {
                switch name {
                case broadcastStartedNotification:
                    FlutterWebRTCPlugin.sharedSingleton()?.postEvent(
                        withName: "screenSharingStarted", data: nil)
                case broadcastStoppedNotification:
                    FlutterWebRTCPlugin.sharedSingleton()?.postEvent(
                        withName: "screenSharingStopped", data: nil)
                default:
                    break
                }
            }
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

class StreamPictureInPictureNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return StreamPictureInPictureNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class StreamPictureInPictureNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var methodChannel: FlutterMethodChannel?
    private lazy var pictureInPictureController = StreamPictureInPictureController()

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        _view = UIView()
        super.init()

        self.methodChannel = FlutterMethodChannel(
            name: "stream_video_flutter_pip", binaryMessenger: messenger)
        methodChannel?.setMethodCallHandler(onMethodCall)

        pictureInPictureController?.sourceView = _view

        createNativeView(view: _view)
    }

    private func onMethodCall(call: FlutterMethodCall, result: FlutterResult) {
        switch call.method {
        case "updateParticipant":
            let argumentsDictionary = call.arguments as? [String: Any]
            let trackId = argumentsDictionary?["trackId"] as? String
            let name = argumentsDictionary?["name"] as? String
            let imageUrl = argumentsDictionary?["imageUrl"] as? String
            let isAudioEnabled = argumentsDictionary?["isAudioEnabled"] as? Bool ?? false
            let isVideoEnabled = argumentsDictionary?["isVideoEnabled"] as? Bool ?? false
            let connectionQuality = argumentsDictionary?["connectionQuality"] as? String
            let showParticipantName = argumentsDictionary?["showParticipantName"] as? Bool ?? true
            let showMicrophoneIndicator =
                argumentsDictionary?["showMicrophoneIndicator"] as? Bool ?? true
            let showConnectionQualityIndicator =
                argumentsDictionary?["showConnectionQualityIndicator"] as? Bool ?? true

            DispatchQueue.main.async {
                if let unwrappedTrackId = trackId {
                    let track = FlutterWebRTCPlugin.sharedSingleton()?.track(
                        forId: unwrappedTrackId, peerConnectionId: nil)
                    if let videoTrack = track as? RTCVideoTrack {
                        self.pictureInPictureController?.track = videoTrack
                    }
                }

                self.pictureInPictureController?.updateParticipant(
                    name: name ?? "",
                    imageUrl: imageUrl,
                    connectionQuality: connectionQuality ?? "",
                    isMuted: !isAudioEnabled,
                    hasVideo: isVideoEnabled,
                    showParticipantName: showParticipantName,
                    showMicrophoneIndicator: showMicrophoneIndicator,
                    showConnectionQualityIndicator: showConnectionQualityIndicator
                )
            }
            result(nil)
        case "callEnded":
            DispatchQueue.main.async {
                self.pictureInPictureController?.stopPictureInPictureAndCleanup()
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView) {
        _view.backgroundColor = UIColor.clear
    }
}

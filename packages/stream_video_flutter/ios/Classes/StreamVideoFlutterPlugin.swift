import Flutter
import UIKit
import stream_webrtc_flutter

public class StreamVideoFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "stream_video_flutter", binaryMessenger: registrar.messenger())
        let instance = StreamVideoFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        let factory = StreamPictureInPictureNativeViewFactory(messenger: registrar.messenger())
        registrar.register(
            factory,
            withId: "stream-pip-view")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isBackgroundEffectSupported":
            if #available(iOS 15.0, *) {
                result(true)
            } else {
                result(false)
            }
        case "registerBlurEffectProcessors":
            if #available(iOS 15.0, *) {
                ProcessorProvider.addProcessor(
                    BlurBackgroundVideoFrameProcessor(blurIntensity: BlurIntensity.light),
                    forName: "BackgroundBlurLight")
                ProcessorProvider.addProcessor(
                    BlurBackgroundVideoFrameProcessor(blurIntensity: BlurIntensity.medium),
                    forName: "BackgroundBlurMedium")
                ProcessorProvider.addProcessor(
                    BlurBackgroundVideoFrameProcessor(blurIntensity: BlurIntensity.heavy),
                    forName: "BackgroundBlurHeavy")
            } else {
                print("Background blur effects are not supported on iOS versions earlier than 15.0")
            }

            result(nil)
        case "registerImageEffectProcessors":
            if #available(iOS 15.0, *) {
                if let arguments = call.arguments as? [String: Any] {
                    guard let backgroundImageUrl = arguments["backgroundImageUrl"] as? String
                    else {
                        result(
                            FlutterError(
                                code: "INVALID_ARGUMENT", message: "Invalid argument", details: nil)
                        )
                        return
                    }

                    ProcessorProvider.addProcessor(
                        ImageBackgroundVideoFrameProcessor(backgroundImageUrl),
                        forName: "VirtualBackground-\(backgroundImageUrl)")

                    result(nil)
                }

                result(nil)

            } else {
                print("Image overlay effects are not supported on iOS versions earlier than 15.0")
            }
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
            self.pictureInPictureController?.track = nil
            self.pictureInPictureController?.sourceView = nil
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

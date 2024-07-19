import Flutter
import UIKit
import flutter_webrtc

public class StreamVideoFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "stream_video_flutter", binaryMessenger: registrar.messenger())
        let instance = StreamVideoFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let factory = StreamPictureInPictureNativeViewFactory(messenger: registrar.messenger())
        registrar.register(
            factory,
            withId: "stream-pip-view")
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
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
        
        self.methodChannel = FlutterMethodChannel(name: "stream_video_flutter_pip" ,binaryMessenger: messenger)
        methodChannel?.setMethodCallHandler(onMethodCall)
        
        pictureInPictureController?.sourceView = _view
        
        createNativeView(view: _view)
    }
    
    private func onMethodCall(call: FlutterMethodCall, result: FlutterResult) {
        switch(call.method){
        case "setTrack":
            let argumentsDictionary = call.arguments as? Dictionary<String, Any>
            let trackId = argumentsDictionary?["trackId"] as? String
          
            DispatchQueue.main.async {
                if let unwrappedTrackId = trackId {
                    let track = FlutterWebRTCPlugin.sharedSingleton()?.track(forId: unwrappedTrackId, peerConnectionId: nil);
                    if let videoTrack = track as? RTCVideoTrack {
                        self.pictureInPictureController?.track = videoTrack
                    }
                }
            }
        case "callEnded":
            self.pictureInPictureController?.track = nil
            self.pictureInPictureController?.sourceView = nil
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func view() -> UIView {
        return _view
    }
    
    func createNativeView(view _view: UIView){
        _view.backgroundColor = UIColor.clear
    }
}

import Flutter
import UIKit

public class StreamVideoScreenSharingPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "stream_video_screen_sharing", binaryMessenger: registrar.messenger())
    let instance = StreamVideoScreenSharingPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}

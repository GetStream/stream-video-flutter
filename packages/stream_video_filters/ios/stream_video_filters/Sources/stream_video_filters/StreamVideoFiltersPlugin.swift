import Flutter
import UIKit
import stream_webrtc_flutter

public class StreamVideoFiltersPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "stream_video_filters", binaryMessenger: registrar.messenger())
    let instance = StreamVideoFiltersPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
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
      guard #available(iOS 15.0, *) else {
        print("Image overlay effects are not supported on iOS versions earlier than 15.0")
        result(nil)
        return
      }

      guard
        let arguments = call.arguments as? [String: Any],
        let backgroundImageUrl = arguments["backgroundImageUrl"] as? String
      else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENT",
            message: "Invalid argument",
            details: nil
          )
        )
        return
      }

      ProcessorProvider.addProcessor(
        ImageBackgroundVideoFrameProcessor(backgroundImageUrl),
        forName: "VirtualBackground-\(backgroundImageUrl)"
      )

      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

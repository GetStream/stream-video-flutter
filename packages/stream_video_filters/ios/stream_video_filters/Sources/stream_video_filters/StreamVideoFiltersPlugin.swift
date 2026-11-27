import Flutter
import UIKit
import stream_webrtc_flutter

public class StreamVideoFiltersPlugin: NSObject, FlutterPlugin {
  // Names we add to the global ProcessorProvider, so unregisterAllFilters can
  // release them. Otherwise the processors live for the app's lifetime.
  private static var registeredNames = Set<String>()

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
        Self.registeredNames.formUnion([
          "BackgroundBlurLight", "BackgroundBlurMedium", "BackgroundBlurHeavy",
        ])
        result(nil)
      } else {
        result(Self.unsupported("Background blur effects"))
      }
    case "registerImageEffectProcessors":
      guard #available(iOS 15.0, *) else {
        result(Self.unsupported("Image overlay effects"))
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

      let name = "VirtualBackground-\(backgroundImageUrl)"
      ProcessorProvider.addProcessor(
        ImageBackgroundVideoFrameProcessor(backgroundImageUrl),
        forName: name
      )
      Self.registeredNames.insert(name)

      result(nil)
    case "registerFullFrameBlurEffectProcessor":
      if #available(iOS 15.0, *) {
        ProcessorProvider.addProcessor(
          FullFrameBlurVideoFrameProcessor(),
          forName: "FullFrameBlur")
        Self.registeredNames.insert("FullFrameBlur")
        result(nil)
      } else {
        result(Self.unsupported("Full frame blur effects"))
      }
    case "unregisterAllFilters":
      for name in Self.registeredNames {
        ProcessorProvider.removeProcessor(name)
      }
      Self.registeredNames.removeAll()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // Fails the registration, so a filter never reports itself applied while
  // its frames go out unprocessed.
  private static func unsupported(_ effect: String) -> FlutterError {
    return FlutterError(
      code: "UNSUPPORTED",
      message: "\(effect) are not supported on iOS versions earlier than 15.0",
      details: nil
    )
  }
}

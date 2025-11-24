import Flutter
import UIKit
import stream_video_filters
import stream_video_flutter
import stream_video_push_notification
import stream_webrtc_flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let CHANNEL = "io.getstream.video.flutter.dogfooding.channel"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // Register for push notifications.
        StreamVideoPKDelegateManager.shared.registerForPushNotifications()
        UNUserNotificationCenter.current().delegate = self

        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(
            name: CHANNEL, binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { [weak self] (call, result) in
            self?.handleMethodCall(call: call, result: result)
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // This method will be called when notification is received
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) ->
            Void
    ) {
        let streamDict = notification.request.content.userInfo["stream"] as? [String: Any]
        if streamDict?["sender"] as? String != "stream.video" {
            return completionHandler([])
        }

        if #available(iOS 14.0, *) {
            completionHandler([.list, .banner, .sound])
        } else {
            completionHandler([.alert])
        }
    }

    func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "registerGreyscaleEffect" {
            ProcessorProvider.addProcessor(GrayScaleVideoFrameProcessor(), forName: "grayscale")
            result(nil)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}

final class GrayScaleVideoFrameProcessor: stream_video_filters.VideoFilter {
    @available(*, unavailable)
    override public init(
        filter: @escaping (Input) -> CIImage
    ) { fatalError() }
    init() {
        super.init(
            filter: { input in
                let filter = CIFilter(name: "CIPhotoEffectMono")
                filter?.setValue(input.originalImage, forKey: kCIInputImageKey)
                let outputImage: CIImage = filter?.outputImage ?? input.originalImage
                return outputImage
            }
        )
    }
}

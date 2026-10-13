import Foundation
import stream_webrtc_flutter

@available(iOS 15.0, *)
final class BlurBackgroundVideoFrameProcessor: VideoFilter {

    @available(*, unavailable)
    override public init(
        filter: @escaping (Input) -> CIImage
    ) { fatalError() }

    private lazy var backgroundImageFilterProcessor = { return BackgroundImageFilterProcessor() }()

    private let blurParameters: [String: Float]

    /// The blur runs on a copy scaled by this factor. A Gaussian with radius `r` at
    /// scale `s` matches radius `r / s` at full resolution, so the radius is scaled
    /// along with the image to keep each [BlurIntensity] at its full-resolution strength.
    private static let downscaleFactor: CGFloat = 0.5

    init(blurIntensity: BlurIntensity = BlurIntensity.medium) {
        blurParameters = ["inputRadius": blurIntensity.rawValue * Float(Self.downscaleFactor)]

        super.init(
            filter: { input in input.originalImage }
        )

        self.filter = { [weak self] input in
            // `[weak self]`: the closure is stored on `self` — a strong capture would leak the processor.
            guard let self = self else { return input.originalImage }
            // Blur at half resolution for speed. clampedToExtent + cropped(to:)
            // keep the result at the original extent; without them the background
            // drifts relative to the foreground and the frame edges darken. Plain
            // bilinear affine scaling is used in both directions: the intermediate is
            // blurred anyway, so Lanczos resampling would only cost GPU time.
            let originalExtent = input.originalImage.extent
            let scale = Self.downscaleFactor
            let downscaled = input.originalImage
                .transformed(by: CGAffineTransform(scaleX: scale, y: scale))
            let blurred =
                downscaled
                .clampedToExtent()
                .applyingFilter("CIGaussianBlur", parameters: self.blurParameters)
                .cropped(to: downscaled.extent)
            let backgroundImage = blurred
                .transformed(by: CGAffineTransform(scaleX: 1 / scale, y: 1 / scale))
                .cropped(to: originalExtent)

            return self.backgroundImageFilterProcessor
                .applyFilter(
                    input.originalPixelBuffer,
                    backgroundImage: backgroundImage
                ) ?? input.originalImage
        }
    }
}

enum BlurIntensity: Float {
    case light = 5.0
    case medium = 10.0
    case heavy = 15.0
}

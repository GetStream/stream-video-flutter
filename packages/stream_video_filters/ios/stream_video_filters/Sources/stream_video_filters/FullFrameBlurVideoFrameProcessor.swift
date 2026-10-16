import Foundation
import stream_webrtc_flutter

@available(iOS 15.0, *)
final class FullFrameBlurVideoFrameProcessor: VideoFilter {

    @available(*, unavailable)
    override public init(
        filter: @escaping (Input) -> CIImage
    ) { fatalError() }

    /// The blur is computed on a quarter-resolution copy of the frame and scaled
    /// back up. A Gaussian with radius `r` at scale `s` matches radius `r / s` at
    /// full resolution, so the radius is scaled along with the image to keep the
    /// same visual strength (radius 50 at full resolution) at a fraction of the cost.
    private static let downscaleFactor: CGFloat = 0.25
    private static let fullResolutionBlurRadius: CGFloat = 50

    init() {
        let scale = Self.downscaleFactor
        let radius = Self.fullResolutionBlurRadius * scale

        super.init(
            filter: { input in
                let originalExtent = input.originalImage.extent
                let downscaled = input.originalImage
                    .transformed(by: CGAffineTransform(scaleX: scale, y: scale))
                // clampedToExtent + cropped(to:) keep the blur from sampling the
                // transparent area outside the frame, which otherwise darkens the edges.
                let blurred = downscaled
                    .clampedToExtent()
                    .applyingFilter(
                        "CIGaussianBlur",
                        parameters: [kCIInputRadiusKey: radius]
                    )
                    .cropped(to: downscaled.extent)
                return blurred
                    .transformed(by: CGAffineTransform(scaleX: 1 / scale, y: 1 / scale))
                    .cropped(to: originalExtent)
            }
        )
    }
}

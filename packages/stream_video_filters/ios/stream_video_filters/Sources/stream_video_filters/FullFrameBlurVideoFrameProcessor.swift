import Foundation
import stream_webrtc_flutter

@available(iOS 15.0, *)
final class FullFrameBlurVideoFrameProcessor: VideoFilter {

    @available(*, unavailable)
    override public init(
        filter: @escaping (Input) -> CIImage
    ) { fatalError() }

    init() {
        super.init(
            filter: { input in input.originalImage }
        )

        self.filter = { input in
            let blurred = input.originalImage.applyingFilter(
                "CIGaussianBlur",
                parameters: [kCIInputRadiusKey: 50.0]
            )
            return blurred.cropped(to: input.originalImage.extent)
        }
    }
}

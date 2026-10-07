//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import CoreImage
import CoreVideo
import Foundation
import stream_webrtc_flutter

extension RTCVideoRotation {
    /// Maps the capture pipeline's frame rotation to the image orientation used when orienting
    /// the background image. Using the frame's own rotation metadata keeps the background in sync
    /// with the outgoing video even when the app UI is orientation-locked or mid-rotation, unlike
    /// reading the UI's interface orientation.
    var cgOrientation: CGImagePropertyOrientation {
        switch self {
        case ._0:
            return .up
        case ._90:
            return .left
        case ._180:
            return .down
        case ._270:
            return .right
        @unknown default:
            return .up
        }
    }
}

open class VideoFilter: NSObject, VideoFrameProcessorDelegate {

    /// An object which encapsulates the required input for a Video filter.
    public struct Input {
        /// The image (video frame) that the filter should be applied on.
        public var originalImage: CIImage

        /// The pixelBuffer that produces the image (video frame) that the filter should be applied on.
        public var originalPixelBuffer: CVPixelBuffer

        /// The orientation on which the image (video frame) was generated from.
        public var originalImageOrientation: CGImagePropertyOrientation
    }
    /// Filter closure that takes a CIImage as input and returns a filtered CIImage as output.
    public var filter: (Input) -> CIImage

    private let context: CIContext

    // Output buffers for the filtered frame. Rendering into a buffer other than the
    // one the CIImage graph reads from keeps neighbour-sampling kernels (blur, blend)
    // from reading tiles that have already been written. The pool matches the camera
    // buffer's format and size and is recreated when either changes. Only touched
    // from the capture thread, which delivers frames serially.
    private var outputPool: CVPixelBufferPool?
    private var outputPoolFormat: OSType = 0
    private var outputPoolWidth = 0
    private var outputPoolHeight = 0

    // Frames handed to WebRTC stay alive until encoded and rendered locally, so a few
    // buffers are in use at once. Above this many we fall back to in-place rendering
    // instead of letting the pool grow without bound.
    private static let maxOutputBuffers = 6

    private static let poolablePixelFormats: Set<OSType> = [
        kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
        kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange,
        kCVPixelFormatType_32BGRA,
    ]

    /// Initializes a new VideoFilter instance with the provided parameters.
    public init(
        filter: @escaping (Input) -> CIImage
    ) {
        self.filter = filter
        self.context = CIContext(options: [CIContextOption.useSoftwareRenderer: false])
        super.init()
    }

    public func capturer(_ capturer: RTCVideoCapturer!, didCapture frame: RTCVideoFrame!)
        -> RTCVideoFrame!
    {
        if let rtcCVPixelBuffer = frame.buffer as? RTCCVPixelBuffer {
            let pixelBuffer = rtcCVPixelBuffer.pixelBuffer

            CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
            let outputImage: CIImage = self.filter(
                Input(
                    originalImage: CIImage(cvPixelBuffer: pixelBuffer),
                    originalPixelBuffer: pixelBuffer,
                    originalImageOrientation: frame.rotation.cgOrientation
                )
            )
            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)

            if let output = makeOutputBuffer(matching: pixelBuffer) {
                // Carry the colour attachments over so Core Image converts to the same
                // YCbCr matrix / range the encoder expects for the camera format.
                CVBufferPropagateAttachments(pixelBuffer, output)
                context.render(outputImage, to: output)
                return RTCVideoFrame.init(
                    buffer: RTCCVPixelBuffer(pixelBuffer: output),
                    rotation: frame.rotation,
                    timeStampNs: frame.timeStampNs
                )
            }

            // Fallback: render in place when no output buffer is available.
            context.render(outputImage, to: pixelBuffer)
            return RTCVideoFrame.init(
                buffer: rtcCVPixelBuffer, rotation: frame.rotation, timeStampNs: frame.timeStampNs)
        }
        return frame
    }

    /// Returns a pooled pixel buffer with the same format and dimensions as `source`,
    /// or `nil` when the format can't be rendered to or the pool is exhausted.
    private func makeOutputBuffer(matching source: CVPixelBuffer) -> CVPixelBuffer? {
        let format = CVPixelBufferGetPixelFormatType(source)
        let width = CVPixelBufferGetWidth(source)
        let height = CVPixelBufferGetHeight(source)

        guard Self.poolablePixelFormats.contains(format),
            let pool = outputPool(format: format, width: width, height: height)
        else {
            return nil
        }

        let auxAttributes: [CFString: Any] = [
            kCVPixelBufferPoolAllocationThresholdKey: Self.maxOutputBuffers
        ]
        var output: CVPixelBuffer?
        let status = CVPixelBufferPoolCreatePixelBufferWithAuxAttributes(
            nil, pool, auxAttributes as CFDictionary, &output)
        guard status == kCVReturnSuccess else {
            // kCVReturnWouldExceedAllocationThreshold: downstream is holding on to
            // too many frames; render in place for this one.
            return nil
        }
        return output
    }

    private func outputPool(format: OSType, width: Int, height: Int) -> CVPixelBufferPool? {
        if let pool = outputPool, outputPoolFormat == format, outputPoolWidth == width,
            outputPoolHeight == height
        {
            return pool
        }

        let attributes: [CFString: Any] = [
            kCVPixelBufferPixelFormatTypeKey: format,
            kCVPixelBufferWidthKey: width,
            kCVPixelBufferHeightKey: height,
            kCVPixelBufferIOSurfacePropertiesKey: [:] as CFDictionary,
        ]
        let poolAttributes: [CFString: Any] = [
            kCVPixelBufferPoolMinimumBufferCountKey: 3
        ]

        var pool: CVPixelBufferPool?
        let status = CVPixelBufferPoolCreate(
            nil, poolAttributes as CFDictionary, attributes as CFDictionary, &pool)
        guard status == kCVReturnSuccess, let createdPool = pool else {
            outputPool = nil
            outputPoolFormat = 0
            outputPoolWidth = 0
            outputPoolHeight = 0
            return nil
        }

        outputPool = createdPool
        outputPoolFormat = format
        outputPoolWidth = width
        outputPoolHeight = height
        return createdPool
    }
}

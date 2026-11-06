//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import CoreVideo
import Foundation
import Vision

/// Blends a video frame with a custom background using a Vision-generated mask.
///
/// Segmentation runs asynchronously: each `applyFilter` call composites with the last
/// completed mask and only kicks a new Vision request if one isn't already in flight.
/// This keeps the capture thread unblocked; the mask can lag a few frames behind the
/// frame it is composited onto.
@available(iOS 15.0, *)
final class BackgroundImageFilterProcessor {
    // Cap on the short side of the segmentation input, so portrait and landscape
    // frames are segmented at the same pixel count (960x540 either way for 1080p).
    private static let segmentationTargetShortSide: CGFloat = 540

    /// Weight of a new Vision mask against the smoothed previous ones, in (0, 1].
    /// 1 disables temporal smoothing. Vision decides per frame whether an accessory
    /// such as headphones belongs to the person; blending consecutive masks turns
    /// that flip-flop into a brief fade instead of a blink. Lower values hide more
    /// of it at the cost of the edge lagging slightly behind fast movement.
    private static let maskTemporalWeight: CGFloat = 0.6

    private let requestHandler = VNSequenceRequestHandler()
    private let request: VNGeneratePersonSegmentationRequest

    // Async segmentation pipeline. The segmentation input is rendered on the GPU into
    // a pixel buffer from `segInputPool`, so it neither shares storage with the camera
    // buffer pool nor forces a GPU->CPU readback on the capture thread. The resulting
    // mask is snapshotted so it survives Vision reusing its own pooled result buffers.
    // `segQueue` serialises Vision calls — `VNSequenceRequestHandler` isn't thread-safe
    // under concurrent use. `segLock` guards `lastMask`, `lastMaskFrameSize` and
    // `inFlight`, all shared between the capture thread and `segQueue`.
    private let ciContext = CIContext(options: [.useSoftwareRenderer: false])
    private let segColorSpace = CGColorSpaceCreateDeviceRGB()
    private let segQueue = DispatchQueue(
        label: "io.getstream.video.segmentation", qos: .userInitiated)
    private let segLock = NSLock()

    // Failures on this path are otherwise invisible: the frame is sent as background
    // only until a mask arrives, so a persistently failing segmentation leaves the
    // person missing from their own video. Logged at most once per interval.
    private static let failureLogInterval: TimeInterval = 5
    private let failureLogLock = NSLock()
    private var lastFailureLog: TimeInterval = 0
    // In the camera buffer's coordinate space, at the segmentation input size.
    private var lastMask: CIImage?
    // Size and orientation of the frame `lastMask` was computed from. A mask from a
    // frame of another size (camera flip, quality change) would be stretched onto
    // the new geometry; one from another orientation (device rotation, which only
    // changes the frame's rotation metadata, not the buffer) would be turned 90°.
    private var lastMaskFrameSize: CGSize = .zero
    private var lastMaskOrientation: CGImagePropertyOrientation = .up
    private var inFlight = false

    // Only touched from the capture thread (`applyFilter` is called serially there).
    private var segInputPool: CVPixelBufferPool?
    private var segInputPoolSize: CGSize = .zero

    /// Initializes a new `BackgroundImageFilterProcessor` instance.
    ///
    /// - Parameters:
    ///   - qualityLevel: The quality level for segmentation, defaults to
    ///     `.balanced` if a neural engine is available, otherwise `.fast` for
    ///     performance.
    init(
        _ qualityLevel: VNGeneratePersonSegmentationRequest.QualityLevel = neuralEngineExists
            ? .balanced : .fast
    ) {
        let request = VNGeneratePersonSegmentationRequest()
        request.qualityLevel = qualityLevel
        request.outputPixelFormat = kCVPixelFormatType_OneComponent8
        self.request = request
    }

    /// Applies the filter to a video frame using a background image.
    ///
    /// - Parameters:
    ///   - buffer: The video frame to process as a `CVPixelBuffer`.
    ///   - backgroundImage: The background image to blend with the foreground.
    ///   - orientation: The orientation of `buffer`, from the frame's rotation. The
    ///     camera delivers buffers in sensor orientation (landscape) and marks the
    ///     rotation on the frame, so in a portrait call the person lies on their side
    ///     in `buffer`. Vision's person model is trained on upright people and is
    ///     markedly less stable on rotated input, above all around accessories, so
    ///     the segmentation input is rotated upright and the mask rotated back.
    /// - Returns: The blended `CIImage`. While no mask is available yet (the first
    ///   request also loads the Vision model, which can take a few hundred
    ///   milliseconds) returns `backgroundImage` on its own, so the real background
    ///   is never sent unfiltered. Returns `nil` if the blend filter itself fails.
    func applyFilter(
        _ buffer: CVPixelBuffer,
        backgroundImage: CIImage,
        orientation: CGImagePropertyOrientation = .up
    ) -> CIImage? {
        let originalImage = CIImage(cvPixelBuffer: buffer)
        let frameSize = originalImage.extent.size

        segLock.lock()
        if lastMaskFrameSize != frameSize || lastMaskOrientation != orientation {
            lastMask = nil
        }
        let mask = lastMask
        let shouldDispatch = !inFlight
        if shouldDispatch {
            inFlight = true
        }
        segLock.unlock()

        if shouldDispatch {
            // Copy out of the camera buffer so Vision never shares storage with the
            // capture pool while the composite is being rendered.
            if let segInput = makeSegmentationInput(from: originalImage, orientation: orientation) {
                segQueue.async { [weak self] in
                    self?.runSegmentation(
                        on: segInput, frameSize: frameSize, orientation: orientation)
                }
            } else {
                segLock.lock()
                inFlight = false
                segLock.unlock()
                logSegmentationFailure("could not allocate the segmentation input buffer")
            }
        }

        guard var maskImage = mask else {
            // No mask yet: treat the whole frame as background rather than leaking
            // the unfiltered camera image for the first frames.
            return backgroundImage.cropped(to: originalImage.extent)
        }

        // Scale the mask image to fit the bounds of the video frame.
        let scaleX = originalImage.extent.width / maskImage.extent.width
        let scaleY = originalImage.extent.height / maskImage.extent.height
        maskImage = maskImage.transformed(by: .init(scaleX: scaleX, y: scaleY))

        // Blend the original, background, and mask images.
        let blendFilter = CIFilter.blendWithMask()
        blendFilter.inputImage = originalImage
        blendFilter.backgroundImage = backgroundImage
        blendFilter.maskImage = maskImage

        return blendFilter.outputImage
    }

    /// Renders an upright, downscaled copy of the frame into a pooled pixel buffer
    /// for Vision.
    ///
    /// Runs segmentation with the short side capped at 540 px — Vision's cost scales
    /// with input size, and the mask-upscale step above handles whatever size Vision
    /// returns. The copy stays
    /// on the GPU (`render(_:to:)` into an IOSurface-backed buffer), and a plain
    /// bilinear transform is used instead of Lanczos because the result is only a
    /// throwaway segmentation input.
    private func makeSegmentationInput(
        from image: CIImage,
        orientation: CGImagePropertyOrientation
    ) -> CVPixelBuffer? {
        // `oriented(orientation)` is what turns an upright image into the buffer's
        // orientation (it is applied to the background image for that purpose), so
        // its inverse turns the buffer upright.
        let upright = image.oriented(orientation.inverted)
        let uprightSize = upright.extent.size
        let shortSide = min(uprightSize.width, uprightSize.height)
        let scale = shortSide > Self.segmentationTargetShortSide
            ? Self.segmentationTargetShortSide / shortSide : 1
        // Pick the integer buffer size first and scale exactly onto it, so no
        // fractional edge is cropped and then stretched over the frame by the
        // mask upscale.
        let targetSize = CGSize(
            width: (uprightSize.width * scale).rounded(.down),
            height: (uprightSize.height * scale).rounded(.down)
        )
        guard targetSize.width >= 1, targetSize.height >= 1,
            let pool = segmentationInputPool(for: targetSize)
        else {
            return nil
        }
        // Scale onto the buffer and normalise to the origin so the render below
        // maps 1:1 onto it.
        let segImage = upright.transformed(
            by: CGAffineTransform(
                translationX: -upright.extent.origin.x,
                y: -upright.extent.origin.y
            )
        ).transformed(
            by: CGAffineTransform(
                scaleX: targetSize.width / uprightSize.width,
                y: targetSize.height / uprightSize.height
            )
        )

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferPoolCreatePixelBuffer(nil, pool, &pixelBuffer)
        guard status == kCVReturnSuccess, let output = pixelBuffer else {
            return nil
        }

        ciContext.render(
            segImage,
            to: output,
            bounds: CGRect(origin: .zero, size: targetSize),
            colorSpace: segColorSpace
        )
        return output
    }

    /// Returns a BGRA pixel-buffer pool matching `size`, recreating it when the
    /// capture format changes (camera flip, quality update, rotation).
    private func segmentationInputPool(for size: CGSize) -> CVPixelBufferPool? {
        if let pool = segInputPool, segInputPoolSize == size {
            return pool
        }

        let attributes: [CFString: Any] = [
            kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA,
            kCVPixelBufferWidthKey: Int(size.width),
            kCVPixelBufferHeightKey: Int(size.height),
            kCVPixelBufferIOSurfacePropertiesKey: [:] as CFDictionary,
        ]
        // One buffer being rendered on the capture thread plus one in flight on
        // `segQueue` is the steady state; the pool grows on its own if needed.
        let poolAttributes: [CFString: Any] = [
            kCVPixelBufferPoolMinimumBufferCountKey: 2
        ]

        var pool: CVPixelBufferPool?
        let status = CVPixelBufferPoolCreate(
            nil,
            poolAttributes as CFDictionary,
            attributes as CFDictionary,
            &pool
        )
        guard status == kCVReturnSuccess, let createdPool = pool else {
            segInputPool = nil
            segInputPoolSize = .zero
            return nil
        }

        segInputPool = createdPool
        segInputPoolSize = size
        return createdPool
    }

    /// Runs on `segQueue`. Performs Vision on the upright pooled input buffer, rotates
    /// the mask back into the camera buffer's orientation, blends it with the previous
    /// mask and stores the result under `segLock`. `inFlight` is always cleared via
    /// `defer`, so a thrown `perform`, missing results, or failed snapshot won't
    /// deadlock future frames.
    private func runSegmentation(
        on pixelBuffer: CVPixelBuffer,
        frameSize: CGSize,
        orientation: CGImagePropertyOrientation
    ) {
        defer {
            segLock.lock()
            inFlight = false
            segLock.unlock()
        }
        do {
            // The input was rotated upright in `makeSegmentationInput`.
            try requestHandler.perform([request], on: pixelBuffer, orientation: .up)
            guard let maskPixelBuffer = request.results?.first?.pixelBuffer else {
                logSegmentationFailure("Vision returned no mask")
                return
            }
            // Back into the buffer's orientation, so it lines up with the frame.
            let rotatedMask = CIImage(cvPixelBuffer: maskPixelBuffer).oriented(orientation)
            var newMask = rotatedMask.transformed(
                by: CGAffineTransform(
                    translationX: -rotatedMask.extent.origin.x,
                    y: -rotatedMask.extent.origin.y
                )
            )

            segLock.lock()
            let previousMask =
                lastMaskFrameSize == frameSize && lastMaskOrientation == orientation
                ? lastMask : nil
            segLock.unlock()
            if let previousMask, previousMask.extent == newMask.extent {
                newMask = Self.blend(newMask, onto: previousMask)
            }

            // Snapshot to a CGImage so `lastMask` survives Vision's potential buffer
            // reuse, and so the blend above is rendered once instead of growing a
            // graph of every mask so far.
            guard let maskCG = ciContext.createCGImage(newMask, from: newMask.extent) else {
                logSegmentationFailure("could not snapshot the mask")
                return
            }
            let snapshot = CIImage(cgImage: maskCG)
            segLock.lock()
            lastMask = snapshot
            lastMaskFrameSize = frameSize
            lastMaskOrientation = orientation
            segLock.unlock()
        } catch {
            let nsError = error as NSError
            logSegmentationFailure(
                "\(nsError.domain) code \(nsError.code): \(nsError.localizedDescription)")
            return
        }
    }

    /// `maskTemporalWeight` of `mask` plus the rest of `previous`.
    private static func blend(_ mask: CIImage, onto previous: CIImage) -> CIImage {
        let mix = CIFilter.mix()
        mix.inputImage = mask
        mix.backgroundImage = previous
        mix.amount = Float(maskTemporalWeight)
        return mix.outputImage ?? mask
    }

    /// Logs `reason` unless a failure was logged less than `failureLogInterval` ago.
    /// Called from both the capture thread and `segQueue`.
    private func logSegmentationFailure(_ reason: String) {
        let now = Date().timeIntervalSinceReferenceDate
        failureLogLock.lock()
        let shouldLog = now - lastFailureLog >= Self.failureLogInterval
        if shouldLog {
            lastFailureLog = now
        }
        failureLogLock.unlock()
        if shouldLog {
            NSLog("Person segmentation failed, sending background only: \(reason)")
        }
    }
}

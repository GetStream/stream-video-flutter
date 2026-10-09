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
/// This keeps the capture thread unblocked at the cost of ≤1–2 frames of mask staleness,
/// which is imperceptible in practice (Android uses the same pattern with ML Kit).
@available(iOS 15.0, *)
final class BackgroundImageFilterProcessor {
    private static let segmentationTargetHeight: CGFloat = 540

    private let requestHandler = VNSequenceRequestHandler()
    private let request: VNGeneratePersonSegmentationRequest

    // Async segmentation pipeline. The segmentation input is rendered on the GPU into
    // a pixel buffer from `segInputPool`, so it neither shares storage with the camera
    // buffer pool nor forces a GPU->CPU readback on the capture thread. The resulting
    // mask is snapshotted so it survives Vision reusing its own pooled result buffers.
    // `segQueue` serialises Vision calls — `VNSequenceRequestHandler` isn't thread-safe
    // under concurrent use. `segLock` guards `lastMask` and `inFlight`, both shared
    // between the capture thread and `segQueue`.
    private let ciContext = CIContext(options: [.useSoftwareRenderer: false])
    private let segColorSpace = CGColorSpaceCreateDeviceRGB()
    private let segQueue = DispatchQueue(
        label: "io.getstream.video.segmentation", qos: .userInitiated)
    private let segLock = NSLock()
    private var lastMask: CIImage?
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
    /// - Returns: The blended `CIImage`. While no mask is available yet (the first
    ///   request also loads the Vision model, which can take a few hundred
    ///   milliseconds) returns `backgroundImage` on its own, so the real background
    ///   is never sent unfiltered. Returns `nil` if the blend filter itself fails.
    func applyFilter(
        _ buffer: CVPixelBuffer,
        backgroundImage: CIImage
    ) -> CIImage? {
        let originalImage = CIImage(cvPixelBuffer: buffer)

        segLock.lock()
        let mask = lastMask
        let shouldDispatch = !inFlight
        if shouldDispatch {
            inFlight = true
        }
        segLock.unlock()

        if shouldDispatch {
            // Copy out of the camera buffer so Vision never shares storage with the
            // capture pool while the composite is being rendered.
            if let segInput = makeSegmentationInput(from: originalImage) {
                segQueue.async { [weak self] in
                    self?.runSegmentation(on: segInput)
                }
            } else {
                segLock.lock()
                inFlight = false
                segLock.unlock()
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

    /// Renders a downscaled copy of the frame into a pooled pixel buffer for Vision.
    ///
    /// Runs segmentation at ~540p — Vision's cost scales with input size, and the
    /// mask-upscale step above handles whatever size Vision returns. The copy stays
    /// on the GPU (`render(_:to:)` into an IOSurface-backed buffer), and a plain
    /// bilinear transform is used instead of Lanczos because the result is only a
    /// throwaway segmentation input.
    private func makeSegmentationInput(from image: CIImage) -> CVPixelBuffer? {
        var segImage = image
        if image.extent.height > Self.segmentationTargetHeight {
            let scale = Self.segmentationTargetHeight / image.extent.height
            segImage = image
                .transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        }
        // Normalise to the origin so the render below maps 1:1 onto the buffer.
        segImage = segImage.transformed(
            by: CGAffineTransform(
                translationX: -segImage.extent.origin.x,
                y: -segImage.extent.origin.y
            )
        )

        let targetSize = CGSize(
            width: segImage.extent.width.rounded(.down),
            height: segImage.extent.height.rounded(.down)
        )
        guard targetSize.width >= 1, targetSize.height >= 1,
            let pool = segmentationInputPool(for: targetSize)
        else {
            return nil
        }

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
    /// capture format changes (camera flip, quality update).
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

    /// Runs on `segQueue`. Performs Vision on the pooled input buffer and stores the
    /// result mask under `segLock`. `inFlight` is always cleared via `defer`, so a thrown
    /// `perform`, missing results, or failed snapshot won't deadlock future frames.
    private func runSegmentation(on pixelBuffer: CVPixelBuffer) {
        defer {
            segLock.lock()
            inFlight = false
            segLock.unlock()
        }
        do {
            try requestHandler.perform([request], on: pixelBuffer, orientation: .up)
            guard let maskPixelBuffer = request.results?.first?.pixelBuffer else {
                return
            }
            let rawMask = CIImage(cvPixelBuffer: maskPixelBuffer)
            // Snapshot to a CGImage so `lastMask` survives Vision's potential buffer reuse.
            guard let maskCG = ciContext.createCGImage(rawMask, from: rawMask.extent) else {
                return
            }
            let snapshot = CIImage(cgImage: maskCG)
            segLock.lock()
            lastMask = snapshot
            segLock.unlock()
        } catch {
            return
        }
    }
}

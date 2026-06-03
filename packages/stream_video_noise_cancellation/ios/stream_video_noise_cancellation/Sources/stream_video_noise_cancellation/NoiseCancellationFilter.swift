//

// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Foundation
import os
import stream_webrtc_flutter

/// A concrete implementation of `AudioFilter` that applies noise cancellation effects.
public final class NoiseCancellationFilter: AudioFilter, @unchecked Sendable {

    public typealias InitializeClosure = (Int, Int) -> Void
    public typealias ProcessClosure = (Int, Int, Int, UnsafeMutablePointer<Float>) -> Void
    public typealias ReleaseClosure = () -> Void

    private var isActive: Bool = false

    /// Guards `isActive` and, crucially, the underlying noise-cancellation processor so that
    /// `process` can never run concurrently with `initialize` / `release`.
    private let unfairLock: os_unfair_lock_t = {
        let lock = os_unfair_lock_t.allocate(capacity: 1)
        lock.initialize(to: os_unfair_lock())
        return lock
    }()

    private let name: String
    private let initializeClosure: InitializeClosure
    private let processClosure: ProcessClosure
    private let releaseClosure: ReleaseClosure

    /// Initializes a new instance of `NoiseCancellationFilter`.
    /// - Parameters:
    ///   - name: The name identifier for the filter.
    ///   - initialize: The closure to initialize the filter with sample rate and channels.
    ///   - process: The closure to apply noise cancellation processing.
    ///   - release: The closure to release the filter.
    public init(
        name: String,
        initialize: @escaping InitializeClosure,
        process: @escaping ProcessClosure,
        release: @escaping ReleaseClosure
    ) {
        self.name = name
        initializeClosure = initialize
        processClosure = process
        releaseClosure = release
    }

    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }

    // MARK: - AudioFilter

    /// The identifier of the filter.
    public var id: String { name }

    /// Initializes the filter with the specified sample rate and number of channels.
    /// - Parameters:
    ///   - sampleRate: The sample rate in Hz.
    ///   - channels: The number of audio channels.
    public func initialize(sampleRate: Int, channels: Int) {
        os_unfair_lock_lock(unfairLock)
        defer { os_unfair_lock_unlock(unfairLock) }
        guard !isActive else { return }
        initializeClosure(sampleRate, channels)
        isActive = true
    }

    /// Applies noise cancellation processing to the audio buffer.
    /// - Parameter buffer: The audio buffer to which the effect is applied.
    public func applyEffect(to buffer: inout RTCAudioBuffer) {
        os_unfair_lock_lock(unfairLock)
        defer { os_unfair_lock_unlock(unfairLock) }
        guard isActive else { return }
        processClosure(
            buffer.channels,
            buffer.bands,
            buffer.frames,
            buffer.rawBuffer(forChannel: 0)
        )
    }

    /// Releases the filter by stopping noise cancellation for the active call.
    ///
    /// Holding `unfairLock` here ensures the Krisp model is never freed while
    /// `applyEffect(to:)` is mid-flight on the audio thread.
    public func release() {
        os_unfair_lock_lock(unfairLock)
        defer { os_unfair_lock_unlock(unfairLock) }
        guard isActive else { return }
        isActive = false
        releaseClosure()
    }
}

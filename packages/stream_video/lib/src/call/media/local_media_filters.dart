import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart' as rtc;
import 'package:synchronized/synchronized.dart';

import '../../errors/stream_video_exception_composer.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';
import '../../webrtc/rtc_track/rtc_track.dart';

/// Where a changed filter chain stands.
@internal
enum LocalFilterChange {
  /// The chain runs on the capture in use.
  applied,

  /// No capture of that kind is in use; the chain runs on the next one.
  deferred,
}

/// The filter chains of a call's local media: one for the camera, one for the
/// microphone and one for the screen share.
///
/// Each chain runs on every new capture of its kind, in order: the app's
/// filter first, then the call's own (the moderation blur on the camera, the
/// audio processor's filter on the microphone). A change to a chain runs it
/// again on the capture in use; when that changes the stream sent,
/// [onOutputChanged] sends the new one.
@internal
class LocalMediaFilters {
  LocalMediaFilters({this._audioProcessorFilter, TaggedLogger? logger})
    : _logger = logger ?? taggedLogger(tag: 'SV:LocalMediaFilters');

  final rtc.AudioFilter? Function()? _audioProcessorFilter;
  final TaggedLogger _logger;

  /// Sends what the chain of a kind now makes of the capture in use, in place
  /// of the stream sent so far.
  Future<Result<None>> Function(SfuTrackType kind)? onOutputChanged;

  final _locks = <SfuTrackType, Lock>{};
  final _changeLocks = <SfuTrackType, Lock>{};
  final _applied = <SfuTrackType, _AppliedChain>{};

  rtc.VideoFilter? _videoFilter;
  rtc.VideoFilter? _moderationFilter;
  rtc.VideoFilter? _screenShareFilter;
  rtc.AudioFilter? _audioFilter;

  /// The app's camera filter.
  rtc.VideoFilter? get videoFilter => _videoFilter;

  /// The app's microphone filter.
  rtc.AudioFilter? get audioFilter => _audioFilter;

  /// The moderation blur, applied after [videoFilter] while set.
  rtc.VideoFilter? get moderationFilter => _moderationFilter;

  /// Sets the app's camera filter. Fails when a filter of the chain fails,
  /// keeping the previous filter.
  Future<Result<LocalFilterChange>> setVideoFilter(rtc.VideoFilter? filter) {
    return _change(SfuTrackType.video, () {
      final previous = _videoFilter;
      _videoFilter = filter;
      return () => _videoFilter = previous;
    });
  }

  /// Sets the moderation blur, which runs after the app's camera filter.
  ///
  /// Fails when the blur fails; a failure of the app's filter is logged. A
  /// new capture is not sent while the blur fails on it.
  Future<Result<LocalFilterChange>> setModerationFilter(
    rtc.VideoFilter? filter,
  ) {
    return _change(SfuTrackType.video, () {
      _moderationFilter = filter;
      return null;
    }, failOnOptional: false);
  }

  /// Sets the screen share filter. Fails when a filter of the chain fails,
  /// keeping the previous filter.
  Future<Result<LocalFilterChange>> setScreenShareFilter(
    rtc.VideoFilter? filter,
  ) {
    return _change(SfuTrackType.screenShare, () {
      final previous = _screenShareFilter;
      _screenShareFilter = filter;
      return () => _screenShareFilter = previous;
    });
  }

  /// Sets the app's microphone filter. Fails when a filter of the chain
  /// fails, keeping the previous filter.
  Future<Result<LocalFilterChange>> setAudioFilter(rtc.AudioFilter? filter) {
    return _change(SfuTrackType.audio, () {
      final previous = _audioFilter;
      _audioFilter = filter;
      return () => _audioFilter = previous;
    });
  }

  List<_ChainEntry> _chainFor(SfuTrackType kind) {
    if (kind == SfuTrackType.video) {
      return [
        if (_videoFilter case final filter?) _ChainEntry(filter),
        if (_moderationFilter case final filter?)
          _ChainEntry(filter, required: true),
      ];
    }
    if (kind == SfuTrackType.audio) {
      return [
        if (_audioFilter case final filter?) _ChainEntry(filter),
        if (_processorFilter() case final filter?) _ChainEntry(filter),
      ];
    }
    if (kind == SfuTrackType.screenShare) {
      return [if (_screenShareFilter case final filter?) _ChainEntry(filter)];
    }
    return const [];
  }

  rtc.AudioFilter? _processorFilter() {
    try {
      return _audioProcessorFilter?.call();
    } catch (e, stk) {
      _logger.e(() => '[chain] the audio processor filter failed: $e\n$stk');
      return null;
    }
  }

  static rtc.MediaStreamFilterSource? _sourceOf(SfuTrackType kind) {
    if (kind == SfuTrackType.video) return rtc.MediaStreamFilterSource.camera;
    if (kind == SfuTrackType.audio) {
      return rtc.MediaStreamFilterSource.microphone;
    }
    if (kind == SfuTrackType.screenShare) {
      return rtc.MediaStreamFilterSource.screenShare;
    }
    return null;
  }

  Lock _lockFor(SfuTrackType kind) => _locks.putIfAbsent(kind, Lock.new);

  /// [track] as the chain of its kind makes it: the chain's output for a
  /// capture the chain already runs on, or for a new capture after the chain
  /// ran on it. A new capture stops the filters of the capture it replaces,
  /// unless [isCurrent] says it no longer replaces it.
  ///
  /// Throws when a filter that must apply, the moderation blur, fails.
  Future<RtcLocalTrack> apply(
    RtcLocalTrack track, {
    bool Function()? isCurrent,
  }) {
    final kind = track.trackType;
    final source = _sourceOf(kind);
    if (source == null) return Future.value(track);

    return _lockFor(kind).synchronized(() async {
      final previous = _applied[kind];
      if (previous != null && previous.holds(track)) {
        return previous.sent(track);
      }

      if (isCurrent != null && !isCurrent()) {
        throw StateError('${track.trackId} was replaced while it was filtered');
      }

      if (previous != null) {
        _applied.remove(kind);
        await previous.stop(
          rtc.MediaStreamFilterStopReason.captureReplaced,
          _logger,
        );
      }

      final applied = await _AppliedChain.run(
        _chainFor(kind),
        source: source,
        capture: track.capturedStream ?? track.mediaStream,
        captureTrack: track.capturedTrack,
        logger: _logger,
      );
      if (applied.requiredFailure case final failure?) {
        await applied.stop(rtc.MediaStreamFilterStopReason.rejected, _logger);
        Error.throwWithStackTrace(failure.error, failure.stackTrace);
      }

      _applied[kind] = applied;
      return applied.sent(track);
    });
  }

  /// Stops the filters of [track]'s capture, once that capture is stopped.
  Future<void> release(RtcLocalTrack track) {
    final kind = track.trackType;
    return _lockFor(kind).synchronized(() async {
      final applied = _applied[kind];
      if (applied == null || !applied.holds(track)) return;

      _applied.remove(kind);
      await applied.stop(
        rtc.MediaStreamFilterStopReason.captureReleased,
        _logger,
      );
    });
  }

  /// Changes a chain, then runs it again on the capture of that kind in use.
  ///
  /// The new chain is applied before the old one is stopped, and its output
  /// is sent first when it is another stream. When the moderation blur fails
  /// on the capture, another filter of the chain fails and [failOnOptional]
  /// is true, or the new stream cannot be sent, the new chain is stopped, the
  /// old one stays applied and the undo that [change] returns, if any, runs.
  /// A new capture that started with the new chain while its stream was being
  /// sent keeps it; a capture released meanwhile does not.
  ///
  /// Changes of a kind run one at a time, each until its stream is sent.
  Future<Result<LocalFilterChange>> _change(
    SfuTrackType kind,
    void Function()? Function() change, {
    bool failOnOptional = true,
  }) {
    return _changeLocks
        .putIfAbsent(kind, Lock.new)
        .synchronized(
          () => _changeChain(kind, change, failOnOptional: failOnOptional),
        );
  }

  Future<Result<LocalFilterChange>> _changeChain(
    SfuTrackType kind,
    void Function()? Function() change, {
    required bool failOnOptional,
  }) async {
    final lock = _lockFor(kind);
    final changed = await lock.synchronized(
      () => _runChange(kind, change, failOnOptional: failOnOptional),
    );
    if (changed == null) {
      return const Result.success(LocalFilterChange.deferred);
    }

    final (:applied, :retired, :rejection, :revert) = changed;
    if (rejection != null) return _failureOf(rejection);

    if (!identical(applied.output, retired.output)) {
      final sent = await _sendOutput(kind);
      if (sent case final Failure failure) {
        await lock.synchronized(() async {
          final restored = await _restore(kind, applied, retired);
          // Kept only by a newer capture that already runs it.
          if (restored || _applied[kind] == null) revert?.call();
        });
        return failure;
      }
    }

    await lock.synchronized(
      () => retired.stop(rtc.MediaStreamFilterStopReason.chainChanged, _logger),
    );
    return const Result.success(LocalFilterChange.applied);
  }

  /// Makes [change] and runs the changed chain on the capture of [kind] in
  /// use, under its lock. A rejected chain is stopped and [change] undone
  /// before the lock is released, so no new capture runs it. Null when no
  /// capture is in use; otherwise the undo [change] returned comes with the
  /// chains.
  Future<
    ({
      _AppliedChain applied,
      _AppliedChain retired,
      _FilterFailure? rejection,
      void Function()? revert,
    })?
  >
  _runChange(
    SfuTrackType kind,
    void Function()? Function() change, {
    required bool failOnOptional,
  }) async {
    final revert = change();

    final current = _applied[kind];
    if (current == null) return null;

    final applied = await _AppliedChain.run(
      _chainFor(kind),
      source: current.input.source,
      capture: current.capture,
      captureTrack: current.captureTrack,
      knownTrackIds: current.knownTrackIds,
      logger: _logger,
    );
    final rejection =
        applied.requiredFailure ??
        (failOnOptional ? applied.failures.firstOrNull : null);
    if (rejection == null) {
      _applied[kind] = applied;
    } else {
      revert?.call();
      await applied.stop(rtc.MediaStreamFilterStopReason.rejected, _logger);
    }
    return (
      applied: applied,
      retired: current,
      rejection: rejection,
      revert: revert,
    );
  }

  /// Puts [retired] back in place of [applied], whose output was not sent,
  /// and returns whether it did. When a new capture replaced [applied]
  /// meanwhile, [retired] is stopped instead.
  Future<bool> _restore(
    SfuTrackType kind,
    _AppliedChain applied,
    _AppliedChain retired,
  ) async {
    if (!identical(_applied[kind], applied)) {
      await retired.stop(
        rtc.MediaStreamFilterStopReason.chainChanged,
        _logger,
      );
      return false;
    }
    _applied[kind] = retired;
    await applied.stop(rtc.MediaStreamFilterStopReason.rejected, _logger);
    return true;
  }

  static Result<LocalFilterChange> _failureOf(_FilterFailure failure) {
    return Result.failure(
      StreamVideoExceptions.compose(failure.error, failure.stackTrace),
      failure.stackTrace,
    );
  }

  Future<Result<None>> _sendOutput(SfuTrackType kind) async {
    final send = onOutputChanged;
    if (send == null) return const Result.success(none);
    try {
      final result = await send(kind);
      if (result case Failure(:final error)) {
        _logger.e(() => '[change] failed to send the new $kind stream: $error');
      }
      return result;
    } catch (e, stk) {
      _logger.e(() => '[change] failed to send the new $kind stream: $e\n$stk');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Stops every applied filter, keeping the chains for the next capture.
  Future<void> stopAll() async {
    for (final kind in _applied.keys.toList()) {
      await _lockFor(kind).synchronized(() async {
        final applied = _applied.remove(kind);
        await applied?.stop(
          rtc.MediaStreamFilterStopReason.captureReleased,
          _logger,
        );
      });
    }
  }
}

class _ChainEntry {
  const _ChainEntry(this.filter, {this.required = false});

  final rtc.MediaStreamFilter filter;

  /// Whether a capture must not be sent while this filter fails on it.
  final bool required;
}

class _FilterFailure {
  const _FilterFailure(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}

/// A chain applied to one capture.
class _AppliedChain {
  _AppliedChain._({
    required this.input,
    required this.capture,
    required this.captureTrack,
    required this.output,
    required this.outputTrack,
    required this.knownTrackIds,
    required this._results,
    required this.failures,
    required this.requiredFailure,
  });

  static Future<_AppliedChain> run(
    List<_ChainEntry> chain, {
    required rtc.MediaStreamFilterSource source,
    required rtc.MediaStream capture,
    required rtc.MediaStreamTrack captureTrack,
    required TaggedLogger logger,
    Set<String> knownTrackIds = const {},
  }) async {
    final results = <rtc.MediaStreamFilterResult>[];
    final failures = <_FilterFailure>[];
    _FilterFailure? requiredFailure;
    var stream = capture;
    var track = captureTrack;

    for (final entry in chain) {
      final filter = entry.filter;
      try {
        final result = await filter.apply(
          rtc.MediaStreamFilterInput(stream: stream, source: source),
        );
        final output = result.output;
        final outputTrack = identical(output, stream)
            ? track
            : _trackOf(output, source);
        if (outputTrack == null) {
          await result.stop?.call(
            const rtc.MediaStreamFilterStopDetails(
              reason: rtc.MediaStreamFilterStopReason.rejected,
            ),
          );
          throw StateError('${filter.runtimeType} made a stream with no track');
        }
        results.add(result);
        stream = output;
        track = outputTrack;
      } catch (e, stk) {
        logger.e(() => '[apply] ${filter.runtimeType} failed: $e\n$stk');
        final failure = _FilterFailure(e, stk);
        failures.add(failure);
        if (entry.required) requiredFailure ??= failure;
      }
    }

    return _AppliedChain._(
      input: rtc.MediaStreamFilterInput(stream: capture, source: source),
      capture: capture,
      captureTrack: captureTrack,
      output: stream,
      outputTrack: track,
      knownTrackIds: {...knownTrackIds, captureTrack.id!, track.id!},
      results: results,
      failures: failures,
      requiredFailure: requiredFailure,
    );
  }

  static rtc.MediaStreamTrack? _trackOf(
    rtc.MediaStream stream,
    rtc.MediaStreamFilterSource source,
  ) {
    final tracks = source == rtc.MediaStreamFilterSource.microphone
        ? stream.getAudioTracks()
        : stream.getVideoTracks();
    return tracks.firstOrNull;
  }

  /// The captured stream the chain ran on, with its source.
  final rtc.MediaStreamFilterInput input;

  /// The captured stream the chain ran on.
  final rtc.MediaStream capture;

  /// The captured track the chain ran on.
  final rtc.MediaStreamTrack captureTrack;

  /// The stream the chain made of [capture].
  final rtc.MediaStream output;

  /// The track of [output] that is sent.
  final rtc.MediaStreamTrack outputTrack;

  /// The ids of [captureTrack] and of every track the chains run on it made.
  final Set<String> knownTrackIds;

  /// The filters that failed, in order.
  final List<_FilterFailure> failures;

  /// The failure of a filter that must apply, if one failed.
  final _FilterFailure? requiredFailure;

  final List<rtc.MediaStreamFilterResult> _results;

  /// Whether [track] is the capture this chain ran on, or what a chain run
  /// on it made.
  bool holds(RtcLocalTrack track) {
    return knownTrackIds.contains(track.mediaTrack.id) ||
        knownTrackIds.contains(track.capturedTrack.id);
  }

  /// [track] sending [output].
  RtcLocalTrack sent(RtcLocalTrack track) {
    if (identical(track.mediaStream, output)) return track;
    return track.withMedia(
      stream: output,
      track: outputTrack,
      capturedStream: identical(output, capture) ? null : capture,
    );
  }

  /// Stops the filters, last first. A failure is logged.
  Future<void> stop(
    rtc.MediaStreamFilterStopReason reason,
    TaggedLogger logger,
  ) async {
    final details = rtc.MediaStreamFilterStopDetails(reason: reason);
    for (final result in _results.reversed) {
      try {
        await result.stop?.call(details);
      } catch (e, stk) {
        logger.w(() => '[stop] filter stop failed: $e\n$stk');
      }
    }
  }
}

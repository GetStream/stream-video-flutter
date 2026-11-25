import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:synchronized/synchronized.dart';

import '../../logger/impl/tagged_logger.dart';
import '../../sfu/data/models/sfu_track_type.dart';
import '../../webrtc/rtc_track/rtc_track.dart';

/// Runs the local media filters on a new capture, returning the track to
/// send in its place.
@internal
typedef LocalCaptureFilter =
    Future<RtcLocalTrack> Function(RtcLocalTrack track);

/// The filter chains of a call's local media: one for the camera, one for the
/// microphone and one for the screen share.
///
/// Each chain runs on every new capture of its kind, in order: the app's
/// filter first, then the call's own (the moderation blur on the camera, the
/// audio processor's filter on the microphone). A change to a chain applies
/// to the capture in use right away.
@internal
class LocalMediaFilters {
  LocalMediaFilters({
    rtc.AudioFilter? Function()? audioProcessorFilter,
    TaggedLogger? logger,
  }) : _audioProcessorFilter = audioProcessorFilter,
       _logger = logger ?? taggedLogger(tag: 'SV:LocalMediaFilters');

  final rtc.AudioFilter? Function()? _audioProcessorFilter;
  final TaggedLogger _logger;

  final _locks = <SfuTrackType, Lock>{};
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

  /// Sets the app's camera filter.
  Future<void> setVideoFilter(rtc.VideoFilter? filter) {
    return _change(SfuTrackType.video, () => _videoFilter = filter);
  }

  /// Sets the moderation blur, which runs after the app's camera filter.
  Future<void> setModerationFilter(rtc.VideoFilter? filter) {
    return _change(SfuTrackType.video, () => _moderationFilter = filter);
  }

  /// Sets the screen share filter.
  Future<void> setScreenShareFilter(rtc.VideoFilter? filter) {
    return _change(SfuTrackType.screenShare, () => _screenShareFilter = filter);
  }

  /// Sets the app's microphone filter.
  Future<void> setAudioFilter(rtc.AudioFilter? filter) {
    return _change(SfuTrackType.audio, () => _audioFilter = filter);
  }

  /// Applies the microphone chain again, after the audio processor's filter
  /// changed.
  Future<void> refreshAudioFilters() => _change(SfuTrackType.audio, () {});

  List<rtc.MediaStreamFilter> _chainFor(SfuTrackType kind) {
    if (kind == SfuTrackType.video) return [?_videoFilter, ?_moderationFilter];
    if (kind == SfuTrackType.audio) {
      return [?_audioFilter, ?_audioProcessorFilter?.call()];
    }
    if (kind == SfuTrackType.screenShare) return [?_screenShareFilter];
    return const [];
  }

  static bool _isFiltered(SfuTrackType kind) =>
      kind == SfuTrackType.video ||
      kind == SfuTrackType.audio ||
      kind == SfuTrackType.screenShare;

  Lock _lockFor(SfuTrackType kind) => _locks.putIfAbsent(kind, Lock.new);

  /// Runs the chain of [track]'s kind on it, unless that capture was
  /// filtered already. Stops the filters of the capture it replaces.
  Future<RtcLocalTrack> apply(RtcLocalTrack track) {
    final kind = track.trackType;
    if (!_isFiltered(kind)) return Future.value(track);

    return _lockFor(kind).synchronized(() async {
      final previous = _applied[kind];
      if (previous != null && previous.holds(track.mediaTrack)) return track;

      if (previous != null) {
        _applied.remove(kind);
        await previous.stop(_logger);
      }

      final applied = await _AppliedChain.run(
        _chainFor(kind),
        track.mediaStream,
        track.mediaTrack,
        _logger,
      );
      _applied[kind] = applied;

      if (identical(applied.output, track.mediaStream)) return track;

      final outputTrack = applied.outputTrack(kind);
      if (outputTrack == null) {
        _logger.w(() => '[apply] filter output has no $kind track, ignored');
        await applied.stop(_logger);
        _applied[kind] = _AppliedChain.unfiltered(
          track.mediaStream,
          track.mediaTrack,
        );
        return track;
      }

      return track.copyWith(
        mediaStream: applied.output,
        mediaTrack: outputTrack,
      );
    });
  }

  /// Changes a chain, then applies it again to the capture of that kind in
  /// use.
  Future<void> _change(SfuTrackType kind, void Function() change) {
    return _lockFor(kind).synchronized(() async {
      change();

      final current = _applied[kind];
      if (current == null) return;

      if (!current.isPassThrough) {
        // The stream being sent would end; a new chain applies from the next
        // capture.
        _logger.w(() => '[change] $kind applies from the next capture');
        return;
      }

      await current.stop(_logger);
      final applied = await _AppliedChain.run(
        _chainFor(kind),
        current.source,
        current.sourceTrack,
        _logger,
      );

      if (!applied.isPassThrough) {
        _logger.w(() => '[change] $kind applies from the next capture');
        await applied.stop(_logger);
        _applied[kind] = _AppliedChain.unfiltered(
          current.source,
          current.sourceTrack,
        );
        return;
      }

      _applied[kind] = applied;
    });
  }

  /// Stops every applied filter, keeping the chains for the next capture.
  Future<void> stopAll() async {
    for (final kind in _applied.keys.toList()) {
      await _lockFor(kind).synchronized(() async {
        final applied = _applied.remove(kind);
        await applied?.stop(_logger);
      });
    }
  }
}

/// A chain applied to one capture.
class _AppliedChain {
  _AppliedChain._(this.source, this.sourceTrack, this.output, this._results);

  _AppliedChain.unfiltered(this.source, this.sourceTrack)
    : output = source,
      _results = const [];

  static Future<_AppliedChain> run(
    List<rtc.MediaStreamFilter> chain,
    rtc.MediaStream source,
    rtc.MediaStreamTrack sourceTrack,
    TaggedLogger logger,
  ) async {
    final results = <rtc.MediaStreamFilterResult>[];
    var stream = source;
    for (final filter in chain) {
      try {
        final result = await filter.apply(stream);
        results.add(result);
        stream = result.output;
      } catch (e, stk) {
        logger.e(() => '[apply] ${filter.runtimeType} failed: $e\n$stk');
      }
    }
    return _AppliedChain._(source, sourceTrack, stream, results);
  }

  /// The captured stream the chain ran on.
  final rtc.MediaStream source;

  /// The captured track the chain ran on.
  final rtc.MediaStreamTrack sourceTrack;

  /// The stream the chain made of [source].
  final rtc.MediaStream output;

  final List<rtc.MediaStreamFilterResult> _results;

  /// Whether the chain sends [source] itself.
  bool get isPassThrough => identical(output, source);

  rtc.MediaStreamTrack? outputTrack(SfuTrackType kind) {
    final tracks = kind == SfuTrackType.audio
        ? output.getAudioTracks()
        : output.getVideoTracks();
    return tracks.firstOrNull;
  }

  /// Whether [track] is the capture this chain ran on, or what it made.
  bool holds(rtc.MediaStreamTrack track) {
    if (track.id == sourceTrack.id) return true;
    return output.getTracks().any((it) => it.id == track.id);
  }

  /// Stops the filters, last first. A failure is logged.
  Future<void> stop(TaggedLogger logger) async {
    for (final result in _results.reversed) {
      try {
        await result.stop?.call();
      } catch (e, stk) {
        logger.w(() => '[stop] filter stop failed: $e\n$stk');
      }
    }
  }
}

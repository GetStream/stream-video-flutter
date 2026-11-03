import 'package:meta/meta.dart';

import '../../../stream_video.dart';
import '../../errors/stream_video_exception_composer.dart';
import '../peer_connection_factory.dart';

final _logger = taggedLogger(tag: 'SV:LocalTrackAcquirer');

/// Opens the camera, the microphone and the screen share as local tracks.
///
/// Acquiring only: publishing the track is left to the caller. A track type
/// has at most one acquisition in flight through [singleFlight].
@internal
class LocalTrackAcquirer {
  LocalTrackAcquirer({
    required this._pcFactory,
    required this._publisherId,
  });

  final StreamPeerConnectionFactory _pcFactory;

  /// The prefix of every acquired track id, or null when this session does
  /// not publish, in which case every acquisition fails.
  final String? _publisherId;

  /// The constraints a microphone track is acquired with when none are given.
  AudioConstraints defaultAudioConstraints = const AudioConstraints();

  /// Acquisitions (and whatever the caller does with the track) in flight per
  /// track type.
  final _inFlight = <SfuTrackType, Future<Result<RtcLocalTrack>>>{};

  /// Runs [create] as the single in-flight acquisition for [trackType],
  /// returning the already-running one when there is one.
  Future<Result<RtcLocalTrack>> singleFlight(
    SfuTrackType trackType,
    Future<Result<RtcLocalTrack>> Function() create,
  ) {
    final inFlight = _inFlight[trackType];
    if (inFlight != null) {
      _logger.i(
        () =>
            '[createTrack] $trackType is already being created; '
            'joining the in-flight request instead of acquiring media again',
      );
      return inFlight;
    }

    final pending = create();
    _inFlight[trackType] = pending;

    return pending.whenComplete(() => _inFlight.remove(trackType));
  }

  /// The acquisition in flight for [trackType], if any.
  Future<Result<RtcLocalTrack>>? inFlight(SfuTrackType trackType) {
    return _inFlight[trackType];
  }

  /// Acquires a track of [trackType] with [constraints], falling back to the
  /// defaults of that type. Fails when [constraints] are of another type.
  Future<Result<RtcLocalTrack>> acquire({
    required SfuTrackType trackType,
    MediaConstraints? constraints,
  }) async {
    if (trackType == SfuTrackType.video) {
      if (constraints != null && constraints is! CameraConstraints) {
        return _invalidConstraints(constraints, CameraConstraints);
      }
      return _createCameraTrack(
        constraints:
            (constraints ?? const CameraConstraints()) as CameraConstraints,
      );
    } else if (trackType == SfuTrackType.audio) {
      if (constraints != null && constraints is! AudioConstraints) {
        return _invalidConstraints(constraints, AudioConstraints);
      }
      return _createAudioTrack(
        constraints:
            (constraints ?? defaultAudioConstraints) as AudioConstraints,
      );
    } else if (trackType == SfuTrackType.screenShare) {
      if (constraints != null && constraints is! ScreenShareConstraints) {
        return _invalidConstraints(constraints, ScreenShareConstraints);
      }
      return createScreenShareTrack(
        constraints:
            (constraints ?? const ScreenShareConstraints())
                as ScreenShareConstraints,
      );
    }

    _logger.e(() => 'Unsupported trackType $trackType');
    return failureWithError('Unsupported trackType $trackType');
  }

  Result<RtcLocalTrack> _invalidConstraints(
    MediaConstraints constraints,
    Type expected,
  ) {
    final errorMessage =
        'Invalid media constraints type ${constraints.runtimeType}, $expected expected';
    _logger.e(() => errorMessage);
    return failureWithError(errorMessage);
  }

  Future<Result<RtcLocalAudioTrack>> _createAudioTrack({
    AudioConstraints? constraints,
  }) async {
    _logger.d(() => '[createAudioTrack] constraints: ${constraints?.toMap()}');

    final publisherId = _publisherId;
    if (publisherId == null) {
      return failureWithError(
        'Publisher is not created, cannot create audio track',
      );
    }

    try {
      final nativeFactory = await _pcFactory.ensureNativeFactory();
      final audioTrack = await RtcLocalTrack.audio(
        trackIdPrefix: publisherId,
        constraints: constraints ?? defaultAudioConstraints,
        nativeFactory: nativeFactory,
      );

      return Result.success(audioTrack);
    } catch (e, stk) {
      _logger.e(() => '[createAudioTrack] rejected: $e');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  Future<Result<RtcLocalCameraTrack>> _createCameraTrack({
    CameraConstraints constraints = const CameraConstraints(),
  }) async {
    _logger.d(() => '[createCameraTrack] constraints: ${constraints.toMap()}');

    final publisherId = _publisherId;
    if (publisherId == null) {
      return failureWithError(
        'Publisher is not created, cannot create camera track',
      );
    }

    try {
      final nativeFactory = await _pcFactory.ensureNativeFactory();
      final videoTrack = await RtcLocalTrack.camera(
        trackIdPrefix: publisherId,
        constraints: constraints,
        nativeFactory: nativeFactory,
      );

      return Result.success(videoTrack);
    } catch (e, stk) {
      _logger.e(() => '[createCameraTrack] rejected: $e');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Acquires a screen share track with [constraints].
  Future<Result<RtcLocalScreenShareTrack>> createScreenShareTrack({
    ScreenShareConstraints constraints = const ScreenShareConstraints(),
  }) async {
    _logger.d(
      () => '[createScreenShareTrack] constraints: ${constraints.toMap()}',
    );

    final publisherId = _publisherId;
    if (publisherId == null) {
      return failureWithError(
        'Publisher is not created, cannot create screen share track',
      );
    }

    try {
      final nativeFactory = await _pcFactory.ensureNativeFactory();
      final screenShareTrack = await RtcLocalTrack.screenShare(
        trackIdPrefix: publisherId,
        constraints: constraints,
        nativeFactory: nativeFactory,
      );

      return Result.success(screenShareTrack);
    } catch (e, stk) {
      _logger.e(() => '[createScreenShareTrack] rejected: $e');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }
}

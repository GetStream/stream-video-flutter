import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../../stream_video.dart';

const _tag = 'SV:CaptureDimension';

/// The physical size of the first Flutter view, or null when there is no
/// view or it has no size yet (e.g. the app was started in the background).
@internal
RtcVideoDimension? platformScreenDimension() {
  final view = WidgetsBinding.instance.platformDispatcher.views.firstOrNull;
  if (view == null) return null;

  final dimension = RtcVideoDimension(
    width: view.physicalSize.width.toInt(),
    height: view.physicalSize.height.toInt(),
  );

  return dimension.isEmpty ? null : dimension;
}

/// Works out the size a local video track is encoded at, which its layers
/// are announced and budgeted from.
///
/// A screen share is announced at the screen size. A mobile camera reports
/// the sensor's capture size, which is landscape, so it is announced in the
/// orientation of the screen. That is a plugin workaround: Android marks a
/// size already rotated to the delivered frames with `sensorOrientation`, iOS
/// does not. Once every platform reports a frame-oriented size, the screen
/// size is needed for screen share only.
@internal
class CaptureDimensionResolver {
  const CaptureDimensionResolver({
    RtcVideoDimension? Function() screenDimension = platformScreenDimension,
  }) : _screenDimension = screenDimension;

  /// The size of the screen, or null when it is unknown.
  final RtcVideoDimension? Function() _screenDimension;

  /// The size [track] is encoded at.
  RtcVideoDimension resolve(RtcLocalVideoTrack track) {
    var dimension = track.getVideoDimension();

    if (track.trackType == SfuTrackType.screenShare) {
      final screenDimension = _screenDimension();
      streamLog.v(
        _tag,
        () => '[publishVideoTrack] screenDimension: $screenDimension',
      );

      if (screenDimension != null) dimension = screenDimension;
    } else if (track.trackType == SfuTrackType.video &&
        CurrentPlatform.isMobile &&
        !track.reportsFrameOrientedSize()) {
      // Frames are rotated to the display before encoding: a phone held
      // upright encodes portrait frames.
      final screenDimension = _screenDimension();
      if (screenDimension != null) {
        dimension = dimension.orientedLike(screenDimension);
      }
    }

    return dimension;
  }
}

extension on RtcLocalTrack<VideoConstraints> {
  /// The size the camera actually captures at, which the layers are announced
  /// and budgeted from. It can differ from what was requested: a 4:3 camera
  /// asked for 2560x1440 captures at 1920x1440.
  ///
  /// Falls back to the size already resolved for this track, then to the
  /// requested constraints. The first fallback matters for clones on Android,
  /// which carry no settings of their own.
  RtcVideoDimension getVideoDimension() {
    var dimension = videoDimension ?? mediaConstraints.params.dimension;

    try {
      // Implemented on web and, via the webrtc fork, on iOS and Android.
      final settings = mediaTrack.getSettings();
      streamLog.v(_tag, () => '[publishVideoTrack] settings: $settings');
      final width = settings['width'];
      final height = settings['height'];
      if (width is num && width > 0) {
        dimension = dimension.copyWith(width: width.toInt());
      }
      if (height is num && height > 0) {
        dimension = dimension.copyWith(height: height.toInt());
      }
    } catch (_) {
      streamLog.w(
        _tag,
        () => '[publishVideoTrack] `mediaStreamTrack.getSettings()` failed',
      );
    }
    return dimension;
  }

  /// Whether the platform reports the capture size already rotated to the
  /// orientation of the delivered frames.
  ///
  /// Android only: stream_webrtc_flutter marks such settings with the
  /// camera's `sensorOrientation`. iOS never sets the marker, so
  /// it always falls back to the Flutter view's orientation.
  bool reportsFrameOrientedSize() {
    try {
      return mediaTrack.getSettings().containsKey('sensorOrientation');
    } catch (_) {
      // Already logged by getVideoDimension(), which makes the same call
      // first.
      return false;
    }
  }
}

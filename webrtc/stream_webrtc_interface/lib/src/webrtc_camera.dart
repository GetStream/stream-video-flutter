import 'dart:math';

import 'package:meta/meta.dart';

import 'third_party/webrtc_interface/media_stream_track.dart';

/// Controls a running camera capture.
///
/// Implemented by the WebRTC packages only.
@sealed
abstract class WebRtcCamera {
  /// Switches the camera of the video [track]: between front and back on
  /// mobile, to the next camera on desktop. Returns whether the camera in use
  /// now faces the user. Throws where
  /// `WebRtcCapabilities.supportsCameraSwitch` is false.
  Future<bool> switchCamera(MediaStreamTrack track);

  /// Sets the zoom of the camera capturing the video [track].
  Future<void> setZoom(MediaStreamTrack track, double zoomLevel);

  /// Focuses the camera capturing the video [track] on [point], with both
  /// coordinates from 0 to 1. Null goes back to automatic focus.
  Future<void> setFocusPoint(MediaStreamTrack track, Point<double>? point);

  /// Sets the exposure of the camera capturing the video [track] for [point],
  /// with both coordinates from 0 to 1. Null goes back to automatic exposure.
  Future<void> setExposurePoint(MediaStreamTrack track, Point<double>? point);

  /// Allows or stops camera capture while the app runs next to another app.
  /// Returns whether it is allowed now. iOS.
  Future<bool> setMultitaskingAccessEnabled(bool enabled);

  /// Whether the capture session in use allows camera capture while the app
  /// runs next to another app. Null when there is no capture session to ask.
  /// iOS.
  Future<bool?> isMultitaskingAccessSupported();
}

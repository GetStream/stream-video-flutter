import 'dart:async';
import 'dart:js_interop';

import 'package:stream_dart_webrtc/stream_dart_webrtc.dart'
    show MediaStreamTrackWeb, MediaStreamWeb;
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:web/web.dart' as web;

import 'effect_stop_delay.dart';

/// Runs [process] on the camera track in the browser: the web counterpart
/// of `CustomVideoFilter`.
///
/// [process] receives the browser's camera track and returns the track to
/// send in its place. Once the filter stops and whatever showed the output
/// has moved on, [WebVideoProcessing.stop] runs and the output track is
/// stopped. Filters with the same [name] are equal.
///
/// Web only: import `package:stream_video_filters/web.dart` from code that
/// is compiled for web, such as through a conditional import.
final class CustomWebVideoFilter extends rtc.VideoFilter {
  CustomWebVideoFilter(this.name, {required this.process});

  /// The name of the effect.
  final String name;

  /// Processes the camera track and returns the track to send.
  final Future<WebVideoProcessing> Function(web.MediaStreamTrack input) process;

  @override
  Future<rtc.MediaStreamFilterResult> apply(
    rtc.MediaStreamFilterInput input,
  ) async {
    final videoTrack = input.stream.getVideoTracks().firstOrNull;
    if (videoTrack == null) return rtc.MediaStreamFilterResult(input.stream);

    final processing = await process(
      (videoTrack as MediaStreamTrackWeb).jsTrack,
    );
    return rtc.MediaStreamFilterResult(
      MediaStreamWeb(web.MediaStream([processing.output].toJS), 'local'),
      stop: (_) => Timer(effectStopDelay, () {
        processing.stop?.call();
        processing.output.stop();
      }),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is CustomWebVideoFilter && other.name == name;

  @override
  int get hashCode => Object.hash(CustomWebVideoFilter, name);

  @override
  String toString() => 'CustomWebVideoFilter($name)';
}

/// What [CustomWebVideoFilter.process] made of the camera track.
final class WebVideoProcessing {
  const WebVideoProcessing(this.output, {this.stop});

  /// The processed track, sent in place of the camera track.
  final web.MediaStreamTrack output;

  /// Releases what the processing holds. [output] is stopped after it.
  final void Function()? stop;
}

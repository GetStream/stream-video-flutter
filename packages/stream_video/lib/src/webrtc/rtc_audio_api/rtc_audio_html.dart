// ignore_for_file: avoid_web_libraries_in_flutter, implementation_imports

import 'dart:js_interop' as jsutil;
import 'dart:js_interop_unsafe';

import 'package:dart_webrtc/src/media_stream_track_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:web/web.dart' as web;

const audioContainerId = 'stream_audio_container';
const audioPrefix = 'stream_audio_';

void startAudio(String id, rtc.MediaStreamTrack track) {
  if (track is! MediaStreamTrackWeb) return;

  final elementId = audioPrefix + id;
  var audioElement = web.document.getElementById(elementId);
  if (audioElement == null) {
    audioElement = web.HTMLAudioElement()
      ..id = elementId
      ..autoplay = true;
    findOrCreateAudioContainer().append(audioElement);
  }

  if (audioElement is! web.HTMLAudioElement) return;

  final audioStream = web.MediaStream();
  audioStream.addTrack(track.jsTrack);
  audioElement.srcObject = audioStream;
}

void stopAudio(String id) {
  final audioElement = web.document.getElementById(audioPrefix + id);
  if (audioElement != null) {
    if (audioElement is web.HTMLAudioElement) {
      audioElement.srcObject = null;
    }
    audioElement.remove();
  }
}

void setSinkId(String id, String deviceId) {
  if (!checkIfAudioOutputChangeSupported()) {
    debugPrint(
      'Audio Output device change is not supported on this browser.',
    );
    return;
  }

  final audioElement = web.document.getElementById(audioPrefix + id);

  if (audioElement is web.HTMLAudioElement &&
      audioElement.hasProperty('setSinkId'.toJS).toDart) {
    audioElement.setSinkId(deviceId);
  }
}

bool checkIfAudioOutputChangeSupported() {
  final element = web.document.createElement('audio');

  try {
    element.callMethod('setSinkId'.toJS, 'default'.toJS);
    return true;
  } catch (_) {
    return false;
  }
}

web.HTMLDivElement findOrCreateAudioContainer() {
  var div = web.document.getElementById(audioContainerId);
  if (div != null) return div as web.HTMLDivElement;

  div = web.HTMLDivElement()
    ..id = audioContainerId
    ..style.display = 'none';
  web.document.body?.append(div);
  return div as web.HTMLDivElement;
}

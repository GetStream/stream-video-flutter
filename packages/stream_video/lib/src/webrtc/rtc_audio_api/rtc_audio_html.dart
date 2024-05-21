// ignore_for_file: avoid_web_libraries_in_flutter, implementation_imports

import 'dart:js_util' as jsutil;

import 'package:dart_webrtc/src/media_stream_track_impl.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
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
  final audioElement = web.document.getElementById(audioPrefix + id);
  if (audioElement is web.HTMLAudioElement &&
      jsutil.hasProperty(audioElement, 'setSinkId')) {
    jsutil.setProperty(audioElement, 'setSinkId', deviceId);
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

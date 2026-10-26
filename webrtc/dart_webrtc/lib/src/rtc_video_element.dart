import 'dart:js_interop';

import 'package:web/web.dart' as web;

import '../dart_webrtc.dart';

class RTCVideoElement {
  RTCVideoElement() {
    _html = web.HTMLVideoElement()
      ..autoplay = true
      ..muted = false
      ..controls = false
      ..style.objectFit = 'contain'
      ..style.border = 'none';

    // Allows Safari iOS to play the video inline
    _html.setAttribute('playsinline', 'true');
  }

  MediaStream? _stream;

  late web.HTMLVideoElement _html;
  web.HTMLVideoElement get htmlElement => _html;

  /// contain or cover
  set objectFit(String fit) => _html.style.objectFit = fit;

  set srcObject(MediaStream? stream) {
    _stream = stream;
    if (stream != null) {
      _html.srcObject = (stream as MediaStreamWeb).jsStream;
    } else {
      _html.srcObject = null;
    }
  }

  int get videoWidth => _html.videoWidth;

  int get videoHeight => _html.videoHeight;

  Stream<web.Event> get onEnded => _html.onEnded;

  Stream<web.Event> get onError => _html.onError;

  Stream<web.Event> get onCanPlay => _html.onCanPlay;

  Stream<web.Event> get onResize => _html.onResize;

  dynamic get error => _html.error;

  MediaStream? get srcObject => _stream;

  set muted(bool v) => _html.muted = v;
  bool get muted => _html.muted;

  set autoplay(bool v) => _html.autoplay = v;
  bool get autoplay => _html.autoplay;

  set controls(bool v) => _html.controls = v;
  bool get controls => _html.controls;

  void load() => _html.load();

  void removeAttribute(String name) => _html.removeAttribute(name);

  Future<void> setSinkId(String sinkId) => _html.setSinkId(sinkId).toDart;
}

import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;
import 'package:webrtc_interface/webrtc_interface.dart';

import 'media_stream_track_impl.dart';

class MediaStreamWeb extends MediaStream {
  MediaStreamWeb(this.jsStream, String ownerTag) : super(jsStream.id, ownerTag);
  final web.MediaStream jsStream;

  @override
  Future<void> getMediaTracks() {
    return Future.value();
  }

  @override
  Future<void> addTrack(MediaStreamTrack track, {bool addToNative = true}) {
    if (addToNative) {
      var _native = track as MediaStreamTrackWeb;
      jsStream.addTrack(_native.jsTrack);
    }
    return Future.value();
  }

  @override
  Future<void> removeTrack(MediaStreamTrack track,
      {bool removeFromNative = true}) async {
    if (removeFromNative) {
      var _native = track as MediaStreamTrackWeb;
      jsStream.removeTrack(_native.jsTrack);
    }
  }

  @override
  List<MediaStreamTrack> getAudioTracks() {
    var audioTracks = <MediaStreamTrack>[];
    jsStream.getAudioTracks().toDart.forEach(
        (dynamic jsTrack) => audioTracks.add(MediaStreamTrackWeb(jsTrack)));
    return audioTracks;
  }

  @override
  List<MediaStreamTrack> getVideoTracks() {
    var audioTracks = <MediaStreamTrack>[];
    jsStream.getVideoTracks().toDart.forEach(
        (dynamic jsTrack) => audioTracks.add(MediaStreamTrackWeb(jsTrack)));
    return audioTracks;
  }

  @override
  List<MediaStreamTrack> getTracks() {
    return <MediaStreamTrack>[...getAudioTracks(), ...getVideoTracks()];
  }

  @override
  bool? get active => jsStream.active;

  @override
  Future<MediaStream> clone() async {
    return MediaStreamWeb(jsStream.clone(), ownerTag);
  }
}

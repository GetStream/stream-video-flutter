import 'package:stream_video/src/core/utils/rx_controller.dart';
import 'package:stream_video/src/track/local/audio.dart';
import 'package:stream_video/src/track/local/local.dart';
import 'package:stream_video/src/track/local/video.dart';
import 'package:stream_video/src/track/remote/audio.dart';
import 'package:stream_video/src/track/remote/remote.dart';
import 'package:stream_video/src/track/remote/video.dart';
import 'package:stream_video/src/track/track.dart';

class PublishedTracksController<T extends Track>
    extends RxController<Map<String, Map<String, T>>> {
  PublishedTracksController() : super(seedValue: {});

  Map<String, T> add(String sessionId, T track) {
    final trackSid = track.sid;
    assert(trackSid != null, 'Track sessionId is null');

    final newTracks = {...?value[sessionId], trackSid!: track};
    value = {...value, sessionId: newTracks};
    return newTracks;
  }

  T? remove(String sessionId, String trackSid) {
    final newTracks = {...?value[sessionId]};
    final removed = newTracks.remove(trackSid);
    value = {...value, sessionId: newTracks};
    return removed;
  }

  Map<String, T>? removeAll(String sessionId) {
    if (value.containsKey(sessionId)) {
      final newValue = {...value};
      final removed = newValue.remove(sessionId);
      value = newValue;
      return removed;
    }
    return null;
  }

  T? getTrack(String sessionId, String trackSessionId) {
    return value[sessionId]?[trackSessionId];
  }

  Map<String, T>? getTracksForSession(String sessionId) => value[sessionId];

  void clear() => value = {};
}

extension PublishedLocalTracksX on PublishedTracksController<LocalTrack> {
  /// A convenience property to get all local tracks.
  Map<String, LocalTrack> all(String sessionId) => {...?value[sessionId]};

  /// A convenience property to get all local video tracks.
  Map<String, LocalVideoTrack> video(String sessionId) {
    final tracks = {...?value[sessionId]};
    tracks.removeWhere((_, track) => track is! LocalVideoTrack);
    return tracks.cast<String, LocalVideoTrack>();
  }

  /// A convenience property to get all local audio tracks.
  Map<String, LocalAudioTrack> audio(String sessionId) {
    final tracks = {...?value[sessionId]};
    tracks.removeWhere((_, track) => track is! LocalAudioTrack);
    return tracks.cast<String, LocalAudioTrack>();
  }
}

extension PublishedRemoteTracksX on PublishedTracksController<RemoteTrack> {
  /// A convenience property to get all local tracks.
  Map<String, RemoteTrack> all(String sessionId) => {...?value[sessionId]};

  /// A convenience property to get all local video tracks.
  Map<String, RemoteVideoTrack> video(String sessionId) {
    final tracks = {...?value[sessionId]};
    tracks.removeWhere((_, track) => track is! RemoteVideoTrack);
    return tracks.cast<String, RemoteVideoTrack>();
  }

  /// A convenience property to get all local audio tracks.
  Map<String, RemoteAudioTrack> audio(String sessionId) {
    final tracks = {...?value[sessionId]};
    tracks.removeWhere((_, track) => track is! RemoteAudioTrack);
    return tracks.cast<String, RemoteAudioTrack>();
  }
}

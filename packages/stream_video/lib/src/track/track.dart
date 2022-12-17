import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:uuid/uuid.dart';

import '../../protobuf/video/sfu/models/models.pbserver.dart' as sfu;
import '../disposable.dart';
import '../event_emitter.dart';
import '../events.dart';
import '../internal/events.dart';
import '../logger/logger.dart';

/// Used to group [LocalAudioTrack] and [RemoteAudioTrack].
mixin AudioTrack on Track {}

/// Used to group [LocalVideoTrack] and [RemoteVideoTrack].
mixin VideoTrack on Track {
  late final viewKey = <GlobalKey>[];

  void Function(Key)? onVideoViewBuild;

  void Function(Key)? onVideoViewSizeChange;

  GlobalKey addViewKey() {
    final key = GlobalKey();
    viewKey.add(key);
    return key;
  }

  void removeViewKey(GlobalKey key) {
    viewKey.remove(key);
  }
}

const _uuid = Uuid();

/// Wrapper around a MediaStreamTrack with additional metadata.
/// Base for [AudioTrack] and [VideoTrack],
/// can not be instantiated directly.
abstract class Track with Disposable, EventEmittable<TrackEvent> {
  Track({
    required this.type,
    required rtc.MediaStream mediaStream,
    required rtc.MediaStreamTrack mediaStreamTrack,
    this.receiver,
  })  : _mediaStream = mediaStream,
        _mediaStreamTrack = mediaStreamTrack;

  final sfu.TrackType type;

  rtc.MediaStream get mediaStream => _mediaStream;
  rtc.MediaStream _mediaStream;

  rtc.MediaStreamTrack get mediaStreamTrack => _mediaStreamTrack;
  rtc.MediaStreamTrack _mediaStreamTrack;

  rtc.RTCRtpReceiver? receiver;

  // lookupId : type
  String? sid;
  String? _cid;

  // started / stopped
  bool get isActive => _active;
  bool _active = false;

  /// Whether this track is muted.
  bool get muted => _muted;
  bool _muted = false;
  void updateMuted({
    required bool muted,
    bool notifyServer = false,
  }) {
    if (_muted == muted) return;
    _muted = muted;
    events.emit(
      InternalTrackMuteUpdatedEvent(
        track: this,
        muted: muted,
        notifyServer: notifyServer,
      ),
    );
  }

  rtc.RTCRtpTransceiver? transceiver;

  rtc.RTCRtpSender? get sender => transceiver?.sender;

  String get cid {
    var cid = _cid ?? mediaStreamTrack.id;

    if (cid == null) {
      cid = _uuid.v4();
      _cid = cid;
    }
    return cid;
  }

  /// Start this [Track] if not started.
  /// Returns true if started, false if already started
  @mustCallSuper
  Future<bool> start() async {
    if (_active) {
      // already started
      return false;
    }

    logger.fine('$runtimeType.start()');

    _active = true;
    return true;
  }

  /// Stop this [Track] if not stopped.
  /// Returns true if stopped, false if already stopped
  @mustCallSuper
  Future<bool> stop() async {
    if (!_active) {
      // already stopped
      return false;
    }

    logger.fine('$runtimeType.stop()');

    _active = false;
    return true;
  }

  Future<void> enable() async {
    logger.fine(
      '$runtimeType.enable() enabling ${mediaStreamTrack.runtimeType}...',
    );
    try {
      mediaStreamTrack.enabled = true;
    } catch (_) {
      logger.warning(
        '[$runtimeType] set mediaStreamTrack.enabled did throw $_',
      );
    }
  }

  Future<void> disable() async {
    logger.fine(
      '$runtimeType.disable() disabling ${mediaStreamTrack.runtimeType}...',
    );
    try {
      mediaStreamTrack.enabled = false;
    } catch (_) {
      logger.warning(
        '[$runtimeType] set mediaStreamTrack.enabled did throw $_',
      );
    }
  }

  void updateMediaStreamAndTrack({
    required rtc.MediaStream stream,
    required rtc.MediaStreamTrack track,
  }) {
    _mediaStream = stream;
    _mediaStreamTrack = track;
    events.emit(
      TrackStreamUpdatedEvent(
        track: this,
        stream: stream,
      ),
    );
  }

  @override
  Future<void> dispose() async {
    events.dispose();
    return super.dispose();
  }
}

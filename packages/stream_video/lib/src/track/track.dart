import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:meta/meta.dart';
import 'package:stream_video/src/core/logger/logger.dart';
import 'package:stream_video/src/types/other.dart';
import 'package:uuid/uuid.dart';

/// Used to group [LocalAudioTrack] and [RemoteAudioTrack].
mixin AudioTrack on Track {}

/// Used to group [LocalVideoTrack] and [RemoteVideoTrack].
mixin VideoTrack on Track {
  /// True when the track is published with name [Track.screenShareName].
  bool get isScreenShare {
    return kind == TrackType.video && name == Track.screenShareName;
  }
}

const _uuid = Uuid();

abstract class Track {
  Track({
    required this.name,
    required this.kind,
    required this.source,
    required this.mediaStream,
    required this.mediaStreamTrack,
    this.receiver,
  });

  static const cameraName = 'camera';
  static const microphoneName = 'microphone';
  static const screenShareName = 'screenshare';

  final String name;
  final TrackType kind;
  final TrackSource source;

  rtc.MediaStream mediaStream;
  rtc.MediaStreamTrack mediaStreamTrack;

  rtc.RTCRtpReceiver? receiver;

  // kind : lookupId
  String? sid;
  String? _cid;

  // started / stopped
  bool get isActive => _active;
  bool _active = false;

  bool get muted => _muted;
  bool _muted = false;

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

  Future<bool> mute({bool muted = true}) async {
    if (muted == _muted) {
      // already muted
      return false;
    }

    logger.fine('$runtimeType.mute($muted)');

    _muted = muted;
    return true;
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
}

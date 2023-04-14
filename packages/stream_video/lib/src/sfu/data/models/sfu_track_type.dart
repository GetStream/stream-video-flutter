import 'package:meta/meta.dart';

@immutable
class SfuTrackType {
  const SfuTrackType();

  static SfuTrackType get unspecified => _Unspecified();

  static SfuTrackTypeAudio get audio => _Audio();

  static SfuTrackTypeVideo get video => _Video();

  static SfuTrackTypeVideo get screenShare => _ScreenShare();

  static SfuTrackTypeAudio get screenShareAudio => _ScreenShareAudio();

  bool get isAudio => this is SfuTrackTypeAudio;

  bool get isVideo => this is SfuTrackTypeVideo;
}

abstract class SfuTrackTypeAudio extends SfuTrackType {
  const SfuTrackTypeAudio();
}

abstract class SfuTrackTypeVideo extends SfuTrackType {
  const SfuTrackTypeVideo();
}

class _Unspecified extends SfuTrackType {
  factory _Unspecified() {
    return _instance;
  }

  const _Unspecified._internal();

  static const _Unspecified _instance = _Unspecified._internal();

  @override
  String toString() {
    return 'unspecified';
  }
}

class _Audio extends SfuTrackTypeAudio {
  factory _Audio() {
    return _instance;
  }

  const _Audio._internal();

  static const _Audio _instance = _Audio._internal();

  @override
  String toString() {
    return 'audio';
  }
}

class _Video extends SfuTrackTypeVideo {
  factory _Video() {
    return _instance;
  }

  const _Video._internal();

  static const _Video _instance = _Video._internal();

  @override
  String toString() {
    return 'video';
  }
}

class _ScreenShare extends SfuTrackTypeVideo {
  factory _ScreenShare() {
    return _instance;
  }

  const _ScreenShare._internal();

  static const _ScreenShare _instance = _ScreenShare._internal();

  @override
  String toString() {
    return 'screenShare';
  }
}

class _ScreenShareAudio extends SfuTrackTypeAudio {
  factory _ScreenShareAudio() {
    return _instance;
  }

  const _ScreenShareAudio._internal();

  static const _ScreenShareAudio _instance = _ScreenShareAudio._internal();

  @override
  String toString() {
    return 'screenShareAudio';
  }
}

import 'dart:async';

import 'package:meta/meta.dart';

import '../logger/stream_log.dart';
import '../stream_video.dart';

@internal
class InstanceHolder {
  StreamVideo? _instance;

  void install(
    StreamVideo instance, {
    bool failIfSingletonExists = true,
  }) {
    if (_instance != null) {
      if (failIfSingletonExists) {
        throw Exception('''
        StreamVideo has already been initialised, use StreamVideo.instance to access the singleton instance.
        If you want to re-initialise the SDK, call StreamVideo.reset() first.
        If you want to use multiple instances of the SDK, use StreamVideo.create() instead.
        ''');
      }
      streamLog.w(
        'InstanceHolder',
        () => 'StreamVideo has already been initialised, '
            'disconnecting the existing instance '
            'and overriding it with the new instance.',
      );
      unawaited(_instance!.disconnect());
    }
    _instance = instance;
  }

  /// The singleton instance of the Stream Video client.
  StreamVideo get instance {
    final instance = _instance;
    if (instance == null) {
      throw Exception(
        'Please initialise Stream Video by calling StreamVideo()',
      );
    }
    return instance;
  }

  /// Return if the singleton instance of the Stream Video Client has already
  /// been initialized.
  bool isInitialized() {
    return _instance != null;
  }

  /// Resets the singleton instance of the Stream Video client.
  ///
  /// This is useful if you want to re-initialise the SDK with a different
  /// API key.
  void reset() {
    _instance = null;
  }
}

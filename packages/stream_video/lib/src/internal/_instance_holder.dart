import 'package:meta/meta.dart';

import '../logger/stream_log.dart';
import '../stream_video.dart';

@internal
class InstanceHolder {
  StreamVideo? _instance;

  void install(StreamVideo instance) {
    if (_instance != null) {
      streamLog.w(
        'InstanceHolder',
        () => 'StreamVideo has already been initialised, '
            'overriding with new instance.',
      );
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

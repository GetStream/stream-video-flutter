import 'package:meta/meta.dart';

import '../stream_video.dart';

@internal
class InstanceHolder {
  StreamVideo? _instance;

  /// Installs [instance] and returns the client it replaced, if any. Throws
  /// when a client is installed already, unless [replace] is true.
  StreamVideo? install(StreamVideo instance, {bool replace = false}) {
    final previous = _instance;
    if (previous != null && !replace) throw alreadyInstalled();
    _instance = instance;
    return previous;
  }

  /// The error for installing a client while one is installed already.
  Exception alreadyInstalled() => Exception('''
        StreamVideo has already been initialised, use StreamVideo.instance to access the singleton instance.
        If you want to re-initialise the SDK, call StreamVideo.reset() first, or pass onInstanceReplaced.
        If you want to use multiple instances of the SDK, use StreamVideo.create() instead.
        ''');

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

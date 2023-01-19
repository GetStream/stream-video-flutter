import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../stream_video_v2.dart';
import '../stream_video_v2_impl.dart';

@internal
class InstanceHolder {
  StreamVideoV2? _instance;

  void init(
    String apiKey, {
    required String coordinatorRpcUrl,
    required String coordinatorWsUrl,
    required int latencyMeasurementRounds,
    required Level logLevel,
    required LogHandlerFunction logHandlerFunction,
  }) {
    if (_instance != null) {
      throw Exception('''
        StreamVideo has already been initialised, use StreamVideo.instance to access the singleton instance.
        If you want to re-initialise the SDK, call StreamVideo.reset() first.
        If you want to use multiple instances of the SDK, use StreamVideo.new() instead.
        ''');
    }
    _instance = StreamVideoV2Impl(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      logLevel: logLevel,
      logHandlerFunction: logHandlerFunction,
    );
  }

  /// The singleton instance of the Stream Video client.
  StreamVideoV2 get instance {
    final instance = _instance;
    if (instance == null) {
      throw Exception(
        'Please initialise Stream Video by calling StreamVideo.init()',
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
  Future<void> reset({bool disconnectUser = false}) async {
    if (disconnectUser) {
      await _instance?.disconnectUser();
    }
    _instance = null;
  }
}

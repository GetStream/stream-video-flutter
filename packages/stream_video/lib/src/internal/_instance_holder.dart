import 'package:meta/meta.dart';

import '../retry/retry_policy.dart';
import '../stream_video.dart';
import '../webrtc/sdp/policy/sdp_policy.dart';

@internal
class InstanceHolder {
  StreamVideo? _instance;

  StreamVideo init(
    String apiKey, {
    required String coordinatorRpcUrl,
    required String coordinatorWsUrl,
    required int latencyMeasurementRounds,
    required RetryPolicy retryPolicy,
    required SdpPolicy sdpPolicy,
  }) {
    if (_instance != null) {
      throw Exception('''
        StreamVideo has already been initialised, use StreamVideo.instance to access the singleton instance.
        If you want to re-initialise the SDK, call StreamVideo.reset() first.
        If you want to use multiple instances of the SDK, use StreamVideo.new() instead.
        ''');
    }
    _instance = StreamVideo.create(
      apiKey,
      coordinatorRpcUrl: coordinatorRpcUrl,
      coordinatorWsUrl: coordinatorWsUrl,
      latencyMeasurementRounds: latencyMeasurementRounds,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
    );
    return _instance!;
  }

  /// The singleton instance of the Stream Video client.
  StreamVideo get instance {
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
  void reset() {
    _instance = null;
  }
}

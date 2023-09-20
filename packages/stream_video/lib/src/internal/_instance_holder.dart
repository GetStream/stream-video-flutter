import 'package:meta/meta.dart';

import '../latency/latency_settings.dart';
import '../logger/stream_log.dart';
import '../retry/retry_policy.dart';
import '../stream_video.dart';
import '../webrtc/sdp/policy/sdp_policy.dart';

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

  StreamVideo init(
    String apiKey, {
    required LatencySettings latencySettings,
    required RetryPolicy retryPolicy,
    required SdpPolicy sdpPolicy,
    bool muteVideoWhenInBackground = false,
    bool muteAudioWhenInBackground = false,
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
      latencySettings: latencySettings,
      retryPolicy: retryPolicy,
      sdpPolicy: sdpPolicy,
      muteVideoWhenInBackground: muteVideoWhenInBackground,
      muteAudioWhenInBackground: muteAudioWhenInBackground,
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

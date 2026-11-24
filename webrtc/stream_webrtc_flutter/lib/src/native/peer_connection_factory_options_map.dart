import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

/// The method channel form of [options]. Each platform reads only its own
/// audio configuration from it. The typed fields win over an additional
/// option with the same key.
@internal
Map<String, dynamic> peerConnectionFactoryOptionsMap(
  PeerConnectionFactoryOptions options,
) {
  return <String, dynamic>{
    ...options.additionalOptions,
    'bypassVoiceProcessing': options.bypassVoiceProcessing,
    if (options.androidAudioConfiguration case final android?)
      'androidAudioConfiguration': android.toMap(),
    if (options.appleAudioConfiguration case final apple?)
      'appleAudioConfiguration': apple.toMap(),
  };
}

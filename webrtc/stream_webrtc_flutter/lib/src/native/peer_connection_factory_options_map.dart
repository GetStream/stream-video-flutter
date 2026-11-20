import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

/// The method channel form of [options]. Each platform reads only its own
/// audio configuration from it.
@internal
Map<String, dynamic> peerConnectionFactoryOptionsMap(
  PeerConnectionFactoryOptions options,
) {
  return <String, dynamic>{
    'bypassVoiceProcessing': options.bypassVoiceProcessing,
    if (options.androidAudioConfiguration case final android?)
      'androidAudioConfiguration': android.toMap(),
    if (options.appleAudioConfiguration case final apple?)
      'appleAudioConfiguration': apple.toMap(),
  };
}

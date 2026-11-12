import 'package:meta/meta.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

/// The method channel form of [options], with only the audio configuration
/// of the platform the app runs on.
@internal
Map<String, dynamic> peerConnectionFactoryOptionsMap(
  PeerConnectionFactoryOptions options, {
  required bool isAndroid,
  required bool isApple,
}) {
  final android = options.androidAudioConfiguration;
  final apple = options.appleAudioConfiguration;
  return <String, dynamic>{
    'bypassVoiceProcessing': options.bypassVoiceProcessing,
    if (isAndroid && android != null)
      'androidAudioConfiguration': android.toMap(),
    if (isApple && apple != null) 'appleAudioConfiguration': apple.toMap(),
  };
}

import 'package:flutter/material.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

class AdmSample extends StatelessWidget {
  const AdmSample({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('ADM Sample'),
    ),
    body: ListView(
      children: [
        ListTile(
          title: const Text('startLocalRecording'),
          onTap: () async {
            await NativeAudioManagement.startLocalRecording();
          },
        ),
        ListTile(
          title: const Text('stopLocalRecording'),
          onTap: () async {
            await NativeAudioManagement.stopLocalRecording();
          },
        ),
        ListTile(
          title: const Text('isVoiceProcessingEnabled'),
          onTap: () async {
            final result =
                await NativeAudioManagement.isVoiceProcessingEnabled();
            print('isVoiceProcessingEnabled: $result');
          },
        ),
        ListTile(
          title: const Text('Get isVoiceProcessingBypassed'),
          onTap: () async {
            final result =
                await NativeAudioManagement.isVoiceProcessingBypassed();
            print('isVoiceProcessingBypassed: $result');
          },
        ),
        ListTile(
          title: const Text('Toggle isVoiceProcessingBypassed'),
          onTap: () async {
            final result =
                await NativeAudioManagement.isVoiceProcessingBypassed();
            await NativeAudioManagement.setIsVoiceProcessingBypassed(!result);
            print('isVoiceProcessingBypassed: $result');
          },
        ),
      ],
    ),
  );
}

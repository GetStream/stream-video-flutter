import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class AudioSettingsScreen extends StatefulWidget {
  const AudioSettingsScreen({super.key});

  static Route<dynamic> routeTo() {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return const AudioSettingsScreen();
      },
    );
  }

  @override
  State<AudioSettingsScreen> createState() => _AudioSettingsState();
}

class _AudioSettingsState extends State<AudioSettingsScreen> {
  RtcMediaDevice? _selectedOutputDevice;
  RtcMediaDevice? _selectedInputDevice;

  Call? get call => StreamVideo.instance.activeCall;

  Future<void> _setAudioOutputDevice(RtcMediaDevice device) async {
    if (call != null) {
      setState(() => _selectedOutputDevice = device);
      final result = await call!.setAudioOutputDevice(device);
      print('[_setAudioOutputDevice]  $result');
    }
    return;
  }

  Future<void> _setAudioInputDevice(RtcMediaDevice device) async {
    if (call != null) {
      setState(() => _selectedInputDevice = device);
      final result = await call!.setAudioInputDevice(device);
      print('[_setAudioInputDevice]  $result');
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: StreamBuilder<List<RtcMediaDevice>>(
          stream: RtcMediaDeviceNotifier.instance.onDeviceChange,
          builder: (context, snapshot) {
            if (snapshot.hasData & !snapshot.hasError) {
              final devices = snapshot.data ?? [];
              final audioInDevice = devices.where(
                  (element) => element.kind == RtcMediaDeviceKind.audioInput);
              final audioOutDevice = devices.where(
                  (element) => element.kind == RtcMediaDeviceKind.audioOutput);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Select Output device'),
                    for (final device in audioOutDevice)
                      RadioListTile(
                        value: device,
                        groupValue: _selectedOutputDevice,
                        selected: _selectedOutputDevice?.id == device.id,
                        title: Text(device.label),
                        onChanged: (val) => _setAudioOutputDevice,
                      ),
                    const Text('Select Input device'),
                    for (final device in audioInDevice)
                      RadioListTile(
                        value: device,
                        groupValue: _selectedInputDevice,
                        selected: _selectedOutputDevice?.id == device.id,
                        title: Text(device.label),
                        onChanged: (val) => _setAudioInputDevice,
                      )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Unable to find devices at this time'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

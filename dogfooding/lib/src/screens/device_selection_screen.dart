import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

/// Shows a list of connected [RtcMediaDevice]s sorted by Video, Audio Output
/// and Audio Input.
///
/// By default, a user must be in a call before the device can be set.
class DeviceScreen extends StatefulWidget {
  const DeviceScreen({
    super.key,
    this.actions,
    this.call,
  });

  /// List of [Widget]s which can be shown at the bottom of the device list.
  /// If not supplied the default actions will allow the user to confirm their
  /// input and output devices or "Cancel" which pops the current route.
  final List<Widget>? actions;

  final Call? call;

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final Map<String, RtcMediaDevice?> _selectedDevice = {
    'video': null,
    'audioIn': null,
    'audioOutput': null,
  };

  late final Call? _currentCall;

  @override
  void initState() {
    super.initState();
    _currentCall = widget.call ?? StreamVideo.instance.activeCall;
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  List<Widget> _buildDefaultActions() {
    return [
      ElevatedButton(
        onPressed: () => Navigator.of(context).maybePop(),
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {},
        child: const Text('Confirm'),
      ),
    ];
  }

  Widget _buildErrorState() {
    return const Center(
      child: Text(
        'Unable to retrieve devices. Please confirm your device permissions',
      ),
    );
  }

  Widget _buildDataState(List<RtcMediaDevice> devices) {
    final audioDevices = devices
        .where(
          (audioDevice) => audioDevice.kind == RtcMediaDeviceKind.audioInput,
        )
        .toList();
    final audioDevicesOutput = devices
        .where(
          (audioOutputDevice) =>
              audioOutputDevice.kind == RtcMediaDeviceKind.audioOutput,
        )
        .toList();
    final videoDevices = devices
        .where(
          (videoDevice) => videoDevice.kind == RtcMediaDeviceKind.videoInput,
        )
        .toList();
    const verticalSpace = SizedBox(height: 24);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 18,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const Text('Select a Camera'),
                for (final inputDevice in videoDevices)
                  RadioListTile<RtcMediaDevice>(
                    title: Text(inputDevice.label),
                    groupValue: _selectedDevice['video'],
                    value: inputDevice,
                    selected: _selectedDevice['video'] == inputDevice,
                    selectedTileColor: const Color(0xFF272A30),
                    onChanged: (RtcMediaDevice? value) {
                      setState(() => _selectedDevice['video'] = value);
                    },
                  ),
                verticalSpace,
                const Text('Select an Audio Output'),
                for (final inputDevice in audioDevicesOutput)
                  RadioListTile<RtcMediaDevice>(
                    title: Text(inputDevice.label),
                    groupValue: _selectedDevice['audioOutput'],
                    value: inputDevice,
                    selectedTileColor: const Color(0xFF272A30),
                    selected: _selectedDevice['audioOutput'] == inputDevice,
                    onChanged: (RtcMediaDevice? value) {
                      setState(() => _selectedDevice['audioOutput'] = value);
                    },
                  ),
                verticalSpace,
                const Text('Select an Audio Input'),
                for (final inputDevice in audioDevices)
                  RadioListTile<RtcMediaDevice>(
                    title: Text(inputDevice.label),
                    groupValue: _selectedDevice['audioIn'],
                    selected: _selectedDevice['audioIn'] == inputDevice,
                    selectedTileColor: const Color(0xFF272A30),
                    value: inputDevice,
                    onChanged: (RtcMediaDevice? value) {
                      setState(() => _selectedDevice['audioIn'] = value);
                    },
                  ),
                verticalSpace,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => const Color(0xFF121416),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  Icons.settings,
                  size: 22,
                ),
              ),
              TextSpan(
                text: ' Audio/Video Settings',
                style: TextStyle(
                  fontSize: 20,
                   fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: StreamVideo.instance.onDeviceChange,
        builder: (context, AsyncSnapshot<List<RtcMediaDevice>> snapshot) {
          if (!snapshot.hasData) {
            return _buildLoadingState();
          } else if (snapshot.hasError) {
            return _buildErrorState();
          } else {
            final devices = snapshot.data ?? [];
            return _buildDataState(devices);
          }
        },
      ),
    );
  }
}

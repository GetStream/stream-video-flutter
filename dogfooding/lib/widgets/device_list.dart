import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class DeviceList extends StatefulWidget {
  const DeviceList({required this.devices, super.key});

  final List<PushDevice> devices;

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  List<PushDevice> devices = [];

  @override
  void initState() {
    devices = widget.devices;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: devices
            .map(
              (e) => Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await StreamVideo.instance.removeDevice(
                        pushToken: e.pushToken,
                      );

                      setState(() {
                        devices.remove(e);
                      });
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(e.pushProvider.name),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(e.userId ?? '')),
                          if (e.voip ?? false) ...[
                            const Icon(Icons.phone, size: 16),
                            const SizedBox(width: 4),
                            const Text('VOIP'),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

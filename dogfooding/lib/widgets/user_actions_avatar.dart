import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/widgets/device_list.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../theme/app_palette.dart';

class UserActionsAvatar extends StatelessWidget {
  const UserActionsAvatar({
    required this.currentUser,
    super.key,
  });

  final UserInfo currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: MenuAnchor(
        style: const MenuStyle(
          alignment: Alignment.bottomRight,
          padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
          backgroundColor:
              WidgetStatePropertyAll(AppColorPalette.buttonSecondary),
        ),
        alignmentOffset: const Offset(00, 0),
        builder: (
          BuildContext context,
          MenuController controller,
          Widget? child,
        ) {
          return InkWell(
            onTap: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            child: StreamUserAvatar(user: currentUser),
          );
        },
        menuChildren: [
          MenuItemButton(
            child: const Text(
              'List devices',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              final devices = await StreamVideo.instance.getDevices();

              showDialog(
                // ignore: use_build_context_synchronously
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Devices'),
                        IconButton(
                            onPressed: () async {
                              for (final device in devices.getDataOrNull()!) {
                                await StreamVideo.instance
                                    .removeDevice(pushToken: device.pushToken);
                              }

                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                    content: DeviceList(
                      devices: devices.getDataOrNull()!,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

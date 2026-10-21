import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'device_list.dart';

/// The padding around the avatar at the start of an app bar.
///
/// 16 at the start, the margin UIKit keeps inside the safe area. iOS reports
/// no inset for a rounded display corner, so this is what keeps the avatar
/// clear of it.
const kAppBarAvatarPadding = EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8);

/// The width of an app bar's leading slot holding a padded avatar.
const kAppBarAvatarLeadingWidth = 64.0;

class UserActionsAvatar extends StatelessWidget {
  const UserActionsAvatar({required this.currentUser, super.key});

  final UserInfo currentUser;

  @override
  Widget build(BuildContext context) {
    final colorScheme = StreamTheme.of(context).colorScheme;

    return Padding(
      padding: kAppBarAvatarPadding,
      child: MenuAnchor(
        style: MenuStyle(
          alignment: Alignment.bottomRight,
          padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
          backgroundColor: WidgetStatePropertyAll(
            colorScheme.backgroundSurface,
          ),
        ),
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
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
            ),
            onPressed: () async {
              final devices = await StreamVideo.instance.getDevices();

              await showDialog<void>(
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
                              await StreamVideo.instance.removeDevice(
                                pushToken: device.pushToken,
                              );
                            }

                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                    content: DeviceList(devices: devices.getDataOrNull()!),
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

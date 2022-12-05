import 'package:example/components/circle_avatar.dart';
import 'package:example/utils/checkbox_controller.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class UserCheckBoxListView extends StatefulWidget {
  final CheckboxController userController;

  UserCheckBoxListView(this.userController);

  @override
  State<UserCheckBoxListView> createState() => _UserCheckBoxListViewState();
}

class _UserCheckBoxListViewState extends State<UserCheckBoxListView> {
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(8),
        children: widget.userController.value
            .map(
              (CheckBoxItem item) => CheckboxListTile(
                secondary: StreamCircleAvatar(
                    initial: item.userInfo.name.toUpperCase()),
                title: Text(item.userInfo.name),
                value: item.isChecked,
                onChanged: (bool? val) {
                  widget.userController.updateItem(item, val!);
                  setState(() => item.isChecked = val);
                },
              ),
            )
            .toList(),
      );
}

class CheckBoxItem {
  UserInfo userInfo;
  bool isChecked;

  CheckBoxItem(this.userInfo, this.isChecked);

  @override
  String toString() => '$userInfo $isChecked';
}

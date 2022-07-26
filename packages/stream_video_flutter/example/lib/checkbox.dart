import 'package:example/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class UserCheckBoxInListView extends StatefulWidget {
  final List<UserInfo> users;

  UserCheckBoxInListView(this.users);
  @override
  _UserCheckBoxInListViewState createState() => _UserCheckBoxInListViewState();
}

class _UserCheckBoxInListViewState extends State<UserCheckBoxInListView> {
  late final List<CheckBoxItem> _checkBoxItems;

  @override
  void initState() {
    _checkBoxItems = widget.users.map((e) => CheckBoxItem(e, false)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(8),
        children: _checkBoxItems
            .map(
              (CheckBoxItem item) => CheckboxListTile(
                title: StreamCircleAvatar(
                    initial: item.userInfo.name.toUpperCase()),
                subtitle: Text(item.userInfo.name),
                value: item.isChecked,
                onChanged: (bool? val) {
                  setState(() => item.isChecked = val!);
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
}

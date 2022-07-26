import 'package:example/demo_users.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class UserDropDropdown extends StatefulWidget {
  const UserDropDropdown({Key? key}) : super(key: key);

  @override
  State<UserDropDropdown> createState() => _UserDropDropdownState();
}

class _UserDropDropdownState extends State<UserDropDropdown> {
  UserInfo dropdownValue = demoUsers[0].userInfo;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<UserInfo>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (UserInfo? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: demoUsers
          .map((e) => e.userInfo)
          // .expand((element) => element)
          .toList()
          .map<DropdownMenuItem<UserInfo>>((UserInfo value) {
        return DropdownMenuItem<UserInfo>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
    );
  }
}

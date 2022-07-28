import 'package:example/checkbox_controller.dart';
import 'package:example/demo_users.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class UserDropDropdown extends StatefulWidget {
  // final CurrentUserController currentUserController;
  const UserDropDropdown( {Key? key})
      : super(key: key);

  @override
  State<UserDropDropdown> createState() => _UserDropDropdownState();
}

class _UserDropDropdownState extends State<UserDropDropdown> {
  UserCredentials dropdownValue = demoUsers[0];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<UserCredentials>(
      value: dropdownValue,
      onChanged: (UserCredentials? newValue) async {
        final streamVideo = StreamVideoProvider.of(context);
      await  streamVideo.client.setUser(newValue!.userInfo,token: newValue.token);
        // widget.currentUserController.value = newValue;
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: demoUsers
          .map((e) => e)
          .toList()
          .map<DropdownMenuItem<UserCredentials>>((UserCredentials value) {
        return DropdownMenuItem<UserCredentials>(
          value: value,
          child: Text(value.userInfo.name),
        );
      }).toList(),
    );
  }
}

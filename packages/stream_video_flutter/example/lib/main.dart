import 'package:example/buttons.dart';
import 'package:example/checkbox.dart';
import 'package:example/demo_users.dart';
import 'package:example/checkbox_controller.dart';
import 'package:example/dropdown_user.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeView(title: 'Stream Video Flutter'),
    );
  }
}

class HomeView extends StatelessWidget {
  final String title;
  const HomeView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = CheckboxController(
        demoUsers.map((e) => CheckBoxItem(e.userInfo, false)).toList());
    var currentUserController = CurrentUserController(demoUsers[0].userInfo);
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Who are you?"),
            ),
            UserDropDropdown(currentUserController),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Select Participants"),
            ),
            Expanded(child: UserCheckBoxInListView(controller)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: JoinCallButton(onTap: () {
                print("currentUser ${currentUserController.value}");
                print("participants ${controller.getIsChecked()}");
                print("call");
              }),
            )
          ],
        ));
  }
}

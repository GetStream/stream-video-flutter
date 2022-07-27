import 'package:example/buttons.dart';
import 'package:example/checkbox.dart';
import 'package:example/demo_users.dart';
import 'package:example/checkbox_controller.dart';
import 'package:example/dropdown_user.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/src/models/user_info.dart';

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: StartCallView.tabIcon,
                ),
                Tab(
                  icon: JoinCallView.tabIcon,
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              StartCallView(
                  currentUserController: currentUserController,
                  controller: controller),
              JoinCallView()
            ],
          )),
    );
  }
}

class JoinCallView extends StatelessWidget {
  static const Icon tabIcon = Icon(Icons.switch_video);

  const JoinCallView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SwitchVideoButton(),
    );
  }
}

class StartCallView extends StatelessWidget {
  static const Icon tabIcon = Icon(Icons.video_call);
  const StartCallView({
    Key? key,
    required this.currentUserController,
    required this.controller,
  }) : super(key: key);

  final ValueNotifier<UserInfo> currentUserController;
  final ValueNotifier<List<CheckBoxItem>> controller;

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

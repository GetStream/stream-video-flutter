import 'package:example/checkbox.dart';
import 'package:example/demo_users.dart';
import 'package:example/checkbox_controller.dart';
import 'package:example/views/join_call.dart';
import 'package:example/views/start_call.dart';
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


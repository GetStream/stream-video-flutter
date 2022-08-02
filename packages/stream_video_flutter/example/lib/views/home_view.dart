import 'package:example/checkbox.dart';
import 'package:example/checkbox_controller.dart';
import 'package:example/demo_users.dart';
import 'package:example/views/join_call.dart';
import 'package:example/views/start_call.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class HomeView extends StatelessWidget {
  static String routeName = "/home";
  final String title;
  const HomeView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = CheckboxController(
        demoUsers.map((e) => CheckBoxItem(e.userInfo, false)).toList());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                  callController: StreamVideoProvider.of(context).client.calls,
                  controller: controller),
              JoinCallView()
            ],
          )),
    );
  }
}

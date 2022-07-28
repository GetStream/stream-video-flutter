import 'package:example/checkbox.dart';
import 'package:example/demo_users.dart';
import 'package:example/checkbox_controller.dart';
import 'package:example/views/join_call.dart';
import 'package:example/views/start_call.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  final client = StreamVideoClient("apiKey");
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final StreamVideoClient client;
  const MyApp({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeView(title: 'Stream Video Flutter'),
      builder: (context, child) {
        return StreamVideoProvider(
          client: client,
          child: child!,
        );
      },
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
                  controller: controller),
              JoinCallView()
            ],
          )),
    );
  }
}

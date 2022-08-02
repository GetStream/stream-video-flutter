import 'package:example/buttons.dart';
import 'package:example/checkbox.dart';
import 'package:example/checkbox_controller.dart';
import 'package:example/dropdown_user.dart';
import 'package:example/input.dart';
import 'package:example/ringer.dart';
import 'package:example/views/staged_view.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class StartCallView extends StatefulWidget {
  static const Icon tabIcon = Icon(Icons.video_call);
  const StartCallView(
      {Key? key, required this.controller, required this.callController})
      : super(key: key);

  final CheckboxController controller;
  final CallController callController;

  @override
  State<StartCallView> createState() => _StartCallViewState();
}

class _StartCallViewState extends State<StartCallView> {
  String caller = "unkown";
  @override
  void initState() {
    widget.callController.on<CallCreatedEvent>((event) {
      caller = event.payload.call.createdByUserId;
      showRinger(context, caller: caller);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textEditingController = TextEditingController();
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Who are you?"),
        ),
        UserDropDropdown(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LoginButton(
            onTap: () async {
              await StreamVideoProvider.of(context).client.connectWs();
              print("connecting");
              //TODO: connect ws
              print("login");
            },
          ),
        ),
        CallInput(
          controller: textEditingController,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Select Participants"),
        ),
        Expanded(child: UserCheckBoxListView(widget.controller)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StartCallButton(onTap: () async {
            final streamVideo = StreamVideoProvider.of(context);
            print("currentUser ${streamVideo.client.currentUser}");
            print("participants ${widget.controller.getIsChecked()}");
            await streamVideo.client.startCall(
                id: textEditingController.text,
                participantIds: widget.controller
                    .getIsChecked()
                    .map((e) => e.userInfo.id)
                    .toList(),
                type: StreamCallType.video);
             Navigator.of(context).pushNamed(StageView.routeName);
            //TODO: client.startCall
            print("startCall");
            //emit an event CallCreated
            // streamVideo.client.fakeIncomingCall("Sacha");
          }),
        )
      ],
    );
  }

  void showRinger(BuildContext context, {required String caller}) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return RingerDialog(caller: caller);
        });
  }
}

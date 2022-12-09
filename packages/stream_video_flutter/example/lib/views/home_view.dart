import 'package:example/components/checkbox.dart';
import 'package:example/utils/checkbox_controller.dart';
import 'package:example/utils/demo_users.dart';
import 'package:example/views/join_call.dart';
import 'package:example/views/start_call.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc
    show RTCVideoRenderer, RTCVideoView, RTCVideoViewObjectFit;

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
                icon: Icon(Icons.video_call),
              ),
              Tab(
                icon: Icon(Icons.switch_video),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StartCall(),
            JoinCall(),
          ],
        ),
      ),
    );
  }
}

class StartCall extends StatefulWidget {
  const StartCall({Key? key}) : super(key: key);

  @override
  State<StartCall> createState() => _StartCallState();
}

class _StartCallState extends State<StartCall> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: OutlinedButton(
          child: const Text("Start Call"),
          onPressed: () async {
            await StreamVideo.instance.connectUser(
              const UserInfo(
                id: 'sahil',
                role: 'admin',
                name: 'Sahil',
              ),
              token: Token(
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9zYWhpbCIsImlhdCI6MTY2OTcyNjkxNSwidXNlcl9pZCI6InNhaGlsIn0.aOOWXDmX-8hG57N7R3w320XZzxAj256Lm2YZj_sqCuQ",
              ),
            );

            var call = Call(
              callConfiguration: const CallConfiguration(
                type: 'default',
                id: 'test_call_1234',
                participantIds: [
                  'sahil',
                  'deven',
                ],
              ),
            );

            var res = await call.getOrCreate();

            await call.connect(
              options: const ConnectOptions(
                microphone: TrackOption(enabled: true),
                camera: TrackOption(enabled: true),
              ),
            );

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CallStage(
                call: call,
              ),
            ));
          },
        ),
      ),
    );
  }
}

class JoinCall extends StatefulWidget {
  const JoinCall({Key? key}) : super(key: key);

  @override
  State<JoinCall> createState() => _JoinCallState();
}

class _JoinCallState extends State<JoinCall> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: OutlinedButton(
            child: const Text("Join Call"),
            onPressed: () async {
              final client = StreamVideo.instance;
              await client.connectUser(
                const UserInfo(
                  id: 'deven',
                  role: 'admin',
                  name: 'Deven',
                ),
                token: Token(
                  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9kZXZlbiIsImlhdCI6MTY2OTcyNjk1MSwidXNlcl9pZCI6ImRldmVuIn0.u5c-MHdpV2UNKYpD0fkc5cML66Bifx_Q2hV9ueRMjpI",
                ),
              );

              final call = await client.joinCall(
                type: 'default',
                id: 'my_new_second_test_id',
              );

              await call.connect(
                options: const ConnectOptions(
                  microphone: TrackOption(enabled: true),
                  camera: TrackOption(enabled: true),
                ),
              );

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CallStage(
                  call: call,
                ),
              ));
            }),
      ),
    );
  }
}

class CallStage extends StatefulWidget {
  const CallStage({Key? key, required this.call}) : super(key: key);

  final Call call;

  @override
  State<CallStage> createState() => _CallStageState();
}

class _CallStageState extends State<CallStage> {
  List<ParticipantTrack> participantTracks = [];

  void _onCallEnded(SfuEvent event) {
    final payload = event.callEnded;
    print('Call Ended: ${payload.message}');
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _onParticipantUpdate(widget.call.participants);
    widget.call.participantsStream.listen(_onParticipantUpdate);
    widget.call.addListener(SfuEvent_EventPayload.callEnded.name, _onCallEnded);
  }

  @override
  void dispose() {
    widget.call.removeListener(
      SfuEvent_EventPayload.callEnded.name,
      _onCallEnded,
    );
    super.dispose();
  }

  void _onParticipantUpdate(List<CallParticipant> participants) {
    print("participants: ${participants.length}");
    for (var participant in participants) {
      print("participant: ${participant.id}");
      print("participant: ${participant.runtimeType}");
    }

    List<ParticipantTrack> screenTracks = [];
    List<ParticipantTrack> userMediaTracks = [];
    for (var participant in participants.where((it) => !it.isLocal)) {
      final videoTracks = participant.videoTracks;
      print('VideoTracks: ${videoTracks?.length}');
      if (videoTracks != null && videoTracks.isNotEmpty) {
        for (var track in videoTracks) {
          if (track.isScreenShare) {
            screenTracks.add(ParticipantTrack(
              participant: participant,
              videoTrack: track,
              isScreenShare: true,
            ));
          } else {
            userMediaTracks.add(ParticipantTrack(
              participant: participant,
              videoTrack: track,
              isScreenShare: false,
            ));
          }
        }
      }
    }

    final localParticipant = widget.call.localParticipant;
    final localParticipantTracks = localParticipant?.videoTracks;
    print('LocalVideoTracks: ${localParticipantTracks?.length}');
    if (localParticipantTracks != null) {
      for (var track in localParticipantTracks) {
        if (track.isScreenShare) {
          screenTracks.add(ParticipantTrack(
            participant: localParticipant!,
            videoTrack: track,
            isScreenShare: true,
          ));
        } else {
          userMediaTracks.add(ParticipantTrack(
            participant: localParticipant!,
            videoTrack: track,
            isScreenShare: false,
          ));
        }
      }
    }

    participantTracks = [...screenTracks, ...userMediaTracks];
    print('ParticipantTracks: ${participantTracks.length}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('Count: ${participantTracks.length}');
    return WillPopScope(
      onWillPop: () async {
        await widget.call.leave();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Call"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: participantTracks.isEmpty
              ? const Text('Empty')
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: participantTracks.length, //
                  itemBuilder: (BuildContext ctx, int index) {
                    final track = participantTracks[index];
                    print('Track: ${track.videoTrack.runtimeType}');
                    return Stack(
                      children: [
                        track.videoTrack != null && !track.videoTrack!.muted
                            ? VideoTrackRenderer(
                                key: Key(track.videoTrack!.cid),
                                track.videoTrack!,
                                fit: rtc.RTCVideoViewObjectFit
                                    .RTCVideoViewObjectFitContain,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  color: Colors.grey,
                                ),
                              ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Builder(builder: (context) {
                                final title = track.participant.id.isNotEmpty
                                    ? track.participant.id
                                    : 'Courage';

                                final audioTrack =
                                    track.participant.audioTracks?.isNotEmpty ??
                                            false
                                        ? track.participant.audioTracks!.first
                                        : null;

                                print('AudioTrack: ${audioTrack?.muted}');
                                final audioAvailable =
                                    audioTrack != null && !audioTrack.muted;

                                final isScreenShare = track.isScreenShare;

                                return Container(
                                  color: Colors.black.withOpacity(0.3),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 7,
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      isScreenShare
                                          ? const Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Icon(
                                                Icons.monitor,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Icon(
                                                audioAvailable
                                                    ? Icons.mic
                                                    : Icons.mic_off,
                                                color: audioAvailable
                                                    ? Colors.white
                                                    : Colors.red,
                                                size: 16,
                                              ),
                                            ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}

enum VideoViewMirrorMode {
  auto,
  off,
  mirror,
}

/// Widget that renders a [VideoTrack].
class VideoTrackRenderer extends StatefulWidget {
  final VideoTrack track;
  final rtc.RTCVideoViewObjectFit fit;
  final VideoViewMirrorMode mirrorMode;

  const VideoTrackRenderer(
    this.track, {
    this.fit = rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
    this.mirrorMode = VideoViewMirrorMode.auto,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoTrackRendererState();
}

class _VideoTrackRendererState extends State<VideoTrackRenderer> {
  final _renderer = rtc.RTCVideoRenderer();
  bool _rendererReady = false;

  @override
  void initState() {
    super.initState();
    (() async {
      await _renderer.initialize();
      await Future.microtask(() => _attach());
      setState(() => _rendererReady = true);
    })();
  }

  @override
  void dispose() {
    _renderer.srcObject = null;
    _renderer.dispose();
    super.dispose();
  }

  void _attach() {
    print('Attach: ${widget.track.mediaStream}');
    _renderer.srcObject = widget.track.mediaStream;
  }

  @override
  void didUpdateWidget(covariant VideoTrackRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.track != widget.track) {
      _attach();
    }
  }

  @override
  Widget build(BuildContext context) => !_rendererReady
      ? const Center(
          child: Text('Loading...'),
        )
      : Builder(
          builder: (ctx) {
            return rtc.RTCVideoView(
              _renderer,
              mirror: _shouldMirror(),
              filterQuality: FilterQuality.medium,
              objectFit: widget.fit,
            );
          },
        );

  bool _shouldMirror() {
    // on
    if (widget.mirrorMode == VideoViewMirrorMode.mirror) return true;
    // auto
    if (widget.mirrorMode == VideoViewMirrorMode.auto) {
      final track = widget.track;
      if (track is LocalVideoTrack) {
        final options = track.currentOptions;
        if (options is CameraCaptureOptions) {
          // mirror if front camera
          return options.cameraPosition == CameraPosition.front;
        }
      }
    }
    // default to false
    return false;
  }
}

class ParticipantTrack {
  ParticipantTrack({
    required this.participant,
    required this.videoTrack,
    required this.isScreenShare,
  });

  final VideoTrack? videoTrack;
  final CallParticipant participant;
  final bool isScreenShare;
}

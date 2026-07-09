import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_video/stream_video.dart';

import '../controls/call_controls.dart';
import '../participants/participant_grid.dart';
import 'call_state_builder.dart';

/// Minimal full-call UI: a participant grid plus a control bar.
///
/// Mirrors `stream_video_flutter`'s `StreamCallContent` at a basic level —
/// local + remote camera tiles, mic/camera toggle, leave.
class StreamCallContent extends StatelessComponent {
  const StreamCallContent({required this.call, this.onLeave, super.key});

  final Call call;
  final void Function()? onLeave;

  @override
  Component build(BuildContext context) {
    return div(classes: 'svj-call-content', [
      CallStateBuilder<CallState>(
        state: call.state,
        builder: (context, state) {
          return div(classes: 'svj-call-content-participants', [
            ParticipantGrid(call: call, participants: state.callParticipants),
          ]);
        },
      ),
      CallControls(call: call, onLeave: onLeave),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.svj-call-content', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        width: 100.vw,
        height: 100.vh,
        backgroundColor: Colors.black,
      ),
    ]),
    css('.svj-call-content-participants', [
      css('&').styles(flex: const Flex(grow: 1), overflow: Overflow.hidden),
    ]),
  ];
}

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_video/stream_video.dart';

import '../call/call_state_builder.dart';
import '../icons/icons.dart';

/// A basic control bar: toggle microphone, toggle camera, leave.
class CallControls extends StatelessComponent {
  const CallControls({required this.call, this.onLeave, super.key});

  final Call call;
  final void Function()? onLeave;

  @override
  Component build(BuildContext context) {
    return CallStateBuilder<CallState>(
      state: call.state,
      builder: (context, state) {
        final local = state.localParticipant;
        return div(classes: 'svj-controls', [
          ControlButton(
            icon: local?.isAudioEnabled ?? false
                ? StreamIcon.mic
                : StreamIcon.micOff,
            onClick: () => call.setMicrophoneEnabled(
              enabled: !(local?.isAudioEnabled ?? false),
            ),
          ),
          ControlButton(
            icon: local?.isVideoEnabled ?? false
                ? StreamIcon.camera
                : StreamIcon.cameraOff,
            onClick: () => call.setCameraEnabled(
              enabled: !(local?.isVideoEnabled ?? false),
            ),
          ),
          ControlButton(
            icon: StreamIcon.callEnd,
            danger: true,
            onClick: () {
              call.leave();
              onLeave?.call();
            },
          ),
        ]);
      },
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.svj-controls', [
      css('&').styles(
        display: .flex,
        justifyContent: .center,
        alignItems: .center,
        gap: Gap(row: Unit.zero, column: 16.px),
        padding: .symmetric(vertical: 16.px),
        backgroundColor: const Color('#000'),
      ),
    ]),
  ];
}

class ControlButton extends StatelessComponent {
  const ControlButton({
    required this.icon,
    required this.onClick,
    this.danger = false,
  });

  final StreamIcon icon;
  final void Function() onClick;
  final bool danger;

  @override
  Component build(BuildContext context) {
    return button(
      classes: danger
          ? 'svj-control-btn svj-control-btn-danger'
          : 'svj-control-btn',
      onClick: onClick,
      [StreamIconView(icon)],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.svj-control-btn', [
      css('&').styles(
        display: .flex,
        width: 3.rem,
        height: 3.rem,
        border: .none,
        radius: .circular(1.5.rem),
        cursor: .pointer,
        justifyContent: .center,
        alignItems: .center,
        color: Colors.white,
        backgroundColor: const Color('#333'),
      ),
      css('&:hover').styles(backgroundColor: const Color('#444')),
    ]),
    css('.svj-control-btn-danger', [
      css('&').styles(backgroundColor: const Color('#c62828')),
      css('&:hover').styles(backgroundColor: const Color('#e53935')),
    ]),
  ];
}

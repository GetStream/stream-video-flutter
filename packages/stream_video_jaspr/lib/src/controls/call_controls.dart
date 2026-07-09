import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:stream_video/stream_video.dart';

import '../call/call_state_builder.dart';

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
            label: local?.isAudioEnabled ?? false ? '\u{1F3A4}' : '\u{1F507}',
            onClick: () => call.setMicrophoneEnabled(
              enabled: !(local?.isAudioEnabled ?? false),
            ),
          ),
          ControlButton(
            label: local?.isVideoEnabled ?? false ? '\u{1F4F9}' : '\u{1F4F7}',
            onClick: () => call.setCameraEnabled(
              enabled: !(local?.isVideoEnabled ?? false),
            ),
          ),
          ControlButton(
            label: '\u{1F4DE}',
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
    required this.label,
    required this.onClick,
    this.danger = false,
  });

  final String label;
  final void Function() onClick;
  final bool danger;

  @override
  Component build(BuildContext context) {
    return button(
      classes: danger
          ? 'svj-control-btn svj-control-btn-danger'
          : 'svj-control-btn',
      onClick: onClick,
      [.text(label)],
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
        fontSize: 1.25.rem,
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

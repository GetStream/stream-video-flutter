import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';

/// The tone of a [CallControlButton].
///
/// A control is something the call cannot happen without — the microphone, the
/// camera, answering, declining, hanging up. Its tone says what pressing it
/// means, not whether some feature is switched on: see [CallFeatureButton] for
/// that.
enum CallControlState {
  /// An affirmative action. Answering a call.
  positive,

  /// The resting tone. A live microphone, a running camera.
  neutral,

  /// A destructive action, or a control the user has turned off. Declining a
  /// call, hanging up, a muted microphone.
  negative,
}

/// A round icon button for the controls a call is built on: the microphone and
/// camera toggles, and answering, declining and leaving.
///
/// Use [CallFeatureButton] instead for anything that is off by default and
/// merely prominent when on — screen sharing, closed captions, recording, or a
/// side panel.
///
/// {@tool snippet}
///
/// ```dart
/// CallControlButton(
///   icon: Icon(context.streamIcons.voiceFill),
///   state: isMuted ? .negative : .neutral,
///   onPressed: () => call.setMicrophoneEnabled(enabled: isMuted),
/// )
/// ```
/// {@end-tool}
class CallControlButton extends StatelessWidget {
  /// Creates a new instance of [CallControlButton].
  const CallControlButton({
    super.key,
    required this.icon,
    this.state = .neutral,
    this.showErrorBadge = false,
    this.onPressed,
    this.tooltip,
  });

  /// The icon of the button.
  final Widget icon;

  /// What pressing this button means.
  final CallControlState state;

  /// Whether to draw an error badge on the button's top-end corner.
  ///
  /// This marks a control the user should look at — a microphone permission
  /// that was refused, a camera that failed to start — and is independent of
  /// [state] and of whether the button can be pressed. A button that simply
  /// cannot be used right now takes a null [onPressed] instead.
  final bool showErrorBadge;

  /// The callback to invoke when the user taps on the button.
  ///
  /// Null renders the button disabled.
  final VoidCallback? onPressed;

  /// The message shown when the button is long-pressed or hovered.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return StreamButtonTheme(
      // There is no success button style in the design system, and `positive`
      // has to read as an answer rather than as an accent. Repainting the
      // primary background is the narrowest way to get there without teaching
      // every app's theme about a fourth style.
      data: .new(
        primary: .new(
          solid: .new(
            backgroundColor: .all(context.streamColorScheme.accentSuccess),
          ),
        ),
      ),
      child: CallButtonBadge(
        showErrorBadge: showErrorBadge,
        child: StreamButton.icon(
          icon: icon,
          onPressed: onPressed,
          tooltip: tooltip,
          style: switch (state) {
            .positive => .primary,
            .neutral => .secondary,
            .negative => .destructive,
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stream_video_filters/video_effects_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../utils/consts.dart';
import '../../utils/feedback_dialog.dart';
import 'background_filters_menu_item.dart';
import 'incoming_video_quality.dart';
import 'reactions_menu_content.dart';

/// What the control bar already carries at a given width.
///
/// The more menu offers a control only where this says the bar does not, so
/// each one is reachable exactly once. It mirrors the layouts `CallScreen`
/// gives `CallControlBar`, and has to move with them.
extension on StreamScreenSize {
  /// The bar's reaction button, and with it raising a hand.
  bool get hasReactions => isLarge;

  bool get hasClosedCaptions => isLarge;

  bool get hasStats => isLarge;

  bool get hasRecording => isLarge;

  /// Screen sharing survives into the medium bar; only a phone drops it.
  bool get hasScreenShare => !isSmall;

  /// The carets on the microphone and camera split buttons, which are plain
  /// round buttons on a phone.
  bool get hasDevicePickers => !isSmall;
}

/// The call's overflow menu.
///
/// A bottom sheet on Android and iOS and an anchored menu elsewhere, both
/// through [StreamAdaptiveMenuAnchor]. Its contents follow the window size:
/// anything the control bar already shows at this width is left out, and
/// anything the bar drops at this width is picked up here.
class CallMoreMenu extends StatefulWidget {
  const CallMoreMenu({
    required this.call,
    required this.devices,
    required this.videoEffectsManager,
    required this.icon,
    this.screenShareConstraints,
    this.onStatsPressed,
    super.key,
  });

  final Call call;

  /// The screen's device controller — the same one behind the split buttons'
  /// carets, so the menu and the carets never disagree about what is in use.
  final StreamMediaDevicesController devices;

  final StreamVideoEffectsManager videoEffectsManager;

  /// The glyph on the button that opens the menu.
  final IconData icon;

  final ScreenShareConstraints? screenShareConstraints;

  final VoidCallback? onStatsPressed;

  @override
  State<CallMoreMenu> createState() => _CallMoreMenuState();
}

class _CallMoreMenuState extends State<CallMoreMenu> {
  /// Resolved asynchronously, so the strip is absent on the first frame.
  bool _effectsSupported = false;

  @override
  void initState() {
    super.initState();
    widget.videoEffectsManager.isSupported().then((supported) {
      if (mounted) setState(() => _effectsSupported = supported);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Both sources feed the menu's rows, and both have to be watched here
    // rather than inside it: the sheet presentation builds its body once, on a
    // route, so what it is handed at open time is what it shows.
    return ListenableBuilder(
      listenable: widget.devices,
      builder: (context, _) => StreamBuilder<CallState>(
        stream: widget.call.state,
        initialData: widget.call.state.value,
        builder: (context, snapshot) {
          final state = snapshot.data ?? widget.call.state.value;

          return StreamAdaptiveMenuAnchor(
            title: 'More',
            // The control bar runs along the bottom of the call.
            direction: StreamMenuDirection.up,
            sections: _sections(context, state),
            builder: (context, handle) => CallFeatureButton(
              icon: Icon(widget.icon),
              selected: handle.isOpen,
              onPressed: handle.toggle,
            ),
          );
        },
      ),
    );
  }

  List<StreamMenuSection> _sections(BuildContext context, CallState state) {
    final size = context.streamScreenSize;

    return [
      if (!size.hasReactions)
        StreamMenuSection(
          content: (context, handle) => ReactionsMenuContent(
            call: widget.call,
            onReactionSent: handle.close,
          ),
        ),
      if (_effectsSupported)
        StreamMenuSection(
          // No handle: the strip stays open so several filters can be tried.
          content: (context, _) => BackgroundFiltersMenuItem(
            videoEffectsManager: widget.videoEffectsManager,
          ),
        ),
      StreamMenuSection(options: _actions(context, state, size)),
      if (!size.hasDevicePickers)
        ...[
          ...widget.devices.audioSections(context),
          ...widget.devices.videoSections(context),
        ].map(_folded),
      if (!kIsProd) ..._developerSections(context, state),
    ];
  }

  /// The same section, folded away until its heading is pressed.
  ///
  /// The device lists are the long tail of the menu on a phone, where they are
  /// the only way to pick a microphone.
  static StreamMenuSection _folded(StreamMenuSection section) =>
      StreamMenuSection(
        heading: section.heading,
        options: section.options,
        content: section.content,
        collapsible: true,
      );

  List<StreamMenuOption> _actions(
    BuildContext context,
    CallState state,
    StreamScreenSize size,
  ) {
    final icons = context.streamIcons;
    final call = widget.call;
    final sharing = state.localParticipant?.isScreenShareEnabled ?? false;

    return [
      // Absent where the call is not configured for it, rather than offered
      // as a switch that does nothing.
      if (state.settings.audio.noiseCancellation?.mode !=
          NoiseCancellationSettingsMode.disabled)
        StreamMenuOption(
          label: 'Noise cancellation',
          leading: Icon(icons.audio),
          trailing: _OnOff(on: state.isAudioProcessing),
          // Leaves the menu up: the row reports the state the press changes,
          // and closing over it would hide the answer.
          closesMenu: false,
          onSelected: () => state.isAudioProcessing
              ? call.stopAudioProcessing()
              : call.startAudioProcessing(),
        ),
      if (!size.hasClosedCaptions &&
          state.settings.transcription.closedCaptionMode !=
              ClosedCaptionSettingsMode.disabled)
        StreamMenuOption(
          label: 'Closed captions',
          leading: Icon(icons.captionFill),
          trailing: _OnOff(on: state.isCaptioning),
          closesMenu: false,
          onSelected: () => state.isCaptioning
              ? call.stopClosedCaptions()
              : call.startClosedCaptions(),
        ),
      if (!size.hasScreenShare)
        StreamMenuOption(
          label: 'Screen share',
          leading: Icon(icons.presentMobileFill),
          trailing: _OnOff(on: sharing),
          // This state's context rather than the row's: the menu closes
          // before the callback runs, and on desktop the action still has a
          // picker to put on screen.
          onSelected: () => toggleScreenShare(
            this.context,
            call: call,
            enabled: !sharing,
            constraints: widget.screenShareConstraints,
          ),
        ),
      if (!size.hasRecording)
        StreamMenuOption(
          label: 'Record call',
          leading: Icon(
            state.isRecording ? icons.recordingStopFill : icons.recordingFill,
          ),
          trailing: _OnOff(on: state.isRecording),
          closesMenu: false,
          onSelected: () =>
              state.isRecording ? call.stopRecording() : call.startRecording(),
        ),
      if (!size.hasStats)
        StreamMenuOption(
          label: 'Stats',
          leading: Icon(icons.statsFill),
          onSelected: widget.onStatsPressed,
        ),
    ];
  }

  List<StreamMenuSection> _developerSections(
    BuildContext context,
    CallState state,
  ) {
    final icons = context.streamIcons;
    final quality = incomingVideoQualityOf(
      widget.call.dynascaleManager.incomingVideoSettings,
    );

    return [
      StreamMenuSection(
        heading: 'Developer options',
        collapsible: true,
        options: [
          StreamMenuOption(
            label: 'Provide feedback',
            leading: Icon(icons.questionCircleFill),
            onSelected: () => showFeedbackDialog(context, call: widget.call),
          ),
        ],
      ),
      StreamMenuSection(
        heading: 'Incoming video quality',
        collapsible: true,
        options: [
          for (final value in IncomingVideoQuality.values)
            StreamMenuOption(
              label: value.name,
              selected: value == quality,
              onSelected: () => _setIncomingVideoQuality(value),
            ),
        ],
      ),
    ];
  }

  void _setIncomingVideoQuality(IncomingVideoQuality quality) {
    if (quality == IncomingVideoQuality.off) {
      widget.call.setIncomingVideoEnabled(false);
      return;
    }

    widget.call.setPreferredIncomingVideoResolution(quality.resolution);
  }
}

/// The value a toggle row reports, accented while it is on.
class _OnOff extends StatelessWidget {
  const _OnOff({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    final colors = context.streamColorScheme;

    return Text(
      on ? 'On' : 'Off',
      style: context.streamTextTheme.captionDefault.copyWith(
        color: on ? colors.accentSuccess : colors.textSecondary,
      ),
    );
  }
}

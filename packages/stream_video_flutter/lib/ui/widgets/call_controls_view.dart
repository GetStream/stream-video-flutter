import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/theme/themes.dart';
import 'package:stream_video_flutter/ui/widgets/common/control_buttons.dart';

const deviceIdSpeaker = "speaker";
const deviceIdEarpiece = "earpiece";

/// Widget with control commands for a Call. This Widget provide the UI and
/// logic to change audio input/output, video output, switch camera and hang up
/// accordingly with the platform using this Widget.
class CallControlsView extends StatefulWidget {
  const CallControlsView({
    Key? key,
    required this.call,
    required this.participant,
    this.theme,
    this.borderRadius,
    this.bgColor,
    this.elevation,
    this.padding,
    this.toggleSpeakerStyle,
    this.toggleSpeakerIconEnabled,
    this.toggleSpeakerIconDisabled,
    this.toggleVideoStyle,
    this.toggleVideoIconEnabled,
    this.toggleVideoIconDisabled,
    this.toggleMicStyle,
    this.toggleMicIconEnabled,
    this.toggleMicIconDisabled,
    this.switchCameraStyle,
    this.switchCameraIcon,
    this.hangUpStyle,
    this.handUpIcon,
    this.buttonsAlignmentDesktop,
    this.buttonsAlignmentMobile,
    this.buttonsSpacing,
    this.onToggleSpeaker,
    this.onToggleVideo,
    this.onToggleMic,
    this.onSwitchCamera,
    required this.onHangUp,
  }) : super(key: key);

  final Call call;
  final LocalParticipant participant;

  ///Theme of CallControlsView. This theme will be used as a fallback for the
  ///properties that were not set in the constructor of CallControlsView.
  final StreamControlsTheme? theme;

  /// Style of borders of container bar.
  final BorderRadius? borderRadius;

  /// Color of the background of the bar/
  final Color? bgColor;

  /// Elevation effect of the bar. This changes the top shadow in the Widget.
  final double? elevation;

  ///Paging of the container Widget. You can use to increase/decrease the padding
  ///of the bar and its inner buttons.
  final EdgeInsets? padding;

  /// The style of speaker toggle button.
  final ButtonStyle? toggleSpeakerStyle;

  /// Icon for the speaker toggle button.
  final Icon? toggleSpeakerIconEnabled;
  final Icon? toggleSpeakerIconDisabled;

  /// The style of video toggle button.
  final ButtonStyle? toggleVideoStyle;

  /// Icon of video toggle button.
  final Icon? toggleVideoIconEnabled;

  /// Icon of video toggle button.
  final Icon? toggleVideoIconDisabled;

  /// The style of microphone toggle button.
  final ButtonStyle? toggleMicStyle;

  /// Icon of microphone toggle button.
  final Icon? toggleMicIconEnabled;

  /// Icon of microphone toggle button.
  final Icon? toggleMicIconDisabled;

  /// The style of camera switch button.
  final ButtonStyle? switchCameraStyle;

  /// Icon of camera switch button.
  final Icon? switchCameraIcon;

  /// The style of hand up button.
  final ButtonStyle? hangUpStyle;

  /// Icon of hand up button.
  final Icon? handUpIcon;

  /// Alignment of buttons when is desktop mode. Default: center
  final WrapAlignment? buttonsAlignmentDesktop;

  /// Alignment of buttons when is mobile mode. Default: space evenly
  final WrapAlignment? buttonsAlignmentMobile;

  //Space between the buttons. This only has effect in certain types of
  //buttonsAlignmentMobile and buttonsAlignmentDesktop.
  final double? buttonsSpacing;

  final VoidCallback? onToggleSpeaker;
  final VoidCallback? onToggleVideo;
  final VoidCallback? onToggleMic;
  final VoidCallback? onSwitchCamera;
  final VoidCallback onHangUp;

  @override
  State<CallControlsView> createState() => _CallControlsViewState();
}

class _CallControlsViewState extends State<CallControlsView> {
  Call get call => widget.call;

  CameraPosition position = CameraPosition.front;

  List<MediaDevice>? _audioOutputs;

  StreamSubscription? _deviceChangeSubscription;

  LocalParticipant get participant => widget.participant;

  bool get isMobile =>
      Theme.of(context).platform == TargetPlatform.iOS ||
      Theme.of(context).platform == TargetPlatform.android;

  @override
  void initState() {
    super.initState();
    _deviceChangeSubscription =
        Hardware.instance.onDeviceChange.stream.listen(_loadDevices);
    Hardware.instance.enumerateDevices().then(_loadDevices);
  }

  StreamControlsTheme _getTheme() {
    final streamVideoTheme = StreamVideoTheme.of(context);
    return widget.theme ?? streamVideoTheme.controlsTheme;
  }

  void _loadDevices(List<MediaDevice> devices) async {
    _audioOutputs =
        devices.where((device) => device.kind == 'audiooutput').toList();

    setState(() {});
  }

  /// Returns if the the speaker being used is the internal one.
  bool _isPhoneSpeakerSelected() {
    return Hardware.instance.selectedAudioOutput?.deviceId == deviceIdSpeaker;
  }

  /// Toggles speaker if another option is available. It should not be possible
  /// to call this function when only one option if available, Example: user
  /// is using the smartphone speaker without headphones.
  void _toggleSpeaker() async {
    var audioSelected = Hardware.instance.selectedAudioOutput?.deviceId;
    MediaDevice? newAudio;

    if (audioSelected == deviceIdSpeaker) {
      newAudio = _audioOutputs
          ?.firstWhere((audioOut) => audioOut.deviceId == deviceIdEarpiece);
    } else {
      newAudio = _audioOutputs
          ?.firstWhere((audioOut) => audioOut.deviceId == deviceIdSpeaker);
    }

    if (newAudio != null) {
      await Hardware.instance.selectAudioOutput(newAudio);
      setState(() {});
    }
  }

  ///Enables/Disables video
  void _toggleVideo() async {
    await participant.setCameraEnabled(enabled: !participant.isVideoEnabled);
    setState(() {});
  }

  ///Enables/Disables microfone
  void _toggleMic() async {
    await participant.setMicrophoneEnabled(
      enabled: !participant.isAudioEnabled,
    );
    setState(() {});
  }

  /// Switch between front and back camera. It should not be possible to call
  /// this function when there are only 1 or no video tracks.
  void _switchCamera() async {
    //
    final track = participant.videoTracks.firstOrNull?.track;
    if (track == null) return;

    try {
      final newPosition = position.switched();
      await track.setCameraPosition(newPosition);
      setState(() {
        position = newPosition;
      });
    } catch (error) {
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _deviceChangeSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var theme = _getTheme();

    return Material(
      elevation: widget.elevation ?? theme.elevation,
      borderRadius: widget.borderRadius ?? theme.borderRadius,
      color: widget.bgColor ?? theme.bgColor,
      child: Container(
        padding: theme.padding,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? theme.borderRadius,
        ),
        child: ControlButtonWrapper(
          theme: theme,
          isPhoneSpeakerSelected: _isPhoneSpeakerSelected(),
          toggleSpeaker: widget.onToggleSpeaker ?? _toggleSpeaker,
          toggleVideo: widget.onToggleVideo ?? _toggleVideo,
          toggleMic: widget.onToggleMic ?? _toggleMic,
          switchCamera: widget.onSwitchCamera ?? _switchCamera,
          hangUp: widget.onHangUp,
          participant: participant,
          buttonsAlignmentMobile: widget.buttonsAlignmentMobile,
          buttonsAlignmentDesktop: widget.buttonsAlignmentMobile,
          buttonsSpacing: widget.buttonsSpacing,
          toggleSpeakerIconEnabled: widget.toggleSpeakerIconEnabled,
          toggleSpeakerIconDisabled: widget.toggleSpeakerIconDisabled,
          toggleVideoStyle: widget.toggleVideoStyle,
          toggleVideoIconEnabled: widget.toggleVideoIconEnabled,
          toggleVideoIconDisabled: widget.toggleVideoIconDisabled,
          toggleMicStyle: widget.toggleMicStyle,
          toggleMicIconEnabled: widget.toggleMicIconEnabled,
          toggleMicIconDisabled: widget.toggleMicIconDisabled,
          switchCameraStyle: widget.switchCameraStyle,
          switchCameraIcon: widget.switchCameraIcon,
          hangUpStyle: widget.hangUpStyle,
          handUpIcon: widget.handUpIcon,
        ),
      ),
    );
  }
}

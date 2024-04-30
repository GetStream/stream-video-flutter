import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

CallReactionData _raisedHandReaction = const CallReactionData(
  emojiCode: ':raise-hand:',
  type: 'Raise hand',
  icon: '✋',
);

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({
    required this.call,
    this.onReactionSend,
    this.onStatsPressed,
    this.onAudioOutputChange,
    this.onAudioInputChange,
    super.key,
  });

  final Call call;
  final void Function(CallReactionData)? onReactionSend;
  final void Function()? onStatsPressed;
  final void Function(RtcMediaDevice)? onAudioOutputChange;
  final void Function(RtcMediaDevice)? onAudioInputChange;

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  final _deviceNotifier = RtcMediaDeviceNotifier.instance;
  StreamSubscription<List<RtcMediaDevice>>? _deviceChangeSubscription;

  var _audioOutputs = <RtcMediaDevice>[];
  var _audioInputs = <RtcMediaDevice>[];

  bool showAudioOutputs = false;
  bool showAudioInputs = false;
  bool get showMainSettings => !showAudioOutputs && !showAudioInputs;

  @override
  void initState() {
    super.initState();
    _deviceChangeSubscription = _deviceNotifier.onDeviceChange.listen(
      (devices) {
        _audioOutputs = devices
            .where(
              (it) => it.kind == RtcMediaDeviceKind.audioOutput,
            )
            .toList();

        _audioInputs = devices
            .where(
              (it) => it.kind == RtcMediaDeviceKind.audioInput,
            )
            .toList();
      },
    );
  }

  @override
  void dispose() {
    _deviceChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColorPalette.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        if (showMainSettings) ..._buildMenuItems(),
        if (showAudioOutputs) ..._buildAudioOutputsMenu(),
        if (showAudioInputs) ..._buildAudioInputsMenu(),
      ]),
    );
  }

  List<Widget> _buildMenuItems() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: StreamVideoTheme.of(context)
            .callControlsTheme
            .callReactions
            .where(
                (element) => element.emojiCode != _raisedHandReaction.emojiCode)
            .map((e) {
          return InkWell(
              onTap: () {
                widget.call.sendReaction(
                  reactionType: e.type,
                  emojiCode: e.emojiCode,
                );

                widget.onReactionSend?.call(e);
              },
              child: IgnorePointer(
                child: CallControlOption(
                  icon: Text(
                    e.icon,
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {},
                  padding: const EdgeInsets.all(0),
                ),
              ));
        }).toList(),
      ),
      const SizedBox(height: 8),
      SettingsMenuItem(
        child: const Center(child: Text('✋ Raise hand')),
        onPressed: () {
          widget.call.sendReaction(
            reactionType: _raisedHandReaction.type,
            emojiCode: _raisedHandReaction.emojiCode,
          );

          widget.onReactionSend?.call(_raisedHandReaction);
        },
      ),
      const SizedBox(height: 16),
      StandardActionMenuItem(
        icon: Icons.auto_graph,
        label: 'Call stats',
        onPressed: widget.onStatsPressed,
      ),
      const SizedBox(height: 16),
      StandardActionMenuItem(
        icon: Icons.headphones,
        label: 'Choose audio output',
        onPressed: () {
          setState(() {
            showAudioOutputs = true;
          });
        },
      ),
      const SizedBox(height: 16),
      StandardActionMenuItem(
        icon: Icons.mic,
        label: 'Choose audio input',
        onPressed: () {
          setState(() {
            showAudioInputs = true;
          });
        },
      )
    ];
  }

  List<Widget> _buildAudioOutputsMenu() {
    return [
      GestureDetector(
        onTap: () {
          setState(() {
            showAudioOutputs = false;
          });
        },
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.arrow_back, size: 24),
        ),
      ),
      const SizedBox(height: 16),
      ..._audioOutputs
          .map(
            (device) {
              return StandardActionMenuItem(
                icon: Icons.multitrack_audio,
                label: device.label,
                color:
                    widget.call.state.value.audioOutputDevice?.id == device.id
                        ? AppColorPalette.appGreen
                        : null,
                onPressed: () {
                  widget.call.setAudioOutputDevice(device);
                  widget.onAudioOutputChange?.call(device);
                },
              );
            },
          )
          .cast()
          .insertBetween(const SizedBox(height: 16)),
    ];
  }

  List<Widget> _buildAudioInputsMenu() {
    return [
      GestureDetector(
        onTap: () {
          setState(() {
            showAudioInputs = false;
          });
        },
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.arrow_back, size: 24),
        ),
      ),
      const SizedBox(height: 16),
      ..._audioInputs
          .map(
            (device) {
              return StandardActionMenuItem(
                icon: Icons.multitrack_audio,
                label: device.label,
                color: widget.call.state.value.audioInputDevice?.id == device.id
                    ? AppColorPalette.appGreen
                    : null,
                onPressed: () {
                  widget.call.setAudioInputDevice(device);
                  widget.onAudioInputChange?.call(device);
                },
              );
            },
          )
          .cast()
          .insertBetween(const SizedBox(height: 16)),
    ];
  }
}

class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({
    super.key,
    required this.child,
    this.onPressed,
  });

  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints.expand(height: 40),
        decoration: BoxDecoration(
          color: AppColorPalette.buttonSecondary,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(8),
        child: child,
      ),
    );
  }
}

class StandardActionMenuItem extends StatelessWidget {
  const StandardActionMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.color,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color? color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SettingsMenuItem(
      onPressed: onPressed,
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

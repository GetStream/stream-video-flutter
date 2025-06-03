import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dogfooding/dogfooding_app_channel.dart';
import 'package:flutter_dogfooding/theme/app_palette.dart';
import 'package:flutter_dogfooding/utils/consts.dart';
import 'package:flutter_dogfooding/widgets/settings_menu/audio_output_menu_item.dart';
import 'package:flutter_dogfooding/widgets/settings_menu/background_filters_menu_item.dart';
import 'package:flutter_dogfooding/widgets/settings_menu/closed_captions_menu_item.dart';
import 'package:flutter_dogfooding/widgets/settings_menu/noise_cancellation_menu_item.dart';
import 'package:flutter_dogfooding/widgets/settings_menu/settings_menu_item.dart';
import 'package:flutter_dogfooding/widgets/settings_menu/standard_action_menu_item.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    hide CurrentPlatform;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../utils/feedback_dialog.dart';

CallReactionData _raisedHandReaction = const CallReactionData(
  emojiCode: ':raise-hand:',
  type: 'Raise hand',
  icon: '✋',
);

enum IncomingVideoQuality {
  auto('Auto'),
  p2160('2160p'),
  p1080('1080p'),
  p720('720p'),
  p480('480p'),
  p144('144p'),
  off('Off');

  final String name;

  const IncomingVideoQuality(this.name);

  @override
  String toString() => name;
}

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({
    required this.call,
    required this.videoEffectsManager,
    this.onReactionSend,
    this.onStatsPressed,
    this.onAudioOutputChange,
    this.onAudioInputChange,
    this.onVideoInputChange,
    super.key,
  });

  final Call call;
  final StreamVideoEffectsManager videoEffectsManager;
  final void Function(CallReactionData)? onReactionSend;
  final void Function()? onStatsPressed;
  final void Function(RtcMediaDevice, {bool closeMenu})? onAudioOutputChange;
  final void Function(RtcMediaDevice)? onAudioInputChange;
  final void Function(RtcMediaDevice)? onVideoInputChange;

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  final _deviceNotifier = RtcMediaDeviceNotifier.instance;
  final DogfoodingAppChannel _dogfoodingAppChannel = DogfoodingAppChannel();
  StreamSubscription<List<RtcMediaDevice>>? _deviceChangeSubscription;
  StreamVideoEffectsManager get _videoEffectsManager =>
      widget.videoEffectsManager;

  var _audioOutputs = <RtcMediaDevice>[];
  RtcMediaDevice? get _audioOutputDevice =>
      widget.call.state.value.audioOutputDevice;
  var _audioInputs = <RtcMediaDevice>[];
  var _videoInputs = <RtcMediaDevice>[];

  bool _backgroundEffectsSupported = false;
  bool showAudioOutputs = false;
  bool showAudioInputs = false;
  bool showVideoInputs = false;
  bool showIncomingQuality = false;
  bool showBackgroundEffects = false;

  bool get showMainSettings =>
      !showAudioOutputs &&
      !showAudioInputs &&
      !showVideoInputs &&
      !showIncomingQuality &&
      !showBackgroundEffects;

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

        _videoInputs = devices
            .where(
              (it) => it.kind == RtcMediaDeviceKind.videoInput,
            )
            .toList();

        if (context.mounted) setState(() {}); // intentionally empty
      },
    );
    widget.videoEffectsManager.isSupported().then((value) {
      if (context.mounted) setState(() => _backgroundEffectsSupported = value);
    });
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
        if (showVideoInputs) ..._buildVideoInputsMenu(),
        if (showIncomingQuality) ..._buildIncomingQualityMenu(),
        if (showBackgroundEffects) ..._buildBackgroundFiltersMenu(),
      ]),
    );
  }

  List<Widget> _buildMenuItems() {
    final incomingVideoQuality = getIncomingVideoQuality(
        widget.call.dynascaleManager.incomingVideoSettings);

    return [
      Wrap(
        alignment: WrapAlignment.spaceEvenly,
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
      if (_backgroundEffectsSupported)
        BackgroundFiltersMenuItem(videoEffectsManager: _videoEffectsManager),
      NoiseCancellationMenuItem(call: widget.call),
      if (_audioOutputs.isDefaultMobileAudioOutput &&
          _audioOutputDevice != null) ...[
        ToggleAudioOutputMenuItem(
          audioOutputDevice: _audioOutputDevice!,
          audioOutputs: _audioOutputs,
          onPressed: (device) => _setAudioOutput(device, closeMenu: false),
        )
      ] else
        ChooseAudioOutputMenuItem(onPressed: () {
          if (CurrentPlatform.isIos) {
            _deviceNotifier.triggeriOSAudioRouteSelectionUI();
            return;
          }

          setState(() {
            showAudioOutputs = true;
          });
        }),
      ClosedCaptionsMenuItem(widget: widget),
      const SizedBox(height: 16),
      StandardActionMenuItem(
        icon: Icons.auto_graph,
        label: 'Stats',
        onPressed: widget.onStatsPressed,
      ),
      if (!kIsProd) ...[
        const SizedBox(height: 16),
        const Text('Developer options'),
        const SizedBox(height: 8),
        StandardActionMenuItem(
          icon: Icons.mic,
          label: 'Choose audio input',
          onPressed: () {
            setState(() {
              showAudioInputs = true;
            });
          },
        ),
        const SizedBox(height: 16),
        StandardActionMenuItem(
          icon: Icons.camera_alt,
          label: 'Choose video input',
          onPressed: () {
            setState(() {
              showVideoInputs = true;
            });
          },
        ),
        const SizedBox(height: 16),
        StandardActionMenuItem(
          icon: Icons.auto_awesome,
          label: 'Set Background Effect',
          onPressed: () {
            setState(() {
              showBackgroundEffects = true;
            });
          },
        ),
        const SizedBox(height: 16),
        StandardActionMenuItem(
          icon: Icons.high_quality_sharp,
          label: 'Incoming video quality',
          trailing: Text(
            incomingVideoQuality.name,
            style: TextStyle(
              color: incomingVideoQuality != IncomingVideoQuality.auto
                  ? AppColorPalette.appGreen
                  : null,
            ),
          ),
          onPressed: () {
            setState(() {
              showIncomingQuality = true;
            });
          },
        ),
        const SizedBox(height: 16),
        StandardActionMenuItem(
          icon: Icons.feedback,
          label: 'Provide feedback',
          onPressed: () {
            showFeedbackDialog(context, call: widget.call);
          },
        ),
      ],
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
                color: _audioOutputDevice?.id == device.id
                    ? AppColorPalette.appGreen
                    : null,
                onPressed: () {
                  _setAudioOutput(device);
                },
              );
            },
          )
          .cast()
          .insertBetween(const SizedBox(height: 16)),
    ];
  }

  void _setAudioOutput(RtcMediaDevice device, {bool closeMenu = true}) {
    widget.call.setAudioOutputDevice(device);
    widget.onAudioOutputChange?.call(device, closeMenu: closeMenu);
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

  List<Widget> _buildVideoInputsMenu() {
    return [
      GestureDetector(
        onTap: () {
          setState(() {
            showVideoInputs = false;
          });
        },
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.arrow_back, size: 24),
        ),
      ),
      const SizedBox(height: 16),
      ..._videoInputs
          .map(
            (device) {
              return StandardActionMenuItem(
                icon: Icons.camera_alt,
                label: device.label,
                color: widget.call.state.value.videoInputDevice?.id == device.id
                    ? AppColorPalette.appGreen
                    : null,
                onPressed: () {
                  widget.call.setVideoInputDevice(device);
                  widget.onVideoInputChange?.call(device);
                },
              );
            },
          )
          .cast()
          .insertBetween(const SizedBox(height: 16)),
    ];
  }

  List<Widget> _buildBackgroundFiltersMenu() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                showBackgroundEffects = false;
              });
            },
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.arrow_back, size: 24),
            ),
          ),
          TextButton(
            child: const Text('Clear'),
            onPressed: () {
              _videoEffectsManager.disableAllFilters();
            },
          )
        ],
      ),
      const SizedBox(height: 16),
      const Text(
        'Background Blur',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              SizedBox(
                height: 60,
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.blur_on,
                      size: 30,
                    ),
                    onPressed: () => _videoEffectsManager
                        .applyBackgroundBlurFilter(BlurIntensity.light),
                  ),
                ),
              ),
              const Text('Light'),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 60,
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.blur_on,
                      size: 40,
                    ),
                    onPressed: () => _videoEffectsManager
                        .applyBackgroundBlurFilter(BlurIntensity.medium),
                  ),
                ),
              ),
              const Text('Medium'),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 60,
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.blur_on,
                      size: 50,
                    ),
                    onPressed: () => _videoEffectsManager
                        .applyBackgroundBlurFilter(BlurIntensity.heavy),
                  ),
                ),
              ),
              const Text('Heavy'),
            ],
          )
        ],
      ),
      const SizedBox(height: 16),
      const Text(
        'Image Background',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () => _videoEffectsManager
                .applyBackgroundImageFilter('assets/bg1.jpg'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/bg1.jpg',
                fit: BoxFit.cover,
                width: 72,
                height: 102,
              ),
            ),
          ),
          InkWell(
            onTap: () => _videoEffectsManager
                .applyBackgroundImageFilter('assets/bg2.jpg'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/bg2.jpg',
                fit: BoxFit.cover,
                width: 72,
                height: 102,
              ),
            ),
          ),
          InkWell(
            onTap: () => _videoEffectsManager
                .applyBackgroundImageFilter('assets/bg3.jpg'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/bg3.jpg',
                fit: BoxFit.cover,
                width: 72,
                height: 102,
              ),
            ),
          )
        ],
      ),
      const SizedBox(height: 16),
      const Text(
        'Custom Filters',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              SizedBox(
                height: 60,
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.filter_b_and_w,
                      size: 40,
                    ),
                    onPressed: () => _videoEffectsManager.applyCustomEffect(
                      'grayscale',
                      registerEffectProcessorCallback: () async {
                        await _dogfoodingAppChannel.registerGreyscaleEffect();
                      },
                    ),
                  ),
                ),
              ),
              const Text('Grayscale'),
            ],
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildIncomingQualityMenu() {
    return [
      GestureDetector(
        onTap: () {
          setState(() {
            showIncomingQuality = false;
          });
        },
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.arrow_back, size: 24),
        ),
      ),
      const SizedBox(height: 16),
      ...IncomingVideoQuality.values
          .map(
            (quality) {
              return StandardActionMenuItem(
                icon: Icons.video_settings,
                label: quality.name,
                color: getIncomingVideoQuality(widget
                            .call.dynascaleManager.incomingVideoSettings) ==
                        quality
                    ? AppColorPalette.appGreen
                    : null,
                onPressed: () {
                  if (quality == IncomingVideoQuality.off) {
                    widget.call.setIncomingVideoEnabled(false);
                  } else {
                    widget.call.setPreferredIncomingVideoResolution(
                        getIncomingVideoResolution(quality));
                  }
                },
              );
            },
          )
          .cast()
          .insertBetween(const SizedBox(height: 16)),
    ];
  }

  VideoDimension? getIncomingVideoResolution(IncomingVideoQuality quality) {
    switch (quality) {
      case IncomingVideoQuality.auto:
      case IncomingVideoQuality.off:
        return null;
      case IncomingVideoQuality.p2160:
        return VideoDimension(width: 3840, height: 2160);
      case IncomingVideoQuality.p1080:
        return VideoDimension(width: 1920, height: 1080);
      case IncomingVideoQuality.p720:
        return VideoDimension(width: 1280, height: 720);
      case IncomingVideoQuality.p480:
        return VideoDimension(width: 640, height: 480);
      case IncomingVideoQuality.p144:
        return VideoDimension(width: 256, height: 144);
    }
  }

  IncomingVideoQuality getIncomingVideoQuality(IncomingVideoSettings? setting) {
    final preferredResolution = setting?.preferredResolution;
    if (setting?.enabled == false) {
      return IncomingVideoQuality.off;
    }
    if (preferredResolution == null) {
      return IncomingVideoQuality.auto;
    } else if (preferredResolution.height >= 2160) {
      return IncomingVideoQuality.p2160;
    } else if (preferredResolution.height >= 1080) {
      return IncomingVideoQuality.p1080;
    } else if (preferredResolution.height >= 720) {
      return IncomingVideoQuality.p720;
    } else if (preferredResolution.height >= 480) {
      return IncomingVideoQuality.p480;
    } else if (preferredResolution.height >= 144) {
      return IncomingVideoQuality.p144;
    } else {
      return IncomingVideoQuality.auto;
    }
  }
}

extension on List<RtcMediaDevice> {
  bool get isDefaultMobileAudioOutput =>
      length == 2 &&
      any((it) => it.id.toUpperCase() == deviceIdSpeaker.toUpperCase()) &&
      any((it) => it.id.toUpperCase() == deviceIdEarpiece.toUpperCase());
}

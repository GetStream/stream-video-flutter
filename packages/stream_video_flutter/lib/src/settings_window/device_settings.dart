import 'package:flutter/material.dart';

import '../../stream_video_flutter.dart';
import '../call_screen/device_select.dart';
import '../l10n/localization_extension.dart';
import 'local_preview.dart';
import 'settings_switch_row.dart';

/// The device tab of a [StreamModalWindow]: the call's device settings, under
/// the label "Device".
///
/// ```dart
/// StreamModalWindow(
///   tabs: [
///     StreamDeviceSettingsTab(call: call, devices: devices),
///   ],
/// )
/// ```
final _logger = taggedLogger(tag: 'SV:DeviceSettings');

class StreamDeviceSettingsTab extends StreamModalWindowTab {
  /// Creates the device tab.
  ///
  /// [icon] and [label] replace the default gear and "Device".
  StreamDeviceSettingsTab({
    required Call call,
    required StreamMediaDevicesController devices,
    Widget? icon,
    Widget? label,
  }) : super(
         icon: icon ?? const _DeviceTabIcon(),
         label: label ?? const _DeviceTabLabel(),
         builder: (context) =>
             StreamDeviceSettings(call: call, devices: devices),
       );
}

class _DeviceTabIcon extends StatelessWidget {
  const _DeviceTabIcon();

  @override
  Widget build(BuildContext context) => Icon(context.streamIcons.settingsFill);
}

class _DeviceTabLabel extends StatelessWidget {
  const _DeviceTabLabel();

  @override
  Widget build(BuildContext context) =>
      Text(context.translations.settingsDeviceTab);
}

/// The call's device settings: a preview of the local participant, the
/// camera, microphone and speaker in use, noise cancellation and the quality
/// other participants' video is received at.
///
/// The content of [StreamDeviceSettingsTab], and usable on its own.
///
/// [devices] is the controller the rest of the call screen picks devices
/// with, so a device picked here shows up there too. The speaker is offered
/// only where the platform lists outputs, and noise cancellation only where
/// the call is configured for it.
class StreamDeviceSettings extends StatelessWidget {
  /// Creates the device settings.
  const StreamDeviceSettings({
    super.key,
    required this.call,
    required this.devices,
  });

  /// The call whose devices are set.
  final Call call;

  /// Lists the devices and picks between them.
  final StreamMediaDevicesController devices;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: spacing.xxl,
      children: [
        Center(child: StreamSettingsLocalPreview(call: call, width: 256)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DeviceSelects(devices: devices),
            // Brings its own gap, so that it leaves none when it is hidden.
            _NoiseCancellation(call: call),
            SizedBox(height: spacing.xl),
            _IncomingVideoQualitySelect(call: call),
          ],
        ),
      ],
    );
  }
}

class _DeviceSelects extends StatelessWidget {
  const _DeviceSelects({required this.devices});

  final StreamMediaDevicesController devices;

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;
    final icons = context.streamIcons;

    return ListenableBuilder(
      listenable: devices,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.streamSpacing.xl,
        children: [
          StreamDeviceSelect(
            title: translations.lobbyCameraSection,
            labelText: translations.deviceSettingsSelectCamera,
            sections: devices.videoSections(context),
            icon: icons.videoFill,
            value: devices.selectedVideoInput?.label,
          ),
          StreamDeviceSelect(
            title: translations.lobbyMicrophoneSection,
            labelText: translations.deviceSettingsSelectMicrophone,
            sections: devices.microphoneSections(context),
            icon: icons.voiceFill,
            value: devices.selectedAudioInput?.label,
          ),
          // Android routes audio itself and lists no outputs.
          if (devices.audioOutputs.isNotEmpty)
            StreamDeviceSelect(
              title: translations.lobbySpeakerSection,
              labelText: translations.deviceSettingsSelectSpeaker,
              sections: devices.speakerSections(context),
              icon: icons.audio,
              value: devices.selectedAudioOutput?.label,
            ),
        ],
      ),
    );
  }
}

class _NoiseCancellation extends StatelessWidget {
  const _NoiseCancellation({required this.call});

  final Call call;

  static ({bool available, bool on}) _noiseCancellation(CallState state) => (
    available:
        state.settings.audio.noiseCancellation?.mode !=
        FeatureActivationMode.disabled,
    on: state.isAudioProcessing,
  );

  Future<void> _setNoiseCancellation(bool on) async {
    final result = on
        ? await call.startAudioProcessing()
        : await call.stopAudioProcessing();
    if (result case Failure(:final error)) {
      _logger.e(
        () => 'Turning noise cancellation ${on ? 'on' : 'off'} failed: $error',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;

    return PartialCallStateBuilder(
      call: call,
      selector: _noiseCancellation,
      builder: (context, noiseCancellation) {
        if (!noiseCancellation.available || !call.isAudioProcessorConfigured) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.only(top: context.streamSpacing.xl),
          child: StreamSettingsSwitchRow(
            title: translations.deviceSettingsNoiseCancellation,
            description:
                translations.deviceSettingsNoiseCancellationDescription,
            value: noiseCancellation.on,
            onChanged: _setNoiseCancellation,
          ),
        );
      },
    );
  }
}

class _IncomingVideoQualitySelect extends StatefulWidget {
  const _IncomingVideoQualitySelect({required this.call});

  final Call call;

  @override
  State<_IncomingVideoQualitySelect> createState() =>
      _IncomingVideoQualitySelectState();
}

class _IncomingVideoQualitySelectState
    extends State<_IncomingVideoQualitySelect> {
  // Held so a rebuild doesn't subscribe again.
  late Stream<IncomingVideoQuality> _quality = call.incomingVideoQualityStream;

  Call get call => widget.call;

  @override
  void didUpdateWidget(_IncomingVideoQualitySelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.call != oldWidget.call) {
      _quality = call.incomingVideoQualityStream;
    }
  }

  Future<void> _setQuality(IncomingVideoQuality quality) async {
    final result = await call.setIncomingVideoQuality(quality);
    if (result case Failure(:final error)) {
      _logger.e(() => 'Setting the incoming video quality failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;

    return StreamBuilder<IncomingVideoQuality>(
      stream: _quality,
      initialData: call.incomingVideoQuality,
      builder: (context, snapshot) {
        final quality = snapshot.data ?? IncomingVideoQuality.auto;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: context.streamSpacing.xs,
          children: [
            StreamAdaptiveMenuAnchor(
              title: translations.deviceSettingsIncomingVideoQuality,
              matchAnchorWidth: true,
              sections: [
                StreamMenuSection(
                  options: [
                    for (final value in IncomingVideoQuality.values)
                      StreamMenuOption(
                        label: value.label(context),
                        selected: value == quality,
                        onSelected: () => _setQuality(value),
                      ),
                  ],
                ),
              ],
              builder: (context, handle) => StreamSelectInput(
                labelText: translations.deviceSettingsIncomingVideoQuality,
                leading: Icon(context.streamIcons.videoFill),
                value: quality.label(context),
                expanded: handle.isOpen,
                onPressed: handle.toggle,
              ),
            ),
            // Drawn here rather than as the field's helper text, which is
            // cut to one line.
            StreamHelperText(
              text: translations.deviceSettingsIncomingVideoQualityHelper,
              maxLines: 3,
            ),
          ],
        );
      },
    );
  }
}

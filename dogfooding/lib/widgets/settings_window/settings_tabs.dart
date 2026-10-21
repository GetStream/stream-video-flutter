import 'package:flutter/widgets.dart';
import 'package:stream_video_filters/video_effects_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'effects_tab.dart';
import 'language_tab.dart';
import 'recordings_tab.dart';
import 'theme_tab.dart';

/// The tabs of the settings window, in the order its sidebar lists them.
///
/// Composed here, the way the call screen composes its control bar, so the
/// window is set up in one place: add, remove or reorder tabs in this list.
///
/// The effects tab is left out where [effectsSupported] says the device can't
/// apply effects.
List<StreamModalWindowTab> settingsTabs(
  BuildContext context, {
  required Call call,
  required StreamMediaDevicesController devices,
  required StreamVideoEffectsManager videoEffectsManager,
  required bool effectsSupported,
}) => [
  StreamDeviceSettingsTab(call: call, devices: devices),
  if (effectsSupported)
    effectsTab(context, call: call, manager: videoEffectsManager),
  StreamCaptionsSettingsTab(call: call),
  languageTab(context),
  themeTab(context),
  recordingsTab(call: call),
];

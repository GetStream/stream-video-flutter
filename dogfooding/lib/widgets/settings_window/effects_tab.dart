import 'package:flutter/material.dart';
import 'package:stream_video_filters/video_effects_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../dogfooding_app_channel.dart';

const _backgroundAssets = [
  'assets/bg1.jpg',
  'assets/bg2.jpg',
  'assets/bg3.jpg',
];

const _grayscale = 'grayscale';

/// The settings window's effects tab: three strengths of background blur, a
/// grayscale filter and the app's background images, applied through
/// [manager].
///
/// Add it only where `manager.isSupported()` says the device can apply them.
StreamEffectsSettingsTab effectsTab(
  BuildContext context, {
  required Call call,
  required StreamVideoEffectsManager manager,
}) {
  final icons = context.streamIcons;

  return StreamEffectsSettingsTab(
    call: call,
    filters: [
      for (final (intensity, label, icon) in [
        (BlurIntensity.light, 'Light blur', icons.blurFill),
        (BlurIntensity.medium, 'Medium blur', icons.gridPixelFill),
        (BlurIntensity.heavy, 'Heavy blur', icons.fullBlurFill),
      ])
        StreamVideoFilter(
          id: intensity.name,
          label: label,
          icon: Icon(icon),
          onSelected: () => manager.applyBackgroundBlurFilter(intensity),
        ),
      // A custom effect the app registers natively, to try that path out.
      StreamVideoFilter(
        id: _grayscale,
        label: 'Grayscale',
        icon: Icon(icons.starFill),
        onSelected: () => manager.applyCustomEffect(
          _grayscale,
          registerEffectProcessorCallback:
              DogfoodingAppChannel().registerGreyscaleEffect,
        ),
      ),
    ],
    backgrounds: [
      for (final (index, asset) in _backgroundAssets.indexed)
        StreamVideoBackground(
          // The name the manager applies the background under.
          id: 'VirtualBackground-$asset',
          label: 'Background ${index + 1}',
          image: AssetImage(asset),
          onSelected: () => manager.applyBackgroundImageFilter(asset),
        ),
    ],
    onClear: manager.disableAllFilters,
    initialSelected: manager.appliedVideoEffects?.firstOrNull,
  );
}

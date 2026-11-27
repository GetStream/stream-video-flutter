import 'package:flutter/material.dart';
import 'package:stream_video_filters/stream_video_filters.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../utils/grayscale_filter.dart';
import '../../utils/video_filters.dart';

const _backgroundAssets = [
  'assets/bg1.jpg',
  'assets/bg2.jpg',
  'assets/bg3.jpg',
];

const _grayscale = 'grayscale';

/// The settings window's effects tab: three strengths of background blur, a
/// grayscale filter and the app's background images, applied to [call].
///
/// Add it only where `StreamVideoFilters.isSupported()` says the device can
/// apply them.
StreamEffectsSettingsTab effectsTab(
  BuildContext context, {
  required Call call,
}) {
  final blur = context.streamIcons.blurFill;

  StreamVideoFilter option(
    VideoFilter filter, {
    required String id,
    required String label,
    required Widget icon,
  }) {
    return StreamVideoFilter(
      id: id,
      label: label,
      icon: icon,
      onSelected: () => applyVideoFilter(call, filter),
    );
  }

  return StreamEffectsSettingsTab(
    call: call,
    filters: [
      // One blur glyph, drawn larger the stronger the blur.
      for (final (intensity, label, size) in [
        (BlurIntensity.light, 'Light blur', 16.0),
        (BlurIntensity.medium, 'Medium blur', 22.0),
        (BlurIntensity.heavy, 'Heavy blur', 26.0),
      ])
        option(
          BackgroundBlurFilter(intensity: intensity),
          id: intensity.effectName,
          label: label,
          icon: Icon(blur, size: size),
        ),
      option(
        grayscaleFilter,
        id: _grayscale,
        label: 'Grayscale',
        icon: const Icon(Icons.filter_b_and_w),
      ),
    ],
    backgrounds: [
      for (final (index, asset) in _backgroundAssets.indexed)
        StreamVideoBackground(
          id: VirtualBackgroundFilter(asset).effectName,
          label: 'Background ${index + 1}',
          image: AssetImage(asset),
          onSelected: () =>
              applyVideoFilter(call, VirtualBackgroundFilter(asset)),
        ),
    ],
    onClear: () => applyVideoFilter(call, null),
    selected: () => switch (call.videoFilter) {
      final filter? when filter == grayscaleFilter => _grayscale,
      final NativeVideoFilter filter => filter.effectName,
      _ => null,
    },
  );
}

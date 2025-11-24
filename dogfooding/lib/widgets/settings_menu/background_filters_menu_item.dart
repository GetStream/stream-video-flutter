import 'package:flutter/material.dart';
import 'package:stream_video_filters/video_effects_manager.dart';

import '../../dogfooding_app_channel.dart';
import '../../theme/app_palette.dart';

const _iconSize = 40.0;

class BackgroundFiltersMenuItem extends StatefulWidget {
  const BackgroundFiltersMenuItem({
    required this.videoEffectsManager,
    super.key,
  });
  final StreamVideoEffectsManager videoEffectsManager;

  @override
  State<BackgroundFiltersMenuItem> createState() =>
      _BackgroundFiltersMenuItemState();
}

class _BackgroundFiltersMenuItemState extends State<BackgroundFiltersMenuItem> {
  List<String> appliedFilters = [];

  static final _filters = [
    const _BlurFilterOption(),
    const _ImageFilterOption('assets/bg1.jpg'),
    const _ImageFilterOption('assets/bg2.jpg'),
    const _ImageFilterOption('assets/bg3.jpg'),
    _GrayscaleFilterOption(),
  ];

  @override
  void initState() {
    super.initState();
    appliedFilters = widget.videoEffectsManager.appliedVideoEffects ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        height: _iconSize,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _FilterIconWrapper(
              onTap: () => _applyFilter(null),
              isFilterApplied: _isFilterApplied(null),
              child: const Icon(Icons.close, size: 24),
            ),
            ..._filters.map(
              (filter) => _FilterIconWrapper(
                onTap: () => _applyFilter(filter),
                isFilterApplied: _isFilterApplied(filter),
                child: filter.buildIcon(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isFilterApplied(_FilterOption? filter) {
    if (filter == null) {
      return appliedFilters.isEmpty;
    }
    return appliedFilters.contains(filter.name);
  }

  Future<void> _applyFilter(_FilterOption? filter) async {
    if (filter == null || _isFilterApplied(filter)) {
      await widget.videoEffectsManager.disableAllFilters();
    } else {
      switch (filter) {
        case _BlurFilterOption():
          await widget.videoEffectsManager.applyBackgroundBlurFilter(
            filter.intensity,
          );
        case _ImageFilterOption():
          await widget.videoEffectsManager.applyBackgroundImageFilter(
            filter.asset,
          );
        case _CustomFilterOption():
          await widget.videoEffectsManager.applyCustomEffect(
            filter.name,
            registerEffectProcessorCallback:
                filter.registerEffectProcessorCallback,
          );
      }
    }

    setState(() {
      appliedFilters = widget.videoEffectsManager.appliedVideoEffects ?? [];
    });
  }
}

class _FilterIconWrapper extends StatelessWidget {
  const _FilterIconWrapper({
    required this.onTap,
    required this.isFilterApplied,
    required this.child,
  });

  final VoidCallback onTap;
  final bool isFilterApplied;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        decoration: isFilterApplied
            ? BoxDecoration(
                border: Border.all(color: Colors.white),
                shape: BoxShape.circle,
              )
            : BoxDecoration(
                border: Border.all(color: Colors.transparent),
                shape: BoxShape.circle,
              ),
        child: Container(
          height: _iconSize,
          width: _iconSize,
          decoration: const BoxDecoration(
            color: AppColorPalette.buttonSecondary,
            shape: BoxShape.circle,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

sealed class _FilterOption {
  const _FilterOption();

  String get name;

  Widget buildIcon(BuildContext context);
}

class _BlurFilterOption extends _FilterOption {
  // ignore: unused_element_parameter
  const _BlurFilterOption([this.intensity = BlurIntensity.medium]);
  final BlurIntensity intensity;

  @override
  String get name => intensity.name;

  @override
  Widget buildIcon(BuildContext context) => const Icon(Icons.blur_on, size: 24);
}

class _ImageFilterOption extends _FilterOption {
  const _ImageFilterOption(this.asset);
  final String asset;

  @override
  String get name => 'VirtualBackground-$asset';

  @override
  Widget buildIcon(BuildContext context) {
    return Container(
      height: _iconSize,
      width: _iconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(fit: BoxFit.fill, image: AssetImage(asset)),
      ),
    );
  }
}

abstract class _CustomFilterOption extends _FilterOption {
  _CustomFilterOption();

  final DogfoodingAppChannel _dogfoodingAppChannel = DogfoodingAppChannel();

  Future<void> registerEffectProcessorCallback();
}

class _GrayscaleFilterOption extends _CustomFilterOption {
  _GrayscaleFilterOption();

  @override
  String get name => 'grayscale';

  @override
  Future<void> registerEffectProcessorCallback() async {
    await _dogfoodingAppChannel.registerGreyscaleEffect();
  }

  @override
  Widget buildIcon(BuildContext context) =>
      const Icon(Icons.filter_b_and_w, size: 24);
}

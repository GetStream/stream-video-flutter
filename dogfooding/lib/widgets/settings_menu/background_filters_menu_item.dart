import 'package:flutter/material.dart';
import 'package:stream_video_filters/stream_video_filters.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../utils/grayscale_filter.dart';

const _iconSize = 40.0;

class BackgroundFiltersMenuItem extends StatefulWidget {
  const BackgroundFiltersMenuItem({required this.call, super.key});

  final Call call;

  @override
  State<BackgroundFiltersMenuItem> createState() =>
      _BackgroundFiltersMenuItemState();
}

class _BackgroundFiltersMenuItemState extends State<BackgroundFiltersMenuItem> {
  static final _filters = [
    const _BlurFilterOption(),
    const _ImageFilterOption('assets/bg1.jpg'),
    const _ImageFilterOption('assets/bg2.jpg'),
    const _ImageFilterOption('assets/bg3.jpg'),
    const _GrayscaleFilterOption(),
  ];

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
              child: Icon(context.streamIcons.xmark, size: 24),
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
    final applied = widget.call.videoFilter;
    if (filter == null) return applied == null;
    return applied == filter.filter;
  }

  Future<void> _applyFilter(_FilterOption? filter) async {
    final next = filter == null || _isFilterApplied(filter)
        ? null
        : filter.filter;
    final result = await widget.call.setVideoFilter(next);
    if (!mounted) return;
    setState(() {});
    if (result.isFailure) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text('Could not apply the filter')),
      );
    }
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
    final colorScheme = StreamTheme.of(context).colorScheme;

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
          decoration: BoxDecoration(
            color: colorScheme.backgroundSurface,
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

  VideoFilter get filter;

  Widget buildIcon(BuildContext context);
}

class _BlurFilterOption extends _FilterOption {
  const _BlurFilterOption();

  @override
  VideoFilter get filter => BackgroundBlurFilter();

  @override
  Widget buildIcon(BuildContext context) =>
      Icon(context.streamIcons.blurFill, size: 24);
}

class _ImageFilterOption extends _FilterOption {
  const _ImageFilterOption(this.asset);
  final String asset;

  @override
  VideoFilter get filter => VirtualBackgroundFilter(asset);

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

class _GrayscaleFilterOption extends _FilterOption {
  const _GrayscaleFilterOption();

  @override
  VideoFilter get filter => grayscaleFilter;

  @override
  Widget buildIcon(BuildContext context) =>
      const Icon(Icons.filter_b_and_w, size: 24);
}

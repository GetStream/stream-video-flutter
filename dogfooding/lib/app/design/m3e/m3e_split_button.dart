// The split button is only exported through core's experimental video library.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:stream_core_flutter/video.dart'
    show StreamSplitButtonProps, StreamSplitButtonVariant;

import '../app_design_spec.dart';

/// A `StreamSplitButton` drawn as the expressive split button: two halves 2dp
/// apart, fully round on the outside and tightly rounded on the inside,
/// tonal, or filled in the error color when destructive.
///
/// The m3e split button opens its own menu, while the SDK's caret half opens
/// the SDK's, so the halves are put together here.
class M3EStreamSplitButton extends StatelessWidget {
  const M3EStreamSplitButton({required this.props, super.key});

  final StreamSplitButtonProps props;

  static const _outer = Radius.circular(20);
  static const _inner = Radius.circular(4);

  @override
  Widget build(BuildContext context) {
    final destructive = props.variant == StreamSplitButtonVariant.destructive;
    final colorScheme = Theme.of(context).colorScheme;
    final height = designSplitButtonHeight;

    Widget half({
      required Widget icon,
      required VoidCallback? onPressed,
      required String? tooltip,
      required BorderRadius borderRadius,
      required double width,
    }) {
      final style = IconButton.styleFrom(
        fixedSize: Size(width, height),
        minimumSize: Size(width, height),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.standard,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        backgroundColor: destructive ? colorScheme.error : null,
        foregroundColor: destructive ? colorScheme.onError : null,
      );
      return destructive
          ? IconButton.filled(
              onPressed: onPressed,
              tooltip: tooltip,
              style: style,
              icon: icon,
            )
          : IconButton.filledTonal(
              onPressed: onPressed,
              tooltip: tooltip,
              style: style,
              icon: icon,
            );
    }

    return designSplitFrame(
      Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          half(
            icon: props.leadingIcon,
            onPressed: props.onLeadingPressed,
            tooltip: props.leadingTooltip,
            borderRadius: const BorderRadius.horizontal(
              left: _outer,
              right: _inner,
            ),
            width: 48,
          ),
          half(
            icon: props.trailingIcon,
            onPressed: props.onTrailingPressed,
            tooltip: props.trailingTooltip,
            borderRadius: const BorderRadius.horizontal(
              left: _inner,
              right: _outer,
            ),
            width: 36,
          ),
        ],
      ),
    );
  }
}

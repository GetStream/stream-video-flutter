import 'package:flutter/material.dart';
import 'package:stream_core_flutter/core.dart';

/// The visual treatment of a [StreamSelectInput]'s field.
enum StreamSelectInputType {
  /// A bordered field, as used on the lobby screen.
  outline,

  /// A borderless field that only shows its interaction ring.
  ghost,
}

/// A select field styled after the design system's `Web / Select Input`.
///
/// This is the field only: it renders the current [value] (or [hintText] when
/// nothing is selected) between a [leading] widget and a caret, and reports
/// presses through [onPressed]. Opening a menu is the caller's job, which is
/// what lets one field drive more than one selection — the lobby's audio field
/// picks both a microphone and a speaker from a single menu.
///
/// Set [expanded] while that menu is open to get the active border and the
/// caret-up glyph.
///
/// Visual states follow the design's `Type` × `State` matrix: the base border
/// carries the disabled, error and active states, while hover and focus draw a
/// 2px ring. Note that the ring paints 1px *outside* the field, so a caller
/// that clips this widget — or packs fields edge to edge — will clip it.
///
/// This is a design-system candidate: it lives in this SDK until the component
/// is finalized and can graduate to stream_core_flutter, alongside
/// `StreamContextMenuAnchor`. The density deliberately follows
/// [StreamTextInput] rather than the (denser) web spec, so a select and a text
/// input in the same form line up.
class StreamSelectInput extends StatefulWidget {
  /// Creates a select field.
  const StreamSelectInput({
    super.key,
    this.labelText,
    this.leading,
    this.value,
    this.hintText,
    this.type = StreamSelectInputType.outline,
    this.expanded = false,
    this.helperText,
    this.helperState,
    this.onPressed,
    this.focusNode,
  });

  /// Persistent label rendered above the field.
  final String? labelText;

  /// An optional widget shown before the value, typically an [Icon].
  final Widget? leading;

  /// The text of the current selection.
  ///
  /// When null, [hintText] is shown in the placeholder color instead.
  final String? value;

  /// Placeholder text shown while [value] is null.
  final String? hintText;

  /// Whether the field is bordered.
  final StreamSelectInputType type;

  /// Whether the field's menu is open.
  final bool expanded;

  /// Helper message displayed below the field.
  final String? helperText;

  /// The semantic state of [helperText].
  ///
  /// [StreamHelperState.error] also drives the field's error border, whether or
  /// not [helperText] is set.
  final StreamHelperState? helperState;

  /// Called when the field is pressed.
  ///
  /// When null, the field is disabled.
  final VoidCallback? onPressed;

  /// Focus node for the field.
  final FocusNode? focusNode;

  @override
  State<StreamSelectInput> createState() => _StreamSelectInputState();
}

class _StreamSelectInputState extends State<StreamSelectInput> {
  bool _hovered = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null;

  void _handlePress() => widget.onPressed?.call();

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final radius = context.streamRadius;
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    final hasError = widget.helperState == StreamHelperState.error;
    final hasValue = widget.value != null;

    final borderColor = switch ((_enabled, hasError, widget.expanded)) {
      (false, _, _) => colorScheme.borderDisabled,
      (_, true, _) => colorScheme.borderError,
      (_, _, true) => colorScheme.borderActive,
      _ => switch (widget.type) {
        .outline => colorScheme.borderDefault,
        .ghost => Colors.transparent,
      },
    };

    // Hover and focus are drawn as an overlay ring rather than a border color,
    // matching the design's `Interaction Overlay` layer.
    final ringColor = switch ((_enabled, _focused, _hovered)) {
      (false, _, _) => null,
      (_, true, _) => colorScheme.borderFocus,
      (_, _, true) => colorScheme.borderHover,
      _ => null,
    };

    final contentColor = switch ((_enabled, hasValue)) {
      (false, _) => colorScheme.textDisabled,
      (_, true) => colorScheme.textPrimary,
      _ => colorScheme.textTertiary,
    };

    final borderRadius = BorderRadius.all(radius.lg);

    final field = Container(
      decoration: ShapeDecoration(
        shape: RoundedSuperellipseBorder(
          side: BorderSide(color: borderColor),
          borderRadius: borderRadius,
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: spacing.sm,
        horizontal: spacing.md,
      ),
      child: IconTheme(
        data: IconThemeData(size: 20, color: contentColor),
        child: StreamRow(
          spacing: spacing.xs,
          children: [
            ?widget.leading,
            Expanded(
              child: Text(
                widget.value ?? widget.hintText ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyDefault.copyWith(color: contentColor),
              ),
            ),
            Icon(widget.expanded ? icons.caretUp : icons.caretDown),
          ],
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.labelText,
      value: widget.value ?? widget.hintText,
      child: StreamColumn(
        spacing: spacing.xs,
        mainAxisAlignment: .center,
        crossAxisAlignment: .start,
        children: [
          if (widget.labelText case final labelText?)
            ExcludeSemantics(
              child: Text(
                labelText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.headingSm.copyWith(
                  color: _enabled
                      ? colorScheme.textPrimary
                      : colorScheme.textDisabled,
                ),
              ),
            ),
          FocusableActionDetector(
            enabled: _enabled,
            focusNode: widget.focusNode,
            mouseCursor: _enabled
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            onShowHoverHighlight: (value) => setState(() => _hovered = value),
            onShowFocusHighlight: (value) => setState(() => _focused = value),
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  _handlePress();
                  return null;
                },
              ),
            },
            child: GestureDetector(
              onTap: widget.onPressed,
              excludeFromSemantics: true,
              child: Stack(
                clipBehavior: .none,
                children: [
                  field,
                  if (ringColor case final ringColor?)
                    Positioned(
                      left: -1,
                      top: -1,
                      right: -1,
                      bottom: -1,
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            shape: RoundedSuperellipseBorder(
                              side: BorderSide(color: ringColor, width: 2),
                              borderRadius: borderRadius,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (widget.helperText case final helperText?)
            StreamHelperText(text: helperText, state: widget.helperState),
        ],
      ),
    );
  }
}

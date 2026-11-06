import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_design_spec.dart';

/// A [StreamTextInput] drawn as a [GlassTextField], with the label above it
/// and the helper text below it.
class LiquidGlassStreamTextInput extends StatelessWidget {
  const LiquidGlassStreamTextInput({required this.props, super.key});

  final StreamTextInputProps props;

  @override
  Widget build(BuildContext context) {
    // A GlassTextField takes its text from a controller only, always has a
    // line limit, and has no tap or editing-complete callback or text
    // alignment, so a field that needs one is the SDK's own.
    final unsupported =
        (props.controller == null && props.initialValue != null) ||
        props.maxLines == null ||
        props.onTap != null ||
        props.onEditingComplete != null ||
        props.textAlign != TextAlign.start;
    if (unsupported) return DefaultStreamTextInput(props: props);

    return DesignLabeledField(
      label: props.labelText,
      helper: props.helperText,
      helperState: props.helperState,
      field: GlassTextField(
        controller: props.controller,
        focusNode: props.focusNode,
        placeholder: props.hintText,
        prefixIcon: props.leading,
        suffixIcon: props.trailing,
        enabled: props.enabled,
        readOnly: props.readOnly,
        autofocus: props.autofocus,
        keyboardType: props.keyboardType,
        textInputAction: props.textInputAction,
        inputFormatters: props.inputFormatters,
        maxLines: props.maxLines!,
        minLines: props.minLines,
        maxLength: props.maxLength,
        onChanged: props.onChanged,
        onSubmitted: props.onSubmitted,
        // The SDK field's padding, so the glass field is as tall as the
        // others rather than taller.
        padding:
            props.style?.contentPadding?.resolve(Directionality.of(context)) ??
            EdgeInsets.symmetric(
              horizontal: context.streamSpacing.md,
              vertical: context.streamSpacing.sm,
            ),
        useOwnLayer: true,
      ),
    );
  }
}

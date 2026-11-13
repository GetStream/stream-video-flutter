import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

/// A [StreamTextInput] drawn as a Material [TextFormField], for designs whose
/// Material theme styles the field.
class MaterialStreamTextInput extends StatelessWidget {
  const MaterialStreamTextInput({
    required this.props,
    this.outlined = false,
    super.key,
  });

  final StreamTextInputProps props;

  /// Whether the field is drawn with an outline instead of the theme's
  /// default border.
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final error = props.helperState == StreamHelperState.error;

    return TextFormField(
      controller: props.controller,
      initialValue: props.controller == null ? props.initialValue : null,
      focusNode: props.focusNode,
      enabled: props.enabled,
      readOnly: props.readOnly,
      autofocus: props.autofocus,
      autocorrect: props.autocorrect,
      keyboardType: props.keyboardType,
      textInputAction: props.textInputAction,
      textCapitalization: props.textCapitalization,
      textAlign: props.textAlign,
      // Centered, as in the SDK's own field, so the text lines up with a
      // leading or trailing button taller than a line.
      textAlignVertical: props.textAlignVertical ?? TextAlignVertical.center,
      inputFormatters: props.inputFormatters,
      maxLines: props.maxLines,
      minLines: props.minLines,
      maxLength: props.maxLength,
      onChanged: props.onChanged,
      onEditingComplete: props.onEditingComplete,
      onFieldSubmitted: props.onSubmitted,
      onTap: props.onTap,
      decoration: InputDecoration(
        border: outlined ? const OutlineInputBorder() : null,
        labelText: props.labelText,
        hintText: props.hintText,
        helperText: error ? null : props.helperText,
        errorText: error ? props.helperText : null,
        prefixIcon: props.leading,
        suffixIcon: props.trailing,
      ),
    );
  }
}

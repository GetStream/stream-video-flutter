import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_design_spec.dart';

/// A [StreamTextInput] drawn as a fluent_ui [fluent.TextBox], with the label
/// above it and the helper text below it.
class FluentStreamTextInput extends StatelessWidget {
  const FluentStreamTextInput({required this.props, super.key});

  final StreamTextInputProps props;

  @override
  Widget build(BuildContext context) {
    // A TextBox takes its text from a controller only.
    if (props.controller == null && props.initialValue != null) {
      return DefaultStreamTextInput(props: props);
    }

    return DesignLabeledField(
      label: props.labelText,
      helper: props.helperText,
      helperState: props.helperState,
      field: fluent.TextBox(
        controller: props.controller,
        focusNode: props.focusNode,
        placeholder: props.hintText,
        prefix: props.leading,
        suffix: props.trailing,
        enabled: props.enabled,
        readOnly: props.readOnly,
        autofocus: props.autofocus,
        autocorrect: props.autocorrect,
        keyboardType: props.keyboardType,
        textInputAction: props.textInputAction,
        textCapitalization: props.textCapitalization,
        textAlign: props.textAlign,
        textAlignVertical: props.textAlignVertical,
        inputFormatters: props.inputFormatters,
        maxLines: props.maxLines,
        minLines: props.minLines,
        maxLength: props.maxLength,
        onChanged: props.onChanged,
        onEditingComplete: props.onEditingComplete,
        onSubmitted: props.onSubmitted,
        onTap: props.onTap,
      ),
    );
  }
}

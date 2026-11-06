import 'package:flutter/material.dart';
import 'package:shad/shad.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../app_design_spec.dart';

/// A [StreamTextInput] drawn as a [ShadInput], with the label above it and the
/// helper text below it.
class ShadStreamTextInput extends StatelessWidget {
  const ShadStreamTextInput({required this.props, super.key});

  final StreamTextInputProps props;

  @override
  Widget build(BuildContext context) {
    final hint = props.hintText;

    return DesignLabeledField(
      label: props.labelText,
      helper: props.helperText,
      helperState: props.helperState,
      field: ShadInput(
        controller: props.controller,
        initialValue: props.controller == null ? props.initialValue : null,
        focusNode: props.focusNode,
        placeholder: hint == null ? null : Text(hint),
        leading: props.leading,
        trailing: props.trailing,
        enabled: props.enabled,
        readOnly: props.readOnly,
        autofocus: props.autofocus,
        autocorrect: props.autocorrect,
        keyboardType: props.keyboardType,
        textInputAction: props.textInputAction,
        textCapitalization: props.textCapitalization,
        textAlign: props.textAlign,
        inputFormatters: props.inputFormatters,
        maxLines: props.maxLines,
        minLines: props.minLines,
        maxLength: props.maxLength,
        onChanged: props.onChanged,
        onEditingComplete: props.onEditingComplete,
        onSubmitted: props.onSubmitted,
        onPressed: props.onTap,
      ),
    );
  }
}

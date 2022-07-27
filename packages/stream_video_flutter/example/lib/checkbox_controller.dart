import 'package:example/checkbox.dart';
import 'package:flutter/material.dart';

typedef CheckboxController = ValueNotifier<List<CheckBoxItem>>;

extension CheckboxControllerX on CheckboxController {
  updateItem(CheckBoxItem item, bool? val) {
    final newValue = value..firstWhere((element) => element == item).isChecked = val!;
    value = newValue;
  }
}

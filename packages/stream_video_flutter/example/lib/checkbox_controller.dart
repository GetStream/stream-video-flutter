import 'package:example/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

typedef CheckboxController = ValueNotifier<List<CheckBoxItem>>;
typedef CurrentUserController = ValueNotifier<UserInfo>;

extension CheckboxControllerX on CheckboxController {
  void updateItem(CheckBoxItem item, bool? val) {
    final newValue = value
      ..firstWhere((element) => element == item).isChecked = val!;
    value = newValue;
  }

  List<CheckBoxItem>  getIsChecked() =>
      value.where((element) => element.isChecked == true).toList();
}

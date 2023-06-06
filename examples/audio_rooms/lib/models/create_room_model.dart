import 'package:flutter/foundation.dart';

@immutable
class CreateRoomModel {
  const CreateRoomModel({
    required this.title,
    required this.desc,
  });

  final String title;
  final String desc;
}

import 'package:equatable/equatable.dart';

import 'call_metadata.dart';

class CallReaction with EquatableMixin {
  const CallReaction({
    required this.type,
    required this.user,
    this.emojiCode,
    this.custom = const {},
  });

  final String type;
  final String? emojiCode;
  final CallUser user;
  final Map<String, Object>? custom;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [type, user, emojiCode, custom];
}

class CallReactionData with EquatableMixin {
  const CallReactionData({
    required this.type,
    required this.icon,
    this.emojiCode,
    this.custom = const {},
  });

  final String type;
  final String? emojiCode;
  final String icon;
  final Map<String, Object>? custom;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [type, icon, emojiCode, custom];
}

import 'package:stream_core/stream_core.dart' show User, UserType;

import 'user_info.dart';

extension UserInfoExtension on User {
  UserInfo toUserInfo() => UserInfo(
    id: id,
    name: originalName ?? '',
    image: image,
    role: role,
    teams: teams,
    extraData: custom,
  );
}

extension UserInfoToUserExtension on UserInfo {
  User toUser({UserType type = UserType.regular}) => User(
    id: id,
    name: name.isEmpty ? null : name,
    image: image,
    role: role,
    teams: teams,
    custom: extraData,
    type: type,
  );
}

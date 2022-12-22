import 'package:stream_video_flutter/stream_video_flutter.dart';

class CallInviteState {
  CallInviteState({required this.users, required this.selectedUsers});

  final List<UserInfo> users;
  final Map<String, UserInfo> selectedUsers;
}

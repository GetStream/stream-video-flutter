import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'sample_user.dart';

/// Typedef for user from the Video SDK.
typedef VideoUser = UserInfo;

/// Typedef for user from the Chat SDK.
typedef ChatUser = User;

/// Useful mapping functions for [SampleUser].
extension SampleUserX on SampleUser {
  /// Maps a [SampleUser] into user from the Video SDK.
  VideoUser toVideoUser() => VideoUser(
        id: id,
        role: role,
        name: name,
        image: image,
      );

  /// Maps a [SampleUser] into user from the Chat SDK.
  ChatUser toChatUser() => ChatUser(
        id: id,
        role: role,
        name: name,
        image: image,
      );
}

import 'package:stream_video_flutter/stream_video_flutter.dart';

class UserCredentials {
  UserCredentials({required this.userInfo, required this.token});
  final Token token;
  final UserInfo userInfo;
}

final demoUsers = [
  UserCredentials(
      userInfo: UserInfo(
        id: "alice",
        name: "Alice",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYWxpY2UifQ.WZkPaUZb84fLkQoEEFw078Xd1RzwR42XjvBISgM2BAk")),
  UserCredentials(
      userInfo: UserInfo(
        id: "bob",
        name: "Bob",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYm9iIn0.6fqa74FESB2DMUcsIiArBDJR2ckkdSvWiSb7qRLVU6U")),
  UserCredentials(
      userInfo: UserInfo(
        id: "trudy",
        name: "Trudy",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHJ1ZHkifQ.yhwq7Dv7znpFiIZrAb9bOYiEXM_PHtgqoq5pgFeOL78"))
];

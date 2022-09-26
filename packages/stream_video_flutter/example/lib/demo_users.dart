import 'package:stream_video_flutter/stream_video_flutter.dart';

class UserCredentials {
  UserCredentials({required this.userInfo, required this.token});
  final Token token;
  final UserInfo userInfo;
}

// generated using the cli command is the backend
// `./video/ctl auth token key10 secret10 <user_id>`
final demoUsers = [
  UserCredentials(
      userInfo: UserInfo(
        id: "sacha",
        name: "Sacha",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9zYWNoYSIsImV4cCI6MTY2NDI4MTU5NCwiaWF0IjoxNjY0MTk1MTk0LCJ1c2VyX2lkIjoic2FjaGEifQ.Qx3p5Vk9VHTfEIc4ApoRZ32HrqZugj04x0ZakEZcXVQ")),
  UserCredentials(
      userInfo: UserInfo(
        id: "salvatore",
        name: "Salvatore",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9zYWx2YXRvcmUiLCJleHAiOjE2NjQyODE2MjcsImlhdCI6MTY2NDE5NTIyNywidXNlcl9pZCI6InNhbHZhdG9yZSJ9.dBuO-BZ-FQcMpPyLNLg24NL-j79rrXgG13GT-UULEAQ")),
  UserCredentials(
      userInfo: UserInfo(
        id: "sahil",
        name: "Sahil",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9zYWhpbCIsImV4cCI6MTY2NDI4MTY2MCwiaWF0IjoxNjY0MTk1MjYwLCJ1c2VyX2lkIjoic2FoaWwifQ.ECN1N1y9AfmYY07CzjSG03QzVBitvw1oXG7przebSr4")),
  UserCredentials(
      userInfo: UserInfo(
        id: "gordon",
        name: "Gordon",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9nb3Jkb24iLCJleHAiOjE2NjQyODE3MDAsImlhdCI6MTY2NDE5NTMwMCwidXNlcl9pZCI6ImdvcmRvbiJ9._3LFW8NjS1tpGj6dnSZf83V6ZBBh-5gfoXfk-UUSqr8")),
  UserCredentials(
      userInfo: UserInfo(
        id: "deven",
        name: "Deven",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9kZXZlbiIsImV4cCI6MTY2NDI4MTczOSwiaWF0IjoxNjY0MTk1MzM5LCJ1c2VyX2lkIjoiZGV2ZW4ifQ.w167QwHZ6OMWEHqYmZBkTgRe_eaXXzEZn4FcedG1xac"))
];

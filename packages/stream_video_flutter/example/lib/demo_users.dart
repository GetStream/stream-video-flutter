import 'package:stream_video_flutter/stream_video_flutter.dart';

class UserCredentials {
  UserCredentials({required this.userInfo, required this.token});
  final Token token;
  final UserInfo userInfo;
}

// generated using the cli command in the backend
// `./video/ctl auth token key1 secret1 <user_id>`
final demoUsers = [
  UserCredentials(
      userInfo: UserInfo(
        id: "sacha",
        name: "Sacha",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9zYWNoYSIsImV4cCI6MTY2NTc2MTExOCwiaWF0IjoxNjY1Njc0NzE4LCJ1c2VyX2lkIjoic2FjaGEifQ.ut3hk5QdaZ0wbxWl7Qh1GLsMVp07JJ4aGCJnwcTEoc8")),
  UserCredentials(
    userInfo: UserInfo(
      id: "salvatore",
      name: "Salvatore",
    ),
    token: Token(
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9zYWx2YXRvcmUiLCJleHAiOjE2NjU3NjEwNjksImlhdCI6MTY2NTY3NDY2OSwidXNlcl9pZCI6InNhbHZhdG9yZSJ9.zzDWjbLNCuBu5iwxZrrbSeIS6Nbvu6NDdaah6rMWYo0",
    ),
  ),
  UserCredentials(
      userInfo: UserInfo(
        id: "sahil",
        name: "Sahil",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9zYWhpbCIsImV4cCI6MTY2NDkwOTYzOCwiaWF0IjoxNjY0ODIzMjM4LCJ1c2VyX2lkIjoic2FoaWwifQ.-Jh6ZGhh4OrgwZYHxnXNpI02FuBk8ZqaF7YVe6wvRJ0")),
  UserCredentials(
      userInfo: UserInfo(
        id: "gordon",
        name: "Gordon",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9nb3Jkb24iLCJleHAiOjE2NjQ5MDk2NTksImlhdCI6MTY2NDgyMzI1OSwidXNlcl9pZCI6ImdvcmRvbiJ9.4gNkAfS9MFfP3vkW0RA3BZdm_vaK85dXQ-GT2iB61yw")),
  UserCredentials(
      userInfo: UserInfo(
        id: "deven",
        name: "Deven",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9kZXZlbiIsImV4cCI6MTY2NDkwOTY3NywiaWF0IjoxNjY0ODIzMjc3LCJ1c2VyX2lkIjoiZGV2ZW4ifQ.k4IeCNVAfY1fcD4gv3LpnujPPyAHw7FRUqE8q2KkKLQ"))
];

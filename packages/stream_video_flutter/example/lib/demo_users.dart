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
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9zYWNoYSIsImV4cCI6MTY2NDI3MzI3MCwiaWF0IjoxNjY0MTg2ODcwLCJ1c2VyX2lkIjoic2FjaGEifQ.zLcoSThu4ETWt8P3V9Am_dvyARDdi4HLownr7N6CyTQ")),
  UserCredentials(
      userInfo: UserInfo(
        id: "salvatore",
        name: "Salvatore",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9zYWx2YXRvcmUiLCJleHAiOjE2NjQyNzMyOTEsImlhdCI6MTY2NDE4Njg5MSwidXNlcl9pZCI6InNhbHZhdG9yZSJ9._YbEzVsDlPG3SdEINFUPmP_C1xEZgZIwRf9xJgPfURQ")),
  UserCredentials(
      userInfo: UserInfo(
        id: "sahil",
        name: "Sahil",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9zYWhpbCIsImV4cCI6MTY2NDI3MzMyNCwiaWF0IjoxNjY0MTg2OTI0LCJ1c2VyX2lkIjoic2FoaWwifQ.052lpcJpOD1EKXv5SlEFoJhTQtLQzR0ikiDHmk5N0qc")),
  UserCredentials(
      userInfo: UserInfo(
        id: "gordon",
        name: "Gordon",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9nb3Jkb24iLCJleHAiOjE2NjQyNzMzNDUsImlhdCI6MTY2NDE4Njk0NSwidXNlcl9pZCI6ImdvcmRvbiJ9.6sShV0rgXctTudPwm7hYS05jrgA5gT9nYKT9L54-BWs")),
  UserCredentials(
      userInfo: UserInfo(
        id: "deven",
        name: "Deven",
      ),
      token: Token(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdHJlYW0tdmlkZW8tZ29AdjAuMS4wIiwic3ViIjoidXNlci9kZXZlbiIsImV4cCI6MTY2NDI3MzM2NiwiaWF0IjoxNjY0MTg2OTY2LCJ1c2VyX2lkIjoiZGV2ZW4ifQ.FQ5rA1Amb4vMjO2WaeKgIBmZGrwHf5_crLON37U_BFw"))
];

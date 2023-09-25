import 'models.dart';

class User {
  const User({
    required this.info,
    this.type = UserType.authenticated,
  });

  factory User.regular({
    required String userId,
    String? name,
    String? image,
    String role = 'user',
    List<String> teams = const [],
    Map<String, Object?> extraData = const {},
  }) {
    return User(
      info: UserInfo(
        id: userId,
        name: name ?? '',
        image: image,
        role: role,
        teams: teams,
        extraData: extraData,
      ),
    );
  }

  factory User.anonymous({
    String userId = '!anon',
  }) {
    return User(
      type: UserType.anonymous,
      info: UserInfo(id: userId),
    );
  }

  factory User.guest({
    required String userId,
    String? name,
    String? image,
  }) {
    return User(
      type: UserType.guest,
      info: UserInfo(
        id: userId,
        name: name ?? userId,
        image: image,
      ),
    );
  }

  final UserType type;
  final UserInfo info;

  String get id => info.id;

  String? get name => info.name;

  String? get image => info.image;

  String get role => info.role;

  List<String> get teams => info.teams;

  Map<String, Object?> get extraData => info.extraData;
}

enum UserType { authenticated, anonymous, guest }

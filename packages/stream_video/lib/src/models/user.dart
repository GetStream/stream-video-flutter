import 'models.dart';

class User {
  User({
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
      type: UserType.anonymous,
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

  factory User.anonymous() {
    return User(
      type: UserType.anonymous,
      info: const UserInfo(
        id: '!anon',
      ),
    );
  }

  factory User.guest(
    String userId, {
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

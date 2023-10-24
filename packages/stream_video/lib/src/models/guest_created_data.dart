import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'user_info.dart';

@immutable
class GuestCreatedData with EquatableMixin {
  /// Returns a new [GuestCreatedData] instance.
  GuestCreatedData({
    required this.accessToken,
    required this.duration,
    required this.user,
  });

  /// the access token to authenticate the user
  final String accessToken;

  final String duration;

  final UserResponseData user;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestCreatedData &&
          other.accessToken == accessToken &&
          other.duration == duration &&
          other.user == user;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (accessToken.hashCode) + (duration.hashCode) + (user.hashCode);

  @override
  String toString() =>
      'CreateGuestResponse[accessToken=$accessToken, duration=$duration, user=$user]';

  @override
  List<Object?> get props => [accessToken, duration, user];
}

@immutable
class UserResponseData with EquatableMixin {
  /// Returns a new [UserResponseData] instance.
  const UserResponseData({
    required this.createdAt,
    this.custom = const {},
    this.deletedAt,
    required this.id,
    this.image,
    this.name,
    required this.role,
    this.teams = const [],
    required this.updatedAt,
  });

  /// Date/time of creation
  final DateTime createdAt;

  final Map<String, Object?> custom;

  /// Date/time of deletion
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  final DateTime? deletedAt;

  final String id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  final String? image;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  final String? name;

  final String role;

  final List<String> teams;

  /// Date/time of the last update
  final DateTime updatedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserResponseData &&
          other.createdAt == createdAt &&
          other.custom == custom &&
          other.deletedAt == deletedAt &&
          other.id == id &&
          other.image == image &&
          other.name == name &&
          other.role == role &&
          other.teams == teams &&
          other.updatedAt == updatedAt;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (createdAt.hashCode) +
      (custom.hashCode) +
      (deletedAt == null ? 0 : deletedAt!.hashCode) +
      (id.hashCode) +
      (image == null ? 0 : image!.hashCode) +
      (name == null ? 0 : name!.hashCode) +
      (role.hashCode) +
      (teams.hashCode) +
      (updatedAt.hashCode);

  @override
  String toString() =>
      'UserResponse[createdAt=$createdAt, custom=$custom, deletedAt=$deletedAt, id=$id, image=$image, name=$name, role=$role, teams=$teams, updatedAt=$updatedAt]';

  @override
  List<Object?> get props =>
      [createdAt, custom, deletedAt, id, image, name, role, teams, updatedAt];
}

extension UserResponseDataX on UserResponseData {
  UserInfo toUserInfo() {
    return UserInfo(
      id: id,
      name: name ?? '',
      image: image,
      role: role,
      teams: teams,
      extraData: custom,
    );
  }
}

import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  const UserInfo({
    required this.id,
    required this.role,
    required this.name,
    this.teams,
    this.imageUrl,
    this.extraData,
  });

  final String id;
  final String name;
  final String role;
  final String? imageUrl;
  final Iterable<String>? teams;
  final Map<String, Object?>? extraData;

  factory UserInfo.fromJson(Map<String, Object?> json) {
    return UserInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      imageUrl: json['image'] as String?,
      teams: json['teams'] as Iterable<String>?,
      extraData: json['extra_data'] as Map<String, Object?>?,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'image': imageUrl,
      'teams': teams,
      'extra_data': extraData,
    };
  }

  @override
  String toString() {
    return 'UserInfo{'
        'id: $id, '
        'name: $name, '
        'role: $role, '
        'imageUrl: $imageUrl, '
        'teams: $teams, '
        'extraData: $extraData'
        '}';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        role,
        imageUrl,
        teams,
        extraData,
      ];
}

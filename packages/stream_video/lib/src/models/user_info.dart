import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  const UserInfo({
    required this.id,
    this.role = 'user',
    this.name = '',
    this.image,
    this.teams = const <String>[],
    this.extraData = const <String, Object?>{},
  });

  final String id;
  final String name;
  final String role;
  final String? image;
  final List<String> teams;
  final Map<String, Object?> extraData;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'image': image,
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
        'image: $image, '
        'teams: $teams, '
        'extraData: $extraData'
        '}';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        role,
        image,
        teams,
        extraData,
      ];
}

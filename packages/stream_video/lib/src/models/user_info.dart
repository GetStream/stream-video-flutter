class UserInfo {
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
}

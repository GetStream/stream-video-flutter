enum RtcMediaType {
  audio('audio'),
  video('video'),
  unknown('unknown');

  const RtcMediaType(this.alias);

  factory RtcMediaType.fromAlias(dynamic alias) {
    return RtcMediaType.values.firstWhere(
      (e) => e.alias == alias,
      orElse: () => RtcMediaType.unknown,
    );
  }

  final String alias;

  static const propertyName = 'mediaType';

  @override
  String toString() => alias;
}

enum RtcKind {
  audio('audio'),
  video('video'),
  unknown('unknown');

  const RtcKind(this.alias);

  factory RtcKind.fromAlias(dynamic alias) {
    return RtcKind.values.firstWhere(
      (e) => e.alias == alias,
      orElse: () => RtcKind.unknown,
    );
  }

  final String alias;

  static const propertyName = 'kind';

  @override
  String toString() => alias;
}

enum RtcSource {
  local('local'),
  remote('remote'),
  unknown('unknown');

  const RtcSource(this.alias);

  factory RtcSource.fromValue(bool? isRemoteSource) {
    if (isRemoteSource == null) {
      return unknown;
    } else if (isRemoteSource) {
      return remote;
    } else {
      return local;
    }
  }

  factory RtcSource.fromAlias(dynamic alias) {
    return RtcSource.values.firstWhere(
      (e) => e.alias == alias,
      orElse: () => unknown,
    );
  }

  final String alias;

  static const String propertyName = 'remoteSource';

  @override
  String toString() => alias;
}

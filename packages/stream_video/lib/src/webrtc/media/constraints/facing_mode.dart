/// https://developer.mozilla.org/en-US/docs/Web/API/MediaTrackConstraints/facingMode
enum FacingMode {
  user('user'),
  environment('environment'),
  left('left'),
  right('right');

  const FacingMode(this.alias);

  factory FacingMode.fromAlias(String? alias) {
    return FacingMode.values.firstWhere(
      (it) => it.alias == alias,
      orElse: () => FacingMode.user,
    );
  }

  final String alias;

  FacingMode flip() {
    switch (this) {
      case FacingMode.user:
        return FacingMode.environment;
      case FacingMode.environment:
        return FacingMode.user;
      case FacingMode.left:
        return FacingMode.right;
      case FacingMode.right:
        return FacingMode.left;
    }
  }
}

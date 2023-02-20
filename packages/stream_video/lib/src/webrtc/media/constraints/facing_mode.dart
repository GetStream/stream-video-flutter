/// https://developer.mozilla.org/en-US/docs/Web/API/MediaTrackConstraints/facingMode
enum FacingMode {
  user,
  environment,
  left,
  right;

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

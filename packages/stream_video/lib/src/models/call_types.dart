enum StreamCallType {
  video("video"),
  $default("default"),
  audio("audio");

  const StreamCallType(this.rawType);
  final String rawType;
}

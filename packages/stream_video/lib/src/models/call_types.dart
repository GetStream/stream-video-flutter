enum StreamCallType {
  video("video"),
  audio("audio");

  const StreamCallType(this.rawType);
  final String rawType;
}

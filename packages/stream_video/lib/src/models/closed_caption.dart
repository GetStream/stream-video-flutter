class ClosedCaption {
  final String userId;
  final int start;
  final int end;
  final String text;
  ClosedCaption({
    required this.userId,
    required this.start,
    required this.end,
    required this.text,
  });
  factory ClosedCaption.fromJson(Map<String, dynamic> json) => ClosedCaption(
      userId: json["user_id"],
      start: json["start"],
      end: json["end"],
      text: json["text"]);

  Map<String, dynamic> toJson() =>
      {"user_id": userId, "start": start, "end": end, "text": text};
}

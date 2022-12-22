import 'package:equatable/equatable.dart';

class ClosedCaption with EquatableMixin {
  // final String userId;
  final int startTime;
  final int endTime;
  final String text;
  ClosedCaption({
    // required this.userId,
    required this.startTime,
    required this.endTime,
    required this.text,
  });
  factory ClosedCaption.fromJson(Map<String, dynamic> json) => ClosedCaption(
      // userId: json["user_id"],
      startTime: json["start_time"],
      endTime: json["end_time"],
      text: json["text"]);

  Map<String, dynamic> toJson() => {
        // "user_id": userId,
        "start": startTime, "end": endTime, "text": text
      };

      //to string
  @override
  String toString() {
    return 'ClosedCaption{startTime: $startTime, endTime: $endTime, text: $text}';
  }
  
  @override
  List<Object?> get props => [startTime, endTime, text];
}

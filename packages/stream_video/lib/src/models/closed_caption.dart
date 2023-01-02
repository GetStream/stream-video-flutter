import 'package:equatable/equatable.dart';

class ClosedCaption with EquatableMixin {
  ClosedCaption({
    // required this.index,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.text,
  });

  // final int index;
  final String userId;
  final Time startTime;
  final Time endTime;
  final String text;

  factory ClosedCaption.fromJson(Map<String, dynamic> json) => ClosedCaption(
        // index: json["index"],
        userId: json["user_id"],
        startTime: Time.fromJson(json["start_time"]),
        endTime: Time.fromJson(json["end_time"]),
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        // "index": index,
        "user_id": userId,
        "start_time": startTime.toJson(),
        "end_time": endTime.toJson(),
        "text": text,
      };

  @override
  List<Object?> get props => [userId, startTime, endTime, text];
}

class Time with EquatableMixin, Comparable<Time> {
  Time({
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
    this.milliseconds = 0,
  });

  final int hours;
  final int minutes;
  final int seconds;
  final int milliseconds;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        hours: json["hours"],
        minutes: json["minutes"],
        seconds: json["seconds"],
        milliseconds: json["milliseconds"],
      );

  Map<String, dynamic> toJson() => {
        "hours": hours,
        "minutes": minutes,
        "seconds": seconds,
        "milliseconds": milliseconds,
      };

  @override
  String toString() => "$hours:$minutes:$seconds,$milliseconds";

  @override
  List<Object?> get props => [hours, minutes, seconds, milliseconds];

  @override
  int compareTo(Time other) {
    if (hours != other.hours) {
      return hours.compareTo(other.hours);
    }
    if (minutes != other.minutes) {
      return minutes.compareTo(other.minutes);
    }
    if (seconds != other.seconds) {
      return seconds.compareTo(other.seconds);
    }
    if (milliseconds != other.milliseconds) {
      return milliseconds.compareTo(other.milliseconds);
    }
    return 0;
  }

  //operator <
  bool operator <(Time other) {
    return this.compareTo(other) < 0;
  }
}

class CCKey with EquatableMixin, Comparable<CCKey> {
  CCKey({
    required this.startTime,
    required this.userId,
  });

  final Time startTime;
  final String userId;

  @override
  List<Object?> get props => [startTime, userId];

  @override
  int compareTo(CCKey other) {
    if (startTime != other.startTime) {
      return startTime.compareTo(other.startTime);
    }
    if (userId != other.userId) {
      return userId.compareTo(other.userId);
    }
    return 0;
  }
}

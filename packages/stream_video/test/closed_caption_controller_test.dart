import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/core/rx_controller.dart';
// import 'package:stream_video/src/events.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_video/src/events.dart' show CallEvent;

class ClosedCaptionEvent with CallEvent, EquatableMixin {
  final ClosedCaption closedCaption;

  const ClosedCaptionEvent({
    required this.closedCaption,
  });

  @override
  String toString() => '${runtimeType}(closedCaption: ${closedCaption})';

  @override
  List<Object?> get props => [closedCaption];
}

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
  //format "hh:mm:ss,mmm,"
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

class ClosedCaptionsController
    extends RxController<Map<CCKey, List<ClosedCaptionEvent>>> {
  ClosedCaptionsController() : super(seedValue: const {});

  void add(ClosedCaptionEvent event) {
    final key = CCKey(
        startTime: event.closedCaption.startTime,
        userId: event.closedCaption.userId);

    if (value.isEmpty) {
      value = {
        ...value,
        key: [event]
      };
    } else {
      final foundEntry = value.entries.lastWhere(
        (entry) => entry.key.userId == key.userId,
        orElse: () {
          return MapEntry(key, [event]);
        },
      );
      if (value.keys.last.startTime < foundEntry.key.startTime) {
        value = {...value, foundEntry.key: foundEntry.value};
      } else {
        if (foundEntry.key == value.keys.last) {
          value = {...value, foundEntry.key: foundEntry.value..add(event)};
        } else {
          value = {
            ...value,
            key: [event]
          };
        }
      }
    }
  }
}

void main() {
  test('stream test', () async {
    final controller = ClosedCaptionsController();
    final cc1 = ClosedCaptionEvent(
        closedCaption: ClosedCaption(
            userId: "sacha@getstream.io",
            startTime: Time(),
            endTime: Time(seconds: 3),
            text: "I've seen things you people wouldn't believe."));

    final cc2 = ClosedCaptionEvent(
        closedCaption: ClosedCaption(
            userId: "sacha@getstream.io",
            startTime: Time(seconds: 3, milliseconds: 500),
            endTime: Time(seconds: 6),
            text: "Attack ships on fire off the shoulder of Orion."));

    final cc3 = ClosedCaptionEvent(
        closedCaption: ClosedCaption(
            startTime: Time(seconds: 6, milliseconds: 500),
            endTime: Time(seconds: 10),
            text:
                "I watched C-beams glitter in the dark near the Tannhäuser Gate.",
            userId: "sahil@getstream.io"));
    final cc4 = ClosedCaptionEvent(
        closedCaption: ClosedCaption(
            userId: "sacha@getstream.io",
            startTime: Time(seconds: 10, milliseconds: 500),
            endTime: Time(seconds: 14),
            text:
                "All those moments will be lost in time, like tears in rain."));

    controller.add(cc1);
    controller.add(cc2);
    controller.add(cc3);
    controller.add(cc4);

    await expectLater(
        controller.stream,
        emits({
          CCKey(
              startTime: cc1.closedCaption.startTime,
              userId: cc1.closedCaption.userId): [cc1, cc2],
          CCKey(
              startTime: cc3.closedCaption.startTime,
              userId: cc3.closedCaption.userId): [cc3],
          CCKey(
              startTime: cc4.closedCaption.startTime,
              userId: cc4.closedCaption.userId): [cc4]
        }));
  });
}

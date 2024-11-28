import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../stream_video.dart';

@immutable
class StreamClosedCaption with EquatableMixin {
  StreamClosedCaption({
    required this.startTime,
    required this.endTime,
    required this.speakerId,
    required this.text,
    required this.user,
  });

  factory StreamClosedCaption.fromEvent(StreamCallClosedCaptionsEvent event) =>
      StreamClosedCaption(
        startTime: event.startTime,
        endTime: event.endTime,
        speakerId: event.speakerId,
        text: event.text,
        user: event.user,
      );

  final DateTime startTime;
  final DateTime endTime;
  final String speakerId;
  final String text;
  final CallUser user;

  @override
  List<Object?> get props => [startTime, endTime, speakerId, text, user];

  @override
  String toString() {
    return 'CallClosedCaption{startTime: $startTime, endTime: $endTime, speakerId: $speakerId, text: $text}';
  }
}

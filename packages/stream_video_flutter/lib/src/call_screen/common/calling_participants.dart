import 'package:flutter/material.dart';

import '../../../stream_video_flutter.dart';

/// Displays call participants as a string.
class CallingParticipants extends StatelessWidget {
  /// Creates a new instance of [CallingParticipants].
  const CallingParticipants({
    super.key,
    required this.participants,
    this.singleParticipantTextStyle = const TextStyle(
      fontSize: 28,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    this.multipleParticipantTextStyle = const TextStyle(
      fontSize: 20,
      color: Colors.white,
    ),
  });

  /// The list of participants in the call.
  final List<UserInfo> participants;

  /// Text style for the participant label in a call with one participant.
  final TextStyle singleParticipantTextStyle;

  /// Text style for the participant label in a call with multiple participants.
  final TextStyle multipleParticipantTextStyle;

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle;
    if (participants.length > 1) {
      textStyle = multipleParticipantTextStyle;
    } else {
      textStyle = singleParticipantTextStyle;
    }

    return Center(
      child: Text(
        _buildParticipantsText(),
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  String _buildParticipantsText() {
    final length = participants.length;

    if (participants.isEmpty) {
      return 'No participants';
    } else if (length == 1) {
      return participants[0].name;
    } else if (length == 2) {
      return '${participants[0].name} and ${participants[1].name}';
    } else if (length == 3) {
      return '${participants[0].name}, ${participants[1].name} and ${participants[2].name}';
    } else {
      final remaining = length - 2;
      return '${participants[0].name}, ${participants[1].name} and +$remaining more';
    }
  }
}

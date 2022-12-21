import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

class NoVideoWidget extends StatelessWidget {
  const NoVideoWidget({
    Key? key,
    required this.participant,
  }) : super(key: key);

  final Participant participant;

  @override
  Widget build(BuildContext context) {
    final String name = participant.userId;
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) => CircleAvatar(
          radius: math.min(constraints.maxHeight, constraints.maxWidth) * 0.15,
          child: Text(
            name[0].toUpperCase(),
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
    );
  }
}

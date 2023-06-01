import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

Future<void> showLoadingIndicator(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SimpleDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        children: <Widget>[
          Center(
            child: CircularProgressIndicator(
              color: StreamVideoTheme.of(context).colorTheme.accentPrimary,
            ),
          )
        ],
      );
    },
  );
}

Future<void> hideLoadingIndicator(BuildContext context) async {
  Navigator.of(context).pop();
}

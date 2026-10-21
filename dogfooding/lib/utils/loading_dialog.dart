// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'dialog_anchor.dart';

Future<void> showLoadingIndicator(BuildContext context) async {
  return showDialog<void>(
    context: context,
    anchorPoint: trailingTopAnchor(context),
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
          ),
        ],
      );
    },
  );
}

void hideLoadingIndicator(BuildContext context) => context.pop();

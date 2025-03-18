import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

import '../theme/stream_video_theme.dart';
import 'screen_share_logger.dart';

typedef OnThumbnailTapped = void Function(DesktopCapturerSource);

class ScreenShareThumbnailWidget extends StatefulWidget {
  const ScreenShareThumbnailWidget({
    super.key,
    required this.source,
    required this.selected,
    required this.onTap,
  });
  final DesktopCapturerSource source;
  final bool selected;
  final OnThumbnailTapped onTap;

  @override
  State<ScreenShareThumbnailWidget> createState() =>
      _ScreenShareThumbnailWidgetState();
}

class _ScreenShareThumbnailWidgetState
    extends State<ScreenShareThumbnailWidget> {
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  Uint8List? _thumbnail;
  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant ScreenShareThumbnailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.source.id != oldWidget.source.id) {
      _unsubscribe();
      _subscribe();
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _subscriptions.add(
      widget.source.onThumbnailChanged.stream.listen((event) {
        setState(() {
          _thumbnail = event;
        });
      }),
    );
    _subscriptions.add(
      widget.source.onNameChanged.stream.listen((event) {
        setState(() {});
      }),
    );
  }

  void _unsubscribe() {
    for (final element in _subscriptions) {
      element.cancel();
    }
    _subscriptions.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: widget.selected
                ? BoxDecoration(
                    border: Border.all(width: 2, color: Colors.blueAccent),
                  )
                : const BoxDecoration(),
            child: InkWell(
              onTap: () {
                screenShareLogger
                    .d(() => 'Selected source id => ${widget.source.id}');
                widget.onTap(widget.source);
              },
              child: _thumbnail != null
                  ? Image.memory(
                      _thumbnail!,
                      gaplessPlayback: true,
                    )
                  : Container(),
            ),
          ),
        ),
        Text(
          widget.source.name,
          style: widget.selected ? textTheme.bodyBold : textTheme.body,
        ),
      ],
    );
  }
}

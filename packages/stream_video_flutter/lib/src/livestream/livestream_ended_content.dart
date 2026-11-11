import 'dart:async';

import 'package:flutter/material.dart';
import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';
import 'livestream_status_card.dart';

class LivestreamEndedContent extends StatefulWidget {
  const LivestreamEndedContent({
    super.key,
    required this.call,
    this.showRecordings = true,
    this.onRecordingTapped,
  });

  final Call call;
  final bool showRecordings;
  final FutureOr<void> Function(String)? onRecordingTapped;

  @override
  State<LivestreamEndedContent> createState() => _LivestreamEndedContentState();
}

class _LivestreamEndedContentState extends State<LivestreamEndedContent> {
  // Fetched once rather than on every rebuild.
  late final _recordings = widget.call.listRecordings();

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;

    return LivestreamStatusCard(
      title: translations.livestreamEndedTitle,
      subtitle: translations.livestreamEndedSubtitle,
      children: [
        if (widget.showRecordings)
          FutureBuilder(
            future: _recordings,
            builder: (context, snapshot) {
              final recordings = snapshot.data?.getDataOrNull();
              if (recordings == null || recordings.isEmpty) {
                return const SizedBox.shrink();
              }

              return _Recordings(
                urls: [for (final recording in recordings) recording.url],
                onRecordingTapped: widget.onRecordingTapped,
              );
            },
          ),
      ],
    );
  }
}

class _Recordings extends StatelessWidget {
  const _Recordings({required this.urls, required this.onRecordingTapped});

  final List<String> urls;
  final FutureOr<void> Function(String)? onRecordingTapped;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    return Padding(
      padding: EdgeInsets.only(top: spacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: spacing.xxs,
        children: [
          Text(
            context.translations.livestreamEndedWatchRecordings,
            style: textTheme.captionDefault.copyWith(
              color: colorScheme.textSecondary,
            ),
          ),
          for (final url in urls)
            StreamButton(
              type: StreamButtonType.ghost,
              size: StreamButtonSize.small,
              onPressed: onRecordingTapped == null
                  ? null
                  : () => onRecordingTapped!(url),
              child: Text(url, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
        ],
      ),
    );
  }
}

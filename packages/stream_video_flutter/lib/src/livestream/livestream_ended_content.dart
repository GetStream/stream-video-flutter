import 'dart:async';

import 'package:flutter/material.dart';
import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';
import 'livestream_status_card.dart';

/// The livestream tile's ended state: a status card, with the call's
/// recordings below it when [showRecordings] is true.
class LivestreamEndedContent extends StatefulWidget {
  /// Creates a [LivestreamEndedContent].
  const LivestreamEndedContent({
    super.key,
    required this.call,
    this.showRecordings = true,
    this.onRecordingTapped,
  });

  /// The livestream that ended.
  final Call call;

  /// Whether the call's recordings are listed.
  ///
  /// Defaults to true.
  final bool showRecordings;

  /// Called with a recording's URL when it is tapped.
  final FutureOr<void> Function(String)? onRecordingTapped;

  @override
  State<LivestreamEndedContent> createState() => _LivestreamEndedContentState();
}

class _LivestreamEndedContentState extends State<LivestreamEndedContent> {
  static final _logger = taggedLogger(tag: 'SV:LivestreamEnded');

  late var _recordings = _fetchRecordings();

  void _retry() => setState(() => _recordings = _fetchRecordings());

  /// Lists the call's recordings, logging a failure once per fetch.
  Future<Result<List<CallRecording>>> _fetchRecordings() {
    return widget.call.listRecordings().then((result) {
      if (result case Failure(:final error)) {
        _logger.w(() => '[recordings] failed: $error');
      }
      return result;
    });
  }

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
              if (snapshot.data is Failure) {
                return _RecordingsFailed(onRetry: _retry);
              }

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

class _RecordingsFailed extends StatelessWidget {
  const _RecordingsFailed({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final translations = context.translations;

    return Padding(
      padding: EdgeInsets.only(top: spacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: spacing.xxs,
        children: [
          Text(
            translations.recordingsErrorTitle,
            style: context.streamTextTheme.captionDefault.copyWith(
              color: context.streamColorScheme.textSecondary,
            ),
          ),
          StreamButton(
            type: StreamButtonType.ghost,
            size: StreamButtonSize.small,
            onPressed: onRetry,
            child: Text(translations.recordingsRetry),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

/// The recordings tab of a [StreamModalWindow]: the call's recordings, to
/// download, under the label "Recordings".
class StreamRecordingsSettingsTab extends StreamModalWindowTab {
  /// Creates the recordings tab.
  ///
  /// [icon] and [label] replace the default icon and "Recordings".
  StreamRecordingsSettingsTab({
    required Call call,
    required ValueChanged<CallRecording> onDownload,
    Widget? icon,
    Widget? label,
  }) : super(
         icon: icon ?? const _RecordingsTabIcon(),
         label: label ?? const _RecordingsTabLabel(),
         builder: (context) =>
             StreamRecordingsSettings(call: call, onDownload: onDownload),
       );
}

class _RecordingsTabIcon extends StatelessWidget {
  const _RecordingsTabIcon();

  @override
  Widget build(BuildContext context) =>
      Icon(context.streamIcons.recordLibraryFill);
}

class _RecordingsTabLabel extends StatelessWidget {
  const _RecordingsTabLabel();

  @override
  Widget build(BuildContext context) =>
      Text(context.translations.settingsRecordingsTab);
}

/// The call's recordings, kept up to date: a [StreamCallRecordingList] that
/// loads them when it opens, waits while a stopped recording is processed and
/// adds it once it is ready.
///
/// The content of [StreamRecordingsSettingsTab], and usable on its own.
class StreamRecordingsSettings extends StatefulWidget {
  /// Creates the recordings settings.
  const StreamRecordingsSettings({
    super.key,
    required this.call,
    required this.onDownload,
  });

  /// The call whose recordings are listed.
  final Call call;

  /// Called with the recording whose download button is pressed.
  final ValueChanged<CallRecording> onDownload;

  @override
  State<StreamRecordingsSettings> createState() =>
      _StreamRecordingsSettingsState();
}

class _StreamRecordingsSettingsState extends State<StreamRecordingsSettings> {
  static final _logger = taggedLogger(tag: 'SV:RecordingsSettings');

  List<CallRecording> _recordings = const [];
  bool _loading = true;
  bool _failed = false;
  StreamSubscription<StreamCallEvent>? _events;

  @override
  void initState() {
    super.initState();
    _events = widget.call.callEvents.listen(_onEvent);
    unawaited(_load());
  }

  @override
  void dispose() {
    _events?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    final result = await widget.call.listRecordings();
    if (!mounted) return;
    switch (result) {
      case Success(:final data):
        setState(() {
          _recordings = data;
          _loading = false;
        });
      case Failure(:final error):
        _logger.e(() => 'Could not list the recordings: $error');
        setState(() {
          _loading = false;
          _failed = true;
        });
    }
  }

  void _onEvent(StreamCallEvent event) {
    switch (event) {
      // A stopped recording takes a while to process before it can be listed.
      case StreamCallRecordingStoppedEvent():
        setState(() => _loading = true);
      // Listed again rather than added, so a recording is never shown twice.
      case StreamCallRecordingReadyEvent():
        unawaited(_load());
      case StreamCallRecordingFailedEvent():
        setState(() => _loading = false);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamCallRecordingList(
      recordings: _recordings,
      loading: _loading,
      onDownload: widget.onDownload,
      onRetry: _failed ? _load : null,
    );
  }
}

/// A table of recordings, newest first, each with a download button.
///
/// Shows an empty state when there are none, a spinner while [loading], and
/// an error with a button to try again where [onRetry] is set.
/// Each recording is named by its place in the call, the first being
/// "Recording #1".
class StreamCallRecordingList extends StatelessWidget {
  /// Creates a recording list.
  const StreamCallRecordingList({
    super.key,
    required this.recordings,
    this.loading = false,
    required this.onDownload,
    this.onRetry,
  });

  /// The recordings, in any order.
  final List<CallRecording> recordings;

  /// Whether recordings are being listed or processed.
  final bool loading;

  /// Called with the recording whose download button is pressed.
  final ValueChanged<CallRecording> onDownload;

  /// Lists the recordings again. Set when listing them failed, which shows
  /// an error in place of the empty state.
  final VoidCallback? onRetry;

  // The width the design gives each column.
  static const double _columnWidth = 120;

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;
    final spacing = context.streamSpacing;

    if (recordings.isEmpty) {
      if (loading) return const _Loading();
      if (onRetry case final onRetry?) {
        return StreamEmptyState(
          icon: Icon(context.streamIcons.exclamationCircleFill),
          title: Text(translations.recordingsErrorTitle),
          description: Text(translations.recordingsErrorDescription),
          action: StreamButton(
            style: StreamButtonStyle.secondary,
            type: StreamButtonType.outline,
            onPressed: onRetry,
            child: Text(translations.recordingsRetry),
          ),
        );
      }
      return StreamEmptyState(
        icon: Icon(context.streamIcons.recordLibraryFill),
        title: Text(translations.recordingsEmptyTitle),
        description: Text(translations.recordingsEmptyDescription),
      );
    }

    final oldestFirst = [...recordings]
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    // Falls back to the default locale where the app hasn't loaded date data
    // for its own.
    final locale = Localizations.localeOf(context).toLanguageTag();
    final time = DateFormat.Hms(
      DateFormat.localeExists(locale) ? locale : null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Header(),
        for (final (index, recording) in oldestFirst.indexed.toList().reversed)
          _Row(
            name: translations.recordingsRecordingName(index + 1),
            start: time.format(recording.startTime.toLocal()),
            end: time.format(recording.endTime.toLocal()),
            filename: recording.filename,
            onDownload: () => onDownload(recording),
          ),
        if (loading)
          Padding(
            padding: EdgeInsets.only(top: spacing.md),
            child: const _Loading(),
          ),
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => Center(child: StreamLoadingSpinner());
}

/// A column of the table: as wide as the design's, or narrower when the
/// table has less room.
class _Column extends StatelessWidget {
  const _Column({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Flexible(
    child: SizedBox(width: StreamCallRecordingList._columnWidth, child: child),
  );
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;
    final spacing = context.streamSpacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.streamColorScheme.backgroundSurfaceCard,
        borderRadius: BorderRadius.all(context.streamRadius.lg),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.sm),
        child: DefaultTextStyle.merge(
          style: context.streamTextTheme.metadataEmphasis.copyWith(
            color: context.streamColorScheme.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: Row(
            spacing: spacing.xs,
            children: [
              for (final title in [
                translations.recordingsName,
                translations.recordingsStartTime,
                translations.recordingsEndTime,
              ])
                _Column(child: Text(title)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.name,
    required this.start,
    required this.end,
    required this.filename,
    required this.onDownload,
  });

  final String name;
  final String start;
  final String end;
  final String filename;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return Padding(
      padding: EdgeInsets.all(spacing.sm),
      child: Row(
        children: [
          Expanded(
            child: DefaultTextStyle.merge(
              style: context.streamTextTheme.captionDefault.copyWith(
                color: context.streamColorScheme.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: Tooltip(
                message: filename,
                child: Row(
                  spacing: spacing.xs,
                  children: [
                    for (final value in [name, start, end])
                      _Column(child: Text(value)),
                  ],
                ),
              ),
            ),
          ),
          _DownloadButton(onPressed: onDownload),
        ],
      ),
    );
  }
}

/// The design's 24px download button. Core's buttons start at 32px, which
/// would make a row taller than the design's 48.
class _DownloadButton extends StatelessWidget {
  const _DownloadButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = context.translations.recordingsDownload;

    return Tooltip(
      message: label,
      excludeFromSemantics: true,
      child: Semantics(
        label: label,
        button: true,
        child: Material(
          type: MaterialType.transparency,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox.square(
              dimension: 24,
              child: Icon(
                context.streamIcons.download,
                size: 16,
                color: context.streamColorScheme.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

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
  Future<Result<List<CallRecording>>>? _recordings;

  @override
  void initState() {
    super.initState();
    _fetchRecordingsIfShown();
  }

  @override
  void didUpdateWidget(LivestreamEndedContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.call != oldWidget.call) _recordings = null;
    _fetchRecordingsIfShown();
  }

  /// Lists the call's recordings when they are shown and not fetched yet.
  void _fetchRecordingsIfShown() {
    if (!widget.showRecordings) return;
    _recordings ??= widget.call.listRecordings();
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final liveTheme = theme.livestreamTheme;
    final translations = context.translations;

    return Scaffold(
      backgroundColor: theme.colorTheme.livestreamBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              translations.livestreamEndedStatus,
              style: liveTheme.liveEndedTextStyle,
            ),
            if (widget.showRecordings)
              FutureBuilder(
                future: _recordings,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isSuccess) {
                    final recordings = snapshot.requireData.getDataOrNull();

                    if (recordings == null || recordings.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        Text(translations.livestreamEndedWatchRecordings),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: recordings.length,
                          itemBuilder: (context, index) {
                            final recording = recordings[index];
                            return ListTile(
                              title: Text(
                                recording.url,
                                style: liveTheme.liveEndedRecordingsTextStyle,
                              ),
                              onTap: () {
                                widget.onRecordingTapped?.call(recording.url);
                              },
                            );
                          },
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import '../../stream_video_flutter.dart';
import '../l10n/localization_extension.dart';

class LivestreamEndedContent extends StatefulWidget {
  const LivestreamEndedContent({
    super.key,
    required this.call,
    this.onRecordingTapped,
  });

  final Call call;
  final FutureOr<void> Function(String)? onRecordingTapped;

  @override
  State<LivestreamEndedContent> createState() => _LivestreamEndedContentState();
}

class _LivestreamEndedContentState extends State<LivestreamEndedContent> {
  @override
  Widget build(BuildContext context) {
    final theme = StreamVideoTheme.of(context);
    final translations = context.translations;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              translations.livestreamEndedStatus,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            FutureBuilder(
              future: widget.call.listRecordings(),
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
                              style: TextStyle(
                                color: theme.colorTheme.textLowEmphasis,
                              ),
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

import 'package:flutter/foundation.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// The settings window's recordings tab: the call's recordings, downloaded by
/// opening them in the browser.
StreamRecordingsSettingsTab recordingsTab({required Call call}) =>
    StreamRecordingsSettingsTab(call: call, onDownload: _download);

Future<void> _download(CallRecording recording) async {
  try {
    // The browser downloads the file, or offers to.
    final opened = await launchUrl(
      Uri.parse(recording.url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened) debugPrint('Could not open ${recording.filename}');
  } catch (e) {
    debugPrint('Could not open ${recording.filename}: $e');
  }
}

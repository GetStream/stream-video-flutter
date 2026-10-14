import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/goldens.dart';
import '../../test_utils/test_wrapper.dart';

/// A recording made from [start] to [end], given as UTC times of day.
CallRecording _recording(String id, String start, String end) {
  DateTime at(String time) => DateTime.parse('2026-10-14T${time}Z');
  return CallRecording(
    endTime: at(end),
    filename: '$id.mp4',
    recordingType: 'composite',
    sessionId: 'session',
    startTime: at(start),
    url: 'https://example.com/$id.mp4',
  );
}

final _recordings = [
  _recording('second', '10:15:00', '10:45:22'),
  _recording('first', '10:00:01', '10:12:58'),
  _recording('third', '11:03:04', '11:33:16'),
];

void main() {
  /// The time of day [utc] shows as, in the zone the tests run in.
  String local(String utc) {
    final time = DateTime.parse('2026-10-14T${utc}Z').toLocal();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(time.hour)}:${two(time.minute)}:${two(time.second)}';
  }

  Future<void> pump(
    WidgetTester tester, {
    List<CallRecording> recordings = const [],
    bool loading = false,
    ValueChanged<CallRecording>? onDownload,
    TextDirection textDirection = TextDirection.ltr,
  }) async {
    tester.view.physicalSize = const Size(520, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      TestWrapper(
        child: Directionality(
          textDirection: textDirection,
          child: SingleChildScrollView(
            child: StreamCallRecordingList(
              recordings: recordings,
              loading: loading,
              onDownload: onDownload ?? (_) {},
            ),
          ),
        ),
      ),
    );
    // Not pumpAndSettle: the spinner never settles.
    await tester.pump();
  }

  group('StreamCallRecordingList', () {
    testWidgets('lists the recordings newest first, numbered from the first', (
      tester,
    ) async {
      await pump(tester, recordings: _recordings);

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Start Time'), findsOneWidget);
      expect(find.text('End Time'), findsOneWidget);

      double top(String text) => tester.getTopLeft(find.text(text)).dy;
      expect(top('Recording #3'), lessThan(top('Recording #2')));
      expect(top('Recording #2'), lessThan(top('Recording #1')));
    });

    testWidgets('shows when each recording started and ended', (tester) async {
      await pump(tester, recordings: [_recordings.first]);

      expect(find.text(local('10:15:00')), findsOneWidget);
      expect(find.text(local('10:45:22')), findsOneWidget);
    });

    testWidgets('the download button reports its recording', (tester) async {
      final downloaded = <CallRecording>[];
      await pump(
        tester,
        recordings: _recordings,
        onDownload: downloaded.add,
      );

      final firstRow = find.ancestor(
        of: find.text('Recording #1'),
        matching: find.byType(Row),
      );
      await tester.tap(
        find.descendant(
          of: firstRow.last,
          matching: find.byIcon(const StreamIcons().download),
        ),
      );

      expect(downloaded.map((it) => it.filename), ['first.mp4']);
    });

    testWidgets('without recordings, says there are none', (tester) async {
      await pump(tester);

      expect(find.byType(StreamEmptyState), findsOneWidget);
      expect(find.text('No Recordings Available'), findsOneWidget);
      expect(find.text('Name'), findsNothing);
    });

    testWidgets('while the first recordings load, shows only a spinner', (
      tester,
    ) async {
      await pump(tester, loading: true);

      expect(find.byType(StreamLoadingSpinner), findsOneWidget);
      expect(find.byType(StreamEmptyState), findsNothing);
    });

    testWidgets('while another recording loads, adds a spinner below', (
      tester,
    ) async {
      await pump(tester, recordings: _recordings, loading: true);

      expect(find.text('Recording #1'), findsOneWidget);
      expect(
        tester.getTopLeft(find.byType(StreamLoadingSpinner)).dy,
        greaterThan(tester.getTopLeft(find.text('Recording #1')).dy),
      );
    });

    testWidgets('right to left, the download buttons are at the left edge', (
      tester,
    ) async {
      await pump(
        tester,
        recordings: [_recordings.first],
        textDirection: TextDirection.rtl,
      );

      expect(
        tester.getCenter(find.byIcon(const StreamIcons().download)).dx,
        lessThan(tester.getCenter(find.text('Recording #1')).dx),
      );
    });

    testWidgets('fits a narrow window', (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        TestWrapper(
          child: SizedBox(
            width: 320,
            child: StreamCallRecordingList(
              recordings: _recordings,
              onDownload: (_) {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('StreamEmptyState', () {
    testWidgets('draws the icon, title and description', (tester) async {
      await tester.pumpWidget(
        const TestWrapper(
          child: StreamEmptyState(
            icon: Icon(Icons.inbox),
            title: Text('Nothing here'),
            description: Text('Things show up here.'),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('Things show up here.'), findsOneWidget);
    });
  });

  group('goldens', () {
    for (final brightness in Brightness.values) {
      streamGoldenTest(
        'StreamCallRecordingList renders the table',
        fileName: 'stream_call_recording_list',
        brightness: brightness,
        constraints: const BoxConstraints.tightFor(width: 520, height: 260),
        builder: () => Padding(
          padding: const EdgeInsets.all(24),
          child: StreamCallRecordingList(
            recordings: _recordings,
            onDownload: (_) {},
          ),
        ),
      );

      streamGoldenTest(
        'StreamCallRecordingList says when there are no recordings',
        fileName: 'stream_call_recording_list_empty',
        brightness: brightness,
        constraints: const BoxConstraints.tightFor(width: 520, height: 260),
        builder: () => Padding(
          padding: const EdgeInsets.all(24),
          child: StreamCallRecordingList(
            recordings: const [],
            onDownload: (_) {},
          ),
        ),
      );
    }
  });
}

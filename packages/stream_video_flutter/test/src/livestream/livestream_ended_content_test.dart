import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

void main() {
  late MockCall call;

  setUp(() {
    call = MockCall();
    when(
      call.listRecordings,
    ).thenAnswer((_) async => const Result.success(<CallRecording>[]));
  });

  Widget endedContent({required bool showRecordings}) {
    return MaterialApp(
      home: LivestreamEndedContent(
        call: call,
        showRecordings: showRecordings,
      ),
    );
  }

  testWidgets('lists the recordings once across rebuilds', (tester) async {
    await tester.pumpWidget(endedContent(showRecordings: true));
    await tester.pump();

    // Same element, new widget: a rebuild of the ended view.
    await tester.pumpWidget(endedContent(showRecordings: true));
    await tester.pump();

    verify(call.listRecordings).called(1);
  });

  testWidgets('does not list the recordings when they are hidden', (
    tester,
  ) async {
    await tester.pumpWidget(endedContent(showRecordings: false));
    await tester.pump();

    verifyNever(call.listRecordings);
  });
}

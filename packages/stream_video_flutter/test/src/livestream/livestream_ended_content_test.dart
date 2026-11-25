import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

MockCall _callWithNoRecordings() {
  final call = MockCall();
  when(
    call.listRecordings,
  ).thenAnswer((_) async => const Result.success(<CallRecording>[]));
  return call;
}

Widget _endedContent(Call call, {required bool showRecordings}) {
  return MaterialApp(
    home: LivestreamEndedContent(call: call, showRecordings: showRecordings),
  );
}

void main() {
  late MockCall call;

  setUp(() => call = _callWithNoRecordings());

  testWidgets('lists the recordings once across rebuilds', (tester) async {
    await tester.pumpWidget(_endedContent(call, showRecordings: true));
    await tester.pump();

    // Same element, new widget: a rebuild of the ended view.
    await tester.pumpWidget(_endedContent(call, showRecordings: true));
    await tester.pump();

    verify(call.listRecordings).called(1);
  });

  testWidgets('does not list the recordings when they are hidden', (
    tester,
  ) async {
    await tester.pumpWidget(_endedContent(call, showRecordings: false));
    await tester.pump();

    verifyNever(call.listRecordings);
  });

  testWidgets('lists the recordings when they are turned on', (tester) async {
    await tester.pumpWidget(_endedContent(call, showRecordings: false));
    await tester.pump();

    await tester.pumpWidget(_endedContent(call, showRecordings: true));
    await tester.pump();

    verify(call.listRecordings).called(1);
  });

  testWidgets('lists the recordings of a new call', (tester) async {
    final otherCall = _callWithNoRecordings();

    await tester.pumpWidget(_endedContent(call, showRecordings: true));
    await tester.pump();

    await tester.pumpWidget(_endedContent(otherCall, showRecordings: true));
    await tester.pump();

    verify(call.listRecordings).called(1);
    verify(otherCall.listRecordings).called(1);
  });
}

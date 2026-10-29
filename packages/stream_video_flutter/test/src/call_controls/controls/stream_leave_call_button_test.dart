import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

void main() {
  const icons = StreamIcons();

  late MockCall call;

  setUp(() {
    call = MockCall();
    when(
      () => call.leave(reason: any(named: 'reason')),
    ).thenAnswer((_) async => const Result.success(none));
  });

  setUpAll(() => registerFallbackValue(const DisconnectReason.left()));

  // The one leave in the SDK a person makes, so the one that reports `user`.
  testWidgets('leaves the call as the user', (tester) async {
    await tester.pumpWidget(
      TestWrapper(child: StreamLeaveCallButton(call: call)),
    );

    await tester.tap(find.byIcon(icons.phoneDownFill));
    await tester.pump();

    verify(
      () => call.leave(
        reason: const DisconnectReason.left(initiator: LeaveInitiator.user),
      ),
    ).called(1);
  });

  testWidgets('leaves nothing when the app handles the tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      TestWrapper(
        child: StreamLeaveCallButton(
          call: call,
          onLeaveCallTap: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.byIcon(icons.phoneDownFill));
    await tester.pump();

    expect(tapped, isTrue);
    verifyNever(() => call.leave(reason: any(named: 'reason')));
  });
}

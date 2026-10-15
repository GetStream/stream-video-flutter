import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../../../test_helpers.dart';

void main() {
  late CallStateNotifier stateNotifier;
  late DynascaleManager dynascale;

  setUpAll(() {
    registerFallbackValue(sfu.UpdateSubscriptionsRequest());
  });

  setUp(() {
    stateNotifier = CallStateNotifier(
      CallState(
        callCid: StreamCallCid.from(
          type: StreamCallType.defaultType(),
          id: 'test-call',
        ),
        currentUserId: 'local-user',
        preferences: DefaultCallPreferences(),
      ),
    );
    dynascale = DynascaleManager(stateManager: stateNotifier);
  });

  tearDown(() async {
    await dynascale.dispose();
    stateNotifier.dispose();
  });

  test(
    'incoming video overrides set before joining are kept, not sent',
    () async {
      dynascale.setVideoTrackSubscriptionOverrides(
        override: VideoTrackSubscriptionOverride(enabled: false),
      );

      final result = await dynascale.applyTrackSubscriptions();

      expect(result, isA<Success<None>>());
      expect(dynascale.incomingVideoSettings?.enabled, isFalse);
    },
  );

  test('once joined, the overrides are sent to the SFU', () async {
    final sfuClient = MockSfuClient();
    when(() => sfuClient.updateSubscriptions(any())).thenAnswer(
      (_) async => Result.success(sfu.UpdateSubscriptionsResponse()),
    );
    dynascale.init(sfuClient: sfuClient, sessionId: 'session-1');

    await dynascale.applyTrackSubscriptions();

    verify(() => sfuClient.updateSubscriptions(any())).called(1);
  });
}

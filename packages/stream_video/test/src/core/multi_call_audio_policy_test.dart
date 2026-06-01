// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../test_helpers.dart';

/// Tests for [MultiCallAudioPolicy] — the SDK-side audio handoff behavior
/// when `allowMultipleActiveCalls` is enabled.
void main() {
  late User user;
  late String userToken;
  late MockCall mockCall1;
  late MockCall mockCall2;
  late MockCall mockCall3;

  void stubSuspendResume(MockCall call) {
    when(call.suspendAudio).thenAnswer((_) async {});
    when(call.resumeAudio).thenAnswer((_) async {});
    when(call.ensureNativeFactory).thenAnswer(
      (_) async => null as rtc.NativePeerConnectionFactory?,
    );
  }

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    user = User.regular(userId: 'test-user', name: 'Test User');
    userToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiSm9obiBEb2UifQ.hrrtiYCtfs2cowE2sx2dypxoXhsEE8pQl-V6Nq4i8qU';

    mockCall1 = MockCall();
    mockCall2 = MockCall();
    mockCall3 = MockCall();

    for (final (i, call) in [mockCall1, mockCall2, mockCall3].indexed) {
      when(() => call.callCid).thenReturn(
        StreamCallCid.from(
          id: 'call${i + 1}',
          type: StreamCallType.defaultType(),
        ),
      );
      when(
        () => call.leave(reason: any(named: 'reason')),
      ).thenAnswer((_) async => const Result.success(none));
      stubSuspendResume(call);
    }
  });

  tearDown(StreamVideo.reset);

  StreamVideo buildClient(MultiCallAudioPolicy policy) {
    return StreamVideo.create(
      'test-api-key',
      user: user,
      userToken: userToken,
      options: StreamVideoOptions(
        allowMultipleActiveCalls: true,
        multiCallAudioPolicy: policy,
        autoConnect: false,
      ),
    );
  }

  group('default policy is suspendExisting', () {
    test('StreamVideoOptions defaults multiCallAudioPolicy', () {
      final options = StreamVideoOptions(allowMultipleActiveCalls: true);
      expect(
        options.multiCallAudioPolicy,
        MultiCallAudioPolicy.suspendExisting,
      );
    });
  });

  group('MultiCallAudioPolicy.suspendExisting', () {
    late StreamVideo client;

    setUp(() {
      client = buildClient(MultiCallAudioPolicy.suspendExisting);
    });

    test(
      'setActiveCall on second call suspends the previously-active call',
      () async {
        await client.state.setActiveCall(mockCall1);
        await client.state.setActiveCall(mockCall2);

        verify(mockCall1.suspendAudio).called(1);
        verifyNever(mockCall2.suspendAudio);
      },
    );

    test(
      'setActiveCall on third call suspends both prior calls',
      () async {
        await client.state.setActiveCall(mockCall1);
        await client.state.setActiveCall(mockCall2);
        clearInteractions(mockCall1);
        clearInteractions(mockCall2);

        await client.state.setActiveCall(mockCall3);

        verify(mockCall1.suspendAudio).called(1);
        verify(mockCall2.suspendAudio).called(1);
        verifyNever(mockCall3.suspendAudio);
      },
    );

    test(
      'removeActiveCall resumes the most-recently-added remaining call',
      () async {
        await client.state.setActiveCall(mockCall1);
        await client.state.setActiveCall(mockCall2);
        await client.state.setActiveCall(mockCall3);
        clearInteractions(mockCall1);
        clearInteractions(mockCall2);

        await client.state.removeActiveCall(mockCall3);

        verify(mockCall2.resumeAudio).called(1);
        verifyNever(mockCall1.resumeAudio);
      },
    );

    test(
      'removeActiveCall on the last remaining call does not call resumeAudio',
      () async {
        await client.state.setActiveCall(mockCall1);
        clearInteractions(mockCall1);

        await client.state.removeActiveCall(mockCall1);

        verifyNever(mockCall1.resumeAudio);
      },
    );
  });

  group('MultiCallAudioPolicy.suspendIncoming', () {
    late StreamVideo client;

    setUp(() {
      client = buildClient(MultiCallAudioPolicy.suspendIncoming);
    });

    test('first setActiveCall does not suspend anything', () async {
      await client.state.setActiveCall(mockCall1);

      verifyNever(mockCall1.suspendAudio);
    });

    test(
      'setActiveCall on second call suspends the new call, not the existing one',
      () async {
        await client.state.setActiveCall(mockCall1);
        clearInteractions(mockCall1);

        await client.state.setActiveCall(mockCall2);

        verifyNever(mockCall1.suspendAudio);
        verify(mockCall2.ensureNativeFactory).called(1);
        verify(mockCall2.suspendAudio).called(1);
      },
    );

    test('removeActiveCall does not auto-resume any remaining call', () async {
      await client.state.setActiveCall(mockCall1);
      await client.state.setActiveCall(mockCall2);
      clearInteractions(mockCall1);
      clearInteractions(mockCall2);

      await client.state.removeActiveCall(mockCall2);

      verifyNever(mockCall1.resumeAudio);
    });
  });

  group('MultiCallAudioPolicy.manual', () {
    late StreamVideo client;

    setUp(() {
      client = buildClient(MultiCallAudioPolicy.manual);
    });

    test('setActiveCall never calls suspendAudio', () async {
      await client.state.setActiveCall(mockCall1);
      await client.state.setActiveCall(mockCall2);
      await client.state.setActiveCall(mockCall3);

      verifyNever(mockCall1.suspendAudio);
      verifyNever(mockCall2.suspendAudio);
      verifyNever(mockCall3.suspendAudio);
    });

    test('removeActiveCall never calls resumeAudio', () async {
      await client.state.setActiveCall(mockCall1);
      await client.state.setActiveCall(mockCall2);
      clearInteractions(mockCall1);
      clearInteractions(mockCall2);

      await client.state.removeActiveCall(mockCall2);

      verifyNever(mockCall1.resumeAudio);
      verifyNever(mockCall2.resumeAudio);
    });
  });

  group('policy is ignored when allowMultipleActiveCalls is false', () {
    test(
      'second setActiveCall replaces (calls leave) regardless of policy',
      () async {
        final client = StreamVideo.create(
          'test-api-key',
          user: user,
          userToken: userToken,
          options: StreamVideoOptions(
            allowMultipleActiveCalls: false,
            multiCallAudioPolicy: MultiCallAudioPolicy.suspendIncoming,
            autoConnect: false,
          ),
        );

        await client.state.setActiveCall(mockCall1);
        await client.state.setActiveCall(mockCall2);

        // In single-call mode the previous call is left, not suspended.
        verify(() => mockCall1.leave(reason: any(named: 'reason'))).called(1);
        verifyNever(mockCall1.suspendAudio);
        verifyNever(mockCall2.suspendAudio);
      },
    );
  });
}

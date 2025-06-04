// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/shared_emitter.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';

class MockCoordinatorClient extends Mock implements CoordinatorClient {}

class MockCall extends Mock implements Call {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Register fallback values for types used with any() matchers
    registerFallbackValue(
      StreamCallCid.from(
        type: StreamCallType.defaultType(),
        id: 'fallback-call-id',
      ),
    );
    registerFallbackValue(DisconnectReasonReplaced());
  });

  group('Call - allowMultipleActiveCalls functionality', () {
    late User user;
    late String userToken;
    late MockCoordinatorClient mockCoordinatorClient;

    setUp(() {
      user = User.regular(
        userId: 'test-user',
        name: 'Test User',
      );

      userToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiSm9obiBEb2UifQ.hrrtiYCtfs2cowE2sx2dypxoXhsEE8pQl-V6Nq4i8qU';

      mockCoordinatorClient = MockCoordinatorClient();

      // Mock coordinator client methods and events that might be called
      when(() => mockCoordinatorClient.events)
          .thenReturn(MutableSharedEmitterImpl<CoordinatorEvent>());
      when(() => mockCoordinatorClient.acceptCall(cid: any(named: 'cid')))
          .thenAnswer((_) async => const Result.success(none));
      when(
        () => mockCoordinatorClient.rejectCall(
          cid: any(named: 'cid'),
          reason: any(named: 'reason'),
        ),
      ).thenAnswer((_) async => const Result.success(none));
      when(
        () => mockCoordinatorClient.joinCall(
          callCid: any(named: 'callCid'),
          ringing: any(named: 'ringing'),
          create: any(named: 'create'),
          migratingFrom: any(named: 'migratingFrom'),
          video: any(named: 'video'),
          membersLimit: any(named: 'membersLimit'),
        ),
      ).thenAnswer((_) async => Result.error('join not implemented in test'));
    });

    group('when allowMultipleActiveCalls is false', () {
      late StreamVideo streamVideo;
      late Call call1;
      late Call call2;

      setUp(() {
        streamVideo = StreamVideo.create(
          'test-api-key',
          user: user,
          userToken: userToken,
          options: const StreamVideoOptions(
            allowMultipleActiveCalls: false,
            autoConnect: false,
          ),
        );

        call1 = streamVideo.makeCall(
          callType: StreamCallType.defaultType(),
          id: 'call-1',
        );

        call2 = streamVideo.makeCall(
          callType: StreamCallType.defaultType(),
          id: 'call-2',
        );
      });

      tearDown(() async {
        await StreamVideo.reset();
      });

      test('isActiveCall returns true when call is in activeCalls', () async {
        // Arrange - add call to active calls
        await streamVideo.state.setActiveCall(call1);

        // Assert
        expect(call1.isActiveCall, true);
        expect(call2.isActiveCall, false);
      });

      test('isActiveCall returns false when call is not in activeCalls',
          () async {
        // Arrange - ensure no active calls
        expect(streamVideo.activeCalls, <Call>[]);

        // Assert
        expect(call1.isActiveCall, false);
        expect(call2.isActiveCall, false);
      });

      test('call correctly identifies when it becomes inactive', () async {
        // Arrange - set call as active
        await streamVideo.state.setActiveCall(call1);
        expect(call1.isActiveCall, true);

        // Act - remove call from active
        await streamVideo.state.removeActiveCall(call1);

        // Assert
        expect(call1.isActiveCall, false);
      });

      test('accepting call replaces existing active call when single call mode',
          () async {
        // Arrange - create and set a mock call as active first
        final mockActiveCall = MockCall();
        when(() => mockActiveCall.callCid).thenReturn(
          StreamCallCid.from(
            id: 'active-call',
            type: StreamCallType.defaultType(),
          ),
        );
        when(() => mockActiveCall.leave(reason: any(named: 'reason')))
            .thenAnswer((_) async => const Result.success(none));

        await streamVideo.state.setActiveCall(mockActiveCall);
        expect(streamVideo.activeCalls, [mockActiveCall]);

        // Create a second call using Call.fromRinging (simulating incoming call)
        final ringingCallCid = StreamCallCid.from(
          id: 'ringing-call',
          type: StreamCallType.defaultType(),
        );

        final ringingCallMetadata = CallMetadata(
          cid: ringingCallCid,
          details: createTestCallDetails(createdByUserId: 'other-user'),
          settings: const CallSettings(),
          session: const CallSessionData(),
          users: const {},
          members: const {},
        );

        final ringingData = CallRingingData(
          callCid: ringingCallCid,
          ringing: true,
          metadata: ringingCallMetadata,
        );

        final ringingCall = Call.fromRinging(
          data: ringingData,
          coordinatorClient: mockCoordinatorClient,
          streamVideo: streamVideo,
          networkMonitor: InternetConnection.createInstance(),
        );

        // Act - accept the ringing call (should remove existing active call but not make ringing call active yet)
        await ringingCall.accept();

        // Assert - the existing active call was removed and leave was called on it
        // The ringing call should NOT be active after just accepting (it needs to be joined)
        expect(streamVideo.activeCalls, <Call>[]);
        verify(() => mockActiveCall.leave(reason: any(named: 'reason')))
            .called(1);

        // The ringing call should be in incoming state, not active
        expect(ringingCall.state.value.status, isA<CallStatusIncoming>());
      });
    });

    group('when allowMultipleActiveCalls is true', () {
      late StreamVideo streamVideo;
      late Call call1;
      late Call call2;
      late Call call3;

      setUp(() {
        streamVideo = StreamVideo.create(
          'test-api-key',
          user: user,
          userToken: userToken,
          options: const StreamVideoOptions(
            allowMultipleActiveCalls: true,
            autoConnect: false,
          ),
        );

        call1 = streamVideo.makeCall(
          callType: StreamCallType.defaultType(),
          id: 'call-1',
        );

        call2 = streamVideo.makeCall(
          callType: StreamCallType.defaultType(),
          id: 'call-2',
        );

        call3 = streamVideo.makeCall(
          callType: StreamCallType.defaultType(),
          id: 'call-3',
        );
      });

      tearDown(() async {
        await StreamVideo.reset();
      });

      test('isActiveCall returns true when call is in activeCalls', () async {
        // Arrange - add multiple calls to active calls
        await streamVideo.state.setActiveCall(call1);
        await streamVideo.state.setActiveCall(call2);

        // Assert
        expect(call1.isActiveCall, true);
        expect(call2.isActiveCall, true);
        expect(call3.isActiveCall, false);
      });

      test('activeCall getter throws exception', () {
        // Act & Assert
        expect(
          () => streamVideo.activeCall,
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains(
                'Multiple active calls are enabled, use activeCalls instead',
              ),
            ),
          ),
        );
      });

      test('call correctly identifies when it becomes inactive', () async {
        // Arrange - set calls as active
        await streamVideo.state.setActiveCall(call1);
        await streamVideo.state.setActiveCall(call2);
        expect(call1.isActiveCall, true);
        expect(call2.isActiveCall, true);

        // Act - remove calls from active
        await streamVideo.state.removeActiveCall(call1);
        await streamVideo.state.removeActiveCall(call2);

        // Assert
        expect(call1.isActiveCall, false);
        expect(call2.isActiveCall, false);
      });

      test(
          'accepting call does not replace existing active calls when multiple calls enabled',
          () async {
        // Arrange - create and set a mock call as active first
        final mockActiveCall = MockCall();
        when(() => mockActiveCall.callCid).thenReturn(
          StreamCallCid.from(
            id: 'active-call',
            type: StreamCallType.defaultType(),
          ),
        );
        when(() => mockActiveCall.leave(reason: any(named: 'reason')))
            .thenAnswer((_) async => const Result.success(none));

        await streamVideo.state.setActiveCall(mockActiveCall);
        expect(streamVideo.activeCalls, [mockActiveCall]);

        // Create a second call using Call.fromRinging (simulating incoming call)
        final ringingCallCid = StreamCallCid.from(
          id: 'ringing-call',
          type: StreamCallType.defaultType(),
        );

        final ringingCallMetadata = CallMetadata(
          cid: ringingCallCid,
          details: createTestCallDetails(createdByUserId: 'other-user'),
          settings: const CallSettings(),
          session: const CallSessionData(),
          users: const {},
          members: const {},
        );

        final ringingData = CallRingingData(
          callCid: ringingCallCid,
          ringing: true,
          metadata: ringingCallMetadata,
        );

        final ringingCall = Call.fromRinging(
          data: ringingData,
          coordinatorClient: mockCoordinatorClient,
          streamVideo: streamVideo,
          networkMonitor: InternetConnection.createInstance(),
        );

        // Act - accept the ringing call (should NOT remove existing active call in multiple calls mode)
        await ringingCall.accept();

        // Assert - previous active call should still be active (ringing call is not active yet, requires join)
        expect(streamVideo.activeCalls, contains(mockActiveCall));
        expect(streamVideo.activeCalls.length, 1);
        verifyNever(() => mockActiveCall.leave(reason: any(named: 'reason')));

        // The ringing call should be in incoming state, not joined
        expect(ringingCall.state.value.status, isA<CallStatusIncoming>());
      });
    });
  });
}

// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';

void main() {
  group('StreamVideo - allowMultipleActiveCalls', () {
    late User user;
    late String userToken;
    late MockCall mockCall1;
    late MockCall mockCall2;
    late MockCall mockCall3;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      user = User.regular(
        userId: 'test-user',
        name: 'Test User',
      );

      userToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiSm9obiBEb2UifQ.hrrtiYCtfs2cowE2sx2dypxoXhsEE8pQl-V6Nq4i8qU';

      mockCall1 = MockCall();
      mockCall2 = MockCall();
      mockCall3 = MockCall();

      // Mock callCid for each call
      when(() => mockCall1.callCid).thenReturn(
        StreamCallCid.from(id: 'call1', type: StreamCallType.defaultType()),
      );
      when(() => mockCall2.callCid).thenReturn(
        StreamCallCid.from(id: 'call2', type: StreamCallType.defaultType()),
      );
      when(() => mockCall3.callCid).thenReturn(
        StreamCallCid.from(id: 'call3', type: StreamCallType.defaultType()),
      );

      when(() => mockCall1.leave(reason: any(named: 'reason')))
          .thenAnswer((_) async => const Result.success(none));
      when(() => mockCall2.leave(reason: any(named: 'reason')))
          .thenAnswer((_) async => const Result.success(none));
      when(() => mockCall3.leave(reason: any(named: 'reason')))
          .thenAnswer((_) async => const Result.success(none));
    });

    group('when allowMultipleActiveCalls is false', () {
      late StreamVideo streamVideo;

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
      });

      tearDown(() async {
        await StreamVideo.reset();
      });

      test('activeCalls contains only one call when multiple calls are set',
          () async {
        // Arrange - start with an empty list
        expect(streamVideo.activeCalls, <Call>[]);

        // Act - set first call
        await streamVideo.state.setActiveCall(mockCall1);
        expect(streamVideo.activeCalls, [mockCall1]);

        // Act - set second call (should replace first)
        await streamVideo.state.setActiveCall(mockCall2);

        // Assert - only the latest call is active and first call leave was called
        expect(streamVideo.activeCalls, [mockCall2]);
        verify(() => mockCall1.leave(reason: any(named: 'reason'))).called(1);
      });

      test('activeCall tracks single active call', () async {
        // Arrange - start with no active call
        expect(streamVideo.activeCalls, <Call>[]);

        // Act - set active call
        await streamVideo.state.setActiveCall(mockCall1);

        // Assert - activeCall is available through getter
        expect(streamVideo.activeCall, mockCall1);
        expect(streamVideo.activeCalls, [mockCall1]);
      });

      test('setActiveCall with null clears active calls', () async {
        // Arrange - set initial call
        await streamVideo.state.setActiveCall(mockCall1);
        expect(streamVideo.activeCalls, [mockCall1]);

        // Act - set null
        await streamVideo.state.setActiveCall(null);

        // Assert - calls are cleared
        expect(streamVideo.activeCall, null);
        expect(streamVideo.activeCalls, <Call>[]);
      });

      test('removeActiveCall removes the active call', () async {
        // Arrange - set initial call
        await streamVideo.state.setActiveCall(mockCall1);
        expect(streamVideo.activeCalls, [mockCall1]);

        // Act - remove the call
        await streamVideo.state.removeActiveCall(mockCall1);

        // Assert - call is removed
        expect(streamVideo.activeCall, null);
        expect(streamVideo.activeCalls, <Call>[]);
      });

      test('removeActiveCall with different call does not change activeCalls',
          () async {
        // Arrange - set initial call
        await streamVideo.state.setActiveCall(mockCall1);
        expect(streamVideo.activeCalls, [mockCall1]);

        // Act - remove a different call
        await streamVideo.state.removeActiveCall(mockCall2);

        // Assert - activeCalls remains unchanged
        expect(streamVideo.activeCall, mockCall1);
        expect(streamVideo.activeCalls, [mockCall1]);
      });

      test('StreamVideo.activeCall getter works in single call mode', () async {
        await streamVideo.state.setActiveCall(mockCall1);
        expect(streamVideo.activeCall, mockCall1);
      });

      test('listenActiveCall works in single call mode', () {
        expect(() => streamVideo.listenActiveCall(null), returnsNormally);
      });

      test('leave method is called with correct reason when call is replaced',
          () async {
        // Arrange - set initial call
        await streamVideo.state.setActiveCall(mockCall1);

        // Act - replace the call
        await streamVideo.state.setActiveCall(mockCall2);

        // Assert - leave was called with replaced reason
        final captured =
            verify(() => mockCall1.leave(reason: captureAny(named: 'reason')))
                .captured;
        expect(captured.length, 1);
        expect(captured.first, isA<DisconnectReasonReplaced>());
      });
    });

    group('when allowMultipleActiveCalls is true', () {
      late StreamVideo streamVideo;

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
      });

      tearDown(() async {
        await StreamVideo.reset();
      });

      test('activeCalls can contain multiple calls', () async {
        // Arrange - start with an empty list
        expect(streamVideo.activeCalls, <Call>[]);

        // Act - set multiple calls
        await streamVideo.state.setActiveCall(mockCall1);
        expect(streamVideo.activeCalls, [mockCall1]);

        await streamVideo.state.setActiveCall(mockCall2);
        expect(streamVideo.activeCalls, [mockCall1, mockCall2]);

        await streamVideo.state.setActiveCall(mockCall3);

        // Assert - all calls are active and no leave was called
        expect(streamVideo.activeCalls, [mockCall1, mockCall2, mockCall3]);
        verifyNever(() => mockCall1.leave(reason: any(named: 'reason')));
        verifyNever(() => mockCall2.leave(reason: any(named: 'reason')));
      });

      test('removeActiveCall removes specific call from multiple active calls',
          () async {
        // Arrange - set multiple calls
        await streamVideo.state.setActiveCall(mockCall1);
        await streamVideo.state.setActiveCall(mockCall2);
        await streamVideo.state.setActiveCall(mockCall3);
        expect(streamVideo.activeCalls, [mockCall1, mockCall2, mockCall3]);

        // Act - remove middle call
        await streamVideo.state.removeActiveCall(mockCall2);

        // Assert - only the specific call is removed
        expect(streamVideo.activeCalls, [mockCall1, mockCall3]);
        verifyNever(() => mockCall2.leave(reason: any(named: 'reason')));
      });

      test(
          'StreamVideo.activeCall getter throws exception when multiple calls are enabled',
          () {
        // Assert - accessing activeCall throws exception
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

      test('listenActiveCall throws exception when multiple calls are enabled',
          () {
        // Act & Assert
        expect(
          () => streamVideo.listenActiveCall(null),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains(
                'Multiple active calls are enabled, use listenActiveCalls instead',
              ),
            ),
          ),
        );
      });

      test(
          'stream subscriptions work correctly with allowMultipleActiveCalls option',
          () async {
        final activeCallsFromStream = <List<Call>>[];
        final subscription =
            streamVideo.listenActiveCalls(activeCallsFromStream.add);

        await streamVideo.state.setActiveCall(mockCall1);
        // await Future.delayed(
        //     const Duration(milliseconds: 10)); // Allow stream to emit

        expect(activeCallsFromStream.isNotEmpty, true);

        await subscription.cancel();
      });
    });
  });
}

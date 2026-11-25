import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';

/// Audio controller whose interruptions are driven by the test, standing in
/// for the WebRTC plugin's process-wide reports.
// ignore: subtype_of_sealed_class, a mock for the tests
class _InterruptionController extends MockPlatformAudioController {
  // Closed by the test's tearDown, which the lint can't see from here.
  // ignore: close_sinks
  final interruptions = StreamController<bool>.broadcast();

  @override
  Stream<bool> get audioInterruptions => interruptions.stream;
}

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Call audio interruption state', () {
    late BehaviorSubject<InternetStatus> internetStatusController;
    late MockRtcMediaDeviceNotifier deviceNotifier;
    late _InterruptionController audio;

    setUp(() {
      internetStatusController = BehaviorSubject<InternetStatus>.seeded(
        InternetStatus.connected,
      );
      deviceNotifier = MockRtcMediaDeviceNotifier();
      audio = _InterruptionController();
      PlatformAudioController.instance = audio;
      // `Call.join` enumerates devices while applying the call settings.
      when(
        () => deviceNotifier.enumerateDevicesFor(any()),
      ).thenAnswer((_) async => const Result.success([]));
    });

    tearDown(() async {
      await internetStatusController.close();
      PlatformAudioController.instance = null;
      await audio.interruptions.close();
    });

    late MockClientState clientState;

    Call makeCall() {
      clientState = setupMockClientState();
      return createTestCall(
        streamVideo: setupMockCallHost(clientState: clientState),
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatusController,
        ),
        rtcMediaDeviceNotifier: deviceNotifier,
      );
    }

    /// Joins [call] and makes it the client's active call, which the mocked
    /// client state does not do itself.
    Future<void> joinActive(Call call) async {
      await call.join();
      (clientState.activeCalls as MutableStateEmitter<List<Call>>).value = [
        call,
      ];
    }

    Future<void> expectInterrupted(Call call, {required bool interrupted}) {
      return expectLater(
        call.state.map((state) => state.isAudioInterrupted),
        emitsThrough(interrupted),
      );
    }

    test('defaults to not interrupted', () async {
      final call = makeCall();
      await call.join();

      expect(call.state.value.isAudioInterrupted, isFalse);
    });

    test('follows the interruptions of a joined call', () async {
      final call = makeCall();
      await joinActive(call);

      audio.interruptions.add(true);
      await expectInterrupted(call, interrupted: true);

      audio.interruptions.add(false);
      await expectInterrupted(call, interrupted: false);
    });

    test('takes no interruption for a call that is not active', () async {
      final call = makeCall();
      await call.join();

      audio.interruptions.add(true);
      await pumpEventQueue();

      expect(call.state.value.isAudioInterrupted, isFalse);
    });

    test('ends the interruption when the call is left', () async {
      final call = makeCall();
      await joinActive(call);
      audio.interruptions.add(true);
      await expectInterrupted(call, interrupted: true);

      await call.leave();

      expect(call.state.value.isAudioInterrupted, isFalse);
    });
  });
}

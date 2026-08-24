import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';

/// Notifier whose autoplay-blocked signal is driven by the test, standing in
/// for the web audio layer's page-global tracking. Seeded like the real one, so
/// a subscriber gets the current value on join.
class _PlaybackNotifier extends MockRtcMediaDeviceNotifier {
  // Closed by the test's tearDown, which the lint can't see from here.
  // ignore: close_sinks
  final blocked = BehaviorSubject<bool>.seeded(false);

  @override
  Stream<bool> get webAudioPlaybackBlockedChanges => blocked.stream;
}

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Call web audio playback blocked state', () {
    late BehaviorSubject<InternetStatus> internetStatusController;
    late _PlaybackNotifier deviceNotifier;

    setUp(() {
      internetStatusController = BehaviorSubject<InternetStatus>.seeded(
        InternetStatus.connected,
      );
      deviceNotifier = _PlaybackNotifier();
      // `Call.join` enumerates devices while applying the call settings.
      when(
        deviceNotifier.enumerateDevices,
      ).thenAnswer((_) async => const Result.success([]));
    });

    tearDown(() async {
      await internetStatusController.close();
      await deviceNotifier.blocked.close();
    });

    Future<Call> joinTestCall() async {
      final call = createTestCall(
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatusController,
        ),
        rtcMediaDeviceNotifier: deviceNotifier,
      );

      await call.join();
      return call;
    }

    Future<void> expectBlocked(Call call, {required bool isBlocked}) {
      return expectLater(
        call.state.valueStream.map((state) => state.isWebAudioPlaybackBlocked),
        emitsThrough(isBlocked),
      );
    }

    test('defaults to not blocked', () async {
      final call = await joinTestCall();

      expect(call.state.value.isWebAudioPlaybackBlocked, isFalse);
    });

    test('picks up playback already blocked when the call joins', () async {
      deviceNotifier.blocked.add(true);

      final call = await joinTestCall();

      await expectBlocked(call, isBlocked: true);
    });

    test('updates the call state when playback becomes blocked', () async {
      final call = await joinTestCall();

      deviceNotifier.blocked.add(true);

      await expectBlocked(call, isBlocked: true);
    });

    test('updates the call state when playback is unblocked', () async {
      final call = await joinTestCall();

      deviceNotifier.blocked.add(true);
      await expectBlocked(call, isBlocked: true);

      deviceNotifier.blocked.add(false);
      await expectBlocked(call, isBlocked: false);
    });
  });
}

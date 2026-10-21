import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import '../call/fixtures/data.dart';

class _MockTracedPeerConnection extends Mock
    implements TracedStreamPeerConnection {}

/// A real [RtcManager] that records the Apple audio session configurations
/// it is asked for instead of sending them to iOS, which the fork only does
/// when the host is an iPhone.
class _RecordingRtcManager extends RtcManager {
  _RecordingRtcManager({
    required super.streamVideo,
    required super.pcFactory,
  }) : super(
         sessionId: 'test-session',
         callCid: SampleCallData.defaultCid,
         publisherId: 'test-publisher',
         publisher: null,
         subscriber: _MockTracedPeerConnection(),
         publishOptions: [],
         stateManager: MockCallStateNotifier(),
       );

  final applied = <({AudioConfigurationPolicy policy, bool speakerOn})>[];
  Result<None> nextResult = const Result.success(none);

  @override
  Future<Result<None>> setAppleAudioConfiguration({
    required AudioConfigurationPolicy policy,
    bool speakerOn = false,
  }) async {
    applied.add((policy: policy, speakerOn: speakerOn));
    return nextResult;
  }
}

class _CapturingLogger extends StreamLogger {
  final warnings = <String>[];

  @override
  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) {
    if (priority == Priority.warning) warnings.add(message());
  }
}

RtcMediaDevice _output(String id, {String? groupId}) => RtcMediaDevice(
  id: id,
  label: id,
  kind: RtcMediaDeviceKind.audioOutput,
  groupId: groupId,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('FlutterWebRTC.Method');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  final selectedOutputs = <Object?>[];

  setUp(() {
    selectedOutputs.clear();
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'selectAudioOutput') {
        selectedOutputs.add(call.arguments);
      }
      return null;
    });
  });

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  /// An RTC manager on a factory built with [factoryPolicy], in a client
  /// whose own policy is the broadcaster policy.
  _RecordingRtcManager makeRtcManager(AudioConfigurationPolicy factoryPolicy) {
    final streamVideo = MockStreamVideo();
    when(() => streamVideo.options).thenReturn(
      StreamVideoOptions(
        clientEventsReportingEnabled: false,
        // ignore: avoid_redundant_argument_values
        audioConfigurationPolicy: const AudioConfigurationPolicy.broadcaster(),
      ),
    );

    return _RecordingRtcManager(
      streamVideo: streamVideo,
      pcFactory: StreamPeerConnectionFactory(
        callCid: SampleCallData.defaultCid,
        audioConfigurationPolicy: factoryPolicy,
      ),
    );
  }

  group('RtcManager.setAudioOutputDevice', () {
    const viewer = AudioConfigurationPolicy.viewer();
    const broadcaster = AudioConfigurationPolicy.broadcaster();

    test('the speaker asks for the loudspeaker', () async {
      final rtcManager = makeRtcManager(broadcaster);

      final result = await rtcManager.setAudioOutputDevice(
        device: _output('Speaker'),
      );

      expect(result.isSuccess, isTrue);
      expect(rtcManager.applied.single.speakerOn, isTrue);
      expect(selectedOutputs, isNotEmpty);
    });

    test('the earpiece does not ask for the loudspeaker, even under the '
        'viewer policy', () async {
      for (final device in [
        _output('earpiece'),
        _output('Built-In Receiver', groupId: 'Receiver'),
      ]) {
        final rtcManager = makeRtcManager(viewer);

        await rtcManager.setAudioOutputDevice(device: device);

        expect(
          rtcManager.applied.single.speakerOn,
          isFalse,
          reason: device.id,
        );
      }
    });

    test('Bluetooth under the viewer policy keeps the loudspeaker as the '
        'built-in output', () async {
      final rtcManager = makeRtcManager(viewer);

      await rtcManager.setAudioOutputDevice(
        device: _output('bt', groupId: 'BluetoothA2DPOutput'),
      );

      expect(rtcManager.applied.single.speakerOn, isTrue);
    });

    test("the factory's policy wins over the client's", () async {
      final rtcManager = makeRtcManager(viewer);

      await rtcManager.setAudioOutputDevice(
        device: _output('bt', groupId: 'BluetoothA2DPOutput'),
      );

      expect(rtcManager.applied.single.policy, viewer);
    });

    test('a failure to configure the audio session is logged and the output '
        'is still selected', () async {
      final logger = _CapturingLogger();
      StreamLog()
        ..logger = logger
        ..priority = Priority.warning;
      addTearDown(() {
        StreamLog()
          ..logger = const SilentStreamLogger()
          ..priority = Priority.none;
      });

      final rtcManager = makeRtcManager(viewer)
        ..nextResult = Result.error('session busy');

      final result = await rtcManager.setAudioOutputDevice(
        device: _output('earpiece'),
      );

      expect(result.isSuccess, isTrue);
      expect(selectedOutputs, isNotEmpty);
      expect(
        logger.warnings,
        contains(allOf(contains('earpiece'), contains('session busy'))),
      );
    });
  });
}

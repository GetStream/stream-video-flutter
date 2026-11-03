import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/telemetry/client_event.dart';
import 'package:stream_video/src/telemetry/client_event_reporter.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';
import 'package:stream_video/src/telemetry/rtc_session_telemetry.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../call/fixtures/data.dart';
import '../webrtc/fixtures/rtc_manager_fakes.dart';

/// Records what is reported; every stage it opens is `stage-<n>`.
class _RecordingReporter extends Fake implements ClientEventReporter {
  final begun = <ClientEventPeerConnectionRole?>[];
  final completed = <String>[];
  final failed = <String>[];
  final events = <ClientEventStage>[];

  @override
  String beginStage(
    StreamCallCid cid,
    ClientEventStage stage, {
    ClientEventDetails details = const ClientEventDetails(),
  }) {
    begun.add(details.peerConnectionRole);
    return 'stage-${begun.length}';
  }

  @override
  void completeStage(
    String stageId, {
    required ClientEventOutcome outcome,
    int retryCount = 0,
    ClientEventFailure? failure,
    ClientEventDetails details = const ClientEventDetails(),
  }) {
    completed.add(stageId);
  }

  @override
  void failStage(
    String stageId, {
    required ClientEventFailure failure,
    int retryCount = 0,
    ClientEventDetails details = const ClientEventDetails(),
  }) {
    failed.add(stageId);
  }

  @override
  void reportEvent(
    StreamCallCid cid,
    ClientEventStage stage, {
    ClientEventType type = ClientEventType.initiated,
    ClientEventDetails details = const ClientEventDetails(),
  }) {
    events.add(stage);
  }
}

/// The connection state callbacks `attach` set on [pc].
({
  void Function(rtc.RTCIceConnectionState) ice,
  void Function(rtc.RTCPeerConnectionState) connection,
})
_callbacksOf(MockTracedPeerConnection pc) {
  final ice =
      verify(() => pc.onIceConnectionStateUpdated = captureAny()).captured.last
          as void Function(rtc.RTCIceConnectionState);
  final connection =
      verify(() => pc.onConnectionStateUpdated = captureAny()).captured.last
          as void Function(rtc.RTCPeerConnectionState);
  return (ice: ice, connection: connection);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _RecordingReporter reporter;
  late RtcSessionTelemetry telemetry;
  late MockTracedPeerConnection publisher;
  late MockTracedPeerConnection subscriber;

  setUp(() {
    reporter = _RecordingReporter();
    telemetry = RtcSessionTelemetry(
      reporter: reporter,
      callCid: SampleCallData.defaultCid,
    );
    publisher = MockTracedPeerConnection();
    subscriber = MockTracedPeerConnection();
  });

  group('attach', () {
    test('reports how each peer connection connects', () {
      telemetry.attach(publisher: publisher, subscriber: subscriber);
      final subscriberCallbacks = _callbacksOf(subscriber);
      final publisherCallbacks = _callbacksOf(publisher);

      subscriberCallbacks.connection(
        rtc.RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
      );
      publisherCallbacks.ice(
        rtc.RTCIceConnectionState.RTCIceConnectionStateChecking,
      );
      subscriberCallbacks.connection(
        rtc.RTCPeerConnectionState.RTCPeerConnectionStateConnected,
      );

      expect(reporter.begun, [
        ClientEventPeerConnectionRole.subscribe,
        ClientEventPeerConnectionRole.publish,
      ]);
      expect(reporter.completed, ['stage-1']);
    });

    test('wires the subscriber alone when there is no publisher', () {
      telemetry.attach(publisher: null, subscriber: subscriber);

      _callbacksOf(subscriber).connection(
        rtc.RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
      );

      expect(reporter.begun, [ClientEventPeerConnectionRole.subscribe]);
    });
  });

  test('dispose fails a connect that is still in flight', () {
    telemetry.attach(publisher: publisher, subscriber: subscriber);
    _callbacksOf(publisher).connection(
      rtc.RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
    );

    telemetry.dispose();

    expect(reporter.failed, ['stage-1']);
  });

  group('first frames', () {
    RtcRemoteTrack remoteAudio() {
      return RtcRemoteTrack(
        trackIdPrefix: 'other-participant',
        trackType: SfuTrackType.audio,
        mediaStream: FakeMediaStream(),
        mediaTrack: FakeMediaStreamTrack('remote-audio', kind: 'audio'),
      );
    }

    test('a remote audio track reports its first frame once audio flows', () {
      final track = remoteAudio();
      telemetry.onRemoteTrack(track);

      telemetry.onSubscriberStats(const [
        RtcInboundRtpAudioStream(packetsReceived: 0),
      ]);
      expect(reporter.events, isEmpty);

      telemetry.onSubscriberStats(const [
        RtcInboundRtpAudioStream(packetsReceived: 5),
      ]);
      expect(reporter.events, [ClientEventStage.firstAudioFrame]);
    });

    test('a remote video track is not taken for audio', () {
      final platform = FakeWebRtcPlatform()..install();
      addTearDown(platform.uninstall);
      final video = RtcRemoteTrack(
        trackIdPrefix: 'other-participant',
        trackType: SfuTrackType.video,
        mediaStream: FakeMediaStream(),
        mediaTrack: FakeMediaStreamTrack('remote-video', kind: 'video'),
      );
      telemetry
        ..onRemoteTrack(video)
        ..onSubscriberStats(const [
          RtcInboundRtpAudioStream(packetsReceived: 5),
        ]);

      expect(reporter.events, isEmpty);
    });

    test('stats report nothing without a remote audio track', () {
      telemetry.onSubscriberStats(const [
        RtcInboundRtpAudioStream(packetsReceived: 5),
      ]);

      expect(reporter.events, isEmpty);
    });

    test('nothing is reported after dispose', () {
      final track = remoteAudio();
      telemetry
        ..onRemoteTrack(track)
        ..dispose()
        ..onSubscriberStats(const [
          RtcInboundRtpAudioStream(packetsReceived: 5),
        ]);

      expect(reporter.events, isEmpty);
    });
  });
}

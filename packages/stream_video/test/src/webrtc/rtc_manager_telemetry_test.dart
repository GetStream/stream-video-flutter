// ignore_for_file: missing_override_of_must_be_overridden

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/telemetry/client_event.dart';
import 'package:stream_video/src/telemetry/client_event_reporter.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../call/fixtures/call_test_helpers.dart';
import 'fixtures/rtc_manager_fakes.dart';

/// Records the stages reported through [reportEvent]; any other call fails the
/// test.
class _RecordingReporter extends Fake implements ClientEventReporter {
  final stages = <ClientEventStage>[];

  @override
  void reportEvent(
    StreamCallCid cid,
    ClientEventStage stage, {
    ClientEventType type = ClientEventType.initiated,
    ClientEventDetails details = const ClientEventDetails(),
  }) {
    stages.add(stage);
  }
}

class _FakeTrackEvent extends Fake implements rtc.RTCTrackEvent {
  _FakeTrackEvent(this.track, this.streams);

  @override
  final rtc.MediaStreamTrack track;

  @override
  final List<rtc.MediaStream> streams;

  @override
  rtc.RTCRtpTransceiver? get transceiver => null;
}

class _FakeRemoteStream extends Fake implements rtc.MediaStream {
  _FakeRemoteStream(this.id);

  @override
  final String id;

  @override
  // ignore: avoid_setters_without_getters
  set onRemoveTrack(void Function(rtc.MediaStreamTrack track)? callback) {}
}

class _FakeRemoteTrack extends FakeMediaStreamTrack {
  _FakeRemoteTrack(super.id, {required super.kind});

  @override
  // ignore: avoid_setters_without_getters
  set onEnded(rtc.StreamTrackCallback? callback) {}
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerRtcManagerFallbacks();
  });

  /// A manager whose subscriber already received a remote audio track, with
  /// client event reporting set to [reportingEnabled].
  ({_RecordingReporter reporter, RtcManager manager}) withRemoteAudio({
    required bool reportingEnabled,
  }) {
    final reporter = _RecordingReporter();
    final host = setupMockCallHost()..clientEventReporterOverride = reporter;
    when(() => host.options).thenReturn(
      StreamVideoOptions(clientEventsReportingEnabled: reportingEnabled),
    );

    final fixture = RtcManagerFixture(host: host);
    final onTrack =
        verify(() => fixture.subscriber.onTrack = captureAny()).captured.single
            as void Function(StreamPeerConnection, rtc.RTCTrackEvent);
    onTrack(
      fixture.subscriber,
      _FakeTrackEvent(_FakeRemoteTrack('remote-audio', kind: 'audio'), [
        _FakeRemoteStream('other:TRACK_TYPE_AUDIO'),
      ]),
    );

    fixture.manager.onSubscriberStats(const [
      RtcInboundRtpAudioStream(packetsReceived: 10),
    ]);
    return (reporter: reporter, manager: fixture.manager);
  }

  group('onSubscriberStats', () {
    test('reports the first audio frame when reporting is enabled', () {
      final reporter = withRemoteAudio(reportingEnabled: true).reporter;

      expect(reporter.stages, [ClientEventStage.firstAudioFrame]);
    });

    test('reports the first audio frame only once', () {
      final wires = withRemoteAudio(reportingEnabled: true);

      wires.manager.onSubscriberStats(const [
        RtcInboundRtpAudioStream(packetsReceived: 20),
      ]);

      expect(wires.reporter.stages, [ClientEventStage.firstAudioFrame]);
    });

    test('reports nothing when reporting is disabled', () {
      final reporter = withRemoteAudio(reportingEnabled: false).reporter;

      expect(reporter.stages, isEmpty);
    });
  });
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stream_video/src/models/call_cid.dart';
import 'package:stream_video/src/telemetry/client_event_reporter.dart';
import 'package:stream_video/src/telemetry/client_event_transport.dart';
import 'package:stream_video/src/telemetry/media_frame_reporter.dart';
import 'package:stream_video/src/webrtc/model/stats/rtc_inbound_rtp_audio_stream.dart';
import 'package:stream_video/src/webrtc/model/stats/rtc_stats.dart';

void main() {
  final cid = StreamCallCid(cid: 'default:call123');

  late List<Map<String, dynamic>> captured;
  late ClientEventReporter reporter;
  late MediaFrameReporter mfr;

  setUp(() {
    captured = [];
    final mockClient = MockClient((request) async {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      for (final event in body['events'] as List) {
        captured.add((event as Map).cast<String, dynamic>());
      }
      return http.Response('', 200);
    });

    reporter = ClientEventReporter(
      transport: ClientEventTransport(
        baseUrl: 'https://example.com',
        apiKey: 'key',
        httpClient: mockClient,
        retryConfig: const ClientEventRetryConfig(maxAttempts: 1),
      ),
      resolveUserId: () => 'user-1',
    )..registerCall(cid);

    mfr = MediaFrameReporter(reporter: reporter, callCid: cid, sfuId: 'sfu-1');
  });

  tearDown(() => mfr.dispose());

  Future<void> flush() => Future<void>.delayed(Duration.zero);

  const noAudio = <RtcStats>[RtcInboundRtpAudioStream(packetsReceived: 0)];
  const audioFlowing = <RtcStats>[
    RtcInboundRtpAudioStream(packetsReceived: 12),
  ];

  test('FirstAudioFrame fires once inbound audio packets appear', () async {
    mfr.onRemoteAudioTrack(trackId: 'track-a:audio');

    mfr.onSubscriberStats(noAudio); // still silent — no packets yet
    await flush();
    expect(captured, isEmpty);

    mfr.onSubscriberStats(audioFlowing);
    await flush();

    final event = captured.single;
    expect(event['stage'], 'FirstAudioFrame');
    expect(event['event_type'], 'initiated');
    expect(event['track_id'], 'track-a:audio');
    expect(event['sfu_id'], 'sfu-1');
    expect(event.containsKey('stage_id'), isTrue); // single-shot carries one
  });

  test('FirstAudioFrame fires at most once across stats ticks', () async {
    mfr.onRemoteAudioTrack(trackId: 'track-a:audio');
    mfr
      ..onSubscriberStats(audioFlowing)
      ..onSubscriberStats(audioFlowing)
      ..onSubscriberStats(audioFlowing);
    await flush();

    expect(
      captured.where((e) => e['stage'] == 'FirstAudioFrame'),
      hasLength(1),
    );
  });

  test('no FirstAudioFrame before a remote audio track is received', () async {
    // Stats show audio, but we never recorded a remote audio track.
    mfr.onSubscriberStats(audioFlowing);
    await flush();
    expect(captured, isEmpty);
  });
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/models/call_cid.dart';
import 'package:stream_video/src/telemetry/client_event_reporter.dart';
import 'package:stream_video/src/telemetry/client_event_transport.dart';
import 'package:stream_video/src/telemetry/media_frame_reporter.dart';
import 'package:stream_video/src/webrtc/model/stats/rtc_inbound_rtp_audio_stream.dart';
import 'package:stream_video/src/webrtc/model/stats/rtc_stats.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

void main() {
  final cid = StreamCallCid(cid: 'default:call123');

  late List<Map<String, dynamic>> captured;
  late ClientEventReporter reporter;
  late MediaFrameReporter mfr;

  setUp(() {
    captured = [];
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final data = options.data;
            if (data is Map && data['events'] is List) {
              for (final event in data['events'] as List) {
                captured.add((event as Map).cast<String, dynamic>());
              }
            }
            handler.resolve(
              Response(requestOptions: options, statusCode: 201),
            );
          },
        ),
      );

    reporter = ClientEventReporter(
      transport: ClientEventTransport(
        baseUrl: 'https://example.com',
        apiKey: 'key',
        getToken: UserToken.anonymous,
        client: dio,
        retryConfig: const ClientEventRetryConfig(maxAttempts: 1),
      ),
      resolveUserId: () => 'user-1',
    )..registerCall(cid);

    mfr = MediaFrameReporter(reporter: reporter, callCid: cid, sfuId: 'sfu-1');
  });

  tearDown(() => mfr.dispose());

  Future<void> flush() => pumpEventQueue();

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

  group('FirstVideoFrame', () {
    late _WatchingEngine engine;

    setUp(() {
      engine = _WatchingEngine();
      WebRtcEngine.instance = engine;
    });

    tearDown(WebRtcEngine.debugUnregister);

    test('fires once on the first frame and stops every watch', () async {
      unawaited(
        mfr.onRemoteVideoTrack(stream: _FakeStream(), trackId: 'track-v1'),
      );
      unawaited(
        mfr.onRemoteVideoTrack(stream: _FakeStream(), trackId: 'track-v2'),
      );
      await flush();

      engine.onFirstFrames.first();
      engine.onFirstFrames.last();
      await flush();

      final event = captured.single;
      expect(event['stage'], 'FirstVideoFrame');
      expect(event['track_id'], 'track-v1');
      expect(engine.watchers.map((w) => w.disposed), [true, true]);
    });

    test('two calls for one track start one watch', () async {
      final gate = engine.gate = Completer<void>();
      unawaited(
        mfr.onRemoteVideoTrack(stream: _FakeStream(), trackId: 'track-v1'),
      );
      unawaited(
        mfr.onRemoteVideoTrack(stream: _FakeStream(), trackId: 'track-v1'),
      );
      gate.complete();
      await flush();

      expect(engine.watchers, hasLength(1));
    });

    test('a watch that fails to dispose does not throw', () async {
      unawaited(
        mfr.onRemoteVideoTrack(stream: _FakeStream(), trackId: 'track-v1'),
      );
      await flush();
      engine.watchers.single.disposeError = StateError('dispose failed');

      mfr.dispose();
      await flush();

      expect(engine.watchers.single.disposed, isTrue);
    });
  });
}

class _FakeStream extends Fake implements MediaStream {}

// ignore: subtype_of_sealed_class, a fake for the tests
class _FakeWatcher implements FirstFrameWatcher {
  bool disposed = false;
  Error? disposeError;

  @override
  Future<void> dispose() async {
    disposed = true;
    if (disposeError case final error?) throw error;
  }
}

// ignore: subtype_of_sealed_class, a fake for the tests
class _WatchingEngine extends Fake implements WebRtcEngine {
  final watchers = <_FakeWatcher>[];
  final onFirstFrames = <void Function()>[];

  /// When set, watches start once it completes.
  Completer<void>? gate;

  @override
  Future<FirstFrameWatcher> watchFirstFrame(
    MediaStream stream, {
    required void Function() onFirstFrame,
  }) async {
    if (gate case final gate?) await gate.future;
    onFirstFrames.add(onFirstFrame);
    final watcher = _FakeWatcher();
    watchers.add(watcher);
    return watcher;
  }
}

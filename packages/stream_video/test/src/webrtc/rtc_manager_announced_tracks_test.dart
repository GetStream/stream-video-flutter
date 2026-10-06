// ignore_for_file: missing_override_of_must_be_overridden

import 'dart:ui' show Size;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/webrtc/media/media_constraints.dart';
import 'package:stream_video/src/webrtc/model/rtc_tracks_info.dart';
import 'package:stream_video/src/webrtc/model/rtc_video_dimension.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/rtc_track/rtc_local_track.dart';
import 'package:stream_video/src/webrtc/rtc_track/rtc_track_publish_options.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../call/fixtures/call_test_helpers.dart';
import '../call/fixtures/data.dart';

class _MockTracedStreamPeerConnection extends Mock
    implements TracedStreamPeerConnection {}

class _MockPeerConnection extends Mock implements rtc.RTCPeerConnection {}

class _MockTransceiver extends Mock implements rtc.RTCRtpTransceiver {}

class _MockSender extends Mock implements rtc.RTCRtpSender {}

class _MockMediaStreamTrack extends Mock implements rtc.MediaStreamTrack {}

class _MockMediaStream extends Mock implements rtc.MediaStream {}

class _MockLocalAudioTrack extends Mock implements RtcLocalAudioTrack {}

const _testCodec = SfuCodec(
  name: 'opus',
  payloadType: 111,
  fmtpLine: '',
  clockRate: 48000,
  encodingParameters: '',
);

/// A cached transceiver sending [trackId], reporting [mid] as its own.
///
/// [mid] stands in for the value a native transceiver captured when it was
/// created — the last-resort source, only reached once the live lookup and the
/// SDP both come up empty.
rtc.RTCRtpTransceiver _transceiver({required String trackId, String mid = ''}) {
  final mediaTrack = _MockMediaStreamTrack();
  when(() => mediaTrack.id).thenReturn(trackId);
  when(() => mediaTrack.kind).thenReturn('audio');
  when(() => mediaTrack.enabled).thenReturn(true);

  final sender = _MockSender();
  when(() => sender.track).thenReturn(mediaTrack);

  final transceiver = _MockTransceiver();
  when(() => transceiver.sender).thenReturn(sender);
  when(() => transceiver.mid).thenReturn(mid);
  return transceiver;
}

SfuPublishOptions _option(int id) {
  return SfuPublishOptions(
    id: id,
    codec: _testCodec,
    trackType: SfuTrackType.audio,
  );
}

/// The announce the SFU acknowledged for [option], as `markNegotiated` sees it.
RtcTrackInfo _announced(
  SfuPublishOptions option, {
  required String trackId,
  required String mid,
}) {
  return RtcTrackInfo(
    trackId: trackId,
    trackType: option.trackType,
    publishOptionId: option.id,
    mid: mid,
    layers: const [],
    codec: option.codec,
    muted: false,
    dtx: false,
    stereo: false,
    red: false,
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  ({RtcManager manager, _MockPeerConnection pc}) buildManager() {
    final pc = _MockPeerConnection();
    final publisher = _MockTracedStreamPeerConnection();
    when(() => publisher.pc).thenReturn(pc);
    when(() => publisher.tracer).thenReturn(Tracer(null));

    final manager = RtcManager(
      sessionId: 'test-session',
      callCid: SampleCallData.defaultCid,
      publisherId: 'test-publisher',
      publisher: publisher,
      subscriber: _MockTracedStreamPeerConnection(),
      publishOptions: [_option(1), _option(2)],
      stateManager: createTestCallStateManager(),
      streamVideo: setupMockStreamVideo(),
      pcFactory: StreamPeerConnectionFactory(
        callCid: SampleCallData.defaultCid,
      ),
    );

    return (manager: manager, pc: pc);
  }

  /// Caches a sending transceiver for [option] under [trackId].
  void cacheTrack(
    RtcManager manager, {
    required SfuPublishOptions option,
    required String trackId,
    String cachedMid = '',
  }) {
    final mediaTrack = _MockMediaStreamTrack();
    when(() => mediaTrack.id).thenReturn(trackId);
    when(() => mediaTrack.kind).thenReturn('audio');

    final track = _MockLocalAudioTrack();
    when(() => track.trackId).thenReturn('track-$trackId');
    when(() => track.trackType).thenReturn(SfuTrackType.audio);
    when(() => track.mediaTrack).thenReturn(mediaTrack);

    manager.transceiversManager.add(
      track,
      option,
      _transceiver(trackId: trackId, mid: cachedMid),
      const RtcTrackPublishOptions(),
    );
  }

  void stubPeerConnection(
    _MockPeerConnection pc, {
    List<rtc.RTCRtpTransceiver> liveTransceivers = const [],
    String? sdp,
    bool failing = false,
  }) {
    if (failing) {
      when(pc.getTransceivers).thenThrow(Exception('pc is closed'));
      when(pc.getLocalDescription).thenThrow(Exception('pc is closed'));
      return;
    }

    when(pc.getTransceivers).thenAnswer((_) async => liveTransceivers);
    when(pc.getLocalDescription).thenAnswer(
      (_) async => sdp == null ? null : rtc.RTCSessionDescription(sdp, 'offer'),
    );
  }

  group('getAnnouncedTracks', () {
    test('announces every track once all mids resolve', () async {
      final wires = buildManager();
      cacheTrack(wires.manager, option: _option(1), trackId: 'track-a');
      cacheTrack(wires.manager, option: _option(2), trackId: 'track-b');

      stubPeerConnection(
        wires.pc,
        liveTransceivers: [
          _transceiver(trackId: 'track-a', mid: '0'),
          _transceiver(trackId: 'track-b', mid: '1'),
        ],
      );

      final announced = await wires.manager.getAnnouncedTracks();

      expect(announced, isNotNull);
      expect(announced!.map((it) => it.trackId), ['track-a', 'track-b']);
      expect(announced.map((it) => it.mid), ['0', '1']);
    });

    test('returns null rather than announcing a subset', () async {
      final wires = buildManager();
      cacheTrack(wires.manager, option: _option(1), trackId: 'track-a');
      cacheTrack(wires.manager, option: _option(2), trackId: 'track-b');

      // Only the first track has a live transceiver, and there is no SDP to
      // fall back on for the second.
      stubPeerConnection(
        wires.pc,
        liveTransceivers: [_transceiver(trackId: 'track-a', mid: '0')],
      );

      expect(await wires.manager.getAnnouncedTracks(), isNull);
    });

    test('returns an empty list when nothing is sending', () async {
      final wires = buildManager();
      stubPeerConnection(wires.pc);

      // Distinct from null: nothing to publish is a no-op, not a failure.
      expect(await wires.manager.getAnnouncedTracks(), isEmpty);
    });

    test('resolves from the offer SDP when no mid is assigned yet', () async {
      final wires = buildManager();
      cacheTrack(wires.manager, option: _option(1), trackId: 'track-a');

      stubPeerConnection(
        wires.pc,
        liveTransceivers: [_transceiver(trackId: 'track-a')],
      );

      final announced = await wires.manager.getAnnouncedTracks(
        sdp: [
          'v=0\r\n',
          'o=- 1 2 IN IP4 127.0.0.1\r\n',
          's=-\r\n',
          't=0 0\r\n',
          'm=audio 9 UDP/TLS/RTP/SAVPF 111\r\n',
          'c=IN IP4 0.0.0.0\r\n',
          'a=mid:5\r\n',
          'a=sendonly\r\n',
          'a=msid:stream-id track-a\r\n',
        ].join(),
      );

      expect(announced?.single.mid, '5');
    });

    test(
      'skips a publish that landed after the offer was created instead of '
      'failing the announce — its own queued negotiation announces it',
      () async {
        final wires = buildManager();
        // track-a is part of the offer; track-b was published concurrently
        // while this negotiation was preparing (its m-line is absent).
        cacheTrack(wires.manager, option: _option(1), trackId: 'track-a');
        cacheTrack(wires.manager, option: _option(2), trackId: 'track-b');

        stubPeerConnection(
          wires.pc,
          liveTransceivers: [_transceiver(trackId: 'track-a', mid: '0')],
        );

        final announced = await wires.manager.getAnnouncedTracks(
          sdp: [
            'v=0\r\n',
            'o=- 1 2 IN IP4 127.0.0.1\r\n',
            's=-\r\n',
            't=0 0\r\n',
            'm=audio 9 UDP/TLS/RTP/SAVPF 111\r\n',
            'c=IN IP4 0.0.0.0\r\n',
            'a=mid:0\r\n',
            'a=sendonly\r\n',
            'a=msid:stream-id track-a\r\n',
          ].join(),
        );

        expect(announced, isNotNull);
        expect(announced!.single.trackId, 'track-a');
      },
    );

    test(
      'fails the announce for a track the SFU already acknowledged, even when '
      'the offer does not name it — dropping it would read as an unpublish',
      () async {
        final wires = buildManager();
        cacheTrack(wires.manager, option: _option(1), trackId: 'track-a');
        cacheTrack(wires.manager, option: _option(2), trackId: 'track-b');

        // track-b was announced and acknowledged, but the ack carried no mid,
        // so there is no negotiatedMid to fall back on. It is a live sender —
        // absence from the offer must not be read as a mid-flight publish.
        wires.manager.transceiversManager.markNegotiated([
          _announced(_option(2), trackId: 'track-b', mid: ''),
        ]);

        stubPeerConnection(
          wires.pc,
          liveTransceivers: [_transceiver(trackId: 'track-a', mid: '0')],
        );

        final announced = await wires.manager.getAnnouncedTracks(
          sdp: [
            'v=0\r\n',
            'o=- 1 2 IN IP4 127.0.0.1\r\n',
            's=-\r\n',
            't=0 0\r\n',
            'm=audio 9 UDP/TLS/RTP/SAVPF 111\r\n',
            'c=IN IP4 0.0.0.0\r\n',
            'a=mid:0\r\n',
            'a=sendonly\r\n',
            'a=msid:stream-id track-a\r\n',
          ].join(),
        );

        expect(announced, isNull);
      },
    );

    test(
      'fails the announce when a republish swapped the track after the offer '
      'was created — the m-line is in the offer under the id it replaced',
      () async {
        final wires = buildManager();
        final option = _option(1);
        cacheTrack(wires.manager, option: option, trackId: 'clone-0');

        // The republish path: `replaceTrack` swaps a fresh clone onto the same
        // sender, and the cache follows it. Nothing is negotiated yet, so there
        // is no negotiatedMid to fall back on either.
        final swappedMedia = _MockMediaStreamTrack();
        when(() => swappedMedia.id).thenReturn('clone-1');
        when(() => swappedMedia.kind).thenReturn('audio');
        when(() => swappedMedia.enabled).thenReturn(true);

        final swapped = _MockLocalAudioTrack();
        when(() => swapped.trackId).thenReturn('track-clone-1');
        when(() => swapped.trackType).thenReturn(SfuTrackType.audio);
        when(() => swapped.mediaTrack).thenReturn(swappedMedia);

        final cached = wires.manager.transceiversManager.get(option)!;
        final sender = cached.transceiver.sender;
        when(() => sender.track).thenReturn(swappedMedia);
        wires.manager.transceiversManager.update(option, track: swapped);

        // The sender now holds clone-1, while the offer — created before the
        // swap — still names clone-0 on the very m-line this sender owns.
        stubPeerConnection(
          wires.pc,
          liveTransceivers: [_transceiver(trackId: 'clone-1')],
        );

        final announced = await wires.manager.getAnnouncedTracks(
          sdp: [
            'v=0\r\n',
            'o=- 1 2 IN IP4 127.0.0.1\r\n',
            's=-\r\n',
            't=0 0\r\n',
            'm=audio 9 UDP/TLS/RTP/SAVPF 111\r\n',
            'c=IN IP4 0.0.0.0\r\n',
            'a=sendonly\r\n',
            'a=msid:stream-id clone-0\r\n',
          ].join(),
        );

        // Skipping it would commit an offer whose m-line keeps sending media
        // the SFU was never told about. Roll back and retry instead.
        expect(announced, isNull);
      },
    );
  });

  group('getAnnouncedTracksForReconnect', () {
    test('reports the resolvable tracks instead of failing the '
        'reconnect', () async {
      final wires = buildManager();
      cacheTrack(wires.manager, option: _option(1), trackId: 'track-a');
      cacheTrack(wires.manager, option: _option(2), trackId: 'track-b');

      stubPeerConnection(
        wires.pc,
        liveTransceivers: [_transceiver(trackId: 'track-b', mid: '1')],
      );

      final announced = await wires.manager.getAnnouncedTracksForReconnect();

      expect(announced.map((it) => it.trackId), ['track-b']);
    });

    test('falls back to the cached mid when the peer connection is '
        'already gone', () async {
      final wires = buildManager();
      cacheTrack(
        wires.manager,
        option: _option(1),
        trackId: 'track-a',
        cachedMid: '4',
      );

      // A rejoin builds ReconnectDetails from the previous session, whose
      // publisher is closed: both live sources fail.
      stubPeerConnection(wires.pc, failing: true);

      final announced = await wires.manager.getAnnouncedTracksForReconnect();

      expect(announced.single.trackId, 'track-a');
      expect(announced.single.mid, '4');
    });

    test('falls back to the last acknowledged mid when the peer connection '
        'is gone and the transceiver reports none', () async {
      final wires = buildManager();
      final option = _option(1);

      // What a native rejoin actually looks like: the cached transceiver's mid
      // was captured before it had one and is never refreshed, so the mid
      // recorded when the SFU acknowledged the announce is all that is left.
      cacheTrack(wires.manager, option: option, trackId: 'track-a');
      wires.manager.transceiversManager.markNegotiated([
        _announced(option, trackId: 'track-a', mid: '2'),
      ]);

      stubPeerConnection(wires.pc, failing: true);

      final announced = await wires.manager.getAnnouncedTracksForReconnect();

      expect(announced.single.trackId, 'track-a');
      expect(announced.single.mid, '2');
    });

    test('drops a track that never negotiated a mid', () async {
      final wires = buildManager();
      cacheTrack(wires.manager, option: _option(1), trackId: 'track-a');

      stubPeerConnection(wires.pc, failing: true);

      expect(await wires.manager.getAnnouncedTracksForReconnect(), isEmpty);
    });

    test(
      'still describes a track published before the publisher died',
      () async {
        final wires = buildManager();
        final option = _option(1);
        cacheTrack(wires.manager, option: option, trackId: 'track-a');

        // Publish: the mid resolves off the live publisher and the SFU
        // acknowledges the announce.
        stubPeerConnection(
          wires.pc,
          liveTransceivers: [_transceiver(trackId: 'track-a', mid: '2')],
        );

        final announced = await wires.manager.getAnnouncedTracks();
        wires.manager.transceiversManager.markNegotiated(announced!);

        // The publisher then goes away and a rejoin has to describe it.
        stubPeerConnection(wires.pc, failing: true);

        final reported = await wires.manager.getAnnouncedTracksForReconnect();

        expect(reported.single.mid, '2');
      },
    );

    test(
      'announces a track once even when publishOptions repeats the same '
      'option — a duplicate (trackType, publishOptionId) would collide on '
      'the SFU',
      () async {
        final wires = buildManager();
        final option = _option(1);
        cacheTrack(wires.manager, option: option, trackId: 'track-a');

        // A duplicated option list must not produce a duplicated announce.
        wires.manager.publishOptions = [option, option];

        stubPeerConnection(
          wires.pc,
          liveTransceivers: [_transceiver(trackId: 'track-a', mid: '0')],
        );

        final reported = await wires.manager.getAnnouncedTracksForReconnect();

        expect(reported, hasLength(1));
        expect(reported.single.trackId, 'track-a');
      },
    );
  });

  group('announced video layers', () {
    final videoOption = SfuPublishOptions(
      id: 3,
      codec: const SfuCodec(
        name: 'h264',
        payloadType: 96,
        fmtpLine: '',
        clockRate: 90000,
        encodingParameters: '',
      ),
      trackType: SfuTrackType.video,
    );

    final screenShareOption = SfuPublishOptions(
      id: 4,
      codec: videoOption.codec,
      trackType: SfuTrackType.screenShare,
    );

    /// Caches a camera (or screen share) track that asked for 1280x720 (the
    /// default constraints) and whose platform reports [settings] for it, or
    /// throws [settingsError] when asked for them.
    void cacheVideoTrack(
      RtcManager manager, {
      required String trackId,
      Map<String, dynamic> settings = const {},
      Object? settingsError,
      RtcVideoDimension? resolved,
      SfuTrackType? trackType,
    }) {
      final mediaTrack = _MockMediaStreamTrack();
      when(() => mediaTrack.id).thenReturn(trackId);
      when(() => mediaTrack.kind).thenReturn('video');
      when(() => mediaTrack.enabled).thenReturn(true);
      if (settingsError != null) {
        when(mediaTrack.getSettings).thenThrow(settingsError);
      } else {
        when(mediaTrack.getSettings).thenReturn(settings);
      }

      final isScreenShare = trackType == SfuTrackType.screenShare;
      final type = trackType ?? SfuTrackType.video;
      final track = isScreenShare
          ? RtcLocalTrack<ScreenShareConstraints>(
              trackIdPrefix: 'pub',
              trackType: type,
              mediaStream: _MockMediaStream(),
              mediaTrack: mediaTrack,
              mediaConstraints: const ScreenShareConstraints(),
              videoDimension: resolved,
            )
          : RtcLocalTrack<CameraConstraints>(
              trackIdPrefix: 'pub',
              trackType: type,
              mediaStream: _MockMediaStream(),
              mediaTrack: mediaTrack,
              mediaConstraints: const CameraConstraints(),
              videoDimension: resolved,
            );

      final transceiver = _transceiver(trackId: trackId, mid: '0');
      manager.transceiversManager.add(
        track,
        isScreenShare ? screenShareOption : videoOption,
        transceiver,
        const RtcTrackPublishOptions(),
      );
    }

    Future<List<RtcVideoDimension>> announcedLayers({
      Map<String, dynamic> settings = const {},
      Object? settingsError,
      RtcVideoDimension? resolved,
      SfuTrackType? trackType,
    }) async {
      final wires = buildManager();
      wires.manager.publishOptions = [
        if (trackType == SfuTrackType.screenShare)
          screenShareOption
        else
          videoOption,
      ];
      cacheVideoTrack(
        wires.manager,
        trackId: 'camera',
        settings: settings,
        settingsError: settingsError,
        resolved: resolved,
        trackType: trackType,
      );
      stubPeerConnection(
        wires.pc,
        liveTransceivers: [_transceiver(trackId: 'camera', mid: '0')],
      );

      final announced = await wires.manager.getAnnouncedTracks();
      return announced!.single.layers!
          .map((layer) => layer.parameters.dimension)
          .toList();
    }

    test(
      'are sized from the capture the platform reports, not from what was '
      'requested',
      () async {
        // A 4:3 camera asked for 1280x720 captures at 960x720.
        final layers = await announcedLayers(
          settings: {'width': 960, 'height': 720},
        );

        // q, h, f
        expect(layers, const [
          RtcVideoDimension(width: 240, height: 180),
          RtcVideoDimension(width: 480, height: 360),
          RtcVideoDimension(width: 960, height: 720),
        ]);
      },
    );

    test(
      'fall back to the size resolved at publish for a clone that reports no '
      'settings',
      () async {
        // Clones on Android carry no settings of their own.
        final layers = await announcedLayers(
          resolved: const RtcVideoDimension(width: 960, height: 720),
        );

        expect(layers.last, const RtcVideoDimension(width: 960, height: 720));
      },
    );

    test(
      'fall back to the requested size when nothing better is known',
      () async {
        final layers = await announcedLayers();

        expect(layers.last, const RtcVideoDimension(width: 1280, height: 720));
      },
    );

    group('orientation', () {
      // The sensor reports a landscape capture size.
      const sensorSettings = {'width': 2560, 'height': 1280};

      void setScreen(Size size) {
        final view =
            TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
        view.physicalSize = size;
        addTearDown(view.resetPhysicalSize);
      }

      void setPlatform(PlatformType platform) {
        CurrentPlatform.debugCurrentPlatformOverride = platform;
        addTearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);
      }

      for (final platform in [PlatformType.android, PlatformType.ios]) {
        test(
          'are announced portrait on a portrait $platform screen, matching '
          'the rotated frames the encoder produces',
          () async {
            setPlatform(platform);
            setScreen(const Size(1080, 2400));

            final layers = await announcedLayers(settings: sensorSettings);

            expect(layers, const [
              RtcVideoDimension(width: 320, height: 640),
              RtcVideoDimension(width: 640, height: 1280),
              RtcVideoDimension(width: 1280, height: 2560),
            ]);
          },
        );
      }

      test('stay landscape on a landscape phone screen', () async {
        setPlatform(PlatformType.android);
        setScreen(const Size(2400, 1080));

        final layers = await announcedLayers(settings: sensorSettings);

        expect(layers.last, const RtcVideoDimension(width: 2560, height: 1280));
      });

      test('are left as reported on desktop', () async {
        setPlatform(PlatformType.macOS);
        setScreen(const Size(1080, 2400));

        final layers = await announcedLayers(settings: sensorSettings);

        expect(layers.last, const RtcVideoDimension(width: 2560, height: 1280));
      });

      test('are left as reported when the screen has no size yet', () async {
        setPlatform(PlatformType.android);
        setScreen(Size.zero);

        final layers = await announcedLayers(settings: sensorSettings);

        expect(layers.last, const RtcVideoDimension(width: 2560, height: 1280));
      });

      test('are left as reported on web', () async {
        // Browsers already report the size rotated.
        setPlatform(PlatformType.web);
        setScreen(const Size(1080, 2400));

        final layers = await announcedLayers(settings: sensorSettings);

        expect(layers.last, const RtcVideoDimension(width: 2560, height: 1280));
      });

      test(
        'fall back to the resolved size, still oriented like the view, when '
        'getSettings() throws on Android',
        () async {
          setPlatform(PlatformType.android);
          setScreen(const Size(1080, 2400));

          final layers = await announcedLayers(
            settingsError: Exception('getSettings failed'),
            resolved: const RtcVideoDimension(width: 960, height: 720),
          );

          expect(
            layers.last,
            const RtcVideoDimension(width: 720, height: 960),
          );
        },
      );

      group('for screen share', () {
        test('announce the view size', () async {
          setPlatform(PlatformType.android);
          setScreen(const Size(1080, 2400));

          final layers = await announcedLayers(
            settings: sensorSettings,
            trackType: SfuTrackType.screenShare,
          );

          expect(
            layers.last,
            const RtcVideoDimension(width: 1080, height: 2400),
          );
        });

        test(
          'fall back to the track size, not 0x0, when the view has no size',
          () async {
            setPlatform(PlatformType.android);
            setScreen(Size.zero);

            final layers = await announcedLayers(
              settings: sensorSettings,
              trackType: SfuTrackType.screenShare,
            );

            expect(
              layers.last,
              const RtcVideoDimension(width: 2560, height: 1280),
            );
          },
        );
      });

      group('when the platform reports the size in frame orientation', () {
        test(
          'trust it over the Flutter view, e.g. a tall split-screen window '
          'on a landscape display',
          () async {
            setPlatform(PlatformType.android);
            setScreen(const Size(1080, 2400));

            final layers = await announcedLayers(
              settings: const {
                'width': 2560,
                'height': 1280,
                'sensorOrientation': 90,
              },
            );

            expect(
              layers.last,
              const RtcVideoDimension(width: 2560, height: 1280),
            );
          },
        );

        test('keep a portrait size on a landscape view', () async {
          setPlatform(PlatformType.android);
          setScreen(const Size(2400, 1080));

          final layers = await announcedLayers(
            settings: const {
              'width': 1280,
              'height': 2560,
              'sensorOrientation': 90,
            },
          );

          expect(
            layers.last,
            const RtcVideoDimension(width: 1280, height: 2560),
          );
        });
      });
    });
  });
}

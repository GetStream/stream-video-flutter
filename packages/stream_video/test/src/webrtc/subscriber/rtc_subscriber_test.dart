// ignore_for_file: missing_override_of_must_be_overridden

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/src/webrtc/subscriber/rtc_subscriber.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../fixtures/rtc_manager_fakes.dart';

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

class _FakeRemoteMediaTrack extends FakeMediaStreamTrack {
  _FakeRemoteMediaTrack(super.id, {required super.kind});

  @override
  // ignore: avoid_setters_without_getters
  set onEnded(rtc.StreamTrackCallback? callback) {}
}

class _FakeReceiver extends Fake implements rtc.RTCRtpReceiver {
  _FakeReceiver(this.track);

  @override
  final rtc.MediaStreamTrack? track;
}

class _ReceivingTransceiver extends Fake implements rtc.RTCRtpTransceiver {
  _ReceivingTransceiver(this.receiver);

  @override
  final rtc.RTCRtpReceiver receiver;
}

const _speaker = RtcMediaDevice(
  id: 'speaker-2',
  label: 'Speaker 2',
  kind: RtcMediaDeviceKind.audioOutput,
);

void main() {
  setUpAll(registerRtcManagerFallbacks);

  late MockTracedPeerConnection pc;
  late MockPeerConnection nativePc;
  late List<String> calls;
  late RtcSubscriber subscriber;
  late OnTrack onTrack;

  setUp(() {
    pc = MockTracedPeerConnection();
    nativePc = MockPeerConnection();
    when(() => pc.pc).thenReturn(nativePc);
    calls = [];
    subscriber =
        RtcSubscriber(
            pc: pc,
            attachDecryptor: (track) async =>
                calls.add('decrypt ${track.trackId}'),
            onTrackAdded: (track) => calls.add('added ${track.trackId}'),
          )
          ..onRemoteTrackReceived = (_, track) {
            // Announced before the track is kept.
            calls.add(
              'received ${track.trackId} '
              'kept: ${subscriber.tracks.containsKey(track.trackId)}',
            );
          };
    onTrack =
        verify(() => pc.onTrack = captureAny()).captured.single as OnTrack;
  });

  /// Delivers a remote track of [kind] in a stream named [streamId], as the
  /// peer connection does.
  RtcRemoteTrack deliver(String streamId, {String kind = 'audio'}) {
    onTrack(
      pc,
      _FakeTrackEvent(_FakeRemoteMediaTrack('$streamId-track', kind: kind), [
        _FakeRemoteStream(streamId),
      ]),
    );
    return subscriber.tracks.values.last;
  }

  group('offer', () {
    test('applies the offer and returns the answer', () async {
      when(
        () => pc.setRemoteOffer(any()),
      ).thenAnswer((_) async => const Result<void>.success(null));
      when(() => pc.createAnswer(any())).thenAnswer(
        (_) async => Result.success(rtc.RTCSessionDescription('v=1', 'answer')),
      );

      expect(await subscriber.onOffer('v=0'), 'v=1');
    });

    test('returns null when the offer cannot be applied', () async {
      when(
        () => pc.setRemoteOffer(any()),
      ).thenAnswer((_) async => failureWithError('bad offer'));

      expect(await subscriber.onOffer('v=0'), isNull);
      verifyNever(() => pc.createAnswer(any()));
    });
  });

  group('a remote track', () {
    test('is kept by id, decrypted and announced, in that order', () {
      final track = deliver('alice:TRACK_TYPE_AUDIO');

      expect(track.trackIdPrefix, 'alice');
      expect(track.trackType, SfuTrackType.audio);
      expect(subscriber.tracks, {track.trackId: track});
      expect(calls, [
        'decrypt ${track.trackId}',
        'received ${track.trackId} kept: false',
        'added ${track.trackId}',
      ]);
    });

    test('without a stream is ignored', () {
      onTrack(
        pc,
        _FakeTrackEvent(_FakeRemoteMediaTrack('orphan', kind: 'audio'), []),
      );

      expect(subscriber.tracks, isEmpty);
      expect(calls, isEmpty);
    });

    test('is stopped and dropped by removeTrack', () async {
      final track = deliver('alice:TRACK_TYPE_VIDEO', kind: 'video');

      expect(await subscriber.removeTrack(track.trackId), isTrue);
      expect(subscriber.tracks, isEmpty);
      expect(track.mediaTrack.enabled, isFalse);
      expect(await subscriber.removeTrack(track.trackId), isFalse);
    });
  });

  group('receiverFor', () {
    test('finds the receiver among the live transceivers', () async {
      final track = deliver('alice:TRACK_TYPE_AUDIO');
      final receiver = _FakeReceiver(track.mediaTrack);
      when(nativePc.getTransceivers).thenAnswer(
        (_) async => [_ReceivingTransceiver(receiver)],
      );

      expect(await subscriber.receiverFor(track), same(receiver));
    });

    test('is null without a live match or a transceiver of its own', () async {
      final track = deliver('alice:TRACK_TYPE_AUDIO');
      when(nativePc.getTransceivers).thenThrow(StateError('closed'));

      expect(await subscriber.receiverFor(track), isNull);
    });
  });

  group('audio output', () {
    test('setAudioSink moves every remote audio track to the device', () async {
      final audio = deliver('alice:TRACK_TYPE_AUDIO');

      final result = await subscriber.setAudioSink(_speaker);

      expect(result.isSuccess, isTrue);
      expect(subscriber.tracks[audio.trackId]!.audioSinkId, 'speaker-2');
    });

    test('useAudioOutput records the device on audio tracks only', () {
      final audio = deliver('alice:TRACK_TYPE_AUDIO');
      final video = deliver('alice:TRACK_TYPE_VIDEO', kind: 'video');

      subscriber.useAudioOutput(_speaker, subscriber.audioTracks);

      expect(subscriber.tracks[audio.trackId]!.audioSinkId, 'speaker-2');
      expect(subscriber.tracks[video.trackId]!.audioSinkId, isNull);
    });
  });
}

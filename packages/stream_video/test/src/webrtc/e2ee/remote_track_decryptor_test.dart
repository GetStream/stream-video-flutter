import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/webrtc/e2ee/remote_track_decryptor.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../fixtures/rtc_manager_fakes.dart';

class _MockEncryptionManager extends Mock implements rtc.EncryptionManager {}

class _FakeReceiver extends Fake implements rtc.RTCRtpReceiver {}

RtcRemoteTrack _remoteTrack(String prefix, {String id = 'remote'}) {
  return RtcRemoteTrack(
    trackIdPrefix: prefix,
    trackType: SfuTrackType.video,
    mediaStream: FakeMediaStream(),
    mediaTrack: FakeMediaStreamTrack('$prefix-$id', kind: 'video'),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeReceiver());
  });

  late _MockEncryptionManager e2ee;
  late Map<String, String> userIdByPrefix;
  late rtc.RTCRtpReceiver? receiver;
  late List<String> decryptedFor;

  setUp(() {
    e2ee = _MockEncryptionManager();
    userIdByPrefix = {};
    receiver = _FakeReceiver();
    decryptedFor = [];
    when(
      () => e2ee.decrypt(
        any(),
        userId: any(named: 'userId'),
        trackType: any(named: 'trackType'),
      ),
    ).thenAnswer((invocation) async {
      decryptedFor.add(invocation.namedArguments[#userId] as String);
    });
  });

  RemoteTrackDecryptor decryptor({bool encrypted = true}) {
    return RemoteTrackDecryptor(
      manager: encrypted ? e2ee : null,
      userIdForTrackPrefix: (prefix) => userIdByPrefix[prefix],
      receiverFor: (_) async => receiver,
    );
  }

  test('decrypts a track whose participant is known', () async {
    userIdByPrefix['alice-prefix'] = 'alice';

    await decryptor().attach(_remoteTrack('alice-prefix'));

    verify(
      () => e2ee.decrypt(
        receiver!,
        userId: 'alice',
        trackType: rtc.E2eeTrackType.video,
      ),
    ).called(1);
  });

  test('queues a track until its participant is known', () async {
    final remote = decryptor();
    await remote.attach(_remoteTrack('alice-prefix'));
    expect(decryptedFor, isEmpty);

    userIdByPrefix['alice-prefix'] = 'alice';
    await remote.flush();

    expect(decryptedFor, ['alice']);
  });

  test('a flushed track is attached once', () async {
    final remote = decryptor();
    await remote.attach(_remoteTrack('alice-prefix'));
    userIdByPrefix['alice-prefix'] = 'alice';

    await remote.flush();
    await remote.flush();

    expect(decryptedFor, ['alice']);
  });

  test('a track still waiting stays queued through a flush', () async {
    final remote = decryptor();
    await remote.attach(_remoteTrack('alice-prefix'));

    await remote.flush();
    userIdByPrefix['alice-prefix'] = 'alice';
    await remote.flush();

    expect(decryptedFor, ['alice']);
  });

  test('discard drops the queued tracks of one participant only', () async {
    final remote = decryptor();
    await remote.attach(_remoteTrack('alice-prefix'));
    await remote.attach(_remoteTrack('bob-prefix'));

    remote.discard('alice-prefix');
    userIdByPrefix
      ..['alice-prefix'] = 'alice'
      ..['bob-prefix'] = 'bob';
    await remote.flush();

    expect(decryptedFor, ['bob']);
  });

  test('clear drops every queued track', () async {
    final remote = decryptor();
    await remote.attach(_remoteTrack('alice-prefix'));

    remote.clear();
    userIdByPrefix['alice-prefix'] = 'alice';
    await remote.flush();

    expect(decryptedFor, isEmpty);
  });

  test('a track without a receiver is skipped', () async {
    userIdByPrefix['alice-prefix'] = 'alice';
    receiver = null;

    await decryptor().attach(_remoteTrack('alice-prefix'));

    expect(decryptedFor, isEmpty);
  });

  test('a failing decrypt does not throw', () async {
    userIdByPrefix['alice-prefix'] = 'alice';
    when(
      () => e2ee.decrypt(
        any(),
        userId: any(named: 'userId'),
        trackType: any(named: 'trackType'),
      ),
    ).thenThrow(StateError('key missing'));

    await expectLater(
      decryptor().attach(_remoteTrack('alice-prefix')),
      completes,
    );
  });

  test('an unencrypted call does nothing', () async {
    final remote = decryptor(encrypted: false);
    await remote.attach(_remoteTrack('alice-prefix'));
    userIdByPrefix['alice-prefix'] = 'alice';
    await remote.flush();

    verifyNever(
      () => e2ee.decrypt(
        any(),
        userId: any(named: 'userId'),
        trackType: any(named: 'trackType'),
      ),
    );
  });
}

// ignore_for_file: missing_override_of_must_be_overridden

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../test_helpers.dart';
import '../../call/fixtures/call_test_helpers.dart';
import '../../call/fixtures/data.dart';

// Shared fakes for the RtcManager characterisation tests. Every fake keeps
// the state a real one would (the sender follows `replaceTrack`, a track
// remembers it was stopped), so a test asserts on outcomes rather than on
// call sequences.

class MockTracedPeerConnection extends Mock
    implements TracedStreamPeerConnection {}

class MockPeerConnection extends Mock implements rtc.RTCPeerConnection {}

class MockPcFactory extends Mock implements StreamPeerConnectionFactory {}

const opusCodec = SfuCodec(
  name: 'opus',
  payloadType: 111,
  fmtpLine: '',
  clockRate: 48000,
  encodingParameters: '',
);

const vp8Codec = SfuCodec(
  name: 'vp8',
  payloadType: 96,
  fmtpLine: '',
  clockRate: 90000,
  encodingParameters: '',
);

const vp9Codec = SfuCodec(
  name: 'vp9',
  payloadType: 98,
  fmtpLine: '',
  clockRate: 90000,
  encodingParameters: '',
);

SfuPublishOptions publishOption(
  int id,
  SfuTrackType trackType, {
  SfuCodec? codec,
}) {
  return SfuPublishOptions(
    id: id,
    codec:
        codec ??
        (trackType == SfuTrackType.audio ||
                trackType == SfuTrackType.screenShareAudio
            ? opusCodec
            : vp8Codec),
    trackType: trackType,
  );
}

/// A media track that records being stopped and hands out clones that are
/// fakes of their own.
class FakeMediaStreamTrack extends Fake implements rtc.MediaStreamTrack {
  FakeMediaStreamTrack(this.id, {required this.kind});

  @override
  final String id;

  @override
  final String kind;

  @override
  bool enabled = true;

  int stopCount = 0;
  bool get stopped => stopCount > 0;

  /// Every clone handed out so far, in order.
  final clones = <FakeMediaStreamTrack>[];

  /// When set, [clone] waits for it before returning.
  Completer<void>? cloneGate;

  @override
  Future<void> stop() async => stopCount++;

  @override
  Future<rtc.MediaStreamTrack> clone() async {
    final clone = FakeMediaStreamTrack(
      '$id-clone-${clones.length}',
      kind: kind,
    );
    clones.add(clone);
    await cloneGate?.future;
    return clone;
  }

  @override
  Map<String, dynamic> getSettings() => const {};

  @override
  String toString() => 'FakeMediaStreamTrack($id)';
}

class FakeMediaStream extends Fake implements rtc.MediaStream {
  int disposeCount = 0;

  @override
  String get id => 'fake-stream';

  @override
  Future<void> dispose() async => disposeCount++;
}

/// A sender that holds whatever track it was last given and keeps the
/// parameters it was last set to, as a real one does.
class FakeSender extends Fake implements rtc.RTCRtpSender {
  FakeSender(this.track, {List<rtc.RTCRtpEncoding>? encodings})
    : parameters = rtc.RTCRtpParameters(encodings: encodings ?? []);

  @override
  rtc.MediaStreamTrack? track;

  @override
  rtc.RTCRtpParameters parameters;

  /// The parameters of every `setParameters` call, in order.
  final setParametersCalls = <rtc.RTCRtpParameters>[];

  /// The tracks of every `replaceTrack` call, in order.
  final replacedTracks = <rtc.MediaStreamTrack?>[];

  @override
  Future<void> replaceTrack(rtc.MediaStreamTrack? track) async {
    replacedTracks.add(track);
    this.track = track;
  }

  @override
  Future<bool> setParameters(rtc.RTCRtpParameters parameters) async {
    setParametersCalls.add(parameters);
    this.parameters = parameters;
    return true;
  }
}

class FakeTransceiver extends Fake implements rtc.RTCRtpTransceiver {
  FakeTransceiver(this.sender);

  @override
  final FakeSender sender;

  @override
  String get mid => '';

  int stopCount = 0;

  @override
  Future<void> stop() async => stopCount++;
}

RtcLocalTrack<T> fakeLocalTrack<T extends MediaConstraints>(
  String mediaId, {
  required SfuTrackType trackType,
  required T constraints,
  required String kind,
  String trackIdPrefix = 'test-publisher',
}) {
  return RtcLocalTrack(
    trackIdPrefix: trackIdPrefix,
    trackType: trackType,
    mediaStream: FakeMediaStream(),
    mediaTrack: FakeMediaStreamTrack(mediaId, kind: kind),
    mediaConstraints: constraints,
  );
}

RtcLocalAudioTrack fakeAudioTrack(String mediaId) => fakeLocalTrack(
  mediaId,
  trackType: SfuTrackType.audio,
  constraints: const AudioConstraints(),
  kind: 'audio',
);

RtcLocalCameraTrack fakeCameraTrack(String mediaId) => fakeLocalTrack(
  mediaId,
  trackType: SfuTrackType.video,
  constraints: const CameraConstraints(),
  kind: 'video',
);

RtcLocalScreenShareTrack fakeScreenShareTrack(String mediaId) => fakeLocalTrack(
  mediaId,
  trackType: SfuTrackType.screenShare,
  constraints: const ScreenShareConstraints(),
  kind: 'video',
);

/// The media track [track] holds, as the fake it was built with.
FakeMediaStreamTrack fakeMediaOf(RtcTrack track) {
  return track.mediaTrack as FakeMediaStreamTrack;
}

/// Answers an `add*Transceiver` call: the track handed to the platform and
/// the encodings it was asked to send with.
typedef AddTransceiverHandler =
    Future<Result<rtc.RTCRtpTransceiver>> Function(
      rtc.MediaStreamTrack track,
      List<rtc.RTCRtpEncoding> encodings,
    );

/// A [RtcManager] wired to a mocked publisher whose transceivers are
/// [FakeTransceiver]s.
class RtcManagerFixture {
  RtcManagerFixture({
    List<SfuPublishOptions> publishOptions = const [],
    StreamPeerConnectionFactory? pcFactory,
    CallStateNotifier? stateManager,
    CallHost? host,
    bool withPublisher = true,
  }) {
    when(() => publisherMock.pc).thenReturn(pc);
    when(() => publisherMock.isReconnecting).thenReturn(false);
    when(() => publisherMock.onRenegotiationNeeded).thenReturn(null);
    when(publisherMock.dispose).thenAnswer((_) async {});
    when(() => pc.removeTrack(any())).thenAnswer((invocation) async {
      removedSenders.add(invocation.positionalArguments.first as FakeSender);
      return true;
    });

    when(
      () => publisherMock.addVideoTransceiver(
        track: any(named: 'track'),
        encodings: any(named: 'encodings'),
        degradationPreference: any(named: 'degradationPreference'),
      ),
    ).thenAnswer(
      (invocation) => _onAdd(invocation, onAddVideoTransceiver),
    );
    when(
      () => publisherMock.addAudioTransceiver(
        track: any(named: 'track'),
        encodings: any(named: 'encodings'),
      ),
    ).thenAnswer(
      (invocation) => _onAdd(invocation, onAddAudioTransceiver),
    );

    when(subscriber.dispose).thenAnswer((_) async {});

    manager = RtcManager(
      sessionId: 'test-session',
      callCid: SampleCallData.defaultCid,
      publisherId: 'test-publisher',
      publisher: withPublisher ? publisherMock : null,
      subscriber: subscriber,
      publishOptions: publishOptions,
      stateManager: stateManager ?? createTestCallStateManager(),
      host: host ?? setupMockCallHost(),
      pcFactory: pcFactory ?? fakePcFactory(),
    );
  }

  final publisherMock = MockTracedPeerConnection();
  final subscriber = MockTracedPeerConnection();
  final pc = MockPeerConnection();
  late final RtcManager manager;

  /// Every transceiver the publisher created, in order.
  final transceivers = <FakeTransceiver>[];

  /// Every sender passed to `pc.removeTrack`, in order.
  final removedSenders = <FakeSender>[];

  /// Overrides how the publisher answers `addVideoTransceiver`. Defaults to a
  /// new [FakeTransceiver] sending the given track.
  AddTransceiverHandler? onAddVideoTransceiver;

  /// Overrides how the publisher answers `addAudioTransceiver`.
  AddTransceiverHandler? onAddAudioTransceiver;

  Future<Result<rtc.RTCRtpTransceiver>> _onAdd(
    Invocation invocation,
    AddTransceiverHandler? handler,
  ) {
    final track = invocation.namedArguments[#track] as rtc.MediaStreamTrack;
    final encodings =
        invocation.namedArguments[#encodings] as List<rtc.RTCRtpEncoding>? ??
        const [];
    if (handler != null) return handler(track, encodings);
    return Future.value(Result.success(newTransceiver(track, encodings)));
  }

  /// A [FakeTransceiver] sending [track], recorded in [transceivers].
  FakeTransceiver newTransceiver(
    rtc.MediaStreamTrack track, [
    List<rtc.RTCRtpEncoding> encodings = const [],
  ]) {
    final transceiver = FakeTransceiver(
      FakeSender(track, encodings: [...encodings]),
    );
    transceivers.add(transceiver);
    return transceiver;
  }
}

/// A factory without Apple ADM mute support, so no test reaches a platform
/// audio call.
MockPcFactory fakePcFactory() {
  final factory = MockPcFactory();
  when(() => factory.isAppleAdmMicrophoneMuteSupported).thenReturn(false);
  when(factory.ensureNativeFactory).thenAnswer((_) async => null);
  return factory;
}

/// A [CallStateNotifier] whose state can be swapped between reads.
class MutableCallStateManager {
  MutableCallStateManager() {
    when(() => mock.callState).thenAnswer((_) => state);
  }

  final mock = MockCallStateNotifier();
  CallState state = createTestCallState();
}

void registerRtcManagerFallbacks() {
  registerMockFallbackValues();
  registerFallbackValue(FakeMediaStreamTrack('fallback', kind: 'video'));
  registerFallbackValue(FakeSender(null));
  registerFallbackValue(<rtc.RTCRtpEncoding>[]);
}

/// Stands in for the native side of `stream_webrtc_flutter`, answering the
/// method calls the media paths make on the VM: `getUserMedia`,
/// `getDisplayMedia`, `trackClone`, `mediaStreamTrackSwitchCamera`,
/// `getSources`, and `createPeerConnection`, `addTransceiver` and
/// `createOffer` for a throwaway peer connection. Everything else answers
/// null.
class FakeWebRtcPlatform {
  static const _methods = MethodChannel('FlutterWebRTC.Method');
  static const _events = EventChannel('FlutterWebRTC.Event');

  /// Every method call received, in order.
  final calls = <MethodCall>[];

  /// The settings reported for every track `getUserMedia` creates.
  Map<String, Object?> trackSettings = const {};

  /// When set, `getUserMedia` fails with it.
  PlatformException? getUserMediaError;

  /// What `mediaStreamTrackSwitchCamera` reports: true for the front camera.
  bool switchesToFrontCamera = false;

  /// The devices `getSources` reports.
  List<Map<String, Object?>> sources = const [];

  var _nextId = 0;
  final _kindByTrackId = <String, String>{};

  TestDefaultBinaryMessenger get _messenger =>
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  void install() {
    _messenger
      ..setMockMethodCallHandler(_methods, _handle)
      ..setMockStreamHandler(
        _events,
        MockStreamHandler.inline(onListen: (_, _) {}),
      );
  }

  void uninstall() {
    _messenger
      ..setMockMethodCallHandler(_methods, null)
      ..setMockStreamHandler(_events, null);
  }

  /// The method calls received for [method].
  Iterable<MethodCall> callsOf(String method) {
    return calls.where((call) => call.method == method);
  }

  /// The ids of the tracks stopped through the platform.
  List<String> get disposedTrackIds => [
    for (final call in callsOf('trackDispose'))
      (call.arguments as Map)['trackId'] as String,
  ];

  /// Emits a native WebRTC event, as the plugin's event channel does.
  ///
  /// Sent straight to the channel rather than through the mock stream
  /// handler: the plugin listens once per isolate, so a handler installed by
  /// a later test never sees a listen of its own.
  Future<void> emitEvent(
    String event, [
    Map<String, Object?> data = const {},
  ]) async {
    await _messenger.handlePlatformMessage(
      _events.name,
      const StandardMethodCodec().encodeSuccessEnvelope({
        'event': event,
        ...data,
      }),
      (_) {},
    );
  }

  Future<Object?> _handle(MethodCall call) async {
    calls.add(call);
    switch (call.method) {
      case 'getUserMedia':
        final error = getUserMediaError;
        if (error != null) throw error;
        return _stream(call);
      case 'getDisplayMedia':
        return _stream(call);
      case 'trackClone':
        final trackId = (call.arguments as Map)['trackId'] as String;
        return _track(
          '$trackId-clone-${_nextId++}',
          kind: _kindByTrackId[trackId] ?? 'video',
        );
      case 'mediaStreamTrackSwitchCamera':
        return switchesToFrontCamera;
      case 'getSources':
        return {'sources': sources};
      case 'createPeerConnection':
        return {'peerConnectionId': 'pc-${_nextId++}'};
      case 'addTransceiver':
        return _transceiver(call);
      case 'createOffer':
        final peerConnectionId = (call.arguments as Map)['peerConnectionId'];
        return {'sdp': 'v=0 $peerConnectionId', 'type': 'offer'};
      default:
        return null;
    }
  }

  Map<String, Object?> _stream(MethodCall call) {
    final constraints =
        (call.arguments as Map)['constraints'] as Map<Object?, Object?>;
    final audio = constraints['audio'];
    final video = constraints['video'];
    final id = _nextId++;

    return {
      'streamId': 'stream-$id',
      'audioTracks': [
        if (audio != null && audio != false) _track('audio-$id', kind: 'audio'),
      ],
      'videoTracks': [
        if (video != null && video != false) _track('video-$id', kind: 'video'),
      ],
    };
  }

  Map<String, Object?> _transceiver(MethodCall call) {
    final arguments = call.arguments as Map;
    final init = arguments['transceiverInit'] as Map?;
    final kind = arguments['mediaType'] == 'audio' ? 'audio' : 'video';
    const rtpParameters = {
      'encodings': <Object?>[],
      'headerExtensions': <Object?>[],
      'codecs': <Object?>[],
      'rtcp': {'cname': '', 'reducedSize': false},
    };
    final id = _nextId++;

    return {
      'transceiverId': 'transceiver-$id',
      'direction': init?['direction'] ?? 'sendrecv',
      'mid': '',
      'sender': {
        'senderId': 'sender-$id',
        'track': <String, Object?>{},
        'rtpParameters': rtpParameters,
        'ownsTrack': false,
      },
      'receiver': {
        'receiverId': 'receiver-$id',
        'track': _track('receiver-track-$id', kind: kind),
        'rtpParameters': rtpParameters,
      },
    };
  }

  Map<String, Object?> _track(String id, {required String kind}) {
    _kindByTrackId[id] = kind;
    return {
      'id': id,
      'label': id,
      'kind': kind,
      'enabled': true,
      'settings': trackSettings,
    };
  }
}

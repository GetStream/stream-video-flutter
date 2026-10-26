import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('FlutterWebRTC.Method');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  /// The options passed to the last `createPeerConnectionFactory` call.
  Map<Object?, Object?>? factoryOptions;

  setUp(() {
    factoryOptions = null;
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'createPeerConnectionFactory') {
        final arguments = call.arguments as Map<Object?, Object?>;
        factoryOptions = arguments['options'] as Map<Object?, Object?>?;
        return {'factoryId': 'factory-1'};
      }
      return null;
    });
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    CurrentPlatform.debugCurrentPlatformOverride = null;
  });

  /// The Apple category options the factory is built with under [policy].
  Future<List<Object?>> appleCategoryOptions(
    AudioConfigurationPolicy policy,
  ) async {
    final factory = StreamPeerConnectionFactory(
      callCid: StreamCallCid(cid: 'default:test'),
      audioConfigurationPolicy: policy,
    );

    final nativeFactory = await factory.ensureNativeFactory();
    expect(nativeFactory, isNotNull);

    final appleConfiguration =
        factoryOptions!['appleAudioConfiguration']! as Map<Object?, Object?>;
    return appleConfiguration['appleAudioCategoryOptions']! as List<Object?>;
  }

  group('StreamPeerConnectionFactory.ensureNativeFactory on iOS', () {
    test('asks for the loudspeaker under the viewer policy', () async {
      expect(
        await appleCategoryOptions(const AudioConfigurationPolicy.viewer()),
        contains('defaultToSpeaker'),
      );
    });

    test('asks for the loudspeaker under a custom policy based on the viewer '
        'policy', () async {
      expect(
        await appleCategoryOptions(
          const AudioConfigurationPolicy.custom(
            basePolicy: AudioConfigurationPolicy.viewer(),
          ),
        ),
        contains('defaultToSpeaker'),
      );
    });

    test(
      'does not ask for the loudspeaker under the broadcaster and HiFi '
      'policies, or a custom policy that opts out',
      () async {
        for (final policy in const [
          AudioConfigurationPolicy.broadcaster(),
          AudioConfigurationPolicy.hiFi(),
          AudioConfigurationPolicy.custom(
            basePolicy: AudioConfigurationPolicy.viewer(),
            defaultsToSpeaker: false,
          ),
        ]) {
          expect(
            await appleCategoryOptions(policy),
            isNot(contains('defaultToSpeaker')),
            reason: '${policy.runtimeType}',
          );
        }
      },
    );
  });
}

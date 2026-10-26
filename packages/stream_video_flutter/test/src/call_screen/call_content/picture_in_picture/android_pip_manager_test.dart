import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

const _channel = MethodChannel('stream_video_flutter_android_pip');

// The manager hands Android the params of the view that set them last, and
// sends them again whenever Android may have lost them.

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final manager = AndroidPipManager.instance();
  late List<Object?> sent;
  late bool hasHandler;

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    manager.debugResetPictureInPictureParams();
    sent = [];
    hasHandler = true;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          if (call.method != 'setPictureInPictureParams') return null;
          // As when no activity has attached a handler to the channel.
          if (!hasHandler) throw MissingPluginException();
          sent.add(call.arguments);
          return null;
        });
  });

  tearDown(() {
    CurrentPlatform.debugCurrentPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
    manager.debugResetPictureInPictureParams();
  });

  Future<void> handlerAttached() async {
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
          _channel.name,
          _channel.codec.encodeMethodCall(
            const MethodCall('onPictureInPictureHandlerAttached'),
          ),
          (_) {},
        );
  }

  const portrait = Size(1080, 1920);
  const landscape = Size(1920, 1080);
  const portraitParams = {'width': 1080, 'height': 1920};
  const landscapeParams = {'width': 1920, 'height': 1080};
  final first = Object();
  final second = Object();

  test('sends the params of the view that set them last', () async {
    await manager.setPictureInPictureParams(owner: first, videoSize: portrait);
    await manager.setPictureInPictureParams(
      owner: second,
      videoSize: landscape,
    );

    expect(sent, [portraitParams, landscapeParams]);
  });

  test('sends the same params once', () async {
    await manager.setPictureInPictureParams(owner: first, videoSize: portrait);
    await manager.setPictureInPictureParams(owner: first, videoSize: portrait);

    expect(sent, [portraitParams]);
  });

  test('hands over to the view before when the last one clears', () async {
    await manager.setPictureInPictureParams(owner: first, videoSize: portrait);
    await manager.setPictureInPictureParams(
      owner: second,
      videoSize: landscape,
    );

    await manager.clearPictureInPictureParams(owner: second);

    expect(sent.last, portraitParams);
  });

  test('keeps the last view when an earlier one clears', () async {
    await manager.setPictureInPictureParams(owner: first, videoSize: portrait);
    await manager.setPictureInPictureParams(
      owner: second,
      videoSize: landscape,
    );

    await manager.clearPictureInPictureParams(owner: first);

    expect(sent, [portraitParams, landscapeParams]);
  });

  test('falls back to no params once every view has cleared', () async {
    await manager.setPictureInPictureParams(owner: first, videoSize: portrait);

    await manager.clearPictureInPictureParams(owner: first);

    expect(sent.last, isEmpty);
  });

  test('sends the params again when an activity attaches', () async {
    await manager.setPictureInPictureParams(owner: first, videoSize: portrait);

    // The activity they went to has gone, and a new one took the engine.
    await handlerAttached();

    expect(sent, [portraitParams, portraitParams]);
  });

  test('stops sending without a handler, until one attaches', () async {
    hasHandler = false;
    await manager.setPictureInPictureParams(owner: first, videoSize: portrait);
    await manager.setPictureInPictureParams(
      owner: first,
      videoSize: landscape,
    );
    expect(sent, isEmpty);

    hasHandler = true;
    // Not tried again until then.
    await manager.setPictureInPictureParams(owner: first, videoSize: portrait);
    expect(sent, isEmpty);

    await handlerAttached();

    expect(sent, [portraitParams]);
  });
}

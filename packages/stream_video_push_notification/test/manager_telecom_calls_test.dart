import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: implementation_imports
import 'package:stream_video/src/core/client_state.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:stream_video_push_notification/stream_video_push_notification_platform_interface.dart';

// Pins that the manager tells core which calls Telecom holds: those already
// held as it starts, and every change the plugin reports after.

class _TelecomPlatform extends StreamVideoPushNotificationPlatform {
  final events = StreamController<RingingEvent?>.broadcast();
  final heldCids = Completer<List<String>>();

  @override
  Future<void> init(Map<String, dynamic> pushConfiguration) async {}

  @override
  Stream<RingingEvent?> get onEvent => events.stream;

  @override
  Future<List<CallData>> activeCalls() async => const [];

  @override
  Future<List<String>> telecomCallCids() => heldCids.future;

  void report(List<String> callCids) => events.add(
    ActionCallCustom({'type': 'telecomCallsChanged', 'callCids': callCids}),
  );
}

class _MockCoordinatorClient extends Mock implements CoordinatorClient {}

// ignore: subtype_of_sealed_class
class _MockStreamVideo extends Mock implements StreamVideo {
  @override
  StreamVideoOptions get options => StreamVideoOptions();

  // StreamVideo marks dispose as @mustBeOverridden.
  @override
  Future<void> dispose() =>
      noSuchMethod(Invocation.method(#dispose, const [])) as Future<void>;
}

class _MockClientState extends Mock implements ClientState {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _TelecomPlatform platform;
  late StreamVideoPushNotificationManager manager;
  late List<Set<String>> held;

  setUp(() {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    platform = _TelecomPlatform();
    StreamVideoPushNotificationPlatform.instance = platform;
    SharedPreferences.setMockInitialValues({});

    final state = _MockClientState();
    when(
      () => state.activeCalls,
    ).thenAnswer((_) => MutableStateEmitter<List<Call>>(const <Call>[]));
    when(
      () => state.outgoingCall,
    ).thenAnswer((_) => MutableStateEmitter<Call?>(null));
    final streamVideo = _MockStreamVideo();
    when(() => streamVideo.state).thenReturn(state);

    manager = StreamVideoPushNotificationManager.create(
      iosPushProvider: const StreamVideoPushProvider.apn(name: 'apn'),
      androidPushProvider: const StreamVideoPushProvider.firebase(name: 'fcm'),
    )(_MockCoordinatorClient(), streamVideo);

    held = [];
    final subscription = manager.systemManagedCallCids.listen(held.add);
    addTearDown(() async {
      await subscription.cancel();
      await manager.dispose();
      await platform.events.close();
    });
  });

  tearDown(() {
    CurrentPlatform.debugCurrentPlatformOverride = null;
  });

  test('reads the calls Telecom already holds as it starts', () async {
    platform.heldCids.complete(['default:c1']);
    await pumpEventQueue();

    expect(held, [
      <String>{},
      {'default:c1'},
    ]);
  });

  test('follows the calls the plugin reports', () async {
    platform.heldCids.complete(const []);
    await pumpEventQueue();

    platform.report(['default:c1']);
    await pumpEventQueue();
    platform.report(['default:c1']);
    platform.report([]);
    await pumpEventQueue();

    expect(held, [
      <String>{},
      {'default:c1'},
      <String>{},
    ]);
  });

  test('a report before the read answers wins over the read', () async {
    platform.report(['default:c2']);
    await pumpEventQueue();
    platform.heldCids.complete(['default:c1']);
    await pumpEventQueue();

    expect(held, [
      <String>{},
      {'default:c2'},
    ]);
  });
}

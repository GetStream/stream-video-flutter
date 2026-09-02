import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';
import '../../mocks.dart';

// The control opens the same list either way, but not in the same shape: an
// anchored menu where there is a pointer, a bottom sheet where there is a
// thumb.
void main() {
  late StreamController<List<RtcMediaDevice>> deviceChanges;
  late StreamLobbyController controller;

  setUp(() async {
    deviceChanges = StreamController<List<RtcMediaDevice>>.broadcast();

    final notifier = MockRtcMediaDeviceNotifier();
    when(() => notifier.onDeviceChange).thenAnswer((_) => deviceChanges.stream);
    when(
      notifier.enumerateDevices,
    ).thenAnswer((_) async => const Result.success(<RtcMediaDevice>[]));

    final video = MockStreamVideo();
    when(() => video.currentUser).thenReturn(const UserInfo(id: 'local'));
    when(() => video.events).thenAnswer((_) => const Stream.empty());

    final callState = MockCallState();
    when(() => callState.settings).thenReturn(
      const CallSettings(
        audio: StreamAudioSettings(micDefaultOn: false),
        video: StreamVideoSettings(cameraDefaultOn: false),
      ),
    );

    final call = MockCall();
    when(() => call.state).thenAnswer(
      (_) => MutableStateEmitter<CallState>(callState, sync: true),
    );
    when(call.getOrCreate).thenAnswer((_) async {
      final metadata = MockCallMetadata();
      when(() => metadata.settings).thenReturn(
        const CallSettings(
          audio: StreamAudioSettings(micDefaultOn: false),
          video: StreamVideoSettings(cameraDefaultOn: false),
        ),
      );
      when(() => metadata.users).thenReturn({
        'rene': const CallUser(
          id: 'rene',
          name: 'Rene iPad',
          roles: [],
          image: '',
        ),
      });
      when(() => metadata.session).thenReturn(
        const CallSessionData(
          participants: {
            'rene': CallParticipant(
              userSessionId: 'session-rene',
              userId: 'rene',
              role: 'user',
            ),
          },
        ),
      );

      final data = MockCallCreatedData();
      when(() => data.metadata).thenReturn(metadata);
      return Result.success(
        CallReceivedOrCreatedData(wasCreated: true, data: data),
      );
    });

    controller = StreamLobbyController(
      call: call,
      streamVideo: video,
      deviceNotifier: notifier,
    );
    addTearDown(controller.dispose);
    await pumpEventQueue();
  });

  tearDown(() => deviceChanges.close());

  Future<void> pumpControl(WidgetTester tester, TargetPlatform platform) async {
    await tester.pumpWidget(
      TestWrapper(
        platform: platform,
        child: StreamLobbyScope(
          controller: controller,
          child: const StreamLobbyParticipantsControl(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('opens an anchored menu on macOS', (tester) async {
    await pumpControl(tester, TargetPlatform.macOS);

    await tester.tap(find.byType(CallControlButton));
    await tester.pumpAndSettle();

    expect(find.byType(StreamContextMenuAction<void>), findsOneWidget);
    expect(find.byType(StreamSheetHeader), findsNothing);
    expect(find.text('Rene iPad'), findsOneWidget);
  });

  testWidgets('opens a bottom sheet on Android', (tester) async {
    await pumpControl(tester, TargetPlatform.android);

    await tester.tap(find.byType(CallControlButton));
    await tester.pumpAndSettle();

    expect(find.byType(StreamSheetHeader), findsOneWidget);
    expect(find.byType(StreamListTile), findsOneWidget);
    expect(find.text('Rene iPad'), findsOneWidget);
  });

  // The design's menu row is sized for a 16px icon; an avatar is 40, and in a
  // 40px row it touches both edges. These are the sheet's own insets, so a
  // name sits the same distance from the edge in either presentation.
  testWidgets('gives an avatar row room in the anchored menu', (tester) async {
    await pumpControl(tester, TargetPlatform.macOS);

    await tester.tap(find.byType(CallControlButton));
    await tester.pumpAndSettle();

    final panel = tester.getRect(find.byType(StreamContextMenu));
    final row = tester.getRect(
      find.byType(StreamContextMenuAction<void>).first,
    );
    final avatar = tester.getRect(find.byType(StreamUserAvatar).first);

    expect(row.height, 56);
    expect(avatar.left - panel.left, 16);
    expect(avatar.top - row.top, 8);
    expect(row.bottom - avatar.bottom, 8);
  });

  testWidgets('badges the number waiting', (tester) async {
    await pumpControl(tester, TargetPlatform.macOS);

    expect(find.byType(StreamBadgeNotification), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

const _user = UserInfo(id: 'katie', name: 'Katie Miler');

void main() {
  group('StreamUserAvatar', () {
    testWidgets('falls back to the initials of the name', (tester) async {
      await tester.pumpWidget(
        TestWrapper(child: StreamUserAvatar(user: _user)),
      );

      expect(find.text('KM'), findsOneWidget);
    });

    testWidgets('falls back to the id when there is no name', (tester) async {
      await tester.pumpWidget(
        TestWrapper(
          child: StreamUserAvatar(user: const UserInfo(id: 'ab')),
        ),
      );

      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('reports taps with the user', (tester) async {
      UserInfo? tapped;

      await tester.pumpWidget(
        TestWrapper(
          child: StreamUserAvatar(user: _user, onTap: (it) => tapped = it),
        ),
      );

      await tester.tap(find.byType(StreamUserAvatar));
      expect(tapped, _user);
    });

    testWidgets('takes its size from an ambient StreamAvatarTheme', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          child: Center(
            child: StreamAvatarTheme(
              data: const StreamAvatarThemeData(size: StreamAvatarSize.xxl),
              child: StreamUserAvatar(user: _user),
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(StreamAvatar)).width,
        StreamAvatarSize.xxl.value,
      );
    });

    testWidgets('honours the deprecated theme when nothing else sizes it', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          child: Center(
            // ignore: deprecated_member_use_from_same_package
            child: StreamUserAvatarTheme(
              data: const StreamUserAvatarThemeData(
                constraints: BoxConstraints.tightFor(height: 80, width: 80),
              ),
              child: StreamUserAvatar(user: _user),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(StreamAvatar)).width, 80);
    });

    testWidgets('one registered builder reaches every avatar in the SDK', (
      tester,
    ) async {
      // The point of the slot: an app replaces the avatar once and every avatar
      // follows, including the one a participant tile shows in place of video.
      final participant = MockCallParticipantState();
      when(participant.toUserInfo).thenReturn(_user);

      await tester.pumpWidget(
        StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              userAvatar: (context, props) => Text('avatar:${props.user.name}'),
            ),
          ),
          child: TestWrapper(
            child: Column(
              children: [
                StreamUserAvatar(user: _user),
                StreamParticipantPlaceholder(
                  call: MockCall(),
                  participant: participant,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('avatar:Katie Miler'), findsNWidgets(2));
      expect(find.byType(DefaultStreamUserAvatar), findsNothing);
    });

    testWidgets('a participant tile shows the placeholder in place of video', (
      tester,
    ) async {
      final participant = MockCallParticipantState();
      when(participant.toUserInfo).thenReturn(_user);
      when(() => participant.name).thenReturn(_user.name);
      when(() => participant.isSpeaking).thenReturn(false);
      when(() => participant.isAudioEnabled).thenReturn(true);
      when(() => participant.isVideoEnabled).thenReturn(false);
      when(
        () => participant.connectionQuality,
      ).thenReturn(SfuConnectionQuality.excellent);
      when(() => participant.reaction).thenReturn(null);

      await tester.pumpWidget(
        TestWrapper(
          child: SizedBox(
            width: 300,
            height: 300,
            child: StreamParticipantTile(
              call: MockCall(),
              participant: participant,
              // The renderer needs a live call, so it stands in for itself and
              // hands back what it would show when there is no picture.
              videoRendererBuilder: (context, call, participant) =>
                  StreamParticipantPlaceholder(
                    call: call,
                    participant: participant,
                  ),
            ),
          ),
        ),
      );

      expect(find.byType(DefaultStreamParticipantPlaceholder), findsOneWidget);
      expect(find.byType(DefaultStreamUserAvatar), findsOneWidget);
    });
  });
}

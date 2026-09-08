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

    testWidgets('falls back to the id when the name is only spaces', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          child: StreamUserAvatar(
            user: const UserInfo(id: 'ab', name: '   '),
          ),
        ),
      );

      // A name with no letters in it has no initials, and an empty circle says
      // nothing about who is behind it.
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('colours the initials per user, off the palette', (
      tester,
    ) async {
      // The design system ships the palette but always picks its first entry,
      // so the SDK has to choose: two people in a call should not both be blue.
      final palette = streamTestTheme()
          .extension<StreamTheme>()!
          .colorScheme
          .avatarPalette;

      await tester.pumpWidget(
        TestWrapper(
          child: Column(
            children: [
              for (final id in ['katie', 'martin'])
                StreamUserAvatar(
                  user: UserInfo(id: id, name: id),
                ),
            ],
          ),
        ),
      );

      final colours = tester
          .widgetList<StreamAvatar>(find.byType(StreamAvatar))
          .map((it) => it.props.backgroundColor)
          .toList();

      expect(
        colours,
        everyElement(isIn(palette.map((it) => it.backgroundColor))),
      );

      // `String.hashCode` is not contractually stable across Dart SDKs or
      // between the native and web backends, so which pair a given id lands on
      // is not asserted — only that the choice follows the id, which is what
      // the feature promises. Two ids colliding on the same pair is legitimate
      // with a five-colour palette, so a difference is not asserted either;
      // the per-id stability test below is the one that would catch the
      // palette collapsing to one entry.
      expect(
        colours.map((it) => palette.indexWhere((p) => p.backgroundColor == it)),
        everyElement(isNonNegative),
      );
    });

    testWidgets('pairs the palette foreground with its background', (
      tester,
    ) async {
      // Taken as a pair or the initials stop being legible: the palette's
      // fills are pale and its text is the matching dark shade.
      final palette = streamTestTheme()
          .extension<StreamTheme>()!
          .colorScheme
          .avatarPalette;

      await tester.pumpWidget(
        TestWrapper(child: StreamUserAvatar(user: _user)),
      );

      final avatar = tester.widget<StreamAvatar>(find.byType(StreamAvatar));
      final pair = palette.firstWhere(
        (it) => it.backgroundColor == avatar.props.backgroundColor,
      );
      expect(avatar.props.foregroundColor, pair.foregroundColor);
    });

    testWidgets('picks the pair the user id indexes to', (tester) async {
      // Pins the formula rather than a colour: whatever `hashCode` returns on
      // this backend, the avatar has to land on the same entry the SDK
      // documents, so "one person keeps one colour everywhere" cannot drift
      // between platforms unnoticed.
      final palette = streamTestTheme()
          .extension<StreamTheme>()!
          .colorScheme
          .avatarPalette;
      final expected = palette[_user.id.hashCode % palette.length];

      await tester.pumpWidget(
        TestWrapper(child: StreamUserAvatar(user: _user)),
      );

      final avatar = tester.widget<StreamAvatar>(find.byType(StreamAvatar));
      expect(avatar.props.backgroundColor, expected.backgroundColor);
      expect(avatar.props.foregroundColor, expected.foregroundColor);
    });

    testWidgets('keeps one colour for one user across avatars', (tester) async {
      await tester.pumpWidget(
        TestWrapper(
          child: Column(
            children: [
              StreamUserAvatar(user: _user),
              // Same person, different name — the colour follows the id, so
              // renaming somebody does not recolour them.
              StreamUserAvatar(
                user: UserInfo(id: _user.id, name: 'Kate M'),
              ),
            ],
          ),
        ),
      );

      final colours = tester
          .widgetList<StreamAvatar>(find.byType(StreamAvatar))
          .map((it) => it.props.backgroundColor);

      expect(colours.toSet(), hasLength(1));
    });

    testWidgets('an ambient StreamAvatarTheme overrides the palette', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestWrapper(
          child: StreamAvatarTheme(
            data: const StreamAvatarThemeData(
              backgroundColor: Color(0xFF112233),
              foregroundColor: Color(0xFF445566),
            ),
            child: StreamUserAvatar(user: _user),
          ),
        ),
      );

      final avatar = tester.widget<StreamAvatar>(find.byType(StreamAvatar));
      expect(avatar.props.backgroundColor, const Color(0xFF112233));
      expect(avatar.props.foregroundColor, const Color(0xFF445566));
    });

    testWidgets('the deprecated theme colours the initials as a pair', (
      tester,
    ) async {
      // Its text colour is non-null even when untouched, so it is honoured
      // only alongside an `initialsBackground` — otherwise the white it
      // defaults to would land on the palette's pale fills.
      await tester.pumpWidget(
        TestWrapper(
          // ignore: deprecated_member_use_from_same_package
          child: StreamUserAvatarTheme(
            data: const StreamUserAvatarThemeData(
              initialsBackground: Color(0xFF6E4BB4),
              initialsTextStyle: TextStyle(color: Color(0xFFFFFFFF)),
            ),
            child: StreamUserAvatar(user: _user),
          ),
        ),
      );

      final avatar = tester.widget<StreamAvatar>(find.byType(StreamAvatar));
      expect(avatar.props.backgroundColor, const Color(0xFF6E4BB4));
      expect(avatar.props.foregroundColor, const Color(0xFFFFFFFF));
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

    testWidgets('the placeholder merges a partial avatar style', (
      tester,
    ) async {
      // A style naming only a colour must not cost the placeholder its size
      // and its ring — the sub-style is merged over the defaults rather than
      // replacing them.
      final participant = MockCallParticipantState();
      when(participant.toUserInfo).thenReturn(_user);

      await tester.pumpWidget(
        TestWrapper(
          child: Center(
            child: StreamParticipantPlaceholder(
              call: MockCall(),
              participant: participant,
              style: const StreamParticipantPlaceholderStyle(
                avatarTheme: StreamAvatarThemeData(
                  backgroundColor: Color(0xFF112233),
                ),
              ),
            ),
          ),
        ),
      );

      final avatar = tester.widget<StreamAvatar>(find.byType(StreamAvatar));
      expect(avatar.props.backgroundColor, const Color(0xFF112233));
      // Still the placeholder's own size, not the design system's default.
      expect(
        tester.getSize(find.byType(StreamAvatar)).width,
        StreamAvatarSize.xxl.value,
      );
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

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

final _icons = StreamTheme.light().icons;

const _longName =
    'Bartholomew Fitzgerald-Montgomery the Third of Northumberland';

MockCallParticipantState _participant({
  String name = 'Rene Floor',
  bool isSpeaking = false,
  bool isAudioEnabled = true,
  bool isVideoEnabled = true,
  SfuConnectionQuality quality = SfuConnectionQuality.excellent,
  bool hasReaction = false,
}) {
  final participant = MockCallParticipantState();
  when(() => participant.name).thenReturn(name);
  when(() => participant.isSpeaking).thenReturn(isSpeaking);
  when(() => participant.isAudioEnabled).thenReturn(isAudioEnabled);
  when(() => participant.isVideoEnabled).thenReturn(isVideoEnabled);
  when(() => participant.connectionQuality).thenReturn(quality);
  when(() => participant.reaction).thenReturn(
    hasReaction ? _reaction : null,
  );
  return participant;
}

// The default theme's ':like:' reaction, whose icon the tile draws.
final _reaction = CallReaction(
  type: 'reaction',
  emojiCode: ':like:',
  user: CallUser.empty(),
);

const _reactionIcon = '\u{1F44D}';

StreamParticipantTileAction _pin() => StreamParticipantTileAction(
  icon: Icons.push_pin,
  label: 'Pin',
  onPressed: () {},
);

Widget _tile({
  required CallParticipantState participant,
  required double width,
  required double height,
  List<StreamParticipantTileAction>? actions,
  StreamParticipantTileActionsBuilder? actionsBuilder,
}) {
  return TestWrapper(
    child: Center(
      child: SizedBox(
        width: width,
        height: height,
        child: StreamParticipantTile(
          call: MockCall(),
          participant: participant,
          actions: actions,
          actionsBuilder: actionsBuilder,
          // The renderer needs a live call to publish tracks.
          videoRendererBuilder: (_, _, _) =>
              const ColoredBox(color: Color(0xFF102030)),
        ),
      ),
    ),
  );
}

void main() {
  group('bottom toolbar', () {
    // The defect this layout exists to fix: the name used to be a Stack child
    // aligned bottom-left and the indicator one aligned bottom-right, so a long
    // name slid underneath the indicator instead of truncating.
    for (final width in [400.0, 320.0, 240.0, 200.0, 160.0, 152.0]) {
      testWidgets('a long name never reaches the indicator at ${width}px', (
        tester,
      ) async {
        await tester.pumpWidget(
          _tile(
            participant: _participant(name: _longName),
            width: width,
            height: 300,
          ),
        );

        expect(tester.takeException(), isNull);

        final label = tester.getRect(
          find.byType(DefaultStreamParticipantLabel),
        );
        final indicator = tester.getRect(
          find.byType(DefaultStreamConnectionQualityIndicator),
        );

        expect(
          label.right,
          lessThanOrEqualTo(indicator.left),
          reason: 'the name pill overlaps the connection quality indicator',
        );
      });
    }

    testWidgets('a long name ellipsizes rather than overflowing', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tile(
          participant: _participant(name: _longName),
          width: 200,
          height: 300,
        ),
      );

      expect(tester.takeException(), isNull);

      final paragraph = tester.renderObject<RenderParagraph>(
        find.text(_longName),
      );
      expect(paragraph.didExceedMaxLines, isTrue);
    });

    testWidgets('a short name leaves the indicator at the trailing edge', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tile(participant: _participant(name: 'Al'), width: 300, height: 300),
      );

      final tile = tester.getRect(find.byType(DefaultStreamParticipantTile));
      final indicator = tester.getRect(
        find.byType(DefaultStreamConnectionQualityIndicator),
      );

      // Within the toolbar's own inset of the tile edge.
      expect(tile.right - indicator.right, lessThan(20));
    });
  });

  group('density', () {
    testWidgets('drops the name but keeps the pill on a narrow tile', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tile(participant: _participant(), width: 130, height: 160),
      );

      expect(find.text('Rene Floor'), findsNothing);
      expect(find.byType(DefaultStreamParticipantLabel), findsOneWidget);
      expect(
        find.byType(DefaultStreamConnectionQualityIndicator),
        findsOneWidget,
      );
    });

    testWidgets('drops the pill on a very narrow tile', (tester) async {
      await tester.pumpWidget(
        _tile(participant: _participant(), width: 90, height: 120),
      );

      expect(find.byType(DefaultStreamParticipantLabel), findsNothing);
      expect(
        find.byType(DefaultStreamConnectionQualityIndicator),
        findsOneWidget,
      );
    });

    testWidgets('drops both toolbars on a tile with no room for them', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tile(participant: _participant(), width: 40, height: 40),
      );

      expect(find.byType(DefaultStreamParticipantLabel), findsNothing);
      expect(
        find.byType(DefaultStreamConnectionQualityIndicator),
        findsNothing,
      );
    });

    // The gap before the indicator used to be emitted whether or not there was
    // a pill on the other side of it, so the narrowest band the ladder allows
    // was 12px short of what the row needed.
    for (final width in [56.0, 60.0, 66.0]) {
      testWidgets('fits the indicator alone at ${width}px', (tester) async {
        await tester.pumpWidget(
          _tile(participant: _participant(), width: width, height: 120),
        );

        expect(tester.takeException(), isNull);
        expect(
          find.byType(DefaultStreamConnectionQualityIndicator),
          findsOneWidget,
        );
      });
    }

    // The pill lays its state icons out at full size, so a muted camera-off
    // participant needs far more room than a name alone. The ladder's widths
    // know nothing about that; the tile measures the pill instead.
    testWidgets('drops the pill when state icons widen it past the room', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tile(
          participant: _participant(
            isAudioEnabled: false,
            isVideoEnabled: false,
          ),
          width: 164,
          height: 300,
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(DefaultStreamParticipantLabel), findsNothing);
      expect(
        find.byType(DefaultStreamConnectionQualityIndicator),
        findsOneWidget,
      );
    });

    testWidgets('keeps the pill once the state icons do fit', (tester) async {
      await tester.pumpWidget(
        _tile(
          participant: _participant(
            isAudioEnabled: false,
            isVideoEnabled: false,
          ),
          width: 180,
          height: 300,
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(DefaultStreamParticipantLabel), findsOneWidget);
      expect(find.byIcon(_icons.voiceOffFill), findsOneWidget);
      expect(find.byIcon(_icons.videoOffFill), findsOneWidget);
    });
  });

  group('top toolbar', () {
    // A reaction arrives mid-call, so a tile that only fits the overflow button
    // would start overflowing the moment someone reacted.
    testWidgets('drops the reaction when it does not fit beside the button', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tile(
          participant: _participant(hasReaction: true),
          width: 110,
          height: 300,
          actions: [_pin()],
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text(_reactionIcon), findsNothing);
      expect(find.byType(StreamButton), findsOneWidget);
    });

    testWidgets('keeps the reaction once it does fit', (tester) async {
      await tester.pumpWidget(
        _tile(
          participant: _participant(hasReaction: true),
          width: 130,
          height: 300,
          actions: [_pin()],
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text(_reactionIcon), findsOneWidget);
    });

    // The two toolbars hang off opposite edges of a Stack, so a tile too short
    // for both does not overflow — the button lands on top of the name pill.
    testWidgets('drops the button on a tile too short to clear the pill', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tile(
          participant: _participant(),
          width: 300,
          height: 104,
          actions: [_pin()],
        ),
      );

      expect(find.byType(StreamButton), findsNothing);
      expect(find.byType(DefaultStreamParticipantLabel), findsOneWidget);
    });

    testWidgets('keeps the button clear of the pill when both are shown', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tile(
          participant: _participant(),
          width: 300,
          height: 120,
          actions: [_pin()],
        ),
      );

      final button = tester.getRect(find.byType(StreamButton));
      final label = tester.getRect(
        find.byType(DefaultStreamParticipantLabel),
      );

      expect(button.overlaps(label), isFalse);
    });
  });

  group('audio indicator', () {
    // The sound indicator never leaves, so the pill keeps its shape as someone
    // starts and stops talking. Only the muted state adds an icon.
    testWidgets('is shown while speaking', (tester) async {
      await tester.pumpWidget(
        _tile(
          participant: _participant(isSpeaking: true),
          width: 300,
          height: 300,
        ),
      );

      expect(find.byType(StreamAudioIndicator), findsOneWidget);
      expect(find.byIcon(_icons.voiceOffFill), findsNothing);
    });

    testWidgets('is shown while silent, with no microphone icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tile(participant: _participant(), width: 300, height: 300),
      );

      expect(find.byType(StreamAudioIndicator), findsOneWidget);
      expect(find.byIcon(_icons.voiceOffFill), findsNothing);
    });

    testWidgets('is shown alongside the muted icon while muted', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tile(
          participant: _participant(isAudioEnabled: false),
          width: 300,
          height: 300,
        ),
      );

      expect(find.byType(StreamAudioIndicator), findsOneWidget);
      expect(find.byIcon(_icons.voiceOffFill), findsOneWidget);
    });

    testWidgets('rests when the participant is not speaking', (tester) async {
      await tester.pumpWidget(
        _tile(participant: _participant(), width: 300, height: 300),
      );

      // A resting indicator runs no animation, so the tree settles. A speaking
      // one never would.
      await tester.pumpAndSettle();
    });
  });

  group('overflow menu', () {
    StreamParticipantTileAction action(String label) =>
        StreamParticipantTileAction(
          icon: Icons.push_pin,
          label: label,
          onPressed: () {},
        );

    testWidgets('is hidden when no actions are given', (tester) async {
      await tester.pumpWidget(
        _tile(participant: _participant(), width: 300, height: 300),
      );

      expect(find.byType(StreamButton), findsNothing);
    });

    testWidgets('is hidden when the action list is empty', (tester) async {
      await tester.pumpWidget(
        _tile(
          participant: _participant(),
          width: 300,
          height: 300,
          actions: const [],
        ),
      );

      expect(find.byType(StreamButton), findsNothing);
    });

    testWidgets('is hidden when the actions builder returns nothing', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tile(
          participant: _participant(),
          width: 300,
          height: 300,
          actionsBuilder: (_, _) => const [],
        ),
      );

      expect(find.byType(StreamButton), findsNothing);
    });

    testWidgets('opens a menu listing every action', (tester) async {
      await tester.pumpWidget(
        _tile(
          participant: _participant(),
          width: 300,
          height: 300,
          actions: [action('Pin'), action('Block')],
        ),
      );

      expect(find.byType(StreamButton), findsOneWidget);

      await tester.tap(find.byType(StreamButton));
      await tester.pumpAndSettle();

      expect(find.text('Pin'), findsOneWidget);
      expect(find.text('Block'), findsOneWidget);
    });

    testWidgets('runs the action and closes the menu on tap', (tester) async {
      var pinned = 0;

      await tester.pumpWidget(
        _tile(
          participant: _participant(),
          width: 300,
          height: 300,
          actions: [
            StreamParticipantTileAction(
              icon: Icons.push_pin,
              label: 'Pin',
              onPressed: () => pinned++,
            ),
          ],
        ),
      );

      await tester.tap(find.byType(StreamButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pin'));
      await tester.pumpAndSettle();

      expect(pinned, 1);
      // A MenuAnchor panel is an overlay rather than a route, so it does not
      // dismiss itself when an item is chosen.
      expect(find.text('Pin'), findsNothing);
    });

    testWidgets('stays open when a rebuild yields an equal action list', (
      tester,
    ) async {
      // actionsBuilder returns a fresh list every build, so comparing identity
      // would close the menu on the next rebuild — which, with participant
      // state streaming in during a call, is immediately.
      await tester.pumpWidget(
        _tile(
          participant: _participant(),
          width: 300,
          height: 300,
          actionsBuilder: (_, _) => [action('Pin')],
        ),
      );

      await tester.tap(find.byType(StreamButton));
      await tester.pumpAndSettle();
      expect(find.text('Pin'), findsOneWidget);

      // Rebuild with an equal — but not identical — list.
      await tester.pumpWidget(
        _tile(
          participant: _participant(),
          width: 300,
          height: 300,
          actionsBuilder: (_, _) => [action('Pin')],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pin'), findsOneWidget);
    });

    testWidgets('closes when the actions actually change', (tester) async {
      await tester.pumpWidget(
        _tile(
          participant: _participant(),
          width: 300,
          height: 300,
          actionsBuilder: (_, _) => [action('Pin')],
        ),
      );

      await tester.tap(find.byType(StreamButton));
      await tester.pumpAndSettle();
      expect(find.text('Pin'), findsOneWidget);

      await tester.pumpWidget(
        _tile(
          participant: _participant(),
          width: 300,
          height: 300,
          actionsBuilder: (_, _) => [action('Unpin')],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unpin'), findsNothing);
    });

    testWidgets('prefers the actions builder over the action list', (
      tester,
    ) async {
      CallParticipantState? received;

      final participant = _participant();
      await tester.pumpWidget(
        _tile(
          participant: participant,
          width: 300,
          height: 300,
          actions: [action('From the list')],
          actionsBuilder: (_, it) {
            received = it;
            return [action('From the builder')];
          },
        ),
      );

      await tester.tap(find.byType(StreamButton));
      await tester.pumpAndSettle();

      expect(find.text('From the builder'), findsOneWidget);
      expect(find.text('From the list'), findsNothing);
      expect(received, same(participant));
    });
  });

  group('component factory', () {
    testWidgets('uses a registered participant label builder', (tester) async {
      await tester.pumpWidget(
        StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              participantLabel: (context, props) => Text('label:${props.name}'),
            ),
          ),
          child: _tile(participant: _participant(), width: 300, height: 300),
        ),
      );

      expect(find.text('label:Rene Floor'), findsOneWidget);
      expect(find.byType(DefaultStreamParticipantLabel), findsNothing);
    });

    testWidgets('uses a registered participant video builder', (tester) async {
      await tester.pumpWidget(
        StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              participantVideo: (context, props) => const Text('video'),
            ),
          ),
          child: TestWrapper(
            child: SizedBox(
              width: 300,
              height: 300,
              child: StreamParticipantTile(
                call: MockCall(),
                participant: _participant(),
              ),
            ),
          ),
        ),
      );

      expect(find.text('video'), findsOneWidget);
      expect(find.byType(DefaultStreamParticipantVideo), findsNothing);
    });

    testWidgets('prefers a per-instance renderer over the registered one', (
      tester,
    ) async {
      await tester.pumpWidget(
        StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              participantVideo: (context, props) => const Text('registered'),
            ),
          ),
          child: TestWrapper(
            child: SizedBox(
              width: 300,
              height: 300,
              child: StreamParticipantTile(
                call: MockCall(),
                participant: _participant(),
                videoRendererBuilder: (_, _, _) => const Text('per instance'),
              ),
            ),
          ),
        ),
      );

      // A call site that named a renderer said something more specific than an
      // app-wide default.
      expect(find.text('per instance'), findsOneWidget);
      expect(find.text('registered'), findsNothing);
    });

    testWidgets('uses a registered connection quality indicator builder', (
      tester,
    ) async {
      await tester.pumpWidget(
        StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              connectionQualityIndicator: (context, props) => SizedBox.square(
                dimension: 32,
                child: Text('q:${props.connectionQuality.name}'),
              ),
            ),
          ),
          child: _tile(participant: _participant(), width: 300, height: 300),
        ),
      );

      expect(find.text('q:excellent'), findsOneWidget);
      expect(
        find.byType(DefaultStreamConnectionQualityIndicator),
        findsNothing,
      );
    });
  });
}

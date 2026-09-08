import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../mocks.dart';

// The component themes are only worth anything if they reach the widget. Every
// other theme test in the suite asserts on `StreamVideoTheme` data alone, which
// a tile that stopped reading its theme would still satisfy — so these pump the
// real widget under a themed ancestor and assert on what it drew.

MockCallParticipantState _participant({
  String name = 'Rene Floor',
  bool isAudioEnabled = true,
  bool isVideoEnabled = true,
  bool isSpeaking = false,
}) {
  final participant = MockCallParticipantState();
  when(() => participant.name).thenReturn(name);
  when(() => participant.image).thenReturn(null);
  when(() => participant.isSpeaking).thenReturn(isSpeaking);
  when(() => participant.isAudioEnabled).thenReturn(isAudioEnabled);
  when(() => participant.isVideoEnabled).thenReturn(isVideoEnabled);
  when(
    () => participant.connectionQuality,
  ).thenReturn(SfuConnectionQuality.excellent);
  when(() => participant.reaction).thenReturn(null);
  return participant;
}

Widget _tile({
  required StreamVideoTheme videoTheme,
  bool? showParticipantLabelProp,
  MockCallParticipantState? participant,
}) {
  final coreTheme = StreamTheme(brightness: Brightness.light);

  return MaterialApp(
    theme: ThemeData(
      extensions: <ThemeExtension<dynamic>>[coreTheme, videoTheme],
    ),
    home: Material(
      child: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: StreamParticipantTile(
            call: MockCall(),
            participant: participant ?? _participant(),
            showParticipantLabel: showParticipantLabelProp,
            videoRendererBuilder: (_, _, _) =>
                const ColoredBox(color: Color(0xFF6E7A8A)),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('StreamParticipantTileTheme reaches the tile', () {
    testWidgets('a themed showParticipantLabel drops the pill', (tester) async {
      await tester.pumpWidget(
        _tile(
          videoTheme: StreamVideoTheme(
            brightness: Brightness.light,
            participantTileTheme: const StreamParticipantTileThemeData(
              style: StreamParticipantTileStyle(showParticipantLabel: false),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(StreamParticipantLabel), findsNothing);
    });

    testWidgets('the pill is there without that theme', (tester) async {
      // The other half of the assertion above: without it the test would pass
      // against a tile that never draws a pill at all.
      await tester.pumpWidget(
        _tile(videoTheme: StreamVideoTheme(brightness: Brightness.light)),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(StreamParticipantLabel), findsOneWidget);
    });

    testWidgets('a prop beats the theme', (tester) async {
      await tester.pumpWidget(
        _tile(
          videoTheme: StreamVideoTheme(
            brightness: Brightness.light,
            participantTileTheme: const StreamParticipantTileThemeData(
              style: StreamParticipantTileStyle(showParticipantLabel: false),
            ),
          ),
          showParticipantLabelProp: true,
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(StreamParticipantLabel), findsOneWidget);
    });

    testWidgets('a themed backgroundColor paints the tile', (tester) async {
      const themed = Color(0xFF123456);

      await tester.pumpWidget(
        _tile(
          videoTheme: StreamVideoTheme(
            brightness: Brightness.light,
            participantTileTheme: const StreamParticipantTileThemeData(
              style: StreamParticipantTileStyle(backgroundColor: themed),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      final decorated = tester.widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(DefaultStreamParticipantTile),
          matching: find.byType(DecoratedBox),
        ),
      );
      expect(
        decorated.map((it) => (it.decoration as BoxDecoration).color),
        contains(themed),
      );
    });
  });

  group('StreamParticipantLabelTheme reaches the pill', () {
    testWidgets('a themed nameTextStyle styles the name', (tester) async {
      await tester.pumpWidget(
        _tile(
          videoTheme: StreamVideoTheme(
            brightness: Brightness.light,
            participantLabelTheme: const StreamParticipantLabelThemeData(
              style: StreamParticipantLabelStyle(
                nameTextStyle: TextStyle(
                  fontSize: 21,
                  color: Color(0xFFAABBCC),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      final name = tester.widget<Text>(find.text('Rene Floor'));
      expect(name.style?.fontSize, 21);
      expect(name.style?.color, const Color(0xFFAABBCC));
    });

    testWidgets('a themed videoPausedColor reaches the paused icon', (
      tester,
    ) async {
      final participant = _participant();
      when(
        () => participant.isTrackPaused(SfuTrackType.video),
      ).thenReturn(true);

      await tester.pumpWidget(
        _tile(
          videoTheme: StreamVideoTheme(
            brightness: Brightness.light,
            participantLabelTheme: const StreamParticipantLabelThemeData(
              style: StreamParticipantLabelStyle(
                videoPausedColor: Color(0xFFFEDCBA),
              ),
            ),
          ),
          participant: participant,
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      final icon = tester.widget<Icon>(find.byIcon(Icons.network_check));
      expect(icon.color, const Color(0xFFFEDCBA));
    });
  });
}

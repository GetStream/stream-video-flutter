import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

StreamParticipantTileStyle? _dropIndicatorWhenCompact(
  StreamParticipantTileStyleDetails details,
) => details.chrome.isCompact
    ? const StreamParticipantTileStyle(showConnectionQualityIndicator: false)
    : null;

void main() {
  group('StreamParticipantTile', () {
    late MockCall call;
    late MockCallParticipantState participant;

    setUp(() {
      call = MockCall();
      participant = MockCallParticipantState();
    });

    testWidgets('renders the builder registered on the component factory', (
      tester,
    ) async {
      StreamParticipantTileProps? receivedProps;

      await tester.pumpWidget(
        StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              participantTile: (context, props) {
                receivedProps = props;
                return const Text('custom tile');
              },
            ),
          ),
          child: TestWrapper(
            child: StreamParticipantTile(
              call: call,
              participant: participant,
              showParticipantLabel: false,
            ),
          ),
        ),
      );

      expect(find.text('custom tile'), findsOneWidget);
      expect(find.byType(DefaultStreamParticipantTile), findsNothing);

      // The props are forwarded as passed to the widget.
      expect(receivedProps?.call, same(call));
      expect(receivedProps?.participant, same(participant));
      expect(receivedProps?.showParticipantLabel, isFalse);
    });

    testWidgets('hands the measured size and chrome to the builder', (
      tester,
    ) async {
      StreamParticipantTileProps? receivedProps;

      await tester.pumpWidget(
        StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              participantTile: (context, props) {
                receivedProps = props;
                return const SizedBox.shrink();
              },
            ),
          ),
          child: TestWrapper(
            child: Center(
              child: SizedBox(
                width: 130,
                height: 200,
                child: StreamParticipantTile(
                  call: call,
                  participant: participant,
                ),
              ),
            ),
          ),
        ),
      );

      expect(receivedProps?.size, const Size(130, 200));
      expect(receivedProps?.chrome, StreamParticipantTileChrome.compact);
    });

    testWidgets('resolves the chrome with the theme policy', (tester) async {
      StreamParticipantTileProps? receivedProps;

      await tester.pumpWidget(
        StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              participantTile: (context, props) {
                receivedProps = props;
                return const SizedBox.shrink();
              },
            ),
          ),
          child: TestWrapper(
            child: StreamParticipantTileTheme(
              data: const StreamParticipantTileThemeData(
                chromePolicy: StreamParticipantTileChromePolicy.none,
              ),
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: StreamParticipantTile(
                    call: call,
                    participant: participant,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(receivedProps?.chrome, StreamParticipantTileChrome.bare);
    });

    testWidgets('merges the style its resolver returns over the theme', (
      tester,
    ) async {
      when(() => participant.name).thenReturn('Rene Floor');
      when(() => participant.isSpeaking).thenReturn(false);
      when(() => participant.isAudioEnabled).thenReturn(true);
      when(() => participant.isVideoEnabled).thenReturn(true);
      when(
        () => participant.connectionQuality,
      ).thenReturn(SfuConnectionQuality.excellent);
      when(() => participant.reaction).thenReturn(null);

      await tester.pumpWidget(
        TestWrapper(
          child: StreamParticipantTileTheme(
            data: const StreamParticipantTileThemeData(
              style: StreamParticipantTileStyle(
                labelStyle: StreamParticipantLabelStyle(blurSigma: 0),
              ),
              styleResolver: _dropIndicatorWhenCompact,
            ),
            child: Center(
              child: SizedBox(
                width: 130,
                height: 200,
                child: StreamParticipantTile(
                  call: call,
                  participant: participant,
                  videoRendererBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
      );

      // The resolver dropped the indicator at this size...
      expect(find.byType(StreamConnectionQualityIndicator), findsNothing);
      // ...and what it said nothing about still comes from the theme.
      expect(find.text('Rene Floor'), findsOneWidget);
    });

    testWidgets('falls back to the default tile without a factory', (
      tester,
    ) async {
      when(() => participant.isSpeaking).thenReturn(false);
      when(() => participant.isVideoEnabled).thenReturn(true);

      await tester.pumpWidget(
        TestWrapper(
          child: StreamParticipantTile(
            call: call,
            participant: participant,
            showParticipantLabel: false,
            showConnectionQualityIndicator: false,
            // Stub out the renderer, it needs a real call to publish tracks.
            videoRendererBuilder: (_, _, _) => const Text('renderer'),
          ),
        ),
      );

      expect(find.byType(DefaultStreamParticipantTile), findsOneWidget);
      expect(find.text('renderer'), findsOneWidget);
    });
  });

  group('StreamFloatingParticipantTile', () {
    // The default composition — a StreamParticipantTile inside the surface.
    testWidgets('clips the tile to the surface radius it was given', (
      tester,
    ) async {
      final participant = MockCallParticipantState();
      when(() => participant.name).thenReturn('Rene Floor');
      when(() => participant.isSpeaking).thenReturn(false);
      when(() => participant.isAudioEnabled).thenReturn(true);
      when(() => participant.isVideoEnabled).thenReturn(true);
      when(
        () => participant.connectionQuality,
      ).thenReturn(SfuConnectionQuality.excellent);
      when(() => participant.reaction).thenReturn(null);

      const radius = BorderRadius.all(Radius.circular(24));

      await tester.pumpWidget(
        StreamComponentFactory(
          // Replaces the renderer, not the tile: the tile's own clip is what
          // this is about.
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              participantVideo: (context, props) =>
                  const ColoredBox(color: Color(0xFF102030)),
            ),
          ),
          child: TestWrapper(
            child: StreamFloatingParticipantTile(
              call: MockCall(),
              participant: participant,
              style: const StreamFloatingParticipantTileStyle(
                borderRadius: radius,
              ),
            ),
          ),
        ),
      );

      // A surface rounded further than the tile inside it leaves transparent
      // notches where the tighter clip stops short of the corner.
      final clip = tester.widget<ClipRRect>(
        find
            .descendant(
              of: find.byType(DefaultStreamParticipantTile),
              matching: find.byType(ClipRRect),
            )
            .first,
      );
      expect(clip.borderRadius, radius);
    });

    // The self-view is 140px wide, which the ladder would call compact and
    // anchor the indicator into the corner for. It draws nothing but that
    // indicator, so there is no chrome to make room for and the design keeps
    // it inset and round.
    testWidgets('pins the full chrome whatever its size', (tester) async {
      final participant = MockCallParticipantState();
      when(() => participant.name).thenReturn('Rene Floor');
      when(() => participant.isSpeaking).thenReturn(false);
      when(() => participant.isAudioEnabled).thenReturn(true);
      when(() => participant.isVideoEnabled).thenReturn(true);
      when(
        () => participant.connectionQuality,
      ).thenReturn(SfuConnectionQuality.excellent);
      when(() => participant.reaction).thenReturn(null);

      await tester.pumpWidget(
        StreamComponentFactory(
          builders: StreamComponentBuilders(
            extensions: streamVideoComponentBuilders(
              participantVideo: (context, props) =>
                  const ColoredBox(color: Color(0xFF102030)),
            ),
          ),
          child: TestWrapper(
            child: StreamFloatingParticipantTile(
              call: MockCall(),
              participant: participant,
            ),
          ),
        ),
      );

      final tile = tester.widget<DefaultStreamParticipantTile>(
        find.byType(DefaultStreamParticipantTile),
      );
      expect(tile.props.chrome, StreamParticipantTileChrome.full);

      // Round rather than a corner-anchored rectangle, and clear of the edges.
      final box = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(StreamConnectionQualityIndicator),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect((box.decoration as BoxDecoration).shape, BoxShape.circle);

      final surface = tester.getRect(
        find.byType(StreamFloatingParticipantTile),
      );
      final indicator = tester.getRect(
        find.byType(StreamConnectionQualityIndicator),
      );
      expect(indicator.right, lessThan(surface.right));
      expect(indicator.bottom, lessThan(surface.bottom));
    });
  });

  group('StreamFloatingParticipantTile default tile style', () {
    // No participantBuilder in either of these: the injected tileStyle only
    // reaches the tile the floating widget builds itself, and a supplied
    // builder bypasses it entirely — which is why both goldens miss this. The
    // renderer is stubbed through the component factory instead, since it
    // needs a live call.
    MockCallParticipantState participant({bool isSpeaking = false}) {
      final it = MockCallParticipantState();
      when(() => it.name).thenReturn('Rene Floor');
      when(() => it.image).thenReturn(null);
      when(() => it.isSpeaking).thenReturn(isSpeaking);
      when(() => it.isAudioEnabled).thenReturn(true);
      when(() => it.isVideoEnabled).thenReturn(true);
      when(
        () => it.connectionQuality,
      ).thenReturn(SfuConnectionQuality.excellent);
      when(() => it.reaction).thenReturn(null);
      return it;
    }

    Widget wrap({required Widget child, StreamVideoTheme? videoTheme}) {
      final withFactory = StreamComponentFactory(
        builders: StreamComponentBuilders(
          extensions: streamVideoComponentBuilders(
            participantVideo: (context, props) => const Text('video'),
          ),
        ),
        child: child,
      );

      if (videoTheme == null) return TestWrapper(child: withFactory);

      return MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[
            StreamTheme(brightness: Brightness.light),
            videoTheme,
          ],
        ),
        home: Material(child: withFactory),
      );
    }

    testWidgets('strips the chrome the self-view has no room for', (
      tester,
    ) async {
      // 140x228 clears the density ladder's `full` thresholds, so without the
      // injection the corner of the screen would carry a name pill.
      await tester.pumpWidget(
        wrap(
          child: Center(
            child: StreamFloatingParticipantTile(
              call: MockCall(),
              participant: participant(isSpeaking: true),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(StreamParticipantLabel), findsNothing);
      expect(find.byType(StreamConnectionQualityIndicator), findsOneWidget);
    });

    testWidgets('an app-wide tile theme still reaches the self-view', (
      tester,
    ) async {
      // A default must not outrank a theme. The name pill is the exception
      // below.
      await tester.pumpWidget(
        wrap(
          videoTheme: StreamVideoTheme(
            brightness: Brightness.light,
            participantTileTheme: const StreamParticipantTileThemeData(
              style: StreamParticipantTileStyle(showSpeakerBorder: true),
            ),
          ),
          child: Center(
            child: StreamFloatingParticipantTile(
              call: MockCall(),
              participant: participant(isSpeaking: true),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(
        tester
            .widget<StreamParticipantTile>(find.byType(StreamParticipantTile))
            .props
            .style
            ?.showSpeakerBorder,
        isTrue,
      );
    });

    testWidgets('no name pill, whatever the ambient tile theme asks for', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          videoTheme: StreamVideoTheme(
            brightness: Brightness.light,
            participantTileTheme: const StreamParticipantTileThemeData(
              style: StreamParticipantTileStyle(showParticipantLabel: true),
            ),
          ),
          child: Center(
            child: StreamFloatingParticipantTile(
              call: MockCall(),
              participant: participant(),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(StreamParticipantLabel), findsNothing);
    });

    // The deprecated theme bridges a non-null `showParticipantLabel: true`
    // into the participant tile theme.
    testWidgets('no name pill under the deprecated participant theme', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          videoTheme: StreamVideoTheme(
            brightness: Brightness.light,
            // ignore: deprecated_member_use_from_same_package
            callParticipantTheme: const StreamCallParticipantThemeData(),
          ),
          child: Center(
            child: StreamFloatingParticipantTile(
              call: MockCall(),
              participant: participant(),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(StreamParticipantLabel), findsNothing);
    });

    testWidgets('an explicit tileStyle beats both', (tester) async {
      await tester.pumpWidget(
        wrap(
          videoTheme: StreamVideoTheme(
            brightness: Brightness.light,
            participantTileTheme: const StreamParticipantTileThemeData(
              style: StreamParticipantTileStyle(showParticipantLabel: true),
            ),
            floatingParticipantTileTheme:
                const StreamFloatingParticipantTileThemeData(
                  style: StreamFloatingParticipantTileStyle(
                    tileStyle: StreamParticipantTileStyle(
                      showParticipantLabel: false,
                    ),
                  ),
                ),
          ),
          child: Center(
            child: StreamFloatingParticipantTile(
              call: MockCall(),
              participant: participant(),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(StreamParticipantLabel), findsNothing);
    });
  });

  group('StreamCallParticipant (deprecated)', () {
    testWidgets('renders the default participant tile', (tester) async {
      final participant = MockCallParticipantState();
      when(() => participant.isSpeaking).thenReturn(false);
      when(() => participant.isVideoEnabled).thenReturn(true);

      await tester.pumpWidget(
        TestWrapper(
          // ignore: deprecated_member_use_from_same_package
          child: StreamCallParticipant(
            call: MockCall(),
            participant: participant,
            showParticipantLabel: false,
            showConnectionQualityIndicator: false,
            // Stub out the renderer, it needs a real call to publish tracks.
            videoRendererBuilder: (_, _, _) => const Text('renderer'),
          ),
        ),
      );

      expect(find.byType(DefaultStreamParticipantTile), findsOneWidget);
      expect(find.text('renderer'), findsOneWidget);
    });

    // It builds the default tile with props of its own rather than going
    // through [StreamParticipantTile], so the chrome is resolved by the tile
    // measuring itself. Nothing else takes that path.
    testWidgets('steps its chrome down with its size', (tester) async {
      final participant = MockCallParticipantState();
      when(() => participant.name).thenReturn('Rene Floor');
      when(() => participant.image).thenReturn(null);
      when(() => participant.isSpeaking).thenReturn(false);
      when(() => participant.isAudioEnabled).thenReturn(true);
      when(() => participant.isVideoEnabled).thenReturn(true);
      when(
        () => participant.connectionQuality,
      ).thenReturn(SfuConnectionQuality.excellent);
      when(() => participant.reaction).thenReturn(null);

      await tester.pumpWidget(
        TestWrapper(
          child: Center(
            child: SizedBox(
              width: 130,
              height: 200,
              // ignore: deprecated_member_use_from_same_package
              child: StreamCallParticipant(
                call: MockCall(),
                participant: participant,
                videoRendererBuilder: (_, _, _) => const Text('renderer'),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Rene Floor'), findsOneWidget);
      expect(find.byType(StreamAudioIndicator), findsNothing);
    });
  });
}

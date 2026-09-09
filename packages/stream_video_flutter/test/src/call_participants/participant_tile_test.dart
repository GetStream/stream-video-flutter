import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../test_utils/test_wrapper.dart';
import '../mocks.dart';

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
    // Both floating goldens hand in their own participantBuilder, so the
    // default composition — a StreamParticipantTile inside the surface — is
    // only covered here.
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
      // A default must not outrank a theme: an app that deliberately styled
      // tiles reaches this one too. The name pill is the exception below.
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
    // into the participant tile theme, so an app that had merely set the old
    // theme — asking for nothing — used to get a pill on its self-view.
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
  });
}

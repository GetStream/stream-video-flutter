import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/src/renderer/rendered_video_sizes.dart';

void main() {
  // The registry asks the scheduler for a frame.
  TestWidgetsFlutterBinding.ensureInitialized();

  final sizes = RenderedVideoSizes.instance;

  setUp(sizes.debugReset);
  tearDown(sizes.debugReset);

  const landscape = Size(1920, 1080);
  const portrait = Size(1080, 1920);

  test('a track no renderer has reported has no size', () {
    expect(sizes.sizeOf('alice:video'), isNull);
  });

  test('keeps the size each renderer reports, per track', () {
    final renderer = Object();
    sizes
      ..report('alice:video', renderer, landscape)
      ..report('bob:video', renderer, portrait);

    expect(sizes.sizeOf('alice:video'), landscape);
    expect(sizes.sizeOf('bob:video'), portrait);
  });

  testWidgets('asks for a frame only when the size of a track changes', (
    tester,
  ) async {
    final renderer = Object();
    sizes.report('alice:video', renderer, landscape);
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pump();

    sizes.report('alice:video', renderer, landscape);
    expect(tester.binding.hasScheduledFrame, isFalse);

    sizes.report('alice:video', renderer, portrait);
    expect(tester.binding.hasScheduledFrame, isTrue);
  });

  test('keeps the size while another renderer of the track remains', () {
    final first = Object();
    final second = Object();
    sizes
      ..report('alice:video', first, landscape)
      ..report('alice:video', second, landscape)
      ..remove('alice:video', first);

    expect(sizes.sizeOf('alice:video'), landscape);

    sizes.remove('alice:video', second);
    expect(sizes.sizeOf('alice:video'), isNull);
  });

  test('uses the first renderer to report when renderers disagree', () {
    final first = Object();
    final second = Object();
    sizes
      ..report('alice:video', first, landscape)
      ..report('alice:video', second, portrait);
    expect(sizes.sizeOf('alice:video'), landscape);

    sizes.report('alice:video', first, portrait);
    expect(sizes.sizeOf('alice:video'), portrait);

    sizes.remove('alice:video', first);
    sizes.report('alice:video', second, landscape);
    expect(sizes.sizeOf('alice:video'), landscape);
  });

  testWidgets('ignores removing a renderer that never reported', (
    tester,
  ) async {
    await tester.pump();

    sizes.remove('alice:video', Object());

    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('tells where a track is drawn', (tester) async {
    late BuildContext tile;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            Positioned.fromRect(
              rect: const Rect.fromLTWH(10, 20, 100, 200),
              child: Builder(
                builder: (context) {
                  tile = context;
                  return const SizedBox.expand();
                },
              ),
            ),
          ],
        ),
      ),
    );

    // One renderer without a context, which is passed over.
    sizes
      ..report('alice:video', Object(), portrait)
      ..report('alice:video', Object(), portrait, context: tile);

    expect(
      sizes.screenRectOf('alice:video'),
      const Rect.fromLTWH(10, 20, 100, 200),
    );
  });

  testWidgets('prefers the largest shown tile, passing over a hidden one', (
    tester,
  ) async {
    late BuildContext hidden;
    late BuildContext thumbnail;
    late BuildContext tile;
    Widget at(Rect rect, ValueSetter<BuildContext> onContext) {
      return Positioned.fromRect(
        rect: rect,
        child: Builder(
          builder: (context) {
            onContext(context);
            return const SizedBox.expand();
          },
        ),
      );
    }

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            // The largest, but in a route below the current one, where
            // tickers are off.
            TickerMode(
              enabled: false,
              child: Stack(
                children: [
                  at(const Rect.fromLTWH(0, 0, 400, 600), (c) => hidden = c),
                ],
              ),
            ),
            at(const Rect.fromLTWH(0, 0, 40, 60), (c) => thumbnail = c),
            at(const Rect.fromLTWH(50, 100, 200, 300), (c) => tile = c),
          ],
        ),
      ),
    );

    sizes
      ..report('alice:video', Object(), portrait, context: hidden)
      ..report('alice:video', Object(), portrait, context: thumbnail)
      ..report('alice:video', Object(), portrait, context: tile);

    expect(
      sizes.screenRectOf('alice:video'),
      const Rect.fromLTWH(50, 100, 200, 300),
    );
  });
}

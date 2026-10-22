import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/src/renderer/rendered_video_sizes.dart';

void main() {
  final sizes = RenderedVideoSizes.instance;
  var notifications = 0;
  void onChange() => notifications++;

  setUp(() {
    sizes.reset();
    notifications = 0;
    sizes.addListener(onChange);
  });

  tearDown(() {
    sizes
      ..removeListener(onChange)
      ..reset();
  });

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

  test('notifies only when the size of a track changes', () {
    final renderer = Object();
    sizes.report('alice:video', renderer, landscape);
    expect(notifications, 1);

    sizes.report('alice:video', renderer, landscape);
    expect(notifications, 1);

    sizes.report('alice:video', renderer, portrait);
    expect(notifications, 2);
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

  test('ignores removing a renderer that never reported', () {
    sizes.remove('alice:video', Object());
    expect(notifications, 0);
  });
}

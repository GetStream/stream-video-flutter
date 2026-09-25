import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/src/renderer/last_frame_cache.dart';

Future<ui.Image> _image(WidgetTester tester) async {
  return (await tester.runAsync(() => createTestImage(width: 4, height: 2)))!;
}

void main() {
  testWidgets('keeps at most maxEntries, dropping the least recently used', (
    tester,
  ) async {
    final cache = LastVideoFrameCache(maxEntries: 2);
    addTearDown(cache.dispose);

    cache.put('a', LastVideoFrame(image: await _image(tester)));
    cache.put('b', LastVideoFrame(image: await _image(tester)));
    expect(cache['a'], isNotNull); // a is now the most recently used
    cache.put('c', LastVideoFrame(image: await _image(tester)));

    expect(cache['a'], isNotNull);
    expect(cache['b'], isNull);
    expect(cache['c'], isNotNull);
  });

  testWidgets('shows the stored frame, and the placeholder once removed', (
    tester,
  ) async {
    final cache = LastVideoFrameCache();
    addTearDown(cache.dispose);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: LastVideoFrameOrPlaceholder(
          cache: cache,
          frameKey: 'a',
          placeholderBuilder: (_) => const Text('placeholder'),
        ),
      ),
    );
    expect(find.text('placeholder'), findsOneWidget);

    cache.put('a', LastVideoFrame(image: await _image(tester), mirror: true));
    await tester.pump();
    expect(find.byType(RawImage), findsOneWidget);
    expect(find.text('placeholder'), findsNothing);

    cache.remove('a');
    await tester.pump();
    expect(find.text('placeholder'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' show StreamChat;
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    as chat
    show StreamChatClient;
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  // The app's routes sit below StreamChat, as in the router's shell route.
  testWidgets(
    'a dialog opened below StreamChat follows an accent change',
    (tester) async {
      final brand = ValueNotifier<StreamColorSwatch?>(StreamColors.red);
      addTearDown(brand.dispose);
      final client = chat.StreamChatClient('test-key');
      Color? accent;

      await tester.pumpWidget(
        ValueListenableBuilder(
          valueListenable: brand,
          builder: (context, brand, _) => MaterialApp(
            theme: ThemeData(
              extensions: [
                StreamTheme(
                  brightness: Brightness.light,
                  colorScheme: switch (brand) {
                    final brand? => StreamColorScheme.light(brand: brand),
                    null => null,
                  },
                ),
                StreamVideoTheme.light(),
              ],
            ),
            home: StreamChat(
              client: client,
              connectivityStream: const Stream.empty(),
              child: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showStreamModalDialog<void>(
                    context: context,
                    builder: (context) => Builder(
                      builder: (context) {
                        accent = context.streamColorScheme.accentPrimary;
                        return const SizedBox();
                      },
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(accent, StreamColors.red.shade500);

      brand.value = null;
      // One frame starts the app's theme animation, the next one ends it.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(accent, StreamColorScheme.light().accentPrimary);
    },
  );
}

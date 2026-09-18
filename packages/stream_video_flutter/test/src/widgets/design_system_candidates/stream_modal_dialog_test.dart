import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../../../test_utils/test_wrapper.dart';

void main() {
  /// Opens a dialog and leaves it open.
  ///
  /// [onResult] is called once the dialog is dismissed, which is the only
  /// point at which what it was popped with is known.
  Future<void> openDialog(
    WidgetTester tester, {
    required Widget Function(BuildContext context) builder,
    ValueChanged<String?>? onResult,
  }) async {
    await tester.pumpWidget(
      TestWrapper(
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              final result = await showStreamModalDialog<String>(
                context: context,
                builder: builder,
              );
              onResult?.call(result);
            },
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  group('StreamModalDialog', () {
    testWidgets('draws the title, the header actions and the footer actions', (
      tester,
    ) async {
      await openDialog(
        tester,
        builder: (context) => StreamModalDialog(
          title: const Text('Choose what to share'),
          headerActions: [
            StreamButton.icon(
              icon: Icon(context.streamIcons.refresh),
              onPressed: () {},
            ),
          ],
          actions: [
            StreamButton(onPressed: () {}, child: const Text('Cancel')),
            StreamButton(onPressed: () {}, child: const Text('Share')),
          ],
          child: const Text('body'),
        ),
      );

      expect(find.text('Choose what to share'), findsOneWidget);
      expect(find.byIcon(const StreamIcons().refresh), findsOneWidget);
      expect(find.text('body'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
    });

    testWidgets('the close button dismisses with no value', (tester) async {
      String? result;
      var popped = false;

      await openDialog(
        tester,
        builder: (context) => const StreamModalDialog(child: Text('body')),
        onResult: (value) {
          result = value;
          popped = true;
        },
      );

      await tester.tap(find.byIcon(const StreamIcons().xmark));
      await tester.pumpAndSettle();

      expect(find.text('body'), findsNothing);
      expect(popped, isTrue);
      expect(result, isNull);
    });

    testWidgets('draws no footer without actions', (tester) async {
      await openDialog(
        tester,
        builder: (context) => const StreamModalDialog(child: Text('body')),
      );

      expect(find.byType(StreamButton), findsOneWidget); // the close button
    });

    testWidgets('a tap outside dismisses it through the scrim', (tester) async {
      await openDialog(
        tester,
        builder: (context) => const StreamModalDialog(child: Text('body')),
      );

      expect(find.byType(StreamBlurScrim), findsOneWidget);

      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();

      expect(find.text('body'), findsNothing);
    });
  });
}

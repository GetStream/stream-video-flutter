import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dogfooding/widgets/side_panel/clipboard_image_paste.dart';
import 'package:flutter_test/flutter_test.dart';

const _png = <int>[0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0, 0];
const _bmp = <int>[0x42, 0x4D, 0, 0, 0, 0];

const _desktop = TargetPlatformVariant({
  TargetPlatform.macOS,
  TargetPlatform.windows,
  TargetPlatform.linux,
});

const _mobile = TargetPlatformVariant({
  TargetPlatform.iOS,
  TargetPlatform.android,
});

void main() {
  const pasteboard = MethodChannel('pasteboard');

  String? clipboardText;
  Object? clipboardImage;
  late int imageReads;
  late List<List<PastedImage>> reported;

  setUp(() {
    clipboardText = null;
    clipboardImage = null;
    imageReads = 0;
    reported = [];

    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      return switch (call.method) {
        'Clipboard.hasStrings' => {
          'value': clipboardText?.isNotEmpty ?? false,
        },
        'Clipboard.getData' =>
          clipboardText == null ? null : {'text': clipboardText},
        _ => null,
      };
    });
    messenger.setMockMethodCallHandler(pasteboard, (call) async {
      if (call.method != 'image') return null;
      imageReads++;
      final image = clipboardImage;
      if (image is Exception) throw image;
      return image;
    });
  });

  tearDown(() {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, null);
    messenger.setMockMethodCallHandler(pasteboard, null);
  });

  Future<TextEditingController> pumpField(WidgetTester tester) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: ClipboardImagePaste(
            focusNode: focusNode,
            onImages: reported.add,
            child: TextField(controller: controller, focusNode: focusNode),
          ),
        ),
      ),
    );
    focusNode.requestFocus();
    await tester.pump();
    return controller;
  }

  Future<void> pressPaste(WidgetTester tester) async {
    final modifier = switch (defaultTargetPlatform) {
      TargetPlatform.macOS || TargetPlatform.iOS => LogicalKeyboardKey.metaLeft,
      _ => LogicalKeyboardKey.controlLeft,
    };
    await tester.sendKeyDownEvent(modifier);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
    await tester.sendKeyUpEvent(modifier);
    await tester.pumpAndSettle();
  }

  testWidgets('an image on the clipboard is reported, not pasted', (
    tester,
  ) async {
    clipboardImage = Uint8List.fromList(_png);
    final controller = await pumpField(tester);

    await pressPaste(tester);

    expect(reported, hasLength(1));
    expect(reported.single.single.mimeType, 'image/png');
    expect(reported.single.single.bytes, _png);
    expect(controller.text, isEmpty);
  }, variant: _desktop);

  testWidgets('a BMP image is reported as image/bmp', (tester) async {
    clipboardImage = Uint8List.fromList(_bmp);
    await pumpField(tester);

    await pressPaste(tester);

    expect(reported.single.single.mimeType, 'image/bmp');
  }, variant: _desktop);

  testWidgets('text on the clipboard is pasted as text', (tester) async {
    clipboardText = 'hello';
    clipboardImage = Uint8List.fromList(_png);
    final controller = await pumpField(tester);

    await pressPaste(tester);

    expect(controller.text, 'hello');
    expect(reported, isEmpty);
    expect(imageReads, 0);
  }, variant: _desktop);

  testWidgets('data that is not an image is not reported', (tester) async {
    clipboardImage = Uint8List.fromList([1, 2, 3, 4]);
    final controller = await pumpField(tester);

    await pressPaste(tester);

    expect(reported, isEmpty);
    expect(controller.text, isEmpty);
  }, variant: _desktop);

  testWidgets('a failed clipboard read reports nothing and does not throw', (
    tester,
  ) async {
    clipboardImage = PlatformException(code: 'error');
    await pumpField(tester);

    await pressPaste(tester);

    expect(tester.takeException(), isNull);
    expect(reported, isEmpty);
  }, variant: _desktop);

  testWidgets('mobile pastes text and never reads an image', (tester) async {
    clipboardText = 'hello';
    clipboardImage = Uint8List.fromList(_png);
    final controller = await pumpField(tester);

    await pressPaste(tester);

    expect(controller.text, 'hello');
    expect(reported, isEmpty);
    expect(imageReads, 0);
  }, variant: _mobile);

  testWidgets('mobile ignores an image-only clipboard', (tester) async {
    clipboardImage = Uint8List.fromList(_png);
    await pumpField(tester);

    await pressPaste(tester);

    expect(reported, isEmpty);
    expect(imageReads, 0);
  }, variant: _mobile);
}

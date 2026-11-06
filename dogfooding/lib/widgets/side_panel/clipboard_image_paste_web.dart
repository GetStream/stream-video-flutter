import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'clipboard_image_paste.dart';

/// The images of each paste into the page.
///
/// A paste without images is skipped, and its text is left to the focused
/// text field.
Stream<List<PastedImage>> pastedImages() {
  return web.EventStreamProviders.pasteEvent
      .forTarget(web.document)
      .asyncMap(_readImages)
      .where((images) => images.isNotEmpty);
}

Future<List<PastedImage>> _readImages(web.ClipboardEvent event) {
  final files = event.clipboardData?.files;
  if (files == null) return Future.value(const []);

  return Future.wait([
    for (var i = 0; i < files.length; i++)
      if (files.item(i) case final file? when file.type.startsWith('image/'))
        _readImage(file),
  ]);
}

Future<PastedImage> _readImage(web.File file) async {
  final buffer = await file.arrayBuffer().toDart;
  return PastedImage(
    bytes: buffer.toDart.asUint8List(),
    mimeType: file.type,
    name: file.name,
  );
}

import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'clipboard_image_paste.dart';

/// Creates the listener for the web, which reads the document's paste event.
ClipboardImagePaste createClipboardImagePaste(
  void Function(List<PastedImage> images) onImages,
) => _WebClipboardImagePaste(onImages);

class _WebClipboardImagePaste implements ClipboardImagePaste {
  _WebClipboardImagePaste(this._onImages);

  final void Function(List<PastedImage> images) _onImages;
  StreamSubscription<web.ClipboardEvent>? _subscription;

  @override
  void start() {
    _subscription ??= web.EventStreamProviders.pasteEvent
        .forTarget(web.document)
        .listen(_onPaste);
  }

  @override
  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _onPaste(web.ClipboardEvent event) async {
    final files = event.clipboardData?.files;
    if (files == null) return;

    final imageFiles = <web.File>[
      for (var i = 0; i < files.length; i++)
        if (files.item(i) case final file? when file.type.startsWith('image/'))
          file,
    ];
    if (imageFiles.isEmpty) return;

    final images = <PastedImage>[];
    for (final file in imageFiles) {
      final buffer = await file.arrayBuffer().toDart;
      images.add(
        PastedImage(
          bytes: buffer.toDart.asUint8List(),
          mimeType: file.type,
          name: file.name,
        ),
      );
    }

    // Stopped while the files were being read.
    if (_subscription == null) return;
    _onImages(images);
  }
}

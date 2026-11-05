import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

import 'clipboard_image_paste.dart';

/// Reads the image files of the page's paste event while the text field has
/// focus. Text in the same paste is left to the text field.
class ClipboardImagePasteRegion extends StatefulWidget {
  /// Creates the region around [child].
  const ClipboardImagePasteRegion({
    super.key,
    required this.focusNode,
    required this.onImages,
    required this.child,
  });

  /// The text field whose pastes are read.
  final FocusNode focusNode;

  /// Called with the images of a paste.
  final ValueChanged<List<PastedImage>> onImages;

  /// The subtree holding the text field.
  final Widget child;

  @override
  State<ClipboardImagePasteRegion> createState() =>
      _ClipboardImagePasteRegionState();
}

class _ClipboardImagePasteRegionState extends State<ClipboardImagePasteRegion> {
  StreamSubscription<web.ClipboardEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
    _onFocusChanged();
  }

  @override
  void didUpdateWidget(ClipboardImagePasteRegion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChanged);
      widget.focusNode.addListener(_onFocusChanged);
      _onFocusChanged();
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    _stop();
    super.dispose();
  }

  void _onFocusChanged() {
    if (widget.focusNode.hasFocus) {
      _subscription ??= web.EventStreamProviders.pasteEvent
          .forTarget(web.document)
          .listen(_onPaste);
    } else {
      _stop();
    }
  }

  void _stop() {
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

    // Focus moved away while the files were being read.
    if (_subscription == null) return;
    widget.onImages(images);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

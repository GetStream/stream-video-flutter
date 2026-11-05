import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import 'clipboard_image_paste_stub.dart'
    if (dart.library.js_interop) 'clipboard_image_paste_web.dart'
    if (dart.library.io) 'clipboard_image_paste_native.dart'
    as platform;

/// An image pasted from the clipboard.
class PastedImage {
  /// Creates a pasted image.
  const PastedImage({
    required this.bytes,
    required this.mimeType,
    this.name = '',
  });

  /// The image data.
  final Uint8List bytes;

  /// The MIME type of [bytes], such as `image/png`.
  final String mimeType;

  /// The file name the clipboard reported, which can be empty.
  final String name;
}

/// Reports images pasted while [focusNode] has focus.
///
/// On the web this reads the files of the page's paste event. Elsewhere it
/// handles the paste shortcut in [child] and reads the image from the system
/// clipboard, handing the paste on to the text field when there is none.
/// Text pasted through a context menu is left to the text field.
class ClipboardImagePaste extends StatelessWidget {
  /// Creates a paste listener around [child].
  const ClipboardImagePaste({
    super.key,
    required this.focusNode,
    required this.onImages,
    required this.child,
  });

  /// The text field whose pastes are read.
  final FocusNode focusNode;

  /// Called with the images of a paste, never with an empty list.
  final ValueChanged<List<PastedImage>> onImages;

  /// The subtree holding the text field.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return platform.ClipboardImagePasteRegion(
      focusNode: focusNode,
      onImages: onImages,
      child: child,
    );
  }
}

import 'dart:typed_data';

import 'clipboard_image_paste_stub.dart'
    if (dart.library.js_interop) 'clipboard_image_paste_web.dart'
    as platform;

/// An image pasted from the clipboard.
class PastedImage {
  /// Creates a pasted image.
  const PastedImage({
    required this.bytes,
    required this.mimeType,
    required this.name,
  });

  /// The image data.
  final Uint8List bytes;

  /// The MIME type the clipboard reported, such as `image/png`.
  final String mimeType;

  /// The file name the clipboard reported, which can be empty.
  final String name;
}

/// Reports images pasted into the page while started.
///
/// Only the web has a page-level paste event carrying files; on the other
/// platforms this reports nothing. Text in the same paste is left to the
/// focused text field.
abstract interface class ClipboardImagePaste {
  /// Creates the paste listener for the current platform.
  factory ClipboardImagePaste({
    required void Function(List<PastedImage> images) onImages,
  }) => platform.createClipboardImagePaste(onImages);

  /// Starts reporting pasted images. Does nothing when already started.
  void start();

  /// Stops reporting pasted images.
  void stop();
}

import 'clipboard_image_paste.dart';

/// Creates the listener for platforms without a page paste event.
ClipboardImagePaste createClipboardImagePaste(
  void Function(List<PastedImage> images) onImages,
) => const _NoClipboardImagePaste();

class _NoClipboardImagePaste implements ClipboardImagePaste {
  const _NoClipboardImagePaste();

  @override
  void start() {}

  @override
  void stop() {}
}

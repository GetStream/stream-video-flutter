import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pasteboard/pasteboard.dart';

import 'clipboard_image_paste.dart';

/// Handles the paste shortcut in [child]: an image on the system clipboard is
/// reported, anything else is pasted into the focused text field as usual.
class ClipboardImagePasteRegion extends StatelessWidget {
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

  static SingleActivator get _pasteShortcut => switch (defaultTargetPlatform) {
    TargetPlatform.macOS || TargetPlatform.iOS => const SingleActivator(
      LogicalKeyboardKey.keyV,
      meta: true,
    ),
    _ => const SingleActivator(LogicalKeyboardKey.keyV, control: true),
  };

  Future<void> _onPaste() async {
    final context = focusNode.context;
    if (!focusNode.hasFocus || context == null) return;

    final bytes = await Pasteboard.image;
    final mimeType = bytes == null ? null : _imageMimeType(bytes);
    if (bytes != null && mimeType != null) {
      return onImages([PastedImage(bytes: bytes, mimeType: mimeType)]);
    }

    if (!context.mounted) return;
    Actions.maybeInvoke(
      context,
      const PasteTextIntent(SelectionChangedCause.keyboard),
    );
  }

  // The plugin hands over PNG on Apple platforms and Linux, BMP on Windows.
  static String? _imageMimeType(Uint8List bytes) {
    bool startsWith(List<int> magic) =>
        bytes.length >= magic.length &&
        Iterable<int>.generate(magic.length).every((i) => bytes[i] == magic[i]);

    if (startsWith(const [0x89, 0x50, 0x4E, 0x47])) return 'image/png';
    if (startsWith(const [0xFF, 0xD8, 0xFF])) return 'image/jpeg';
    if (startsWith(const [0x47, 0x49, 0x46, 0x38])) return 'image/gif';
    if (startsWith(const [0x42, 0x4D])) return 'image/bmp';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {_pasteShortcut: _onPaste},
      child: child,
    );
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mime/mime.dart';
import 'package:pasteboard/pasteboard.dart';

import 'clipboard_image_paste_stub.dart'
    if (dart.library.js_interop) 'clipboard_image_paste_web.dart';

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

/// A region that reports images pasted into its text field.
///
/// Covers the paste shortcut on web and desktop. When the clipboard holds
/// text, the text is pasted as usual and no image is reported. A paste from
/// the context menu always pastes text.
class ClipboardImagePaste extends StatefulWidget {
  /// Creates a paste region around [child].
  const ClipboardImagePaste({
    super.key,
    required this.focusNode,
    required this.onImages,
    required this.child,
  });

  /// The focus node of the text field whose pastes are read.
  final FocusNode focusNode;

  /// Called with the images of a paste, never with an empty list.
  final ValueChanged<List<PastedImage>> onImages;

  /// The subtree holding the text field.
  final Widget child;

  @override
  State<ClipboardImagePaste> createState() => _ClipboardImagePasteState();
}

class _ClipboardImagePasteState extends State<ClipboardImagePaste> {
  late final _pasteImage = _PasteImageAction(
    (images) => widget.onImages(images),
  );
  StreamSubscription<List<PastedImage>>? _webPastes;

  static bool get _isDesktop => switch (defaultTargetPlatform) {
    TargetPlatform.macOS ||
    TargetPlatform.windows ||
    TargetPlatform.linux => !kIsWeb,
    _ => false,
  };

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      widget.focusNode.addListener(_onFocusChanged);
      _onFocusChanged();
    }
  }

  @override
  void didUpdateWidget(ClipboardImagePaste oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (kIsWeb && oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChanged);
      widget.focusNode.addListener(_onFocusChanged);
      _onFocusChanged();
    }
  }

  @override
  void dispose() {
    if (kIsWeb) widget.focusNode.removeListener(_onFocusChanged);
    _webPastes?.cancel();
    super.dispose();
  }

  void _onFocusChanged() {
    if (widget.focusNode.hasFocus) {
      _webPastes ??= pastedImages().listen((images) => widget.onImages(images));
    } else {
      _webPastes?.cancel();
      _webPastes = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDesktop) return widget.child;

    return Actions(
      actions: <Type, Action<Intent>>{PasteTextIntent: _pasteImage},
      child: widget.child,
    );
  }
}

// Replaces the text field's paste: an image on the clipboard is reported,
// anything else is handed back to the text field's own paste.
class _PasteImageAction extends ContextAction<PasteTextIntent> {
  _PasteImageAction(this.onImages);

  final ValueChanged<List<PastedImage>> onImages;

  static final _mimeTypes = MimeTypeResolver()
    // Windows hands over BMP, which the default resolver does not detect.
    ..addMagicNumber(const [0x42, 0x4D], 'image/bmp');

  @override
  Future<void> invoke(PasteTextIntent intent, [BuildContext? context]) async {
    // The framework clears this once the synchronous part of invoke returns.
    final pasteText = callingAction;

    final image = await _readImage();
    if (image != null) return onImages([image]);

    if (context != null && !context.mounted) return;
    pasteText?.invoke(intent);
  }

  static Future<PastedImage?> _readImage() async {
    try {
      // Text wins: a clipboard with text can also carry an image of it.
      if (await Clipboard.hasStrings()) return null;

      final bytes = await Pasteboard.image;
      if (bytes == null) return null;

      final mimeType = _mimeTypes.lookup('', headerBytes: bytes);
      if (mimeType == null || !mimeType.startsWith('image/')) return null;
      return PastedImage(bytes: bytes, mimeType: mimeType);
    } on Exception {
      return null;
    }
  }
}

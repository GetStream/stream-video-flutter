import 'package:flutter/widgets.dart';

import 'clipboard_image_paste.dart';

/// Leaves pastes to the text field, on platforms without a clipboard to read.
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

  @override
  Widget build(BuildContext context) => child;
}

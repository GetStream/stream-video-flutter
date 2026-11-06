import 'clipboard_image_paste.dart';

/// The images pasted into the page, of which there are none outside the web.
Stream<List<PastedImage>> pastedImages() => const Stream.empty();

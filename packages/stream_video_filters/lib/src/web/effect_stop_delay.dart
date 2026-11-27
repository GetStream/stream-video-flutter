import 'package:meta/meta.dart';

/// How long a browser effect runs on after its filter is stopped.
///
/// A video element showing a track that ends turns black, so the effect
/// waits for what showed its output to move to the stream that replaces it.
@internal
const effectStopDelay = Duration(seconds: 1);

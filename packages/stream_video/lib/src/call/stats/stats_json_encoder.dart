import 'dart:convert';

import 'package:flutter/foundation.dart';

/// Encodes a stats payload to JSON off the UI isolate.
///
/// A full stats blob is every report of a peer connection with every one of its
/// properties, and it is encoded on every SFU stats tick for the lifetime of a
/// call. Doing that inline blocks the UI isolate for as long as it takes;
/// [compute] moves it to a worker instead.
///
/// Only plain JSON-encodable values may be passed — maps, lists, numbers,
/// strings and booleans — since the payload has to cross an isolate boundary.
///
/// On web there are no isolates, so [compute] runs the encode inline and this
/// is equivalent to calling [jsonEncode] directly.
Future<String> encodeStatsJson(Object payload) {
  return compute(_encodeJson, payload, debugLabel: 'encodeStatsJson');
}

String _encodeJson(Object payload) => jsonEncode(payload);

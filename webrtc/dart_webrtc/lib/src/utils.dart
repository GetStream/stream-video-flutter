import 'dart:math';

import 'package:web/web.dart' as web;

bool get isMobile {
  final toMatch = [
    'Android',
    'webOS',
    'iPhone',
    'iPad',
    'iPod',
    'BlackBerry',
    'Windows Phone',
    'OpenHarmony'
  ];
  return toMatch.indexWhere((device) => web.window.navigator.userAgent
          .contains(RegExp(device, caseSensitive: false))) !=
      -1;
}

String randomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final rnd = Random();
  final buf = StringBuffer();
  for (var i = 0; i < length; i++) {
    buf.write(chars[rnd.nextInt(chars.length)]);
  }
  return buf.toString();
}

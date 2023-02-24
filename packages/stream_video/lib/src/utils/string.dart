import 'dart:math';

const _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
Random _rnd = Random();

String generateAlphanumericString(int length) => String.fromCharCodes(
  Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
  ),
);

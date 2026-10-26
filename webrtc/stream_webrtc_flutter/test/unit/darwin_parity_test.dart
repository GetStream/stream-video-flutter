@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';

import '../../tool/darwin_parity.dart';

void main() {
  test('iOS and macOS Objective-C trees agree', () {
    final findings = checkDarwinParity();
    expect(
      findings,
      isEmpty,
      reason:
          'The two Darwin source trees have drifted:\n\n'
          '${findings.map((f) => '  - $f').join('\n\n')}\n\n'
          'See tool/darwin_parity.dart for how the trees are meant to relate.',
    );
  });
}

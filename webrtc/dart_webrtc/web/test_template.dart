import 'package:test/test.dart';

List<void Function()> testFunctions = <void Function()>[
  () => test('ClassName.constructor()', () {}),
  () => test('ClassName.method1()', () {}),
  () => test('ClassName.method2()', () {}),
  () => test('ClassName.method3()', () {})
];

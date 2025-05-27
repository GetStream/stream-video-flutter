import 'package:flutter/material.dart';

class TestWrapper extends StatelessWidget {
  const TestWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }
}

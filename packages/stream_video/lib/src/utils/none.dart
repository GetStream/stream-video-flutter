class None {
  factory None() {
    return _instance;
  }

  const None._internal();

  static const None _instance = None._internal();

  @override
  String toString() {
    return 'None';
  }
}

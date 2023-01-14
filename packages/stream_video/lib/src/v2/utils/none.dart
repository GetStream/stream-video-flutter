class None {
  factory None() {
    return _instance;
  }
  None._internal();
  static final None _instance = None._internal();
  @override
  String toString() {
    return 'None';
  }
}

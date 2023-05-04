/// Used instead of `void` as a return statement for a function when no value
/// is expected to be returned.
///
/// There is only one value of type [None].
class None {
  const None._instance();

  static const None _none = None._instance();

  @override
  String toString() => 'None';
}

/// Used instead of `void` as a return statement for a function when no value
/// is expected to be returned.
const none = None._none;

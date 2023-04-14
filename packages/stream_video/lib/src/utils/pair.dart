import 'package:meta/meta.dart';

@immutable
class Pair<T1, T2> {
  const Pair({
    required this.first,
    required this.second,
  });

  final T1 first;
  final T2 second;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }
}

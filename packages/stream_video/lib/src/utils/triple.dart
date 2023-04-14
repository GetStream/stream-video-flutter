import 'package:meta/meta.dart';

@immutable
class Triple<T1, T2, T3> {
  const Triple({
    required this.first,
    required this.second,
    required this.third,
  });

  final T1 first;
  final T2 second;
  final T3 third;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Triple &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second &&
          third == other.third;

  @override
  int get hashCode => first.hashCode ^ second.hashCode ^ third.hashCode;

  @override
  String toString() {
    return 'Triple{first: $first, second: $second, third: $third}';
  }
}

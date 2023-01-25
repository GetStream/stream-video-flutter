import 'package:meta/meta.dart';

@immutable
class StreamCallCid {
  factory StreamCallCid({required String cid}) {
    final typeAndId = cid.split(':');
    if (typeAndId.length != 2) {
      throw FormatException('invalid cid format: $cid');
    }
    return StreamCallCid._(
      value: cid,
      type: typeAndId.first,
      id: typeAndId.last,
    );
  }

  factory StreamCallCid.from({
    required String type,
    required String id,
  }) {
    return StreamCallCid._(
      value: '$type:$id',
      type: type,
      id: id,
    );
  }

  StreamCallCid._({
    required this.value,
    required this.type,
    required this.id,
  });

  final value;
  final type;
  final id;

  @override
  String toString() {
    return value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamCallCid &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

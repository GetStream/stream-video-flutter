import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class StreamCallCid with EquatableMixin {
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

  const StreamCallCid._({
    required this.value,
    required this.type,
    required this.id,
  });

  final String value;
  final String type;
  final String id;

  @override
  String toString() {
    return value;
  }

  @override
  List<Object?> get props => [value];
}

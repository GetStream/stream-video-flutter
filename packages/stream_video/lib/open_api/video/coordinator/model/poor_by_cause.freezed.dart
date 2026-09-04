// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poor_by_cause.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PoorByCause {
  int get delivery;
  int get edge;
  int get isolatedLocal;
  int get source;
  int get unattributed;

  /// Create a copy of PoorByCause
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PoorByCauseCopyWith<PoorByCause> get copyWith =>
      _$PoorByCauseCopyWithImpl<PoorByCause>(this as PoorByCause, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PoorByCause &&
            (identical(other.delivery, delivery) ||
                other.delivery == delivery) &&
            (identical(other.edge, edge) || other.edge == edge) &&
            (identical(other.isolatedLocal, isolatedLocal) ||
                other.isolatedLocal == isolatedLocal) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.unattributed, unattributed) ||
                other.unattributed == unattributed));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    delivery,
    edge,
    isolatedLocal,
    source,
    unattributed,
  );

  @override
  String toString() {
    return 'PoorByCause(delivery: $delivery, edge: $edge, isolatedLocal: $isolatedLocal, source: $source, unattributed: $unattributed)';
  }
}

/// @nodoc
abstract mixin class $PoorByCauseCopyWith<$Res> {
  factory $PoorByCauseCopyWith(
    PoorByCause value,
    $Res Function(PoorByCause) _then,
  ) = _$PoorByCauseCopyWithImpl;
  @useResult
  $Res call({
    int delivery,
    int edge,
    int isolatedLocal,
    int source,
    int unattributed,
  });
}

/// @nodoc
class _$PoorByCauseCopyWithImpl<$Res> implements $PoorByCauseCopyWith<$Res> {
  _$PoorByCauseCopyWithImpl(this._self, this._then);

  final PoorByCause _self;
  final $Res Function(PoorByCause) _then;

  /// Create a copy of PoorByCause
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? delivery = null,
    Object? edge = null,
    Object? isolatedLocal = null,
    Object? source = null,
    Object? unattributed = null,
  }) {
    return _then(
      PoorByCause(
        delivery: null == delivery
            ? _self.delivery
            : delivery // ignore: cast_nullable_to_non_nullable
                  as int,
        edge: null == edge
            ? _self.edge
            : edge // ignore: cast_nullable_to_non_nullable
                  as int,
        isolatedLocal: null == isolatedLocal
            ? _self.isolatedLocal
            : isolatedLocal // ignore: cast_nullable_to_non_nullable
                  as int,
        source: null == source
            ? _self.source
            : source // ignore: cast_nullable_to_non_nullable
                  as int,
        unattributed: null == unattributed
            ? _self.unattributed
            : unattributed // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

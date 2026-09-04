// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poor_tail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PoorTail {
  double? get healthyPct;
  int get healthyViewers;
  String get note;
  PoorByCause get poorByCause;
  int get poorTotal;
  Supporting get supporting;

  /// Create a copy of PoorTail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PoorTailCopyWith<PoorTail> get copyWith =>
      _$PoorTailCopyWithImpl<PoorTail>(this as PoorTail, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PoorTail &&
            (identical(other.healthyPct, healthyPct) ||
                other.healthyPct == healthyPct) &&
            (identical(other.healthyViewers, healthyViewers) ||
                other.healthyViewers == healthyViewers) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.poorByCause, poorByCause) ||
                other.poorByCause == poorByCause) &&
            (identical(other.poorTotal, poorTotal) ||
                other.poorTotal == poorTotal) &&
            (identical(other.supporting, supporting) ||
                other.supporting == supporting));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    healthyPct,
    healthyViewers,
    note,
    poorByCause,
    poorTotal,
    supporting,
  );

  @override
  String toString() {
    return 'PoorTail(healthyPct: $healthyPct, healthyViewers: $healthyViewers, note: $note, poorByCause: $poorByCause, poorTotal: $poorTotal, supporting: $supporting)';
  }
}

/// @nodoc
abstract mixin class $PoorTailCopyWith<$Res> {
  factory $PoorTailCopyWith(PoorTail value, $Res Function(PoorTail) _then) =
      _$PoorTailCopyWithImpl;
  @useResult
  $Res call({
    double? healthyPct,
    int healthyViewers,
    String note,
    PoorByCause poorByCause,
    int poorTotal,
    Supporting supporting,
  });
}

/// @nodoc
class _$PoorTailCopyWithImpl<$Res> implements $PoorTailCopyWith<$Res> {
  _$PoorTailCopyWithImpl(this._self, this._then);

  final PoorTail _self;
  final $Res Function(PoorTail) _then;

  /// Create a copy of PoorTail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? healthyPct = freezed,
    Object? healthyViewers = null,
    Object? note = null,
    Object? poorByCause = null,
    Object? poorTotal = null,
    Object? supporting = null,
  }) {
    return _then(
      PoorTail(
        healthyPct: freezed == healthyPct
            ? _self.healthyPct
            : healthyPct // ignore: cast_nullable_to_non_nullable
                  as double?,
        healthyViewers: null == healthyViewers
            ? _self.healthyViewers
            : healthyViewers // ignore: cast_nullable_to_non_nullable
                  as int,
        note: null == note
            ? _self.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String,
        poorByCause: null == poorByCause
            ? _self.poorByCause
            : poorByCause // ignore: cast_nullable_to_non_nullable
                  as PoorByCause,
        poorTotal: null == poorTotal
            ? _self.poorTotal
            : poorTotal // ignore: cast_nullable_to_non_nullable
                  as int,
        supporting: null == supporting
            ? _self.supporting
            : supporting // ignore: cast_nullable_to_non_nullable
                  as Supporting,
      ),
    );
  }
}

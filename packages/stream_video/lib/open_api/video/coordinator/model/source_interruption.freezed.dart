// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'source_interruption.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SourceInterruption {
  double get atOffsetMin;
  int get deadAirS;
  String get kind;
  bool? get seamless;

  /// Create a copy of SourceInterruption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SourceInterruptionCopyWith<SourceInterruption> get copyWith =>
      _$SourceInterruptionCopyWithImpl<SourceInterruption>(
        this as SourceInterruption,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SourceInterruption &&
            (identical(other.atOffsetMin, atOffsetMin) ||
                other.atOffsetMin == atOffsetMin) &&
            (identical(other.deadAirS, deadAirS) ||
                other.deadAirS == deadAirS) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.seamless, seamless) ||
                other.seamless == seamless));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, atOffsetMin, deadAirS, kind, seamless);

  @override
  String toString() {
    return 'SourceInterruption(atOffsetMin: $atOffsetMin, deadAirS: $deadAirS, kind: $kind, seamless: $seamless)';
  }
}

/// @nodoc
abstract mixin class $SourceInterruptionCopyWith<$Res> {
  factory $SourceInterruptionCopyWith(
    SourceInterruption value,
    $Res Function(SourceInterruption) _then,
  ) = _$SourceInterruptionCopyWithImpl;
  @useResult
  $Res call({double atOffsetMin, int deadAirS, String kind, bool? seamless});
}

/// @nodoc
class _$SourceInterruptionCopyWithImpl<$Res>
    implements $SourceInterruptionCopyWith<$Res> {
  _$SourceInterruptionCopyWithImpl(this._self, this._then);

  final SourceInterruption _self;
  final $Res Function(SourceInterruption) _then;

  /// Create a copy of SourceInterruption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? atOffsetMin = null,
    Object? deadAirS = null,
    Object? kind = null,
    Object? seamless = freezed,
  }) {
    return _then(
      SourceInterruption(
        atOffsetMin: null == atOffsetMin
            ? _self.atOffsetMin
            : atOffsetMin // ignore: cast_nullable_to_non_nullable
                  as double,
        deadAirS: null == deadAirS
            ? _self.deadAirS
            : deadAirS // ignore: cast_nullable_to_non_nullable
                  as int,
        kind: null == kind
            ? _self.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as String,
        seamless: freezed == seamless
            ? _self.seamless
            : seamless // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

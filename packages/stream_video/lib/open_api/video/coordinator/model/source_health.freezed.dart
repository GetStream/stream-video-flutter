// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'source_health.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SourceHealth {
  int get coHostPeak;
  int get deadAirS;
  List<SourceInterruption> get interruptions;
  List<PublisherSession> get publisherSessions;

  /// Create a copy of SourceHealth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SourceHealthCopyWith<SourceHealth> get copyWith =>
      _$SourceHealthCopyWithImpl<SourceHealth>(
        this as SourceHealth,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SourceHealth &&
            (identical(other.coHostPeak, coHostPeak) ||
                other.coHostPeak == coHostPeak) &&
            (identical(other.deadAirS, deadAirS) ||
                other.deadAirS == deadAirS) &&
            const DeepCollectionEquality().equals(
              other.interruptions,
              interruptions,
            ) &&
            const DeepCollectionEquality().equals(
              other.publisherSessions,
              publisherSessions,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    coHostPeak,
    deadAirS,
    const DeepCollectionEquality().hash(interruptions),
    const DeepCollectionEquality().hash(publisherSessions),
  );

  @override
  String toString() {
    return 'SourceHealth(coHostPeak: $coHostPeak, deadAirS: $deadAirS, interruptions: $interruptions, publisherSessions: $publisherSessions)';
  }
}

/// @nodoc
abstract mixin class $SourceHealthCopyWith<$Res> {
  factory $SourceHealthCopyWith(
    SourceHealth value,
    $Res Function(SourceHealth) _then,
  ) = _$SourceHealthCopyWithImpl;
  @useResult
  $Res call({
    int coHostPeak,
    int deadAirS,
    List<SourceInterruption> interruptions,
    List<PublisherSession> publisherSessions,
  });
}

/// @nodoc
class _$SourceHealthCopyWithImpl<$Res> implements $SourceHealthCopyWith<$Res> {
  _$SourceHealthCopyWithImpl(this._self, this._then);

  final SourceHealth _self;
  final $Res Function(SourceHealth) _then;

  /// Create a copy of SourceHealth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coHostPeak = null,
    Object? deadAirS = null,
    Object? interruptions = null,
    Object? publisherSessions = null,
  }) {
    return _then(
      SourceHealth(
        coHostPeak: null == coHostPeak
            ? _self.coHostPeak
            : coHostPeak // ignore: cast_nullable_to_non_nullable
                  as int,
        deadAirS: null == deadAirS
            ? _self.deadAirS
            : deadAirS // ignore: cast_nullable_to_non_nullable
                  as int,
        interruptions: null == interruptions
            ? _self.interruptions
            : interruptions // ignore: cast_nullable_to_non_nullable
                  as List<SourceInterruption>,
        publisherSessions: null == publisherSessions
            ? _self.publisherSessions
            : publisherSessions // ignore: cast_nullable_to_non_nullable
                  as List<PublisherSession>,
      ),
    );
  }
}

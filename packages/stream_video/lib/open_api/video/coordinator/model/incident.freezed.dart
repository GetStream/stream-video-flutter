// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incident.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Incident {
  String get from;
  int get peakConcurrency;
  String get to;
  int get viewersInterrupted;

  /// Create a copy of Incident
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IncidentCopyWith<Incident> get copyWith =>
      _$IncidentCopyWithImpl<Incident>(this as Incident, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Incident &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.peakConcurrency, peakConcurrency) ||
                other.peakConcurrency == peakConcurrency) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.viewersInterrupted, viewersInterrupted) ||
                other.viewersInterrupted == viewersInterrupted));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, from, peakConcurrency, to, viewersInterrupted);

  @override
  String toString() {
    return 'Incident(from: $from, peakConcurrency: $peakConcurrency, to: $to, viewersInterrupted: $viewersInterrupted)';
  }
}

/// @nodoc
abstract mixin class $IncidentCopyWith<$Res> {
  factory $IncidentCopyWith(Incident value, $Res Function(Incident) _then) =
      _$IncidentCopyWithImpl;
  @useResult
  $Res call({
    String from,
    int peakConcurrency,
    String to,
    int viewersInterrupted,
  });
}

/// @nodoc
class _$IncidentCopyWithImpl<$Res> implements $IncidentCopyWith<$Res> {
  _$IncidentCopyWithImpl(this._self, this._then);

  final Incident _self;
  final $Res Function(Incident) _then;

  /// Create a copy of Incident
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? peakConcurrency = null,
    Object? to = null,
    Object? viewersInterrupted = null,
  }) {
    return _then(
      Incident(
        from: null == from
            ? _self.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String,
        peakConcurrency: null == peakConcurrency
            ? _self.peakConcurrency
            : peakConcurrency // ignore: cast_nullable_to_non_nullable
                  as int,
        to: null == to
            ? _self.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String,
        viewersInterrupted: null == viewersInterrupted
            ? _self.viewersInterrupted
            : viewersInterrupted // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_window.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeWindow {
  String get from;
  String get to;

  /// Create a copy of TimeWindow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimeWindowCopyWith<TimeWindow> get copyWith =>
      _$TimeWindowCopyWithImpl<TimeWindow>(this as TimeWindow, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimeWindow &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to));
  }

  @override
  int get hashCode => Object.hash(runtimeType, from, to);

  @override
  String toString() {
    return 'TimeWindow(from: $from, to: $to)';
  }
}

/// @nodoc
abstract mixin class $TimeWindowCopyWith<$Res> {
  factory $TimeWindowCopyWith(
    TimeWindow value,
    $Res Function(TimeWindow) _then,
  ) = _$TimeWindowCopyWithImpl;
  @useResult
  $Res call({String from, String to});
}

/// @nodoc
class _$TimeWindowCopyWithImpl<$Res> implements $TimeWindowCopyWith<$Res> {
  _$TimeWindowCopyWithImpl(this._self, this._then);

  final TimeWindow _self;
  final $Res Function(TimeWindow) _then;

  /// Create a copy of TimeWindow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? from = null, Object? to = null}) {
    return _then(
      TimeWindow(
        from: null == from
            ? _self.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String,
        to: null == to
            ? _self.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

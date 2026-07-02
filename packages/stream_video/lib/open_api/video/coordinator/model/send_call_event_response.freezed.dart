// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_call_event_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendCallEventResponse {
  String get duration;

  /// Create a copy of SendCallEventResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SendCallEventResponseCopyWith<SendCallEventResponse> get copyWith =>
      _$SendCallEventResponseCopyWithImpl<SendCallEventResponse>(
        this as SendCallEventResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendCallEventResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration);

  @override
  String toString() {
    return 'SendCallEventResponse(duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $SendCallEventResponseCopyWith<$Res> {
  factory $SendCallEventResponseCopyWith(
    SendCallEventResponse value,
    $Res Function(SendCallEventResponse) _then,
  ) = _$SendCallEventResponseCopyWithImpl;
  @useResult
  $Res call({String duration});
}

/// @nodoc
class _$SendCallEventResponseCopyWithImpl<$Res>
    implements $SendCallEventResponseCopyWith<$Res> {
  _$SendCallEventResponseCopyWithImpl(this._self, this._then);

  final SendCallEventResponse _self;
  final $Res Function(SendCallEventResponse) _then;

  /// Create a copy of SendCallEventResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null}) {
    return _then(
      SendCallEventResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

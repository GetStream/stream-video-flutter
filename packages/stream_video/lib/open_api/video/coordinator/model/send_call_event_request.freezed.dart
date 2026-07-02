// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_call_event_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendCallEventRequest {
  Map<String, Object?>? get custom;

  /// Create a copy of SendCallEventRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SendCallEventRequestCopyWith<SendCallEventRequest> get copyWith =>
      _$SendCallEventRequestCopyWithImpl<SendCallEventRequest>(
        this as SendCallEventRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendCallEventRequest &&
            const DeepCollectionEquality().equals(other.custom, custom));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(custom));

  @override
  String toString() {
    return 'SendCallEventRequest(custom: $custom)';
  }
}

/// @nodoc
abstract mixin class $SendCallEventRequestCopyWith<$Res> {
  factory $SendCallEventRequestCopyWith(
    SendCallEventRequest value,
    $Res Function(SendCallEventRequest) _then,
  ) = _$SendCallEventRequestCopyWithImpl;
  @useResult
  $Res call({Map<String, Object?>? custom});
}

/// @nodoc
class _$SendCallEventRequestCopyWithImpl<$Res>
    implements $SendCallEventRequestCopyWith<$Res> {
  _$SendCallEventRequestCopyWithImpl(this._self, this._then);

  final SendCallEventRequest _self;
  final $Res Function(SendCallEventRequest) _then;

  /// Create a copy of SendCallEventRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? custom = freezed}) {
    return _then(
      SendCallEventRequest(
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
      ),
    );
  }
}

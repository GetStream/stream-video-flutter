// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_call_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateCallRequest {
  Map<String, Object?>? get custom;
  CallSettingsRequest? get settingsOverride;
  DateTime? get startsAt;

  /// Create a copy of UpdateCallRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateCallRequestCopyWith<UpdateCallRequest> get copyWith =>
      _$UpdateCallRequestCopyWithImpl<UpdateCallRequest>(
        this as UpdateCallRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateCallRequest &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.settingsOverride, settingsOverride) ||
                other.settingsOverride == settingsOverride) &&
            (identical(other.startsAt, startsAt) ||
                other.startsAt == startsAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(custom),
    settingsOverride,
    startsAt,
  );

  @override
  String toString() {
    return 'UpdateCallRequest(custom: $custom, settingsOverride: $settingsOverride, startsAt: $startsAt)';
  }
}

/// @nodoc
abstract mixin class $UpdateCallRequestCopyWith<$Res> {
  factory $UpdateCallRequestCopyWith(
    UpdateCallRequest value,
    $Res Function(UpdateCallRequest) _then,
  ) = _$UpdateCallRequestCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?>? custom,
    CallSettingsRequest? settingsOverride,
    DateTime? startsAt,
  });
}

/// @nodoc
class _$UpdateCallRequestCopyWithImpl<$Res>
    implements $UpdateCallRequestCopyWith<$Res> {
  _$UpdateCallRequestCopyWithImpl(this._self, this._then);

  final UpdateCallRequest _self;
  final $Res Function(UpdateCallRequest) _then;

  /// Create a copy of UpdateCallRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? custom = freezed,
    Object? settingsOverride = freezed,
    Object? startsAt = freezed,
  }) {
    return _then(
      UpdateCallRequest(
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        settingsOverride: freezed == settingsOverride
            ? _self.settingsOverride
            : settingsOverride // ignore: cast_nullable_to_non_nullable
                  as CallSettingsRequest?,
        startsAt: freezed == startsAt
            ? _self.startsAt
            : startsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

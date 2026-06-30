// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sip_caller_configs_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SIPCallerConfigsResponse {
  Map<String, Object?> get customData;
  String get id;

  /// Create a copy of SIPCallerConfigsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SIPCallerConfigsResponseCopyWith<SIPCallerConfigsResponse> get copyWith =>
      _$SIPCallerConfigsResponseCopyWithImpl<SIPCallerConfigsResponse>(
        this as SIPCallerConfigsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SIPCallerConfigsResponse &&
            const DeepCollectionEquality().equals(
              other.customData,
              customData,
            ) &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(customData),
    id,
  );

  @override
  String toString() {
    return 'SIPCallerConfigsResponse(customData: $customData, id: $id)';
  }
}

/// @nodoc
abstract mixin class $SIPCallerConfigsResponseCopyWith<$Res> {
  factory $SIPCallerConfigsResponseCopyWith(
    SIPCallerConfigsResponse value,
    $Res Function(SIPCallerConfigsResponse) _then,
  ) = _$SIPCallerConfigsResponseCopyWithImpl;
  @useResult
  $Res call({Map<String, Object?> customData, String id});
}

/// @nodoc
class _$SIPCallerConfigsResponseCopyWithImpl<$Res>
    implements $SIPCallerConfigsResponseCopyWith<$Res> {
  _$SIPCallerConfigsResponseCopyWithImpl(this._self, this._then);

  final SIPCallerConfigsResponse _self;
  final $Res Function(SIPCallerConfigsResponse) _then;

  /// Create a copy of SIPCallerConfigsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? customData = null, Object? id = null}) {
    return _then(
      SIPCallerConfigsResponse(
        customData: null == customData
            ? _self.customData
            : customData // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

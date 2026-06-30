// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_state_response_fields.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallStateResponseFields {
  CallResponse get call;
  List<MemberResponse> get members;
  MemberResponse? get membership;
  List<OwnCapability> get ownCapabilities;

  /// Create a copy of CallStateResponseFields
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallStateResponseFieldsCopyWith<CallStateResponseFields> get copyWith =>
      _$CallStateResponseFieldsCopyWithImpl<CallStateResponseFields>(
        this as CallStateResponseFields,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallStateResponseFields &&
            (identical(other.call, call) || other.call == call) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.membership, membership) ||
                other.membership == membership) &&
            const DeepCollectionEquality().equals(
              other.ownCapabilities,
              ownCapabilities,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    call,
    const DeepCollectionEquality().hash(members),
    membership,
    const DeepCollectionEquality().hash(ownCapabilities),
  );

  @override
  String toString() {
    return 'CallStateResponseFields(call: $call, members: $members, membership: $membership, ownCapabilities: $ownCapabilities)';
  }
}

/// @nodoc
abstract mixin class $CallStateResponseFieldsCopyWith<$Res> {
  factory $CallStateResponseFieldsCopyWith(
    CallStateResponseFields value,
    $Res Function(CallStateResponseFields) _then,
  ) = _$CallStateResponseFieldsCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    List<MemberResponse> members,
    MemberResponse? membership,
    List<OwnCapability> ownCapabilities,
  });
}

/// @nodoc
class _$CallStateResponseFieldsCopyWithImpl<$Res>
    implements $CallStateResponseFieldsCopyWith<$Res> {
  _$CallStateResponseFieldsCopyWithImpl(this._self, this._then);

  final CallStateResponseFields _self;
  final $Res Function(CallStateResponseFields) _then;

  /// Create a copy of CallStateResponseFields
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? members = null,
    Object? membership = freezed,
    Object? ownCapabilities = null,
  }) {
    return _then(
      CallStateResponseFields(
        call: null == call
            ? _self.call
            : call // ignore: cast_nullable_to_non_nullable
                  as CallResponse,
        members: null == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<MemberResponse>,
        membership: freezed == membership
            ? _self.membership
            : membership // ignore: cast_nullable_to_non_nullable
                  as MemberResponse?,
        ownCapabilities: null == ownCapabilities
            ? _self.ownCapabilities
            : ownCapabilities // ignore: cast_nullable_to_non_nullable
                  as List<OwnCapability>,
      ),
    );
  }
}

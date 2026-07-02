// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sip_trunk_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SIPTrunkResponse {
  List<String> get allowedIps;
  DateTime get createdAt;
  String get id;
  String get name;
  List<String> get numbers;
  String get password;
  DateTime get updatedAt;
  String get uri;
  String get username;

  /// Create a copy of SIPTrunkResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SIPTrunkResponseCopyWith<SIPTrunkResponse> get copyWith =>
      _$SIPTrunkResponseCopyWithImpl<SIPTrunkResponse>(
        this as SIPTrunkResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SIPTrunkResponse &&
            const DeepCollectionEquality().equals(
              other.allowedIps,
              allowedIps,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.numbers, numbers) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(allowedIps),
    createdAt,
    id,
    name,
    const DeepCollectionEquality().hash(numbers),
    password,
    updatedAt,
    uri,
    username,
  );

  @override
  String toString() {
    return 'SIPTrunkResponse(allowedIps: $allowedIps, createdAt: $createdAt, id: $id, name: $name, numbers: $numbers, password: $password, updatedAt: $updatedAt, uri: $uri, username: $username)';
  }
}

/// @nodoc
abstract mixin class $SIPTrunkResponseCopyWith<$Res> {
  factory $SIPTrunkResponseCopyWith(
    SIPTrunkResponse value,
    $Res Function(SIPTrunkResponse) _then,
  ) = _$SIPTrunkResponseCopyWithImpl;
  @useResult
  $Res call({
    List<String> allowedIps,
    DateTime createdAt,
    String id,
    String name,
    List<String> numbers,
    String password,
    DateTime updatedAt,
    String uri,
    String username,
  });
}

/// @nodoc
class _$SIPTrunkResponseCopyWithImpl<$Res>
    implements $SIPTrunkResponseCopyWith<$Res> {
  _$SIPTrunkResponseCopyWithImpl(this._self, this._then);

  final SIPTrunkResponse _self;
  final $Res Function(SIPTrunkResponse) _then;

  /// Create a copy of SIPTrunkResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowedIps = null,
    Object? createdAt = null,
    Object? id = null,
    Object? name = null,
    Object? numbers = null,
    Object? password = null,
    Object? updatedAt = null,
    Object? uri = null,
    Object? username = null,
  }) {
    return _then(
      SIPTrunkResponse(
        allowedIps: null == allowedIps
            ? _self.allowedIps
            : allowedIps // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        numbers: null == numbers
            ? _self.numbers
            : numbers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        password: null == password
            ? _self.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        uri: null == uri
            ? _self.uri
            : uri // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _self.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

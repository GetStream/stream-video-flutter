// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credentials.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Credentials {
  List<ICEServerResponse> get iceServers;
  SFUResponse get server;
  String get token;

  /// Create a copy of Credentials
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CredentialsCopyWith<Credentials> get copyWith =>
      _$CredentialsCopyWithImpl<Credentials>(this as Credentials, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Credentials &&
            const DeepCollectionEquality().equals(
              other.iceServers,
              iceServers,
            ) &&
            (identical(other.server, server) || other.server == server) &&
            (identical(other.token, token) || other.token == token));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(iceServers),
    server,
    token,
  );

  @override
  String toString() {
    return 'Credentials(iceServers: $iceServers, server: $server, token: $token)';
  }
}

/// @nodoc
abstract mixin class $CredentialsCopyWith<$Res> {
  factory $CredentialsCopyWith(
    Credentials value,
    $Res Function(Credentials) _then,
  ) = _$CredentialsCopyWithImpl;
  @useResult
  $Res call({
    List<ICEServerResponse> iceServers,
    SFUResponse server,
    String token,
  });
}

/// @nodoc
class _$CredentialsCopyWithImpl<$Res> implements $CredentialsCopyWith<$Res> {
  _$CredentialsCopyWithImpl(this._self, this._then);

  final Credentials _self;
  final $Res Function(Credentials) _then;

  /// Create a copy of Credentials
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iceServers = null,
    Object? server = null,
    Object? token = null,
  }) {
    return _then(
      Credentials(
        iceServers: null == iceServers
            ? _self.iceServers
            : iceServers // ignore: cast_nullable_to_non_nullable
                  as List<ICEServerResponse>,
        server: null == server
            ? _self.server
            : server // ignore: cast_nullable_to_non_nullable
                  as SFUResponse,
        token: null == token
            ? _self.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

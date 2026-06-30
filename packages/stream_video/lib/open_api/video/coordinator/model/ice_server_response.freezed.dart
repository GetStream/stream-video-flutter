// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ice_server_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ICEServerResponse {
  String get password;
  List<String> get urls;
  String get username;

  /// Create a copy of ICEServerResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ICEServerResponseCopyWith<ICEServerResponse> get copyWith =>
      _$ICEServerResponseCopyWithImpl<ICEServerResponse>(
        this as ICEServerResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ICEServerResponse &&
            (identical(other.password, password) ||
                other.password == password) &&
            const DeepCollectionEquality().equals(other.urls, urls) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    password,
    const DeepCollectionEquality().hash(urls),
    username,
  );

  @override
  String toString() {
    return 'ICEServerResponse(password: $password, urls: $urls, username: $username)';
  }
}

/// @nodoc
abstract mixin class $ICEServerResponseCopyWith<$Res> {
  factory $ICEServerResponseCopyWith(
    ICEServerResponse value,
    $Res Function(ICEServerResponse) _then,
  ) = _$ICEServerResponseCopyWithImpl;
  @useResult
  $Res call({String password, List<String> urls, String username});
}

/// @nodoc
class _$ICEServerResponseCopyWithImpl<$Res>
    implements $ICEServerResponseCopyWith<$Res> {
  _$ICEServerResponseCopyWithImpl(this._self, this._then);

  final ICEServerResponse _self;
  final $Res Function(ICEServerResponse) _then;

  /// Create a copy of ICEServerResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
    Object? urls = null,
    Object? username = null,
  }) {
    return _then(
      ICEServerResponse(
        password: null == password
            ? _self.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        urls: null == urls
            ? _self.urls
            : urls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        username: null == username
            ? _self.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sip_challenge_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SIPChallengeRequest {

 String? get a1; String? get algorithm; String? get charset; String? get cnonce; List<String>? get domain; String? get method; String? get nc; String? get nonce; String? get opaque; List<String>? get qop; String? get realm; String? get response; bool? get stale; String? get uri; bool? get userhash; String? get username;
/// Create a copy of SIPChallengeRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SIPChallengeRequestCopyWith<SIPChallengeRequest> get copyWith => _$SIPChallengeRequestCopyWithImpl<SIPChallengeRequest>(this as SIPChallengeRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SIPChallengeRequest&&(identical(other.a1, a1) || other.a1 == a1)&&(identical(other.algorithm, algorithm) || other.algorithm == algorithm)&&(identical(other.charset, charset) || other.charset == charset)&&(identical(other.cnonce, cnonce) || other.cnonce == cnonce)&&const DeepCollectionEquality().equals(other.domain, domain)&&(identical(other.method, method) || other.method == method)&&(identical(other.nc, nc) || other.nc == nc)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.opaque, opaque) || other.opaque == opaque)&&const DeepCollectionEquality().equals(other.qop, qop)&&(identical(other.realm, realm) || other.realm == realm)&&(identical(other.response, response) || other.response == response)&&(identical(other.stale, stale) || other.stale == stale)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.userhash, userhash) || other.userhash == userhash)&&(identical(other.username, username) || other.username == username));
}


@override
int get hashCode => Object.hash(runtimeType,a1,algorithm,charset,cnonce,const DeepCollectionEquality().hash(domain),method,nc,nonce,opaque,const DeepCollectionEquality().hash(qop),realm,response,stale,uri,userhash,username);

@override
String toString() {
  return 'SIPChallengeRequest(a1: $a1, algorithm: $algorithm, charset: $charset, cnonce: $cnonce, domain: $domain, method: $method, nc: $nc, nonce: $nonce, opaque: $opaque, qop: $qop, realm: $realm, response: $response, stale: $stale, uri: $uri, userhash: $userhash, username: $username)';
}


}

/// @nodoc
abstract mixin class $SIPChallengeRequestCopyWith<$Res>  {
  factory $SIPChallengeRequestCopyWith(SIPChallengeRequest value, $Res Function(SIPChallengeRequest) _then) = _$SIPChallengeRequestCopyWithImpl;
@useResult
$Res call({
 String? a1, String? algorithm, String? charset, String? cnonce, List<String>? domain, String? method, String? nc, String? nonce, String? opaque, List<String>? qop, String? realm, String? response, bool? stale, String? uri, bool? userhash, String? username
});




}
/// @nodoc
class _$SIPChallengeRequestCopyWithImpl<$Res>
    implements $SIPChallengeRequestCopyWith<$Res> {
  _$SIPChallengeRequestCopyWithImpl(this._self, this._then);

  final SIPChallengeRequest _self;
  final $Res Function(SIPChallengeRequest) _then;

/// Create a copy of SIPChallengeRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? a1 = freezed,Object? algorithm = freezed,Object? charset = freezed,Object? cnonce = freezed,Object? domain = freezed,Object? method = freezed,Object? nc = freezed,Object? nonce = freezed,Object? opaque = freezed,Object? qop = freezed,Object? realm = freezed,Object? response = freezed,Object? stale = freezed,Object? uri = freezed,Object? userhash = freezed,Object? username = freezed,}) {
  return _then(SIPChallengeRequest(
a1: freezed == a1 ? _self.a1 : a1 // ignore: cast_nullable_to_non_nullable
as String?,algorithm: freezed == algorithm ? _self.algorithm : algorithm // ignore: cast_nullable_to_non_nullable
as String?,charset: freezed == charset ? _self.charset : charset // ignore: cast_nullable_to_non_nullable
as String?,cnonce: freezed == cnonce ? _self.cnonce : cnonce // ignore: cast_nullable_to_non_nullable
as String?,domain: freezed == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as List<String>?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,nc: freezed == nc ? _self.nc : nc // ignore: cast_nullable_to_non_nullable
as String?,nonce: freezed == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String?,opaque: freezed == opaque ? _self.opaque : opaque // ignore: cast_nullable_to_non_nullable
as String?,qop: freezed == qop ? _self.qop : qop // ignore: cast_nullable_to_non_nullable
as List<String>?,realm: freezed == realm ? _self.realm : realm // ignore: cast_nullable_to_non_nullable
as String?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as String?,stale: freezed == stale ? _self.stale : stale // ignore: cast_nullable_to_non_nullable
as bool?,uri: freezed == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String?,userhash: freezed == userhash ? _self.userhash : userhash // ignore: cast_nullable_to_non_nullable
as bool?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SIPChallengeRequest].
extension SIPChallengeRequestPatterns on SIPChallengeRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on

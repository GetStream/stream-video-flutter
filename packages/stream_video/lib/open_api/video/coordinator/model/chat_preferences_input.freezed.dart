// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_preferences_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatPreferencesInput {

 ChatPreferencesInputChannelMentions? get channelMentions; ChatPreferencesInputDefaultPreference? get defaultPreference; ChatPreferencesInputDirectMentions? get directMentions; ChatPreferencesInputGroupMentions? get groupMentions; ChatPreferencesInputHereMentions? get hereMentions; ChatPreferencesInputRoleMentions? get roleMentions; ChatPreferencesInputThreadReplies? get threadReplies;
/// Create a copy of ChatPreferencesInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatPreferencesInputCopyWith<ChatPreferencesInput> get copyWith => _$ChatPreferencesInputCopyWithImpl<ChatPreferencesInput>(this as ChatPreferencesInput, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatPreferencesInput&&(identical(other.channelMentions, channelMentions) || other.channelMentions == channelMentions)&&(identical(other.defaultPreference, defaultPreference) || other.defaultPreference == defaultPreference)&&(identical(other.directMentions, directMentions) || other.directMentions == directMentions)&&(identical(other.groupMentions, groupMentions) || other.groupMentions == groupMentions)&&(identical(other.hereMentions, hereMentions) || other.hereMentions == hereMentions)&&(identical(other.roleMentions, roleMentions) || other.roleMentions == roleMentions)&&(identical(other.threadReplies, threadReplies) || other.threadReplies == threadReplies));
}


@override
int get hashCode => Object.hash(runtimeType,channelMentions,defaultPreference,directMentions,groupMentions,hereMentions,roleMentions,threadReplies);

@override
String toString() {
  return 'ChatPreferencesInput(channelMentions: $channelMentions, defaultPreference: $defaultPreference, directMentions: $directMentions, groupMentions: $groupMentions, hereMentions: $hereMentions, roleMentions: $roleMentions, threadReplies: $threadReplies)';
}


}

/// @nodoc
abstract mixin class $ChatPreferencesInputCopyWith<$Res>  {
  factory $ChatPreferencesInputCopyWith(ChatPreferencesInput value, $Res Function(ChatPreferencesInput) _then) = _$ChatPreferencesInputCopyWithImpl;
@useResult
$Res call({
 ChatPreferencesInputChannelMentions? channelMentions, ChatPreferencesInputDefaultPreference? defaultPreference, ChatPreferencesInputDirectMentions? directMentions, ChatPreferencesInputGroupMentions? groupMentions, ChatPreferencesInputHereMentions? hereMentions, ChatPreferencesInputRoleMentions? roleMentions, ChatPreferencesInputThreadReplies? threadReplies
});




}
/// @nodoc
class _$ChatPreferencesInputCopyWithImpl<$Res>
    implements $ChatPreferencesInputCopyWith<$Res> {
  _$ChatPreferencesInputCopyWithImpl(this._self, this._then);

  final ChatPreferencesInput _self;
  final $Res Function(ChatPreferencesInput) _then;

/// Create a copy of ChatPreferencesInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channelMentions = freezed,Object? defaultPreference = freezed,Object? directMentions = freezed,Object? groupMentions = freezed,Object? hereMentions = freezed,Object? roleMentions = freezed,Object? threadReplies = freezed,}) {
  return _then(ChatPreferencesInput(
channelMentions: freezed == channelMentions ? _self.channelMentions : channelMentions // ignore: cast_nullable_to_non_nullable
as ChatPreferencesInputChannelMentions?,defaultPreference: freezed == defaultPreference ? _self.defaultPreference : defaultPreference // ignore: cast_nullable_to_non_nullable
as ChatPreferencesInputDefaultPreference?,directMentions: freezed == directMentions ? _self.directMentions : directMentions // ignore: cast_nullable_to_non_nullable
as ChatPreferencesInputDirectMentions?,groupMentions: freezed == groupMentions ? _self.groupMentions : groupMentions // ignore: cast_nullable_to_non_nullable
as ChatPreferencesInputGroupMentions?,hereMentions: freezed == hereMentions ? _self.hereMentions : hereMentions // ignore: cast_nullable_to_non_nullable
as ChatPreferencesInputHereMentions?,roleMentions: freezed == roleMentions ? _self.roleMentions : roleMentions // ignore: cast_nullable_to_non_nullable
as ChatPreferencesInputRoleMentions?,threadReplies: freezed == threadReplies ? _self.threadReplies : threadReplies // ignore: cast_nullable_to_non_nullable
as ChatPreferencesInputThreadReplies?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatPreferencesInput].
extension ChatPreferencesInputPatterns on ChatPreferencesInput {
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

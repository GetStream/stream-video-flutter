// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatPreferences {

 String? get channelMentions; String? get defaultPreference; String? get directMentions; String? get distinctChannelMessages; String? get groupMentions; String? get hereMentions; String? get roleMentions; String? get threadReplies;
/// Create a copy of ChatPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatPreferencesCopyWith<ChatPreferences> get copyWith => _$ChatPreferencesCopyWithImpl<ChatPreferences>(this as ChatPreferences, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatPreferences&&(identical(other.channelMentions, channelMentions) || other.channelMentions == channelMentions)&&(identical(other.defaultPreference, defaultPreference) || other.defaultPreference == defaultPreference)&&(identical(other.directMentions, directMentions) || other.directMentions == directMentions)&&(identical(other.distinctChannelMessages, distinctChannelMessages) || other.distinctChannelMessages == distinctChannelMessages)&&(identical(other.groupMentions, groupMentions) || other.groupMentions == groupMentions)&&(identical(other.hereMentions, hereMentions) || other.hereMentions == hereMentions)&&(identical(other.roleMentions, roleMentions) || other.roleMentions == roleMentions)&&(identical(other.threadReplies, threadReplies) || other.threadReplies == threadReplies));
}


@override
int get hashCode => Object.hash(runtimeType,channelMentions,defaultPreference,directMentions,distinctChannelMessages,groupMentions,hereMentions,roleMentions,threadReplies);

@override
String toString() {
  return 'ChatPreferences(channelMentions: $channelMentions, defaultPreference: $defaultPreference, directMentions: $directMentions, distinctChannelMessages: $distinctChannelMessages, groupMentions: $groupMentions, hereMentions: $hereMentions, roleMentions: $roleMentions, threadReplies: $threadReplies)';
}


}

/// @nodoc
abstract mixin class $ChatPreferencesCopyWith<$Res>  {
  factory $ChatPreferencesCopyWith(ChatPreferences value, $Res Function(ChatPreferences) _then) = _$ChatPreferencesCopyWithImpl;
@useResult
$Res call({
 String? channelMentions, String? defaultPreference, String? directMentions, String? distinctChannelMessages, String? groupMentions, String? hereMentions, String? roleMentions, String? threadReplies
});




}
/// @nodoc
class _$ChatPreferencesCopyWithImpl<$Res>
    implements $ChatPreferencesCopyWith<$Res> {
  _$ChatPreferencesCopyWithImpl(this._self, this._then);

  final ChatPreferences _self;
  final $Res Function(ChatPreferences) _then;

/// Create a copy of ChatPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channelMentions = freezed,Object? defaultPreference = freezed,Object? directMentions = freezed,Object? distinctChannelMessages = freezed,Object? groupMentions = freezed,Object? hereMentions = freezed,Object? roleMentions = freezed,Object? threadReplies = freezed,}) {
  return _then(ChatPreferences(
channelMentions: freezed == channelMentions ? _self.channelMentions : channelMentions // ignore: cast_nullable_to_non_nullable
as String?,defaultPreference: freezed == defaultPreference ? _self.defaultPreference : defaultPreference // ignore: cast_nullable_to_non_nullable
as String?,directMentions: freezed == directMentions ? _self.directMentions : directMentions // ignore: cast_nullable_to_non_nullable
as String?,distinctChannelMessages: freezed == distinctChannelMessages ? _self.distinctChannelMessages : distinctChannelMessages // ignore: cast_nullable_to_non_nullable
as String?,groupMentions: freezed == groupMentions ? _self.groupMentions : groupMentions // ignore: cast_nullable_to_non_nullable
as String?,hereMentions: freezed == hereMentions ? _self.hereMentions : hereMentions // ignore: cast_nullable_to_non_nullable
as String?,roleMentions: freezed == roleMentions ? _self.roleMentions : roleMentions // ignore: cast_nullable_to_non_nullable
as String?,threadReplies: freezed == threadReplies ? _self.threadReplies : threadReplies // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatPreferences].
extension ChatPreferencesPatterns on ChatPreferences {
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

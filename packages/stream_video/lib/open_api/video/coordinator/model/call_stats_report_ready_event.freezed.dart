// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_stats_report_ready_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallStatsReportReadyEvent {

 String get callCid; CallStatsParticipantCounts get counts; DateTime get createdAt; bool? get isTrimmed; List<CallStatsParticipant>? get participantsOverview; String get sessionId; String get type;
/// Create a copy of CallStatsReportReadyEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallStatsReportReadyEventCopyWith<CallStatsReportReadyEvent> get copyWith => _$CallStatsReportReadyEventCopyWithImpl<CallStatsReportReadyEvent>(this as CallStatsReportReadyEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallStatsReportReadyEvent&&(identical(other.callCid, callCid) || other.callCid == callCid)&&(identical(other.counts, counts) || other.counts == counts)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isTrimmed, isTrimmed) || other.isTrimmed == isTrimmed)&&const DeepCollectionEquality().equals(other.participantsOverview, participantsOverview)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,callCid,counts,createdAt,isTrimmed,const DeepCollectionEquality().hash(participantsOverview),sessionId,type);

@override
String toString() {
  return 'CallStatsReportReadyEvent(callCid: $callCid, counts: $counts, createdAt: $createdAt, isTrimmed: $isTrimmed, participantsOverview: $participantsOverview, sessionId: $sessionId, type: $type)';
}


}

/// @nodoc
abstract mixin class $CallStatsReportReadyEventCopyWith<$Res>  {
  factory $CallStatsReportReadyEventCopyWith(CallStatsReportReadyEvent value, $Res Function(CallStatsReportReadyEvent) _then) = _$CallStatsReportReadyEventCopyWithImpl;
@useResult
$Res call({
 String callCid, CallStatsParticipantCounts counts, DateTime createdAt, bool? isTrimmed, List<CallStatsParticipant>? participantsOverview, String sessionId, String type
});




}
/// @nodoc
class _$CallStatsReportReadyEventCopyWithImpl<$Res>
    implements $CallStatsReportReadyEventCopyWith<$Res> {
  _$CallStatsReportReadyEventCopyWithImpl(this._self, this._then);

  final CallStatsReportReadyEvent _self;
  final $Res Function(CallStatsReportReadyEvent) _then;

/// Create a copy of CallStatsReportReadyEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callCid = null,Object? counts = null,Object? createdAt = null,Object? isTrimmed = freezed,Object? participantsOverview = freezed,Object? sessionId = null,Object? type = null,}) {
  return _then(CallStatsReportReadyEvent(
callCid: null == callCid ? _self.callCid : callCid // ignore: cast_nullable_to_non_nullable
as String,counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as CallStatsParticipantCounts,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isTrimmed: freezed == isTrimmed ? _self.isTrimmed : isTrimmed // ignore: cast_nullable_to_non_nullable
as bool?,participantsOverview: freezed == participantsOverview ? _self.participantsOverview : participantsOverview // ignore: cast_nullable_to_non_nullable
as List<CallStatsParticipant>?,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CallStatsReportReadyEvent].
extension CallStatsReportReadyEventPatterns on CallStatsReportReadyEvent {
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

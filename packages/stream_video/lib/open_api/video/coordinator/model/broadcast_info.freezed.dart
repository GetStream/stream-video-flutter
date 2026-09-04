// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'broadcast_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BroadcastInfo {
  int get appId;
  String get callCid;
  String get callSessionId;
  String get callType;
  List<String> get creators;
  double get durationMin;
  String get endedAt;
  String? get sourceMode;
  String get startedAt;

  /// Create a copy of BroadcastInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BroadcastInfoCopyWith<BroadcastInfo> get copyWith =>
      _$BroadcastInfoCopyWithImpl<BroadcastInfo>(
        this as BroadcastInfo,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BroadcastInfo &&
            (identical(other.appId, appId) || other.appId == appId) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.callSessionId, callSessionId) ||
                other.callSessionId == callSessionId) &&
            (identical(other.callType, callType) ||
                other.callType == callType) &&
            const DeepCollectionEquality().equals(other.creators, creators) &&
            (identical(other.durationMin, durationMin) ||
                other.durationMin == durationMin) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.sourceMode, sourceMode) ||
                other.sourceMode == sourceMode) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    appId,
    callCid,
    callSessionId,
    callType,
    const DeepCollectionEquality().hash(creators),
    durationMin,
    endedAt,
    sourceMode,
    startedAt,
  );

  @override
  String toString() {
    return 'BroadcastInfo(appId: $appId, callCid: $callCid, callSessionId: $callSessionId, callType: $callType, creators: $creators, durationMin: $durationMin, endedAt: $endedAt, sourceMode: $sourceMode, startedAt: $startedAt)';
  }
}

/// @nodoc
abstract mixin class $BroadcastInfoCopyWith<$Res> {
  factory $BroadcastInfoCopyWith(
    BroadcastInfo value,
    $Res Function(BroadcastInfo) _then,
  ) = _$BroadcastInfoCopyWithImpl;
  @useResult
  $Res call({
    int appId,
    String callCid,
    String callSessionId,
    String callType,
    List<String> creators,
    double durationMin,
    String endedAt,
    String? sourceMode,
    String startedAt,
  });
}

/// @nodoc
class _$BroadcastInfoCopyWithImpl<$Res>
    implements $BroadcastInfoCopyWith<$Res> {
  _$BroadcastInfoCopyWithImpl(this._self, this._then);

  final BroadcastInfo _self;
  final $Res Function(BroadcastInfo) _then;

  /// Create a copy of BroadcastInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appId = null,
    Object? callCid = null,
    Object? callSessionId = null,
    Object? callType = null,
    Object? creators = null,
    Object? durationMin = null,
    Object? endedAt = null,
    Object? sourceMode = freezed,
    Object? startedAt = null,
  }) {
    return _then(
      BroadcastInfo(
        appId: null == appId
            ? _self.appId
            : appId // ignore: cast_nullable_to_non_nullable
                  as int,
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        callSessionId: null == callSessionId
            ? _self.callSessionId
            : callSessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        callType: null == callType
            ? _self.callType
            : callType // ignore: cast_nullable_to_non_nullable
                  as String,
        creators: null == creators
            ? _self.creators
            : creators // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        durationMin: null == durationMin
            ? _self.durationMin
            : durationMin // ignore: cast_nullable_to_non_nullable
                  as double,
        endedAt: null == endedAt
            ? _self.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceMode: freezed == sourceMode
            ? _self.sourceMode
            : sourceMode // ignore: cast_nullable_to_non_nullable
                  as String?,
        startedAt: null == startedAt
            ? _self.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

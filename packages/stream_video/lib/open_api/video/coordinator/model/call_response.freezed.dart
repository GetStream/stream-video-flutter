// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallResponse {
  bool get backstage;
  List<String> get blockedUserIds;
  bool get captioning;
  String? get channelCid;
  String get cid;
  DateTime get createdAt;
  UserResponse get createdBy;
  String get currentSessionId;
  Map<String, Object?> get custom;
  EgressResponse get egress;
  DateTime? get endedAt;
  String get id;
  CallIngressResponse get ingress;
  int? get joinAheadTimeSeconds;
  bool get recording;
  String? get routingNumber;
  CallSessionResponse? get session;
  CallSettingsResponse get settings;
  DateTime? get startsAt;
  String? get team;
  ThumbnailResponse? get thumbnails;
  bool get transcribing;
  bool get translating;
  String get type;
  DateTime get updatedAt;

  /// Create a copy of CallResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallResponseCopyWith<CallResponse> get copyWith =>
      _$CallResponseCopyWithImpl<CallResponse>(
        this as CallResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallResponse &&
            (identical(other.backstage, backstage) ||
                other.backstage == backstage) &&
            const DeepCollectionEquality().equals(
              other.blockedUserIds,
              blockedUserIds,
            ) &&
            (identical(other.captioning, captioning) ||
                other.captioning == captioning) &&
            (identical(other.channelCid, channelCid) ||
                other.channelCid == channelCid) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.currentSessionId, currentSessionId) ||
                other.currentSessionId == currentSessionId) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.egress, egress) || other.egress == egress) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ingress, ingress) || other.ingress == ingress) &&
            (identical(other.joinAheadTimeSeconds, joinAheadTimeSeconds) ||
                other.joinAheadTimeSeconds == joinAheadTimeSeconds) &&
            (identical(other.recording, recording) ||
                other.recording == recording) &&
            (identical(other.routingNumber, routingNumber) ||
                other.routingNumber == routingNumber) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.startsAt, startsAt) ||
                other.startsAt == startsAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.thumbnails, thumbnails) ||
                other.thumbnails == thumbnails) &&
            (identical(other.transcribing, transcribing) ||
                other.transcribing == transcribing) &&
            (identical(other.translating, translating) ||
                other.translating == translating) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    backstage,
    const DeepCollectionEquality().hash(blockedUserIds),
    captioning,
    channelCid,
    cid,
    createdAt,
    createdBy,
    currentSessionId,
    const DeepCollectionEquality().hash(custom),
    egress,
    endedAt,
    id,
    ingress,
    joinAheadTimeSeconds,
    recording,
    routingNumber,
    session,
    settings,
    startsAt,
    team,
    thumbnails,
    transcribing,
    translating,
    type,
    updatedAt,
  ]);

  @override
  String toString() {
    return 'CallResponse(backstage: $backstage, blockedUserIds: $blockedUserIds, captioning: $captioning, channelCid: $channelCid, cid: $cid, createdAt: $createdAt, createdBy: $createdBy, currentSessionId: $currentSessionId, custom: $custom, egress: $egress, endedAt: $endedAt, id: $id, ingress: $ingress, joinAheadTimeSeconds: $joinAheadTimeSeconds, recording: $recording, routingNumber: $routingNumber, session: $session, settings: $settings, startsAt: $startsAt, team: $team, thumbnails: $thumbnails, transcribing: $transcribing, translating: $translating, type: $type, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $CallResponseCopyWith<$Res> {
  factory $CallResponseCopyWith(
    CallResponse value,
    $Res Function(CallResponse) _then,
  ) = _$CallResponseCopyWithImpl;
  @useResult
  $Res call({
    bool backstage,
    List<String> blockedUserIds,
    bool captioning,
    String? channelCid,
    String cid,
    DateTime createdAt,
    UserResponse createdBy,
    String currentSessionId,
    Map<String, Object?> custom,
    EgressResponse egress,
    DateTime? endedAt,
    String id,
    CallIngressResponse ingress,
    int? joinAheadTimeSeconds,
    bool recording,
    String? routingNumber,
    CallSessionResponse? session,
    CallSettingsResponse settings,
    DateTime? startsAt,
    String? team,
    ThumbnailResponse? thumbnails,
    bool transcribing,
    bool translating,
    String type,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$CallResponseCopyWithImpl<$Res> implements $CallResponseCopyWith<$Res> {
  _$CallResponseCopyWithImpl(this._self, this._then);

  final CallResponse _self;
  final $Res Function(CallResponse) _then;

  /// Create a copy of CallResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backstage = null,
    Object? blockedUserIds = null,
    Object? captioning = null,
    Object? channelCid = freezed,
    Object? cid = null,
    Object? createdAt = null,
    Object? createdBy = null,
    Object? currentSessionId = null,
    Object? custom = null,
    Object? egress = null,
    Object? endedAt = freezed,
    Object? id = null,
    Object? ingress = null,
    Object? joinAheadTimeSeconds = freezed,
    Object? recording = null,
    Object? routingNumber = freezed,
    Object? session = freezed,
    Object? settings = null,
    Object? startsAt = freezed,
    Object? team = freezed,
    Object? thumbnails = freezed,
    Object? transcribing = null,
    Object? translating = null,
    Object? type = null,
    Object? updatedAt = null,
  }) {
    return _then(
      CallResponse(
        backstage: null == backstage
            ? _self.backstage
            : backstage // ignore: cast_nullable_to_non_nullable
                  as bool,
        blockedUserIds: null == blockedUserIds
            ? _self.blockedUserIds
            : blockedUserIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        captioning: null == captioning
            ? _self.captioning
            : captioning // ignore: cast_nullable_to_non_nullable
                  as bool,
        channelCid: freezed == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: null == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: null == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
        currentSessionId: null == currentSessionId
            ? _self.currentSessionId
            : currentSessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        egress: null == egress
            ? _self.egress
            : egress // ignore: cast_nullable_to_non_nullable
                  as EgressResponse,
        endedAt: freezed == endedAt
            ? _self.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ingress: null == ingress
            ? _self.ingress
            : ingress // ignore: cast_nullable_to_non_nullable
                  as CallIngressResponse,
        joinAheadTimeSeconds: freezed == joinAheadTimeSeconds
            ? _self.joinAheadTimeSeconds
            : joinAheadTimeSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
        recording: null == recording
            ? _self.recording
            : recording // ignore: cast_nullable_to_non_nullable
                  as bool,
        routingNumber: freezed == routingNumber
            ? _self.routingNumber
            : routingNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        session: freezed == session
            ? _self.session
            : session // ignore: cast_nullable_to_non_nullable
                  as CallSessionResponse?,
        settings: null == settings
            ? _self.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as CallSettingsResponse,
        startsAt: freezed == startsAt
            ? _self.startsAt
            : startsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbnails: freezed == thumbnails
            ? _self.thumbnails
            : thumbnails // ignore: cast_nullable_to_non_nullable
                  as ThumbnailResponse?,
        transcribing: null == transcribing
            ? _self.transcribing
            : transcribing // ignore: cast_nullable_to_non_nullable
                  as bool,
        translating: null == translating
            ? _self.translating
            : translating // ignore: cast_nullable_to_non_nullable
                  as bool,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

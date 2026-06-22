// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_call_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinCallResponse _$JoinCallResponseFromJson(Map<String, dynamic> json) =>
    JoinCallResponse(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      created: json['created'] as bool,
      credentials: Credentials.fromJson(
        json['credentials'] as Map<String, dynamic>,
      ),
      duration: json['duration'] as String,
      members:
          (json['members'] as List<dynamic>?)
              ?.map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      membership: json['membership'] == null
          ? null
          : MemberResponse.fromJson(json['membership'] as Map<String, dynamic>),
      ownCapabilities:
          (json['own_capabilities'] as List<dynamic>?)
              ?.map(
                (e) => $enumDecode(
                  _$OwnCapabilityEnumMap,
                  e,
                  unknownValue: OwnCapability.unknown,
                ),
              )
              .toList() ??
          [],
      statsOptions: StatsOptions.fromJson(
        json['stats_options'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$JoinCallResponseToJson(JoinCallResponse instance) =>
    <String, dynamic>{
      'call': instance.call,
      'created': instance.created,
      'credentials': instance.credentials,
      'duration': instance.duration,
      'members': instance.members,
      'membership': instance.membership,
      'own_capabilities': instance.ownCapabilities
          .map((e) => _$OwnCapabilityEnumMap[e]!)
          .toList(),
      'stats_options': instance.statsOptions,
    };

const _$OwnCapabilityEnumMap = {
  OwnCapability.blockUsers: 'block-users',
  OwnCapability.changeMaxDuration: 'change-max-duration',
  OwnCapability.createCall: 'create-call',
  OwnCapability.createReaction: 'create-reaction',
  OwnCapability.enableNoiseCancellation: 'enable-noise-cancellation',
  OwnCapability.endCall: 'end-call',
  OwnCapability.joinBackstage: 'join-backstage',
  OwnCapability.joinCall: 'join-call',
  OwnCapability.joinEndedCall: 'join-ended-call',
  OwnCapability.kickUser: 'kick-user',
  OwnCapability.muteUsers: 'mute-users',
  OwnCapability.pinForEveryone: 'pin-for-everyone',
  OwnCapability.readCall: 'read-call',
  OwnCapability.removeCallMember: 'remove-call-member',
  OwnCapability.screenshare: 'screenshare',
  OwnCapability.sendAudio: 'send-audio',
  OwnCapability.sendClosedCaptionsCall: 'send-closed-captions-call',
  OwnCapability.sendVideo: 'send-video',
  OwnCapability.startBroadcastCall: 'start-broadcast-call',
  OwnCapability.startClosedCaptionsCall: 'start-closed-captions-call',
  OwnCapability.startFrameRecordCall: 'start-frame-record-call',
  OwnCapability.startIndividualRecordCall: 'start-individual-record-call',
  OwnCapability.startRawRecordCall: 'start-raw-record-call',
  OwnCapability.startRecordCall: 'start-record-call',
  OwnCapability.startTranscriptionCall: 'start-transcription-call',
  OwnCapability.stopBroadcastCall: 'stop-broadcast-call',
  OwnCapability.stopClosedCaptionsCall: 'stop-closed-captions-call',
  OwnCapability.stopFrameRecordCall: 'stop-frame-record-call',
  OwnCapability.stopIndividualRecordCall: 'stop-individual-record-call',
  OwnCapability.stopRawRecordCall: 'stop-raw-record-call',
  OwnCapability.stopRecordCall: 'stop-record-call',
  OwnCapability.stopTranscriptionCall: 'stop-transcription-call',
  OwnCapability.updateCall: 'update-call',
  OwnCapability.updateCallMember: 'update-call-member',
  OwnCapability.updateCallPermissions: 'update-call-permissions',
  OwnCapability.updateCallSettings: 'update-call-settings',
  OwnCapability.unknown: '_unknown',
};

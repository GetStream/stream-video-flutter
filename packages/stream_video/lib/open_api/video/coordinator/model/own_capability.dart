//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'own_capability.g.dart';

class OwnCapability extends EnumClass {
  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'block-users')
  static const OwnCapability blockUsers = _$blockUsers;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'change-max-duration')
  static const OwnCapability changeMaxDuration = _$changeMaxDuration;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'create-call')
  static const OwnCapability createCall = _$createCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'create-reaction')
  static const OwnCapability createReaction = _$createReaction;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'enable-noise-cancellation')
  static const OwnCapability enableNoiseCancellation =
      _$enableNoiseCancellation;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'end-call')
  static const OwnCapability endCall = _$endCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'join-backstage')
  static const OwnCapability joinBackstage = _$joinBackstage;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'join-call')
  static const OwnCapability joinCall = _$joinCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'join-ended-call')
  static const OwnCapability joinEndedCall = _$joinEndedCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'mute-users')
  static const OwnCapability muteUsers = _$muteUsers;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'pin-for-everyone')
  static const OwnCapability pinForEveryone = _$pinForEveryone;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'read-call')
  static const OwnCapability readCall = _$readCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'remove-call-member')
  static const OwnCapability removeCallMember = _$removeCallMember;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'screenshare')
  static const OwnCapability screenshare = _$screenshare;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'send-audio')
  static const OwnCapability sendAudio = _$sendAudio;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'send-video')
  static const OwnCapability sendVideo = _$sendVideo;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'start-broadcast-call')
  static const OwnCapability startBroadcastCall = _$startBroadcastCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'start-closed-captions-call')
  static const OwnCapability startClosedCaptionsCall =
      _$startClosedCaptionsCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'start-frame-record-call')
  static const OwnCapability startFrameRecordCall = _$startFrameRecordCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'start-record-call')
  static const OwnCapability startRecordCall = _$startRecordCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'start-transcription-call')
  static const OwnCapability startTranscriptionCall = _$startTranscriptionCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'stop-broadcast-call')
  static const OwnCapability stopBroadcastCall = _$stopBroadcastCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'stop-closed-captions-call')
  static const OwnCapability stopClosedCaptionsCall = _$stopClosedCaptionsCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'stop-frame-record-call')
  static const OwnCapability stopFrameRecordCall = _$stopFrameRecordCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'stop-record-call')
  static const OwnCapability stopRecordCall = _$stopRecordCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'stop-transcription-call')
  static const OwnCapability stopTranscriptionCall = _$stopTranscriptionCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'update-call')
  static const OwnCapability updateCall = _$updateCall;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'update-call-member')
  static const OwnCapability updateCallMember = _$updateCallMember;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'update-call-permissions')
  static const OwnCapability updateCallPermissions = _$updateCallPermissions;

  /// All possibility of string to use
  @BuiltValueEnumConst(wireName: r'update-call-settings')
  static const OwnCapability updateCallSettings = _$updateCallSettings;

  static Serializer<OwnCapability> get serializer => _$ownCapabilitySerializer;

  const OwnCapability._(String name) : super(name);

  static BuiltSet<OwnCapability> get values => _$values;
  static OwnCapability valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class OwnCapabilityMixin = Object with _$OwnCapabilityMixin;

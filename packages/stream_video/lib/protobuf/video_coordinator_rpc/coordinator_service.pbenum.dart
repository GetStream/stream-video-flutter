///
//  Generated code. Do not modify.
//  source: video_coordinator_rpc/coordinator_service.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class CallStatEventType extends $pb.ProtobufEnum {
  static const CallStatEventType AUDIO_FROZEN = CallStatEventType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AUDIO_FROZEN');
  static const CallStatEventType AUDIO_DELAY = CallStatEventType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AUDIO_DELAY');
  static const CallStatEventType VIDEO_FROZEN = CallStatEventType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VIDEO_FROZEN');
  static const CallStatEventType VIDEO_DELAY = CallStatEventType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VIDEO_DELAY');
  static const CallStatEventType VIDEO_NOT_OPTIMAL = CallStatEventType._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VIDEO_NOT_OPTIMAL');

  static const $core.List<CallStatEventType> values = <CallStatEventType> [
    AUDIO_FROZEN,
    AUDIO_DELAY,
    VIDEO_FROZEN,
    VIDEO_DELAY,
    VIDEO_NOT_OPTIMAL,
  ];

  static final $core.Map<$core.int, CallStatEventType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CallStatEventType? valueOf($core.int value) => _byValue[value];

  const CallStatEventType._($core.int v, $core.String n) : super(v, n);
}

class UserEventType extends $pb.ProtobufEnum {
  static const UserEventType USER_EVENT_TYPE_AUDIO_MUTED_UNSPECIFIED = UserEventType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'USER_EVENT_TYPE_AUDIO_MUTED_UNSPECIFIED');
  static const UserEventType USER_EVENT_TYPE_AUDIO_UNMUTED = UserEventType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'USER_EVENT_TYPE_AUDIO_UNMUTED');
  static const UserEventType USER_EVENT_TYPE_VIDEO_STARTED = UserEventType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'USER_EVENT_TYPE_VIDEO_STARTED');
  static const UserEventType USER_EVENT_TYPE_VIDEO_STOPPED = UserEventType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'USER_EVENT_TYPE_VIDEO_STOPPED');

  static const $core.List<UserEventType> values = <UserEventType> [
    USER_EVENT_TYPE_AUDIO_MUTED_UNSPECIFIED,
    USER_EVENT_TYPE_AUDIO_UNMUTED,
    USER_EVENT_TYPE_VIDEO_STARTED,
    USER_EVENT_TYPE_VIDEO_STOPPED,
  ];

  static final $core.Map<$core.int, UserEventType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UserEventType? valueOf($core.int value) => _byValue[value];

  const UserEventType._($core.int v, $core.String n) : super(v, n);
}


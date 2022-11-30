///
//  Generated code. Do not modify.
//  source: video/coordinator/stat_v1/stat.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class MediaType extends $pb.ProtobufEnum {
  static const MediaType MEDIA_TYPE_UNSPECIFIED = MediaType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEDIA_TYPE_UNSPECIFIED');
  static const MediaType MEDIA_TYPE_AUDIO = MediaType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEDIA_TYPE_AUDIO');
  static const MediaType MEDIA_TYPE_VIDEO = MediaType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEDIA_TYPE_VIDEO');

  static const $core.List<MediaType> values = <MediaType> [
    MEDIA_TYPE_UNSPECIFIED,
    MEDIA_TYPE_AUDIO,
    MEDIA_TYPE_VIDEO,
  ];

  static final $core.Map<$core.int, MediaType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MediaType? valueOf($core.int value) => _byValue[value];

  const MediaType._($core.int v, $core.String n) : super(v, n);
}

class MediaStateChange extends $pb.ProtobufEnum {
  static const MediaStateChange MEDIA_STATE_CHANGE_UNSPECIFIED = MediaStateChange._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEDIA_STATE_CHANGE_UNSPECIFIED');
  static const MediaStateChange MEDIA_STATE_CHANGE_STARTED = MediaStateChange._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEDIA_STATE_CHANGE_STARTED');
  static const MediaStateChange MEDIA_STATE_CHANGE_ENDED = MediaStateChange._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEDIA_STATE_CHANGE_ENDED');

  static const $core.List<MediaStateChange> values = <MediaStateChange> [
    MEDIA_STATE_CHANGE_UNSPECIFIED,
    MEDIA_STATE_CHANGE_STARTED,
    MEDIA_STATE_CHANGE_ENDED,
  ];

  static final $core.Map<$core.int, MediaStateChange> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MediaStateChange? valueOf($core.int value) => _byValue[value];

  const MediaStateChange._($core.int v, $core.String n) : super(v, n);
}

class MediaDirection extends $pb.ProtobufEnum {
  static const MediaDirection MEDIA_DIRECTION_UNSPECIFIED = MediaDirection._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEDIA_DIRECTION_UNSPECIFIED');
  static const MediaDirection MEDIA_DIRECTION_SEND = MediaDirection._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEDIA_DIRECTION_SEND');
  static const MediaDirection MEDIA_DIRECTION_RECEIVE = MediaDirection._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEDIA_DIRECTION_RECEIVE');

  static const $core.List<MediaDirection> values = <MediaDirection> [
    MEDIA_DIRECTION_UNSPECIFIED,
    MEDIA_DIRECTION_SEND,
    MEDIA_DIRECTION_RECEIVE,
  ];

  static final $core.Map<$core.int, MediaDirection> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MediaDirection? valueOf($core.int value) => _byValue[value];

  const MediaDirection._($core.int v, $core.String n) : super(v, n);
}

class MediaStateChangeReason extends $pb.ProtobufEnum {
  static const MediaStateChangeReason MEDIA_STATE_CHANGE_REASON_UNSPECIFIED = MediaStateChangeReason._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEDIA_STATE_CHANGE_REASON_UNSPECIFIED');
  static const MediaStateChangeReason MEDIA_STATE_CHANGE_REASON_MUTE = MediaStateChangeReason._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEDIA_STATE_CHANGE_REASON_MUTE');
  static const MediaStateChangeReason MEDIA_STATE_CHANGE_REASON_CONNECTION = MediaStateChangeReason._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEDIA_STATE_CHANGE_REASON_CONNECTION');

  static const $core.List<MediaStateChangeReason> values = <MediaStateChangeReason> [
    MEDIA_STATE_CHANGE_REASON_UNSPECIFIED,
    MEDIA_STATE_CHANGE_REASON_MUTE,
    MEDIA_STATE_CHANGE_REASON_CONNECTION,
  ];

  static final $core.Map<$core.int, MediaStateChangeReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MediaStateChangeReason? valueOf($core.int value) => _byValue[value];

  const MediaStateChangeReason._($core.int v, $core.String n) : super(v, n);
}


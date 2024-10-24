//
//  Generated code. Do not modify.
//  source: video/sfu/event/events.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class VideoLayerSetting_Priority extends $pb.ProtobufEnum {
  static const VideoLayerSetting_Priority PRIORITY_HIGH_UNSPECIFIED = VideoLayerSetting_Priority._(0, _omitEnumNames ? '' : 'PRIORITY_HIGH_UNSPECIFIED');
  static const VideoLayerSetting_Priority PRIORITY_LOW = VideoLayerSetting_Priority._(1, _omitEnumNames ? '' : 'PRIORITY_LOW');
  static const VideoLayerSetting_Priority PRIORITY_MEDIUM = VideoLayerSetting_Priority._(2, _omitEnumNames ? '' : 'PRIORITY_MEDIUM');
  static const VideoLayerSetting_Priority PRIORITY_VERY_LOW = VideoLayerSetting_Priority._(3, _omitEnumNames ? '' : 'PRIORITY_VERY_LOW');

  static const $core.List<VideoLayerSetting_Priority> values = <VideoLayerSetting_Priority> [
    PRIORITY_HIGH_UNSPECIFIED,
    PRIORITY_LOW,
    PRIORITY_MEDIUM,
    PRIORITY_VERY_LOW,
  ];

  static final $core.Map<$core.int, VideoLayerSetting_Priority> _byValue = $pb.ProtobufEnum.initByValue(values);
  static VideoLayerSetting_Priority? valueOf($core.int value) => _byValue[value];

  const VideoLayerSetting_Priority._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');

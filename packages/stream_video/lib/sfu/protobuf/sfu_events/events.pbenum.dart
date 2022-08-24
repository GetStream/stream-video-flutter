///
//  Generated code. Do not modify.
//  source: sfu_events/events.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class VideoLayerSetting_Priority extends $pb.ProtobufEnum {
  static const VideoLayerSetting_Priority HIGH = VideoLayerSetting_Priority._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'HIGH');
  static const VideoLayerSetting_Priority LOW = VideoLayerSetting_Priority._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LOW');
  static const VideoLayerSetting_Priority MEDIUM = VideoLayerSetting_Priority._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEDIUM');
  static const VideoLayerSetting_Priority VERY_LOW = VideoLayerSetting_Priority._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VERY_LOW');

  static const $core.List<VideoLayerSetting_Priority> values = <VideoLayerSetting_Priority> [
    HIGH,
    LOW,
    MEDIUM,
    VERY_LOW,
  ];

  static final $core.Map<$core.int, VideoLayerSetting_Priority> _byValue = $pb.ProtobufEnum.initByValue(values);
  static VideoLayerSetting_Priority? valueOf($core.int value) => _byValue[value];

  const VideoLayerSetting_Priority._($core.int v, $core.String n) : super(v, n);
}


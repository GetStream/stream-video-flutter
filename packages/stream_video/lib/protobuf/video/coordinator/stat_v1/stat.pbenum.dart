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


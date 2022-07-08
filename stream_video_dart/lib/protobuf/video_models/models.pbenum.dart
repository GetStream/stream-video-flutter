///
//  Generated code. Do not modify.
//  source: video_models/models.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class Codec extends $pb.ProtobufEnum {
  static const Codec CODEC_H264_UNSPECIFIED = Codec._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CODEC_H264_UNSPECIFIED');
  static const Codec CODEC_VP8 = Codec._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CODEC_VP8');
  static const Codec CODEC_VP9 = Codec._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CODEC_VP9');

  static const $core.List<Codec> values = <Codec> [
    CODEC_H264_UNSPECIFIED,
    CODEC_VP8,
    CODEC_VP9,
  ];

  static final $core.Map<$core.int, Codec> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Codec? valueOf($core.int value) => _byValue[value];

  const Codec._($core.int v, $core.String n) : super(v, n);
}

class RecordingStorage extends $pb.ProtobufEnum {
  static const RecordingStorage RECORDING_STORAGE_S3_UNSPECIFIED = RecordingStorage._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RECORDING_STORAGE_S3_UNSPECIFIED');

  static const $core.List<RecordingStorage> values = <RecordingStorage> [
    RECORDING_STORAGE_S3_UNSPECIFIED,
  ];

  static final $core.Map<$core.int, RecordingStorage> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RecordingStorage? valueOf($core.int value) => _byValue[value];

  const RecordingStorage._($core.int v, $core.String n) : super(v, n);
}

class Security_IsAllowed extends $pb.ProtobufEnum {
  static const Security_IsAllowed IS_ALLOWED_YES_UNSPECIFIED = Security_IsAllowed._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'IS_ALLOWED_YES_UNSPECIFIED');
  static const Security_IsAllowed IS_ALLOWED_NO = Security_IsAllowed._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'IS_ALLOWED_NO');
  static const Security_IsAllowed IS_ALLOWED_REQUEST = Security_IsAllowed._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'IS_ALLOWED_REQUEST');

  static const $core.List<Security_IsAllowed> values = <Security_IsAllowed> [
    IS_ALLOWED_YES_UNSPECIFIED,
    IS_ALLOWED_NO,
    IS_ALLOWED_REQUEST,
  ];

  static final $core.Map<$core.int, Security_IsAllowed> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Security_IsAllowed? valueOf($core.int value) => _byValue[value];

  const Security_IsAllowed._($core.int v, $core.String n) : super(v, n);
}


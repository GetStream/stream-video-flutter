///
//  Generated code. Do not modify.
//  source: video/coordinator/transcription_v1/transcription.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class TranscriptionStorage extends $pb.ProtobufEnum {
  static const TranscriptionStorage TRANSCRIPTION_STORAGE_S3_UNSPECIFIED = TranscriptionStorage._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TRANSCRIPTION_STORAGE_S3_UNSPECIFIED');

  static const $core.List<TranscriptionStorage> values = <TranscriptionStorage> [
    TRANSCRIPTION_STORAGE_S3_UNSPECIFIED,
  ];

  static final $core.Map<$core.int, TranscriptionStorage> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TranscriptionStorage? valueOf($core.int value) => _byValue[value];

  const TranscriptionStorage._($core.int v, $core.String n) : super(v, n);
}


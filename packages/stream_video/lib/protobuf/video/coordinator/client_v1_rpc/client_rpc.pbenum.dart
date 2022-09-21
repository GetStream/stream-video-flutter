///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/client_rpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class MemberField extends $pb.ProtobufEnum {
  static const MemberField MEMBER_FIELD_UNSPECIFIED = MemberField._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEMBER_FIELD_UNSPECIFIED');
  static const MemberField MEMBER_FIELD_ROLE = MemberField._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEMBER_FIELD_ROLE');
  static const MemberField MEMBER_FIELD_CUSTOM = MemberField._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MEMBER_FIELD_CUSTOM');

  static const $core.List<MemberField> values = <MemberField> [
    MEMBER_FIELD_UNSPECIFIED,
    MEMBER_FIELD_ROLE,
    MEMBER_FIELD_CUSTOM,
  ];

  static final $core.Map<$core.int, MemberField> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MemberField? valueOf($core.int value) => _byValue[value];

  const MemberField._($core.int v, $core.String n) : super(v, n);
}


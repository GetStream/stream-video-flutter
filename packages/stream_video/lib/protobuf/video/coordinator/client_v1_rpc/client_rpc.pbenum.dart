///
//  Generated code. Do not modify.
//  source: video/coordinator/client_v1_rpc/client_rpc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class UserEventType extends $pb.ProtobufEnum {
  static const UserEventType USER_EVENT_TYPE_UNSPECIFIED = UserEventType._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'USER_EVENT_TYPE_UNSPECIFIED');
  static const UserEventType USER_EVENT_TYPE_ACCEPTED_CALL = UserEventType._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'USER_EVENT_TYPE_ACCEPTED_CALL');
  static const UserEventType USER_EVENT_TYPE_REJECTED_CALL = UserEventType._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'USER_EVENT_TYPE_REJECTED_CALL');
  static const UserEventType USER_EVENT_TYPE_CANCELLED_CALL = UserEventType._(
      3,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'USER_EVENT_TYPE_CANCELLED_CALL');

  static const $core.List<UserEventType> values = <UserEventType>[
    USER_EVENT_TYPE_UNSPECIFIED,
    USER_EVENT_TYPE_ACCEPTED_CALL,
    USER_EVENT_TYPE_REJECTED_CALL,
    USER_EVENT_TYPE_CANCELLED_CALL,
  ];

  static final $core.Map<$core.int, UserEventType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static UserEventType? valueOf($core.int value) => _byValue[value];

  const UserEventType._($core.int v, $core.String n) : super(v, n);
}

///
//  Generated code. Do not modify.
//  source: video/coordinator/geofence_v1/geofence.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class GeofenceType extends $pb.ProtobufEnum {
  static const GeofenceType GEOFENCE_TYPE_UNSPECIFIED = GeofenceType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GEOFENCE_TYPE_UNSPECIFIED');
  static const GeofenceType GEOFENCE_TYPE_INCLUSION = GeofenceType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GEOFENCE_TYPE_INCLUSION');
  static const GeofenceType GEOFENCE_TYPE_EXCLUSION = GeofenceType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GEOFENCE_TYPE_EXCLUSION');

  static const $core.List<GeofenceType> values = <GeofenceType> [
    GEOFENCE_TYPE_UNSPECIFIED,
    GEOFENCE_TYPE_INCLUSION,
    GEOFENCE_TYPE_EXCLUSION,
  ];

  static final $core.Map<$core.int, GeofenceType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static GeofenceType? valueOf($core.int value) => _byValue[value];

  const GeofenceType._($core.int v, $core.String n) : super(v, n);
}


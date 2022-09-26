///
//  Generated code. Do not modify.
//  source: video/sfu/sfu_models/models.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class PeerType extends $pb.ProtobufEnum {
  static const PeerType PUBLISHER = PeerType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PUBLISHER');
  static const PeerType SUBSCRIBER = PeerType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUBSCRIBER');

  static const $core.List<PeerType> values = <PeerType> [
    PUBLISHER,
    SUBSCRIBER,
  ];

  static final $core.Map<$core.int, PeerType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PeerType? valueOf($core.int value) => _byValue[value];

  const PeerType._($core.int v, $core.String n) : super(v, n);
}

class ConnectionQuality extends $pb.ProtobufEnum {
  static const ConnectionQuality BAD = ConnectionQuality._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BAD');
  static const ConnectionQuality POOR = ConnectionQuality._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'POOR');
  static const ConnectionQuality GOOD = ConnectionQuality._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GOOD');

  static const $core.List<ConnectionQuality> values = <ConnectionQuality> [
    BAD,
    POOR,
    GOOD,
  ];

  static final $core.Map<$core.int, ConnectionQuality> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ConnectionQuality? valueOf($core.int value) => _byValue[value];

  const ConnectionQuality._($core.int v, $core.String n) : super(v, n);
}

class VideoQuality extends $pb.ProtobufEnum {
  static const VideoQuality LOW = VideoQuality._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LOW');
  static const VideoQuality MID = VideoQuality._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MID');
  static const VideoQuality HIGH = VideoQuality._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'HIGH');

  static const $core.List<VideoQuality> values = <VideoQuality> [
    LOW,
    MID,
    HIGH,
  ];

  static final $core.Map<$core.int, VideoQuality> _byValue = $pb.ProtobufEnum.initByValue(values);
  static VideoQuality? valueOf($core.int value) => _byValue[value];

  const VideoQuality._($core.int v, $core.String n) : super(v, n);
}


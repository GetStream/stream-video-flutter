import 'package:equatable/equatable.dart';
import 'package:stream_video/src/platform_detector/platform_detector.dart';
import 'package:stream_video/src/webrtc/sdp/codec/sdp_codec.dart';
import 'package:stream_video/src/webrtc/sdp/editor/rule/rule_prioritize_codec.dart';
import 'package:stream_video/src/webrtc/sdp/editor/rule/rule_set_opus_dtx_enabled.dart';
import 'package:stream_video/src/webrtc/sdp/editor/rule/rule_set_opus_red_enabled.dart';
import 'package:stream_video/src/webrtc/sdp/sdp.dart';

abstract class SdpMungingRule with EquatableMixin {
  const SdpMungingRule({
    this.platforms = const [],
    this.types = const [],
  });

  const factory SdpMungingRule.prioritizeCodec({
    required SdpCodec codec,
    List<PlatformType> platforms,
    List<SdpType> types,
  }) = PrioritizeCodecRule;

  const factory SdpMungingRule.setOpusDtxEnabled({
    required bool enabled,
    List<PlatformType> platforms,
    List<SdpType> types,
  }) = SetOpusDtxEnabledRule;

  const factory SdpMungingRule.setOpusRedEnabled({
    required bool enabled,
    List<PlatformType> platforms,
    List<SdpType> types,
  }) = SetOpusRedEnabledRule;

  String get key;

  final List<SdpType> types;
  final List<PlatformType> platforms;

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [key];
}

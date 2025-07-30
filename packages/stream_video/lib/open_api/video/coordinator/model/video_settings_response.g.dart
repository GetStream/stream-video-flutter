// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VideoSettingsResponseCameraFacingEnum
    _$videoSettingsResponseCameraFacingEnum_front =
    const VideoSettingsResponseCameraFacingEnum._('front');
const VideoSettingsResponseCameraFacingEnum
    _$videoSettingsResponseCameraFacingEnum_back =
    const VideoSettingsResponseCameraFacingEnum._('back');
const VideoSettingsResponseCameraFacingEnum
    _$videoSettingsResponseCameraFacingEnum_external_ =
    const VideoSettingsResponseCameraFacingEnum._('external_');

VideoSettingsResponseCameraFacingEnum
    _$videoSettingsResponseCameraFacingEnumValueOf(String name) {
  switch (name) {
    case 'front':
      return _$videoSettingsResponseCameraFacingEnum_front;
    case 'back':
      return _$videoSettingsResponseCameraFacingEnum_back;
    case 'external_':
      return _$videoSettingsResponseCameraFacingEnum_external_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VideoSettingsResponseCameraFacingEnum>
    _$videoSettingsResponseCameraFacingEnumValues = BuiltSet<
        VideoSettingsResponseCameraFacingEnum>(const <VideoSettingsResponseCameraFacingEnum>[
  _$videoSettingsResponseCameraFacingEnum_front,
  _$videoSettingsResponseCameraFacingEnum_back,
  _$videoSettingsResponseCameraFacingEnum_external_,
]);

Serializer<VideoSettingsResponseCameraFacingEnum>
    _$videoSettingsResponseCameraFacingEnumSerializer =
    _$VideoSettingsResponseCameraFacingEnumSerializer();

class _$VideoSettingsResponseCameraFacingEnumSerializer
    implements PrimitiveSerializer<VideoSettingsResponseCameraFacingEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'front': 'front',
    'back': 'back',
    'external_': 'external',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'front': 'front',
    'back': 'back',
    'external': 'external_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    VideoSettingsResponseCameraFacingEnum
  ];
  @override
  final String wireName = 'VideoSettingsResponseCameraFacingEnum';

  @override
  Object serialize(
          Serializers serializers, VideoSettingsResponseCameraFacingEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VideoSettingsResponseCameraFacingEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VideoSettingsResponseCameraFacingEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VideoSettingsResponse extends VideoSettingsResponse {
  @override
  final bool accessRequestEnabled;
  @override
  final bool cameraDefaultOn;
  @override
  final VideoSettingsResponseCameraFacingEnum cameraFacing;
  @override
  final bool enabled;
  @override
  final TargetResolution targetResolution;

  factory _$VideoSettingsResponse(
          [void Function(VideoSettingsResponseBuilder)? updates]) =>
      (VideoSettingsResponseBuilder()..update(updates))._build();

  _$VideoSettingsResponse._(
      {required this.accessRequestEnabled,
      required this.cameraDefaultOn,
      required this.cameraFacing,
      required this.enabled,
      required this.targetResolution})
      : super._();
  @override
  VideoSettingsResponse rebuild(
          void Function(VideoSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VideoSettingsResponseBuilder toBuilder() =>
      VideoSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VideoSettingsResponse &&
        accessRequestEnabled == other.accessRequestEnabled &&
        cameraDefaultOn == other.cameraDefaultOn &&
        cameraFacing == other.cameraFacing &&
        enabled == other.enabled &&
        targetResolution == other.targetResolution;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessRequestEnabled.hashCode);
    _$hash = $jc(_$hash, cameraDefaultOn.hashCode);
    _$hash = $jc(_$hash, cameraFacing.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, targetResolution.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VideoSettingsResponse')
          ..add('accessRequestEnabled', accessRequestEnabled)
          ..add('cameraDefaultOn', cameraDefaultOn)
          ..add('cameraFacing', cameraFacing)
          ..add('enabled', enabled)
          ..add('targetResolution', targetResolution))
        .toString();
  }
}

class VideoSettingsResponseBuilder
    implements Builder<VideoSettingsResponse, VideoSettingsResponseBuilder> {
  _$VideoSettingsResponse? _$v;

  bool? _accessRequestEnabled;
  bool? get accessRequestEnabled => _$this._accessRequestEnabled;
  set accessRequestEnabled(bool? accessRequestEnabled) =>
      _$this._accessRequestEnabled = accessRequestEnabled;

  bool? _cameraDefaultOn;
  bool? get cameraDefaultOn => _$this._cameraDefaultOn;
  set cameraDefaultOn(bool? cameraDefaultOn) =>
      _$this._cameraDefaultOn = cameraDefaultOn;

  VideoSettingsResponseCameraFacingEnum? _cameraFacing;
  VideoSettingsResponseCameraFacingEnum? get cameraFacing =>
      _$this._cameraFacing;
  set cameraFacing(VideoSettingsResponseCameraFacingEnum? cameraFacing) =>
      _$this._cameraFacing = cameraFacing;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  TargetResolutionBuilder? _targetResolution;
  TargetResolutionBuilder get targetResolution =>
      _$this._targetResolution ??= TargetResolutionBuilder();
  set targetResolution(TargetResolutionBuilder? targetResolution) =>
      _$this._targetResolution = targetResolution;

  VideoSettingsResponseBuilder() {
    VideoSettingsResponse._defaults(this);
  }

  VideoSettingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessRequestEnabled = $v.accessRequestEnabled;
      _cameraDefaultOn = $v.cameraDefaultOn;
      _cameraFacing = $v.cameraFacing;
      _enabled = $v.enabled;
      _targetResolution = $v.targetResolution.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VideoSettingsResponse other) {
    _$v = other as _$VideoSettingsResponse;
  }

  @override
  void update(void Function(VideoSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VideoSettingsResponse build() => _build();

  _$VideoSettingsResponse _build() {
    _$VideoSettingsResponse _$result;
    try {
      _$result = _$v ??
          _$VideoSettingsResponse._(
            accessRequestEnabled: BuiltValueNullFieldError.checkNotNull(
                accessRequestEnabled,
                r'VideoSettingsResponse',
                'accessRequestEnabled'),
            cameraDefaultOn: BuiltValueNullFieldError.checkNotNull(
                cameraDefaultOn, r'VideoSettingsResponse', 'cameraDefaultOn'),
            cameraFacing: BuiltValueNullFieldError.checkNotNull(
                cameraFacing, r'VideoSettingsResponse', 'cameraFacing'),
            enabled: BuiltValueNullFieldError.checkNotNull(
                enabled, r'VideoSettingsResponse', 'enabled'),
            targetResolution: targetResolution.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'targetResolution';
        targetResolution.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VideoSettingsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

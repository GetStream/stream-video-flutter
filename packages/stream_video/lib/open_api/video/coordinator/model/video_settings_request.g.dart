// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VideoSettingsRequestCameraFacingEnum
    _$videoSettingsRequestCameraFacingEnum_front =
    const VideoSettingsRequestCameraFacingEnum._('front');
const VideoSettingsRequestCameraFacingEnum
    _$videoSettingsRequestCameraFacingEnum_back =
    const VideoSettingsRequestCameraFacingEnum._('back');
const VideoSettingsRequestCameraFacingEnum
    _$videoSettingsRequestCameraFacingEnum_external_ =
    const VideoSettingsRequestCameraFacingEnum._('external_');

VideoSettingsRequestCameraFacingEnum
    _$videoSettingsRequestCameraFacingEnumValueOf(String name) {
  switch (name) {
    case 'front':
      return _$videoSettingsRequestCameraFacingEnum_front;
    case 'back':
      return _$videoSettingsRequestCameraFacingEnum_back;
    case 'external_':
      return _$videoSettingsRequestCameraFacingEnum_external_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VideoSettingsRequestCameraFacingEnum>
    _$videoSettingsRequestCameraFacingEnumValues = BuiltSet<
        VideoSettingsRequestCameraFacingEnum>(const <VideoSettingsRequestCameraFacingEnum>[
  _$videoSettingsRequestCameraFacingEnum_front,
  _$videoSettingsRequestCameraFacingEnum_back,
  _$videoSettingsRequestCameraFacingEnum_external_,
]);

Serializer<VideoSettingsRequestCameraFacingEnum>
    _$videoSettingsRequestCameraFacingEnumSerializer =
    _$VideoSettingsRequestCameraFacingEnumSerializer();

class _$VideoSettingsRequestCameraFacingEnumSerializer
    implements PrimitiveSerializer<VideoSettingsRequestCameraFacingEnum> {
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
    VideoSettingsRequestCameraFacingEnum
  ];
  @override
  final String wireName = 'VideoSettingsRequestCameraFacingEnum';

  @override
  Object serialize(
          Serializers serializers, VideoSettingsRequestCameraFacingEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VideoSettingsRequestCameraFacingEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VideoSettingsRequestCameraFacingEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VideoSettingsRequest extends VideoSettingsRequest {
  @override
  final bool? accessRequestEnabled;
  @override
  final bool? cameraDefaultOn;
  @override
  final VideoSettingsRequestCameraFacingEnum? cameraFacing;
  @override
  final bool? enabled;
  @override
  final TargetResolution? targetResolution;

  factory _$VideoSettingsRequest(
          [void Function(VideoSettingsRequestBuilder)? updates]) =>
      (VideoSettingsRequestBuilder()..update(updates))._build();

  _$VideoSettingsRequest._(
      {this.accessRequestEnabled,
      this.cameraDefaultOn,
      this.cameraFacing,
      this.enabled,
      this.targetResolution})
      : super._();
  @override
  VideoSettingsRequest rebuild(
          void Function(VideoSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VideoSettingsRequestBuilder toBuilder() =>
      VideoSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VideoSettingsRequest &&
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
    return (newBuiltValueToStringHelper(r'VideoSettingsRequest')
          ..add('accessRequestEnabled', accessRequestEnabled)
          ..add('cameraDefaultOn', cameraDefaultOn)
          ..add('cameraFacing', cameraFacing)
          ..add('enabled', enabled)
          ..add('targetResolution', targetResolution))
        .toString();
  }
}

class VideoSettingsRequestBuilder
    implements Builder<VideoSettingsRequest, VideoSettingsRequestBuilder> {
  _$VideoSettingsRequest? _$v;

  bool? _accessRequestEnabled;
  bool? get accessRequestEnabled => _$this._accessRequestEnabled;
  set accessRequestEnabled(bool? accessRequestEnabled) =>
      _$this._accessRequestEnabled = accessRequestEnabled;

  bool? _cameraDefaultOn;
  bool? get cameraDefaultOn => _$this._cameraDefaultOn;
  set cameraDefaultOn(bool? cameraDefaultOn) =>
      _$this._cameraDefaultOn = cameraDefaultOn;

  VideoSettingsRequestCameraFacingEnum? _cameraFacing;
  VideoSettingsRequestCameraFacingEnum? get cameraFacing =>
      _$this._cameraFacing;
  set cameraFacing(VideoSettingsRequestCameraFacingEnum? cameraFacing) =>
      _$this._cameraFacing = cameraFacing;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  TargetResolutionBuilder? _targetResolution;
  TargetResolutionBuilder get targetResolution =>
      _$this._targetResolution ??= TargetResolutionBuilder();
  set targetResolution(TargetResolutionBuilder? targetResolution) =>
      _$this._targetResolution = targetResolution;

  VideoSettingsRequestBuilder() {
    VideoSettingsRequest._defaults(this);
  }

  VideoSettingsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessRequestEnabled = $v.accessRequestEnabled;
      _cameraDefaultOn = $v.cameraDefaultOn;
      _cameraFacing = $v.cameraFacing;
      _enabled = $v.enabled;
      _targetResolution = $v.targetResolution?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VideoSettingsRequest other) {
    _$v = other as _$VideoSettingsRequest;
  }

  @override
  void update(void Function(VideoSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VideoSettingsRequest build() => _build();

  _$VideoSettingsRequest _build() {
    _$VideoSettingsRequest _$result;
    try {
      _$result = _$v ??
          _$VideoSettingsRequest._(
            accessRequestEnabled: accessRequestEnabled,
            cameraDefaultOn: cameraDefaultOn,
            cameraFacing: cameraFacing,
            enabled: enabled,
            targetResolution: _targetResolution?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'targetResolution';
        _targetResolution?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VideoSettingsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

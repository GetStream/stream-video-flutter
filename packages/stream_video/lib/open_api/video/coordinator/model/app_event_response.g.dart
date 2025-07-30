// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_event_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppEventResponse extends AppEventResponse {
  @override
  final bool? asyncUrlEnrichEnabled;
  @override
  final bool autoTranslationEnabled;
  @override
  final FileUploadConfig? fileUploadConfig;
  @override
  final FileUploadConfig? imageUploadConfig;
  @override
  final String name;

  factory _$AppEventResponse(
          [void Function(AppEventResponseBuilder)? updates]) =>
      (AppEventResponseBuilder()..update(updates))._build();

  _$AppEventResponse._(
      {this.asyncUrlEnrichEnabled,
      required this.autoTranslationEnabled,
      this.fileUploadConfig,
      this.imageUploadConfig,
      required this.name})
      : super._();
  @override
  AppEventResponse rebuild(void Function(AppEventResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppEventResponseBuilder toBuilder() =>
      AppEventResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppEventResponse &&
        asyncUrlEnrichEnabled == other.asyncUrlEnrichEnabled &&
        autoTranslationEnabled == other.autoTranslationEnabled &&
        fileUploadConfig == other.fileUploadConfig &&
        imageUploadConfig == other.imageUploadConfig &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, asyncUrlEnrichEnabled.hashCode);
    _$hash = $jc(_$hash, autoTranslationEnabled.hashCode);
    _$hash = $jc(_$hash, fileUploadConfig.hashCode);
    _$hash = $jc(_$hash, imageUploadConfig.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppEventResponse')
          ..add('asyncUrlEnrichEnabled', asyncUrlEnrichEnabled)
          ..add('autoTranslationEnabled', autoTranslationEnabled)
          ..add('fileUploadConfig', fileUploadConfig)
          ..add('imageUploadConfig', imageUploadConfig)
          ..add('name', name))
        .toString();
  }
}

class AppEventResponseBuilder
    implements Builder<AppEventResponse, AppEventResponseBuilder> {
  _$AppEventResponse? _$v;

  bool? _asyncUrlEnrichEnabled;
  bool? get asyncUrlEnrichEnabled => _$this._asyncUrlEnrichEnabled;
  set asyncUrlEnrichEnabled(bool? asyncUrlEnrichEnabled) =>
      _$this._asyncUrlEnrichEnabled = asyncUrlEnrichEnabled;

  bool? _autoTranslationEnabled;
  bool? get autoTranslationEnabled => _$this._autoTranslationEnabled;
  set autoTranslationEnabled(bool? autoTranslationEnabled) =>
      _$this._autoTranslationEnabled = autoTranslationEnabled;

  FileUploadConfigBuilder? _fileUploadConfig;
  FileUploadConfigBuilder get fileUploadConfig =>
      _$this._fileUploadConfig ??= FileUploadConfigBuilder();
  set fileUploadConfig(FileUploadConfigBuilder? fileUploadConfig) =>
      _$this._fileUploadConfig = fileUploadConfig;

  FileUploadConfigBuilder? _imageUploadConfig;
  FileUploadConfigBuilder get imageUploadConfig =>
      _$this._imageUploadConfig ??= FileUploadConfigBuilder();
  set imageUploadConfig(FileUploadConfigBuilder? imageUploadConfig) =>
      _$this._imageUploadConfig = imageUploadConfig;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AppEventResponseBuilder() {
    AppEventResponse._defaults(this);
  }

  AppEventResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _asyncUrlEnrichEnabled = $v.asyncUrlEnrichEnabled;
      _autoTranslationEnabled = $v.autoTranslationEnabled;
      _fileUploadConfig = $v.fileUploadConfig?.toBuilder();
      _imageUploadConfig = $v.imageUploadConfig?.toBuilder();
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppEventResponse other) {
    _$v = other as _$AppEventResponse;
  }

  @override
  void update(void Function(AppEventResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppEventResponse build() => _build();

  _$AppEventResponse _build() {
    _$AppEventResponse _$result;
    try {
      _$result = _$v ??
          _$AppEventResponse._(
            asyncUrlEnrichEnabled: asyncUrlEnrichEnabled,
            autoTranslationEnabled: BuiltValueNullFieldError.checkNotNull(
                autoTranslationEnabled,
                r'AppEventResponse',
                'autoTranslationEnabled'),
            fileUploadConfig: _fileUploadConfig?.build(),
            imageUploadConfig: _imageUploadConfig?.build(),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'AppEventResponse', 'name'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'fileUploadConfig';
        _fileUploadConfig?.build();
        _$failedField = 'imageUploadConfig';
        _imageUploadConfig?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AppEventResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

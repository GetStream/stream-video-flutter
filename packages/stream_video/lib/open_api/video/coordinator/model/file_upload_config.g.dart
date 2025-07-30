// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_config.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FileUploadConfig extends FileUploadConfig {
  @override
  final BuiltList<String> allowedFileExtensions;
  @override
  final BuiltList<String> allowedMimeTypes;
  @override
  final BuiltList<String> blockedFileExtensions;
  @override
  final BuiltList<String> blockedMimeTypes;
  @override
  final int sizeLimit;

  factory _$FileUploadConfig(
          [void Function(FileUploadConfigBuilder)? updates]) =>
      (FileUploadConfigBuilder()..update(updates))._build();

  _$FileUploadConfig._(
      {required this.allowedFileExtensions,
      required this.allowedMimeTypes,
      required this.blockedFileExtensions,
      required this.blockedMimeTypes,
      required this.sizeLimit})
      : super._();
  @override
  FileUploadConfig rebuild(void Function(FileUploadConfigBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FileUploadConfigBuilder toBuilder() =>
      FileUploadConfigBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FileUploadConfig &&
        allowedFileExtensions == other.allowedFileExtensions &&
        allowedMimeTypes == other.allowedMimeTypes &&
        blockedFileExtensions == other.blockedFileExtensions &&
        blockedMimeTypes == other.blockedMimeTypes &&
        sizeLimit == other.sizeLimit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, allowedFileExtensions.hashCode);
    _$hash = $jc(_$hash, allowedMimeTypes.hashCode);
    _$hash = $jc(_$hash, blockedFileExtensions.hashCode);
    _$hash = $jc(_$hash, blockedMimeTypes.hashCode);
    _$hash = $jc(_$hash, sizeLimit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FileUploadConfig')
          ..add('allowedFileExtensions', allowedFileExtensions)
          ..add('allowedMimeTypes', allowedMimeTypes)
          ..add('blockedFileExtensions', blockedFileExtensions)
          ..add('blockedMimeTypes', blockedMimeTypes)
          ..add('sizeLimit', sizeLimit))
        .toString();
  }
}

class FileUploadConfigBuilder
    implements Builder<FileUploadConfig, FileUploadConfigBuilder> {
  _$FileUploadConfig? _$v;

  ListBuilder<String>? _allowedFileExtensions;
  ListBuilder<String> get allowedFileExtensions =>
      _$this._allowedFileExtensions ??= ListBuilder<String>();
  set allowedFileExtensions(ListBuilder<String>? allowedFileExtensions) =>
      _$this._allowedFileExtensions = allowedFileExtensions;

  ListBuilder<String>? _allowedMimeTypes;
  ListBuilder<String> get allowedMimeTypes =>
      _$this._allowedMimeTypes ??= ListBuilder<String>();
  set allowedMimeTypes(ListBuilder<String>? allowedMimeTypes) =>
      _$this._allowedMimeTypes = allowedMimeTypes;

  ListBuilder<String>? _blockedFileExtensions;
  ListBuilder<String> get blockedFileExtensions =>
      _$this._blockedFileExtensions ??= ListBuilder<String>();
  set blockedFileExtensions(ListBuilder<String>? blockedFileExtensions) =>
      _$this._blockedFileExtensions = blockedFileExtensions;

  ListBuilder<String>? _blockedMimeTypes;
  ListBuilder<String> get blockedMimeTypes =>
      _$this._blockedMimeTypes ??= ListBuilder<String>();
  set blockedMimeTypes(ListBuilder<String>? blockedMimeTypes) =>
      _$this._blockedMimeTypes = blockedMimeTypes;

  int? _sizeLimit;
  int? get sizeLimit => _$this._sizeLimit;
  set sizeLimit(int? sizeLimit) => _$this._sizeLimit = sizeLimit;

  FileUploadConfigBuilder() {
    FileUploadConfig._defaults(this);
  }

  FileUploadConfigBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _allowedFileExtensions = $v.allowedFileExtensions.toBuilder();
      _allowedMimeTypes = $v.allowedMimeTypes.toBuilder();
      _blockedFileExtensions = $v.blockedFileExtensions.toBuilder();
      _blockedMimeTypes = $v.blockedMimeTypes.toBuilder();
      _sizeLimit = $v.sizeLimit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FileUploadConfig other) {
    _$v = other as _$FileUploadConfig;
  }

  @override
  void update(void Function(FileUploadConfigBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FileUploadConfig build() => _build();

  _$FileUploadConfig _build() {
    _$FileUploadConfig _$result;
    try {
      _$result = _$v ??
          _$FileUploadConfig._(
            allowedFileExtensions: allowedFileExtensions.build(),
            allowedMimeTypes: allowedMimeTypes.build(),
            blockedFileExtensions: blockedFileExtensions.build(),
            blockedMimeTypes: blockedMimeTypes.build(),
            sizeLimit: BuiltValueNullFieldError.checkNotNull(
                sizeLimit, r'FileUploadConfig', 'sizeLimit'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'allowedFileExtensions';
        allowedFileExtensions.build();
        _$failedField = 'allowedMimeTypes';
        allowedMimeTypes.build();
        _$failedField = 'blockedFileExtensions';
        blockedFileExtensions.build();
        _$failedField = 'blockedMimeTypes';
        blockedMimeTypes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FileUploadConfig', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

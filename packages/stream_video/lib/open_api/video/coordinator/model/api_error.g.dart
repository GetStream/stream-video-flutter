// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$APIError extends APIError {
  @override
  final int statusCode;
  @override
  final int code;
  @override
  final BuiltList<int> details;
  @override
  final String duration;
  @override
  final BuiltMap<String, String>? exceptionFields;
  @override
  final String message;
  @override
  final String moreInfo;
  @override
  final bool? unrecoverable;

  factory _$APIError([void Function(APIErrorBuilder)? updates]) =>
      (APIErrorBuilder()..update(updates))._build();

  _$APIError._(
      {required this.statusCode,
      required this.code,
      required this.details,
      required this.duration,
      this.exceptionFields,
      required this.message,
      required this.moreInfo,
      this.unrecoverable})
      : super._();
  @override
  APIError rebuild(void Function(APIErrorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  APIErrorBuilder toBuilder() => APIErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is APIError &&
        statusCode == other.statusCode &&
        code == other.code &&
        details == other.details &&
        duration == other.duration &&
        exceptionFields == other.exceptionFields &&
        message == other.message &&
        moreInfo == other.moreInfo &&
        unrecoverable == other.unrecoverable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, statusCode.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, exceptionFields.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, moreInfo.hashCode);
    _$hash = $jc(_$hash, unrecoverable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'APIError')
          ..add('statusCode', statusCode)
          ..add('code', code)
          ..add('details', details)
          ..add('duration', duration)
          ..add('exceptionFields', exceptionFields)
          ..add('message', message)
          ..add('moreInfo', moreInfo)
          ..add('unrecoverable', unrecoverable))
        .toString();
  }
}

class APIErrorBuilder implements Builder<APIError, APIErrorBuilder> {
  _$APIError? _$v;

  int? _statusCode;
  int? get statusCode => _$this._statusCode;
  set statusCode(int? statusCode) => _$this._statusCode = statusCode;

  int? _code;
  int? get code => _$this._code;
  set code(int? code) => _$this._code = code;

  ListBuilder<int>? _details;
  ListBuilder<int> get details => _$this._details ??= ListBuilder<int>();
  set details(ListBuilder<int>? details) => _$this._details = details;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  MapBuilder<String, String>? _exceptionFields;
  MapBuilder<String, String> get exceptionFields =>
      _$this._exceptionFields ??= MapBuilder<String, String>();
  set exceptionFields(MapBuilder<String, String>? exceptionFields) =>
      _$this._exceptionFields = exceptionFields;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _moreInfo;
  String? get moreInfo => _$this._moreInfo;
  set moreInfo(String? moreInfo) => _$this._moreInfo = moreInfo;

  bool? _unrecoverable;
  bool? get unrecoverable => _$this._unrecoverable;
  set unrecoverable(bool? unrecoverable) =>
      _$this._unrecoverable = unrecoverable;

  APIErrorBuilder() {
    APIError._defaults(this);
  }

  APIErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _statusCode = $v.statusCode;
      _code = $v.code;
      _details = $v.details.toBuilder();
      _duration = $v.duration;
      _exceptionFields = $v.exceptionFields?.toBuilder();
      _message = $v.message;
      _moreInfo = $v.moreInfo;
      _unrecoverable = $v.unrecoverable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(APIError other) {
    _$v = other as _$APIError;
  }

  @override
  void update(void Function(APIErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  APIError build() => _build();

  _$APIError _build() {
    _$APIError _$result;
    try {
      _$result = _$v ??
          _$APIError._(
            statusCode: BuiltValueNullFieldError.checkNotNull(
                statusCode, r'APIError', 'statusCode'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'APIError', 'code'),
            details: details.build(),
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'APIError', 'duration'),
            exceptionFields: _exceptionFields?.build(),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'APIError', 'message'),
            moreInfo: BuiltValueNullFieldError.checkNotNull(
                moreInfo, r'APIError', 'moreInfo'),
            unrecoverable: unrecoverable,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'details';
        details.build();

        _$failedField = 'exceptionFields';
        _exceptionFields?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'APIError', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_closed_caption.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallClosedCaption extends CallClosedCaption {
  @override
  final DateTime endTime;
  @override
  final String speakerId;
  @override
  final DateTime startTime;
  @override
  final String text;
  @override
  final UserResponse user;

  factory _$CallClosedCaption(
          [void Function(CallClosedCaptionBuilder)? updates]) =>
      (CallClosedCaptionBuilder()..update(updates))._build();

  _$CallClosedCaption._(
      {required this.endTime,
      required this.speakerId,
      required this.startTime,
      required this.text,
      required this.user})
      : super._();
  @override
  CallClosedCaption rebuild(void Function(CallClosedCaptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallClosedCaptionBuilder toBuilder() =>
      CallClosedCaptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallClosedCaption &&
        endTime == other.endTime &&
        speakerId == other.speakerId &&
        startTime == other.startTime &&
        text == other.text &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, endTime.hashCode);
    _$hash = $jc(_$hash, speakerId.hashCode);
    _$hash = $jc(_$hash, startTime.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallClosedCaption')
          ..add('endTime', endTime)
          ..add('speakerId', speakerId)
          ..add('startTime', startTime)
          ..add('text', text)
          ..add('user', user))
        .toString();
  }
}

class CallClosedCaptionBuilder
    implements Builder<CallClosedCaption, CallClosedCaptionBuilder> {
  _$CallClosedCaption? _$v;

  DateTime? _endTime;
  DateTime? get endTime => _$this._endTime;
  set endTime(DateTime? endTime) => _$this._endTime = endTime;

  String? _speakerId;
  String? get speakerId => _$this._speakerId;
  set speakerId(String? speakerId) => _$this._speakerId = speakerId;

  DateTime? _startTime;
  DateTime? get startTime => _$this._startTime;
  set startTime(DateTime? startTime) => _$this._startTime = startTime;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  CallClosedCaptionBuilder() {
    CallClosedCaption._defaults(this);
  }

  CallClosedCaptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _endTime = $v.endTime;
      _speakerId = $v.speakerId;
      _startTime = $v.startTime;
      _text = $v.text;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallClosedCaption other) {
    _$v = other as _$CallClosedCaption;
  }

  @override
  void update(void Function(CallClosedCaptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallClosedCaption build() => _build();

  _$CallClosedCaption _build() {
    _$CallClosedCaption _$result;
    try {
      _$result = _$v ??
          _$CallClosedCaption._(
            endTime: BuiltValueNullFieldError.checkNotNull(
                endTime, r'CallClosedCaption', 'endTime'),
            speakerId: BuiltValueNullFieldError.checkNotNull(
                speakerId, r'CallClosedCaption', 'speakerId'),
            startTime: BuiltValueNullFieldError.checkNotNull(
                startTime, r'CallClosedCaption', 'startTime'),
            text: BuiltValueNullFieldError.checkNotNull(
                text, r'CallClosedCaption', 'text'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallClosedCaption', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

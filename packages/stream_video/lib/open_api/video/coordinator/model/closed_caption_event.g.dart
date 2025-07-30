// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'closed_caption_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ClosedCaptionEvent extends ClosedCaptionEvent {
  @override
  final String callCid;
  @override
  final CallClosedCaption closedCaption;
  @override
  final DateTime createdAt;
  @override
  final String type;

  factory _$ClosedCaptionEvent(
          [void Function(ClosedCaptionEventBuilder)? updates]) =>
      (ClosedCaptionEventBuilder()..update(updates))._build();

  _$ClosedCaptionEvent._(
      {required this.callCid,
      required this.closedCaption,
      required this.createdAt,
      required this.type})
      : super._();
  @override
  ClosedCaptionEvent rebuild(
          void Function(ClosedCaptionEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClosedCaptionEventBuilder toBuilder() =>
      ClosedCaptionEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClosedCaptionEvent &&
        callCid == other.callCid &&
        closedCaption == other.closedCaption &&
        createdAt == other.createdAt &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, closedCaption.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClosedCaptionEvent')
          ..add('callCid', callCid)
          ..add('closedCaption', closedCaption)
          ..add('createdAt', createdAt)
          ..add('type', type))
        .toString();
  }
}

class ClosedCaptionEventBuilder
    implements Builder<ClosedCaptionEvent, ClosedCaptionEventBuilder> {
  _$ClosedCaptionEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  CallClosedCaptionBuilder? _closedCaption;
  CallClosedCaptionBuilder get closedCaption =>
      _$this._closedCaption ??= CallClosedCaptionBuilder();
  set closedCaption(CallClosedCaptionBuilder? closedCaption) =>
      _$this._closedCaption = closedCaption;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  ClosedCaptionEventBuilder() {
    ClosedCaptionEvent._defaults(this);
  }

  ClosedCaptionEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _closedCaption = $v.closedCaption.toBuilder();
      _createdAt = $v.createdAt;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClosedCaptionEvent other) {
    _$v = other as _$ClosedCaptionEvent;
  }

  @override
  void update(void Function(ClosedCaptionEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClosedCaptionEvent build() => _build();

  _$ClosedCaptionEvent _build() {
    _$ClosedCaptionEvent _$result;
    try {
      _$result = _$v ??
          _$ClosedCaptionEvent._(
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'ClosedCaptionEvent', 'callCid'),
            closedCaption: closedCaption.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ClosedCaptionEvent', 'createdAt'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'ClosedCaptionEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'closedCaption';
        closedCaption.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ClosedCaptionEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

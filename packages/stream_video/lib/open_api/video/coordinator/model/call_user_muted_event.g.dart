// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_user_muted_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallUserMutedEvent extends CallUserMutedEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String fromUserId;
  @override
  final BuiltList<String> mutedUserIds;
  @override
  final String type;

  factory _$CallUserMutedEvent(
          [void Function(CallUserMutedEventBuilder)? updates]) =>
      (CallUserMutedEventBuilder()..update(updates))._build();

  _$CallUserMutedEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.fromUserId,
      required this.mutedUserIds,
      required this.type})
      : super._();
  @override
  CallUserMutedEvent rebuild(
          void Function(CallUserMutedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallUserMutedEventBuilder toBuilder() =>
      CallUserMutedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallUserMutedEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        fromUserId == other.fromUserId &&
        mutedUserIds == other.mutedUserIds &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, fromUserId.hashCode);
    _$hash = $jc(_$hash, mutedUserIds.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallUserMutedEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('fromUserId', fromUserId)
          ..add('mutedUserIds', mutedUserIds)
          ..add('type', type))
        .toString();
  }
}

class CallUserMutedEventBuilder
    implements Builder<CallUserMutedEvent, CallUserMutedEventBuilder> {
  _$CallUserMutedEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _fromUserId;
  String? get fromUserId => _$this._fromUserId;
  set fromUserId(String? fromUserId) => _$this._fromUserId = fromUserId;

  ListBuilder<String>? _mutedUserIds;
  ListBuilder<String> get mutedUserIds =>
      _$this._mutedUserIds ??= ListBuilder<String>();
  set mutedUserIds(ListBuilder<String>? mutedUserIds) =>
      _$this._mutedUserIds = mutedUserIds;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallUserMutedEventBuilder() {
    CallUserMutedEvent._defaults(this);
  }

  CallUserMutedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _fromUserId = $v.fromUserId;
      _mutedUserIds = $v.mutedUserIds.toBuilder();
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallUserMutedEvent other) {
    _$v = other as _$CallUserMutedEvent;
  }

  @override
  void update(void Function(CallUserMutedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallUserMutedEvent build() => _build();

  _$CallUserMutedEvent _build() {
    _$CallUserMutedEvent _$result;
    try {
      _$result = _$v ??
          _$CallUserMutedEvent._(
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallUserMutedEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallUserMutedEvent', 'createdAt'),
            fromUserId: BuiltValueNullFieldError.checkNotNull(
                fromUserId, r'CallUserMutedEvent', 'fromUserId'),
            mutedUserIds: mutedUserIds.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallUserMutedEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'mutedUserIds';
        mutedUserIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallUserMutedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

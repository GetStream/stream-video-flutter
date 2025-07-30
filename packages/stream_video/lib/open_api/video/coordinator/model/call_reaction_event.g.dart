// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_reaction_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallReactionEvent extends CallReactionEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final ReactionResponse reaction;
  @override
  final String type;

  factory _$CallReactionEvent(
          [void Function(CallReactionEventBuilder)? updates]) =>
      (CallReactionEventBuilder()..update(updates))._build();

  _$CallReactionEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.reaction,
      required this.type})
      : super._();
  @override
  CallReactionEvent rebuild(void Function(CallReactionEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallReactionEventBuilder toBuilder() =>
      CallReactionEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallReactionEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        reaction == other.reaction &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, reaction.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallReactionEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('reaction', reaction)
          ..add('type', type))
        .toString();
  }
}

class CallReactionEventBuilder
    implements Builder<CallReactionEvent, CallReactionEventBuilder> {
  _$CallReactionEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ReactionResponseBuilder? _reaction;
  ReactionResponseBuilder get reaction =>
      _$this._reaction ??= ReactionResponseBuilder();
  set reaction(ReactionResponseBuilder? reaction) =>
      _$this._reaction = reaction;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallReactionEventBuilder() {
    CallReactionEvent._defaults(this);
  }

  CallReactionEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _reaction = $v.reaction.toBuilder();
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallReactionEvent other) {
    _$v = other as _$CallReactionEvent;
  }

  @override
  void update(void Function(CallReactionEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallReactionEvent build() => _build();

  _$CallReactionEvent _build() {
    _$CallReactionEvent _$result;
    try {
      _$result = _$v ??
          _$CallReactionEvent._(
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallReactionEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallReactionEvent', 'createdAt'),
            reaction: reaction.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallReactionEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reaction';
        reaction.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallReactionEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

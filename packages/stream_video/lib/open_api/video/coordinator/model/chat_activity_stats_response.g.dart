// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_activity_stats_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatActivityStatsResponse extends ChatActivityStatsResponse {
  @override
  final MessageStatsResponse? messages;

  factory _$ChatActivityStatsResponse(
          [void Function(ChatActivityStatsResponseBuilder)? updates]) =>
      (ChatActivityStatsResponseBuilder()..update(updates))._build();

  _$ChatActivityStatsResponse._({this.messages}) : super._();
  @override
  ChatActivityStatsResponse rebuild(
          void Function(ChatActivityStatsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatActivityStatsResponseBuilder toBuilder() =>
      ChatActivityStatsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatActivityStatsResponse && messages == other.messages;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, messages.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatActivityStatsResponse')
          ..add('messages', messages))
        .toString();
  }
}

class ChatActivityStatsResponseBuilder
    implements
        Builder<ChatActivityStatsResponse, ChatActivityStatsResponseBuilder> {
  _$ChatActivityStatsResponse? _$v;

  MessageStatsResponseBuilder? _messages;
  MessageStatsResponseBuilder get messages =>
      _$this._messages ??= MessageStatsResponseBuilder();
  set messages(MessageStatsResponseBuilder? messages) =>
      _$this._messages = messages;

  ChatActivityStatsResponseBuilder() {
    ChatActivityStatsResponse._defaults(this);
  }

  ChatActivityStatsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _messages = $v.messages?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatActivityStatsResponse other) {
    _$v = other as _$ChatActivityStatsResponse;
  }

  @override
  void update(void Function(ChatActivityStatsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatActivityStatsResponse build() => _build();

  _$ChatActivityStatsResponse _build() {
    _$ChatActivityStatsResponse _$result;
    try {
      _$result = _$v ??
          _$ChatActivityStatsResponse._(
            messages: _messages?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'messages';
        _messages?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatActivityStatsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

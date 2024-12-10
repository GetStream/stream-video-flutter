//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

/// All possibility of string to use
class ChannelOwnCapability {
  /// Instantiate a new enum with the provided [value].
  const ChannelOwnCapability._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const banChannelMembers = ChannelOwnCapability._(r'ban-channel-members');
  static const castPollVote = ChannelOwnCapability._(r'cast-poll-vote');
  static const connectEvents = ChannelOwnCapability._(r'connect-events');
  static const createAttachment = ChannelOwnCapability._(r'create-attachment');
  static const createCall = ChannelOwnCapability._(r'create-call');
  static const deleteAnyMessage = ChannelOwnCapability._(r'delete-any-message');
  static const deleteChannel = ChannelOwnCapability._(r'delete-channel');
  static const deleteOwnMessage = ChannelOwnCapability._(r'delete-own-message');
  static const flagMessage = ChannelOwnCapability._(r'flag-message');
  static const freezeChannel = ChannelOwnCapability._(r'freeze-channel');
  static const joinCall = ChannelOwnCapability._(r'join-call');
  static const joinChannel = ChannelOwnCapability._(r'join-channel');
  static const leaveChannel = ChannelOwnCapability._(r'leave-channel');
  static const muteChannel = ChannelOwnCapability._(r'mute-channel');
  static const pinMessage = ChannelOwnCapability._(r'pin-message');
  static const queryPollVotes = ChannelOwnCapability._(r'query-poll-votes');
  static const quoteMessage = ChannelOwnCapability._(r'quote-message');
  static const readEvents = ChannelOwnCapability._(r'read-events');
  static const searchMessages = ChannelOwnCapability._(r'search-messages');
  static const sendCustomEvents = ChannelOwnCapability._(r'send-custom-events');
  static const sendLinks = ChannelOwnCapability._(r'send-links');
  static const sendMessage = ChannelOwnCapability._(r'send-message');
  static const sendPoll = ChannelOwnCapability._(r'send-poll');
  static const sendReaction = ChannelOwnCapability._(r'send-reaction');
  static const sendReply = ChannelOwnCapability._(r'send-reply');
  static const sendTypingEvents = ChannelOwnCapability._(r'send-typing-events');
  static const setChannelCooldown = ChannelOwnCapability._(r'set-channel-cooldown');
  static const skipSlowMode = ChannelOwnCapability._(r'skip-slow-mode');
  static const slowMode = ChannelOwnCapability._(r'slow-mode');
  static const typingEvents = ChannelOwnCapability._(r'typing-events');
  static const updateAnyMessage = ChannelOwnCapability._(r'update-any-message');
  static const updateChannel = ChannelOwnCapability._(r'update-channel');
  static const updateChannelMembers = ChannelOwnCapability._(r'update-channel-members');
  static const updateOwnMessage = ChannelOwnCapability._(r'update-own-message');
  static const updateThread = ChannelOwnCapability._(r'update-thread');
  static const uploadFile = ChannelOwnCapability._(r'upload-file');

  /// List of all possible values in this [enum][ChannelOwnCapability].
  static const values = <ChannelOwnCapability>[
    banChannelMembers,
    castPollVote,
    connectEvents,
    createAttachment,
    createCall,
    deleteAnyMessage,
    deleteChannel,
    deleteOwnMessage,
    flagMessage,
    freezeChannel,
    joinCall,
    joinChannel,
    leaveChannel,
    muteChannel,
    pinMessage,
    queryPollVotes,
    quoteMessage,
    readEvents,
    searchMessages,
    sendCustomEvents,
    sendLinks,
    sendMessage,
    sendPoll,
    sendReaction,
    sendReply,
    sendTypingEvents,
    setChannelCooldown,
    skipSlowMode,
    slowMode,
    typingEvents,
    updateAnyMessage,
    updateChannel,
    updateChannelMembers,
    updateOwnMessage,
    updateThread,
    uploadFile,
  ];

  static ChannelOwnCapability? fromJson(dynamic value) => ChannelOwnCapabilityTypeTransformer().decode(value);

  static List<ChannelOwnCapability> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChannelOwnCapability>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChannelOwnCapability.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ChannelOwnCapability] to String,
/// and [decode] dynamic data back to [ChannelOwnCapability].
class ChannelOwnCapabilityTypeTransformer {
  factory ChannelOwnCapabilityTypeTransformer() => _instance ??= const ChannelOwnCapabilityTypeTransformer._();

  const ChannelOwnCapabilityTypeTransformer._();

  String encode(ChannelOwnCapability data) => data.value;

  /// Decodes a [dynamic value][data] to a ChannelOwnCapability.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ChannelOwnCapability? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ban-channel-members': return ChannelOwnCapability.banChannelMembers;
        case r'cast-poll-vote': return ChannelOwnCapability.castPollVote;
        case r'connect-events': return ChannelOwnCapability.connectEvents;
        case r'create-attachment': return ChannelOwnCapability.createAttachment;
        case r'create-call': return ChannelOwnCapability.createCall;
        case r'delete-any-message': return ChannelOwnCapability.deleteAnyMessage;
        case r'delete-channel': return ChannelOwnCapability.deleteChannel;
        case r'delete-own-message': return ChannelOwnCapability.deleteOwnMessage;
        case r'flag-message': return ChannelOwnCapability.flagMessage;
        case r'freeze-channel': return ChannelOwnCapability.freezeChannel;
        case r'join-call': return ChannelOwnCapability.joinCall;
        case r'join-channel': return ChannelOwnCapability.joinChannel;
        case r'leave-channel': return ChannelOwnCapability.leaveChannel;
        case r'mute-channel': return ChannelOwnCapability.muteChannel;
        case r'pin-message': return ChannelOwnCapability.pinMessage;
        case r'query-poll-votes': return ChannelOwnCapability.queryPollVotes;
        case r'quote-message': return ChannelOwnCapability.quoteMessage;
        case r'read-events': return ChannelOwnCapability.readEvents;
        case r'search-messages': return ChannelOwnCapability.searchMessages;
        case r'send-custom-events': return ChannelOwnCapability.sendCustomEvents;
        case r'send-links': return ChannelOwnCapability.sendLinks;
        case r'send-message': return ChannelOwnCapability.sendMessage;
        case r'send-poll': return ChannelOwnCapability.sendPoll;
        case r'send-reaction': return ChannelOwnCapability.sendReaction;
        case r'send-reply': return ChannelOwnCapability.sendReply;
        case r'send-typing-events': return ChannelOwnCapability.sendTypingEvents;
        case r'set-channel-cooldown': return ChannelOwnCapability.setChannelCooldown;
        case r'skip-slow-mode': return ChannelOwnCapability.skipSlowMode;
        case r'slow-mode': return ChannelOwnCapability.slowMode;
        case r'typing-events': return ChannelOwnCapability.typingEvents;
        case r'update-any-message': return ChannelOwnCapability.updateAnyMessage;
        case r'update-channel': return ChannelOwnCapability.updateChannel;
        case r'update-channel-members': return ChannelOwnCapability.updateChannelMembers;
        case r'update-own-message': return ChannelOwnCapability.updateOwnMessage;
        case r'update-thread': return ChannelOwnCapability.updateThread;
        case r'upload-file': return ChannelOwnCapability.uploadFile;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ChannelOwnCapabilityTypeTransformer] instance.
  static ChannelOwnCapabilityTypeTransformer? _instance;
}


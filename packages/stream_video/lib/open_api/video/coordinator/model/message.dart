//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Message {
  /// Returns a new [Message] instance.
  Message({
    this.attachments = const [],
    this.beforeMessageSendFailed,
    required this.cid,
    this.command,
    required this.createdAt,
    this.custom = const {},
    this.deletedAt,
    required this.deletedReplyCount,
    required this.html,
    this.i18n = const {},
    required this.id,
    this.imageLabels = const {},
    this.latestReactions = const [],
    this.mentionedUsers = const [],
    this.messageTextUpdatedAt,
    this.mml,
    this.ownReactions = const [],
    this.parentId,
    this.pinExpires,
    required this.pinned,
    this.pinnedAt,
    this.pinnedBy,
    this.poll,
    this.pollId,
    this.quotedMessage,
    this.quotedMessageId,
    this.reactionCounts = const {},
    this.reactionGroups = const {},
    this.reactionScores = const {},
    required this.replyCount,
    required this.shadowed,
    this.showInChannel,
    required this.silent,
    required this.text,
    this.threadParticipants = const [],
    required this.type,
    required this.updatedAt,
    this.user,
  });

  List<Attachment> attachments;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? beforeMessageSendFailed;

  String cid;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? command;

  DateTime createdAt;

  Map<String, Object> custom;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? deletedAt;

  int deletedReplyCount;

  String html;

  Map<String, String> i18n;

  String id;

  Map<String, List<String>> imageLabels;

  List<Reaction> latestReactions;

  List<User> mentionedUsers;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? messageTextUpdatedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? mml;

  List<Reaction> ownReactions;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? parentId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? pinExpires;

  bool pinned;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? pinnedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  User? pinnedBy;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Poll? poll;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? pollId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Message? quotedMessage;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? quotedMessageId;

  Map<String, int> reactionCounts;

  Map<String, ReactionGroupResponse> reactionGroups;

  Map<String, int> reactionScores;

  int replyCount;

  bool shadowed;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? showInChannel;

  bool silent;

  String text;

  List<User> threadParticipants;

  String type;

  DateTime updatedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  User? user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Message &&
    _deepEquality.equals(other.attachments, attachments) &&
    other.beforeMessageSendFailed == beforeMessageSendFailed &&
    other.cid == cid &&
    other.command == command &&
    other.createdAt == createdAt &&
    _deepEquality.equals(other.custom, custom) &&
    other.deletedAt == deletedAt &&
    other.deletedReplyCount == deletedReplyCount &&
    other.html == html &&
    _deepEquality.equals(other.i18n, i18n) &&
    other.id == id &&
    _deepEquality.equals(other.imageLabels, imageLabels) &&
    _deepEquality.equals(other.latestReactions, latestReactions) &&
    _deepEquality.equals(other.mentionedUsers, mentionedUsers) &&
    other.messageTextUpdatedAt == messageTextUpdatedAt &&
    other.mml == mml &&
    _deepEquality.equals(other.ownReactions, ownReactions) &&
    other.parentId == parentId &&
    other.pinExpires == pinExpires &&
    other.pinned == pinned &&
    other.pinnedAt == pinnedAt &&
    other.pinnedBy == pinnedBy &&
    other.poll == poll &&
    other.pollId == pollId &&
    other.quotedMessage == quotedMessage &&
    other.quotedMessageId == quotedMessageId &&
    _deepEquality.equals(other.reactionCounts, reactionCounts) &&
    _deepEquality.equals(other.reactionGroups, reactionGroups) &&
    _deepEquality.equals(other.reactionScores, reactionScores) &&
    other.replyCount == replyCount &&
    other.shadowed == shadowed &&
    other.showInChannel == showInChannel &&
    other.silent == silent &&
    other.text == text &&
    _deepEquality.equals(other.threadParticipants, threadParticipants) &&
    other.type == type &&
    other.updatedAt == updatedAt &&
    other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (attachments.hashCode) +
    (beforeMessageSendFailed == null ? 0 : beforeMessageSendFailed!.hashCode) +
    (cid.hashCode) +
    (command == null ? 0 : command!.hashCode) +
    (createdAt.hashCode) +
    (custom.hashCode) +
    (deletedAt == null ? 0 : deletedAt!.hashCode) +
    (deletedReplyCount.hashCode) +
    (html.hashCode) +
    (i18n.hashCode) +
    (id.hashCode) +
    (imageLabels.hashCode) +
    (latestReactions.hashCode) +
    (mentionedUsers.hashCode) +
    (messageTextUpdatedAt == null ? 0 : messageTextUpdatedAt!.hashCode) +
    (mml == null ? 0 : mml!.hashCode) +
    (ownReactions.hashCode) +
    (parentId == null ? 0 : parentId!.hashCode) +
    (pinExpires == null ? 0 : pinExpires!.hashCode) +
    (pinned.hashCode) +
    (pinnedAt == null ? 0 : pinnedAt!.hashCode) +
    (pinnedBy == null ? 0 : pinnedBy!.hashCode) +
    (poll == null ? 0 : poll!.hashCode) +
    (pollId == null ? 0 : pollId!.hashCode) +
    (quotedMessage == null ? 0 : quotedMessage!.hashCode) +
    (quotedMessageId == null ? 0 : quotedMessageId!.hashCode) +
    (reactionCounts.hashCode) +
    (reactionGroups.hashCode) +
    (reactionScores.hashCode) +
    (replyCount.hashCode) +
    (shadowed.hashCode) +
    (showInChannel == null ? 0 : showInChannel!.hashCode) +
    (silent.hashCode) +
    (text.hashCode) +
    (threadParticipants.hashCode) +
    (type.hashCode) +
    (updatedAt.hashCode) +
    (user == null ? 0 : user!.hashCode);

  @override
  String toString() => 'Message[attachments=$attachments, beforeMessageSendFailed=$beforeMessageSendFailed, cid=$cid, command=$command, createdAt=$createdAt, custom=$custom, deletedAt=$deletedAt, deletedReplyCount=$deletedReplyCount, html=$html, i18n=$i18n, id=$id, imageLabels=$imageLabels, latestReactions=$latestReactions, mentionedUsers=$mentionedUsers, messageTextUpdatedAt=$messageTextUpdatedAt, mml=$mml, ownReactions=$ownReactions, parentId=$parentId, pinExpires=$pinExpires, pinned=$pinned, pinnedAt=$pinnedAt, pinnedBy=$pinnedBy, poll=$poll, pollId=$pollId, quotedMessage=$quotedMessage, quotedMessageId=$quotedMessageId, reactionCounts=$reactionCounts, reactionGroups=$reactionGroups, reactionScores=$reactionScores, replyCount=$replyCount, shadowed=$shadowed, showInChannel=$showInChannel, silent=$silent, text=$text, threadParticipants=$threadParticipants, type=$type, updatedAt=$updatedAt, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'attachments'] = this.attachments;
    if (this.beforeMessageSendFailed != null) {
      json[r'before_message_send_failed'] = this.beforeMessageSendFailed;
    } else {
      json[r'before_message_send_failed'] = null;
    }
      json[r'cid'] = this.cid;
    if (this.command != null) {
      json[r'command'] = this.command;
    } else {
      json[r'command'] = null;
    }
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'custom'] = this.custom;
    if (this.deletedAt != null) {
      json[r'deleted_at'] = this.deletedAt!.toUtc().toIso8601String();
    } else {
      json[r'deleted_at'] = null;
    }
      json[r'deleted_reply_count'] = this.deletedReplyCount;
      json[r'html'] = this.html;
      json[r'i18n'] = this.i18n;
      json[r'id'] = this.id;
      json[r'image_labels'] = this.imageLabels;
      json[r'latest_reactions'] = this.latestReactions;
      json[r'mentioned_users'] = this.mentionedUsers;
    if (this.messageTextUpdatedAt != null) {
      json[r'message_text_updated_at'] = this.messageTextUpdatedAt!.toUtc().toIso8601String();
    } else {
      json[r'message_text_updated_at'] = null;
    }
    if (this.mml != null) {
      json[r'mml'] = this.mml;
    } else {
      json[r'mml'] = null;
    }
      json[r'own_reactions'] = this.ownReactions;
    if (this.parentId != null) {
      json[r'parent_id'] = this.parentId;
    } else {
      json[r'parent_id'] = null;
    }
    if (this.pinExpires != null) {
      json[r'pin_expires'] = this.pinExpires!.toUtc().toIso8601String();
    } else {
      json[r'pin_expires'] = null;
    }
      json[r'pinned'] = this.pinned;
    if (this.pinnedAt != null) {
      json[r'pinned_at'] = this.pinnedAt!.toUtc().toIso8601String();
    } else {
      json[r'pinned_at'] = null;
    }
    if (this.pinnedBy != null) {
      json[r'pinned_by'] = this.pinnedBy;
    } else {
      json[r'pinned_by'] = null;
    }
    if (this.poll != null) {
      json[r'poll'] = this.poll;
    } else {
      json[r'poll'] = null;
    }
    if (this.pollId != null) {
      json[r'poll_id'] = this.pollId;
    } else {
      json[r'poll_id'] = null;
    }
    if (this.quotedMessage != null) {
      json[r'quoted_message'] = this.quotedMessage;
    } else {
      json[r'quoted_message'] = null;
    }
    if (this.quotedMessageId != null) {
      json[r'quoted_message_id'] = this.quotedMessageId;
    } else {
      json[r'quoted_message_id'] = null;
    }
      json[r'reaction_counts'] = this.reactionCounts;
      json[r'reaction_groups'] = this.reactionGroups;
      json[r'reaction_scores'] = this.reactionScores;
      json[r'reply_count'] = this.replyCount;
      json[r'shadowed'] = this.shadowed;
    if (this.showInChannel != null) {
      json[r'show_in_channel'] = this.showInChannel;
    } else {
      json[r'show_in_channel'] = null;
    }
      json[r'silent'] = this.silent;
      json[r'text'] = this.text;
      json[r'thread_participants'] = this.threadParticipants;
      json[r'type'] = this.type;
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    return json;
  }

  /// Returns a new [Message] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Message? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Message[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Message[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Message(
        attachments: Attachment.listFromJson(json[r'attachments']),
        beforeMessageSendFailed: mapValueOfType<bool>(json, r'before_message_send_failed'),
        cid: mapValueOfType<String>(json, r'cid')!,
        command: mapValueOfType<String>(json, r'command'),
        createdAt: mapDateTime(json, r'created_at', r'')!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        deletedAt: mapDateTime(json, r'deleted_at', r''),
        deletedReplyCount: mapValueOfType<int>(json, r'deleted_reply_count')!,
        html: mapValueOfType<String>(json, r'html')!,
        i18n: mapCastOfType<String, String>(json, r'i18n') ?? const {},
        id: mapValueOfType<String>(json, r'id')!,
        // MANUAL_EDIT: List to List<String>
        imageLabels: json[r'image_labels'] == null
            ? const {}
            : mapCastOfType<String, List<String>>(json, r'image_labels') ?? const {},
        latestReactions: Reaction.listFromJson(json[r'latest_reactions']),
        mentionedUsers: User.listFromJson(json[r'mentioned_users']),
        messageTextUpdatedAt: mapDateTime(json, r'message_text_updated_at', r''),
        mml: mapValueOfType<String>(json, r'mml'),
        ownReactions: Reaction.listFromJson(json[r'own_reactions']),
        parentId: mapValueOfType<String>(json, r'parent_id'),
        pinExpires: mapDateTime(json, r'pin_expires', r''),
        pinned: mapValueOfType<bool>(json, r'pinned')!,
        pinnedAt: mapDateTime(json, r'pinned_at', r''),
        pinnedBy: User.fromJson(json[r'pinned_by']),
        poll: Poll.fromJson(json[r'poll']),
        pollId: mapValueOfType<String>(json, r'poll_id'),
        quotedMessage: Message.fromJson(json[r'quoted_message']),
        quotedMessageId: mapValueOfType<String>(json, r'quoted_message_id'),
        reactionCounts: mapCastOfType<String, int>(json, r'reaction_counts')!,
        reactionGroups: ReactionGroupResponse.mapFromJson(json[r'reaction_groups']),
        reactionScores: mapCastOfType<String, int>(json, r'reaction_scores')!,
        replyCount: mapValueOfType<int>(json, r'reply_count')!,
        shadowed: mapValueOfType<bool>(json, r'shadowed')!,
        showInChannel: mapValueOfType<bool>(json, r'show_in_channel'),
        silent: mapValueOfType<bool>(json, r'silent')!,
        text: mapValueOfType<String>(json, r'text')!,
        threadParticipants: User.listFromJson(json[r'thread_participants']),
        type: mapValueOfType<String>(json, r'type')!,
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
        user: User.fromJson(json[r'user']),
      );
    }
    return null;
  }

  static List<Message> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Message>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Message.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Message> mapFromJson(dynamic json) {
    final map = <String, Message>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Message.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Message-objects as value to a dart map
  static Map<String, List<Message>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Message>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Message.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'attachments',
    'cid',
    'created_at',
    'custom',
    'deleted_reply_count',
    'html',
    'id',
    'latest_reactions',
    'mentioned_users',
    'own_reactions',
    'pinned',
    'reaction_counts',
    'reaction_groups',
    'reaction_scores',
    'reply_count',
    'shadowed',
    'silent',
    'text',
    'type',
    'updated_at',
  };
}


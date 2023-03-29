import 'dart:convert';

class HealthCheck {
  HealthCheck({
    this.type,
    this.connectionId,
    this.cid,
    this.me,
    this.createdAt,
  });

  final String? type;
  final String? connectionId;
  final String? cid;
  final Me? me;
  final DateTime? createdAt;

  HealthCheck copyWith({
    String? type,
    String? connectionId,
    String? cid,
    Me? me,
    DateTime? createdAt,
  }) =>
      HealthCheck(
        type: type ?? this.type,
        connectionId: connectionId ?? this.connectionId,
        cid: cid ?? this.cid,
        me: me ?? this.me,
        createdAt: createdAt ?? this.createdAt,
      );

  factory HealthCheck.fromRawJson(String str) =>
      HealthCheck.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HealthCheck.fromJson(Map<String, dynamic> json) => HealthCheck(
        type: json["type"],
        connectionId: json["connection_id"],
        cid: json["cid"],
        me: json["me"] == null ? null : Me.fromJson(json["me"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "connection_id": connectionId,
        "cid": cid,
        "me": me?.toJson(),
        "created_at": createdAt?.toIso8601String(),
      };
}

class Me {
  Me({
    this.id,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.lastActive,
    this.banned,
    this.online,
    this.invisible,
    this.devices,
    this.mutes,
    this.channelMutes,
    this.unreadCount,
    this.totalUnreadCount,
    this.unreadChannels,
    this.language,
    this.image,
    this.imageUrl,
    this.userName,
    this.name,
  });

  final String? id;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastActive;
  final bool? banned;
  final bool? online;
  final bool? invisible;
  final List<dynamic>? devices;
  final List<dynamic>? mutes;
  final List<dynamic>? channelMutes;
  final int? unreadCount;
  final int? totalUnreadCount;
  final int? unreadChannels;
  final String? language;
  final String? image;
  final String? imageUrl;
  final String? userName;
  final String? name;

  Me copyWith({
    String? id,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActive,
    bool? banned,
    bool? online,
    bool? invisible,
    List<dynamic>? devices,
    List<dynamic>? mutes,
    List<dynamic>? channelMutes,
    int? unreadCount,
    int? totalUnreadCount,
    int? unreadChannels,
    String? language,
    String? image,
    String? imageUrl,
    String? userName,
    String? name,
  }) =>
      Me(
        id: id ?? this.id,
        role: role ?? this.role,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastActive: lastActive ?? this.lastActive,
        banned: banned ?? this.banned,
        online: online ?? this.online,
        invisible: invisible ?? this.invisible,
        devices: devices ?? this.devices,
        mutes: mutes ?? this.mutes,
        channelMutes: channelMutes ?? this.channelMutes,
        unreadCount: unreadCount ?? this.unreadCount,
        totalUnreadCount: totalUnreadCount ?? this.totalUnreadCount,
        unreadChannels: unreadChannels ?? this.unreadChannels,
        language: language ?? this.language,
        image: image ?? this.image,
        imageUrl: imageUrl ?? this.imageUrl,
        userName: userName ?? this.userName,
        name: name ?? this.name,
      );

  factory Me.fromRawJson(String str) => Me.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Me.fromJson(Map<String, dynamic> json) => Me(
        id: json["id"],
        role: json["role"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        lastActive: json["last_active"] == null
            ? null
            : DateTime.parse(json["last_active"]),
        banned: json["banned"],
        online: json["online"],
        invisible: json["invisible"],
        devices: json["devices"] == null
            ? []
            : List<dynamic>.from(json["devices"]!.map((x) => x)),
        mutes: json["mutes"] == null
            ? []
            : List<dynamic>.from(json["mutes"]!.map((x) => x)),
        channelMutes: json["channel_mutes"] == null
            ? []
            : List<dynamic>.from(json["channel_mutes"]!.map((x) => x)),
        unreadCount: json["unread_count"],
        totalUnreadCount: json["total_unread_count"],
        unreadChannels: json["unread_channels"],
        language: json["language"],
        image: json["image"],
        imageUrl: json["imageURL"],
        userName: json["userName"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "last_active": lastActive?.toIso8601String(),
        "banned": banned,
        "online": online,
        "invisible": invisible,
        "devices":
            devices == null ? [] : List<dynamic>.from(devices!.map((x) => x)),
        "mutes": mutes == null ? [] : List<dynamic>.from(mutes!.map((x) => x)),
        "channel_mutes": channelMutes == null
            ? []
            : List<dynamic>.from(channelMutes!.map((x) => x)),
        "unread_count": unreadCount,
        "total_unread_count": totalUnreadCount,
        "unread_channels": unreadChannels,
        "language": language,
        "image": image,
        "imageURL": imageUrl,
        "userName": userName,
        "name": name,
      };
}

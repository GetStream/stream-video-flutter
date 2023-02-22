// To parse this JSON data, do
//
//     final callCreatedEventDto = callCreatedEventDtoFromJson(jsonString);

import 'dart:convert';

import 'event_dto.dart';

class CallCreatedEventDto extends EventDto {
  CallCreatedEventDto({
    this.type,
    this.createdAt,
    this.call,
    this.members,
    this.ringing,
  });

  final String? type;
  final DateTime? createdAt;
  final Call? call;
  final List<dynamic>? members;
  final bool? ringing;

  CallCreatedEventDto copyWith({
    String? type,
    DateTime? createdAt,
    Call? call,
    List<dynamic>? members,
    bool? ringing,
  }) =>
      CallCreatedEventDto(
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        call: call ?? this.call,
        members: members ?? this.members,
        ringing: ringing ?? this.ringing,
      );

  factory CallCreatedEventDto.fromRawJson(String str) => CallCreatedEventDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CallCreatedEventDto.fromJson(Map<String, dynamic> json) => CallCreatedEventDto(
    type: json["type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    call: json["call"] == null ? null : Call.fromJson(json["call"]),
    members: json["members"] == null ? [] : List<dynamic>.from(json["members"]!.map((x) => x)),
    ringing: json["ringing"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "created_at": createdAt?.toIso8601String(),
    "call": call?.toJson(),
    "members": members == null ? [] : List<dynamic>.from(members!.map((x) => x)),
    "ringing": ringing,
  };
}

class Call {
  Call({
    this.type,
    this.id,
    this.cid,
    this.team,
    this.createdBy,
    this.custom,
    this.createdAt,
    this.updatedAt,
    this.broadcastEgress,
    this.recordEgress,
    this.endedAt,
    this.settings,
    this.ownCapabilities,
  });

  final String? type;
  final String? id;
  final String? cid;
  final String? team;
  final CreatedBy? createdBy;
  final dynamic custom;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? broadcastEgress;
  final String? recordEgress;
  final dynamic endedAt;
  final Settings? settings;
  final List<String>? ownCapabilities;

  Call copyWith({
    String? type,
    String? id,
    String? cid,
    String? team,
    CreatedBy? createdBy,
    dynamic custom,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? broadcastEgress,
    String? recordEgress,
    dynamic endedAt,
    Settings? settings,
    List<String>? ownCapabilities,
  }) =>
      Call(
        type: type ?? this.type,
        id: id ?? this.id,
        cid: cid ?? this.cid,
        team: team ?? this.team,
        createdBy: createdBy ?? this.createdBy,
        custom: custom ?? this.custom,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        broadcastEgress: broadcastEgress ?? this.broadcastEgress,
        recordEgress: recordEgress ?? this.recordEgress,
        endedAt: endedAt ?? this.endedAt,
        settings: settings ?? this.settings,
        ownCapabilities: ownCapabilities ?? this.ownCapabilities,
      );

  factory Call.fromRawJson(String str) => Call.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Call.fromJson(Map<String, dynamic> json) => Call(
    type: json["type"],
    id: json["id"],
    cid: json["cid"],
    team: json["team"],
    createdBy: json["created_by"] == null ? null : CreatedBy.fromJson(json["created_by"]),
    custom: json["custom"] == null ? null : json["custom"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    broadcastEgress: json["broadcast_egress"],
    recordEgress: json["record_egress"],
    endedAt: json["ended_at"],
    settings: json["settings"] == null ? null : Settings.fromJson(json["settings"]),
    ownCapabilities: json["own_capabilities"] == null ? [] : List<String>.from(json["own_capabilities"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "id": id,
    "cid": cid,
    "team": team,
    "created_by": createdBy?.toJson(),
    "custom": custom?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "broadcast_egress": broadcastEgress,
    "record_egress": recordEgress,
    "ended_at": endedAt,
    "settings": settings?.toJson(),
    "own_capabilities": ownCapabilities == null ? [] : List<dynamic>.from(ownCapabilities!.map((x) => x)),
  };
}

class CreatedBy {
  CreatedBy({
    this.id,
    this.name,
    this.role,
    this.image,
    this.custom,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? name;
  final String? role;
  final String? image;
  final CreatedByCustom? custom;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CreatedBy copyWith({
    String? id,
    String? name,
    String? role,
    String? image,
    CreatedByCustom? custom,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      CreatedBy(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role ?? this.role,
        image: image ?? this.image,
        custom: custom ?? this.custom,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory CreatedBy.fromRawJson(String str) => CreatedBy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
    id: json["id"],
    name: json["name"],
    role: json["role"],
    image: json["image"],
    custom: json["custom"] == null ? null : CreatedByCustom.fromJson(json["custom"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "role": role,
    "image": image,
    "custom": custom?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class CreatedByCustom {
  CreatedByCustom({
    this.imageUrl,
    this.userName,
  });

  final String? imageUrl;
  final String? userName;

  CreatedByCustom copyWith({
    String? imageUrl,
    String? userName,
  }) =>
      CreatedByCustom(
        imageUrl: imageUrl ?? this.imageUrl,
        userName: userName ?? this.userName,
      );

  factory CreatedByCustom.fromRawJson(String str) => CreatedByCustom.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreatedByCustom.fromJson(Map<String, dynamic> json) => CreatedByCustom(
    imageUrl: json["imageURL"],
    userName: json["userName"],
  );

  Map<String, dynamic> toJson() => {
    "imageURL": imageUrl,
    "userName": userName,
  };
}

class Settings {
  Settings({
    this.audio,
    this.video,
    this.screensharing,
    this.recording,
    this.broadcasting,
    this.geofencing,
  });

  final Audio? audio;
  final Screensharing? video;
  final Screensharing? screensharing;
  final Recording? recording;
  final Broadcasting? broadcasting;
  final Geofencing? geofencing;

  Settings copyWith({
    Audio? audio,
    Screensharing? video,
    Screensharing? screensharing,
    Recording? recording,
    Broadcasting? broadcasting,
    Geofencing? geofencing,
  }) =>
      Settings(
        audio: audio ?? this.audio,
        video: video ?? this.video,
        screensharing: screensharing ?? this.screensharing,
        recording: recording ?? this.recording,
        broadcasting: broadcasting ?? this.broadcasting,
        geofencing: geofencing ?? this.geofencing,
      );

  factory Settings.fromRawJson(String str) => Settings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    audio: json["audio"] == null ? null : Audio.fromJson(json["audio"]),
    video: json["video"] == null ? null : Screensharing.fromJson(json["video"]),
    screensharing: json["screensharing"] == null ? null : Screensharing.fromJson(json["screensharing"]),
    recording: json["recording"] == null ? null : Recording.fromJson(json["recording"]),
    broadcasting: json["broadcasting"] == null ? null : Broadcasting.fromJson(json["broadcasting"]),
    geofencing: json["geofencing"] == null ? null : Geofencing.fromJson(json["geofencing"]),
  );

  Map<String, dynamic> toJson() => {
    "audio": audio?.toJson(),
    "video": video?.toJson(),
    "screensharing": screensharing?.toJson(),
    "recording": recording?.toJson(),
    "broadcasting": broadcasting?.toJson(),
    "geofencing": geofencing?.toJson(),
  };
}

class Audio {
  Audio({
    this.accessRequestEnabled,
  });

  final bool? accessRequestEnabled;

  Audio copyWith({
    bool? accessRequestEnabled,
  }) =>
      Audio(
        accessRequestEnabled: accessRequestEnabled ?? this.accessRequestEnabled,
      );

  factory Audio.fromRawJson(String str) => Audio.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
    accessRequestEnabled: json["access_request_enabled"],
  );

  Map<String, dynamic> toJson() => {
    "access_request_enabled": accessRequestEnabled,
  };
}

class Broadcasting {
  Broadcasting({
    this.enabled,
    this.hls,
  });

  final bool? enabled;
  final Hls? hls;

  Broadcasting copyWith({
    bool? enabled,
    Hls? hls,
  }) =>
      Broadcasting(
        enabled: enabled ?? this.enabled,
        hls: hls ?? this.hls,
      );

  factory Broadcasting.fromRawJson(String str) => Broadcasting.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Broadcasting.fromJson(Map<String, dynamic> json) => Broadcasting(
    enabled: json["enabled"],
    hls: json["hls"] == null ? null : Hls.fromJson(json["hls"]),
  );

  Map<String, dynamic> toJson() => {
    "enabled": enabled,
    "hls": hls?.toJson(),
  };
}

class Hls {
  Hls({
    this.autoOn,
    this.enabled,
    this.qualityTracks,
  });

  final bool? autoOn;
  final bool? enabled;
  final List<String>? qualityTracks;

  Hls copyWith({
    bool? autoOn,
    bool? enabled,
    List<String>? qualityTracks,
  }) =>
      Hls(
        autoOn: autoOn ?? this.autoOn,
        enabled: enabled ?? this.enabled,
        qualityTracks: qualityTracks ?? this.qualityTracks,
      );

  factory Hls.fromRawJson(String str) => Hls.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Hls.fromJson(Map<String, dynamic> json) => Hls(
    autoOn: json["auto_on"],
    enabled: json["enabled"],
    qualityTracks: json["quality_tracks"] == null ? [] : List<String>.from(json["quality_tracks"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "auto_on": autoOn,
    "enabled": enabled,
    "quality_tracks": qualityTracks == null ? [] : List<dynamic>.from(qualityTracks!.map((x) => x)),
  };
}

class Geofencing {
  Geofencing({
    this.names,
  });

  final List<dynamic>? names;

  Geofencing copyWith({
    List<dynamic>? names,
  }) =>
      Geofencing(
        names: names ?? this.names,
      );

  factory Geofencing.fromRawJson(String str) => Geofencing.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Geofencing.fromJson(Map<String, dynamic> json) => Geofencing(
    names: json["names"] == null ? [] : List<dynamic>.from(json["names"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "names": names == null ? [] : List<dynamic>.from(names!.map((x) => x)),
  };
}

class Recording {
  Recording({
    this.audioOnly,
    this.mode,
    this.quality,
  });

  final bool? audioOnly;
  final String? mode;
  final String? quality;

  Recording copyWith({
    bool? audioOnly,
    String? mode,
    String? quality,
  }) =>
      Recording(
        audioOnly: audioOnly ?? this.audioOnly,
        mode: mode ?? this.mode,
        quality: quality ?? this.quality,
      );

  factory Recording.fromRawJson(String str) => Recording.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Recording.fromJson(Map<String, dynamic> json) => Recording(
    audioOnly: json["audio_only"],
    mode: json["mode"],
    quality: json["quality"],
  );

  Map<String, dynamic> toJson() => {
    "audio_only": audioOnly,
    "mode": mode,
    "quality": quality,
  };
}

class Screensharing {
  Screensharing({
    this.enabled,
    this.accessRequestEnabled,
  });

  final bool? enabled;
  final bool? accessRequestEnabled;

  Screensharing copyWith({
    bool? enabled,
    bool? accessRequestEnabled,
  }) =>
      Screensharing(
        enabled: enabled ?? this.enabled,
        accessRequestEnabled: accessRequestEnabled ?? this.accessRequestEnabled,
      );

  factory Screensharing.fromRawJson(String str) => Screensharing.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Screensharing.fromJson(Map<String, dynamic> json) => Screensharing(
    enabled: json["enabled"],
    accessRequestEnabled: json["access_request_enabled"],
  );

  Map<String, dynamic> toJson() => {
    "enabled": enabled,
    "access_request_enabled": accessRequestEnabled,
  };
}

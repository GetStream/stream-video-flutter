import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class HealthCheckEvent extends Equatable {
  /// Returns a new [HealthCheckEvent] instance.
  HealthCheckEvent({
    this.cid,
    required this.connectionId,
    required this.createdAt,
    this.receivedAt,
    this.type = 'health.check',
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? cid;

  String connectionId;

  DateTime createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? receivedAt;

  String type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthCheckEvent &&
          other.cid == cid &&
          other.connectionId == connectionId &&
          other.createdAt == createdAt &&
          other.receivedAt == receivedAt &&
          other.type == type;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (cid == null ? 0 : cid!.hashCode) +
      (connectionId.hashCode) +
      (createdAt.hashCode) +
      (receivedAt == null ? 0 : receivedAt!.hashCode) +
      (type.hashCode);

  @override
  String toString() =>
      'HealthCheckEvent[cid=$cid, connectionId=$connectionId, createdAt=$createdAt, receivedAt=$receivedAt, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (cid != null) {
      json['cid'] = cid;
    } else {
      json['cid'] = null;
    }
    json['connection_id'] = connectionId;
    json['created_at'] = createdAt.toUtc().toIso8601String();
    if (receivedAt != null) {
      json['received_at'] = receivedAt!.toUtc().toIso8601String();
    } else {
      json['received_at'] = null;
    }
    json['type'] = type;
    return json;
  }

  /// Returns a new [HealthCheckEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static HealthCheckEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(
          json.containsKey('connection_id'),
          'Required key "HealthCheckEvent[connection_id]" is missing from JSON.',
        );
        assert(
          json['connection_id'] != null,
          'Required key "HealthCheckEvent[connection_id]" has a null value in JSON.',
        );
        assert(
          json.containsKey('created_at'),
          'Required key "HealthCheckEvent[created_at]" is missing from JSON.',
        );
        assert(
          json['created_at'] != null,
          'Required key "HealthCheckEvent[created_at]" has a null value in JSON.',
        );
        assert(
          json.containsKey('type'),
          'Required key "HealthCheckEvent[type]" is missing from JSON.',
        );
        assert(
          json['type'] != null,
          'Required key "HealthCheckEvent[type]" has a null value in JSON.',
        );
        return true;
      }());

      return HealthCheckEvent(
        cid: mapValueOfType<String>(json, 'cid'),
        connectionId: mapValueOfType<String>(json, 'connection_id')!,
        createdAt: mapDateTime(json, 'created_at', '')!,
        receivedAt: mapDateTime(json, 'received_at', ''),
        type: mapValueOfType<String>(json, 'type')!,
      );
    }
    return null;
  }

  static List<HealthCheckEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <HealthCheckEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = HealthCheckEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, HealthCheckEvent> mapFromJson(dynamic json) {
    final map = <String, HealthCheckEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = HealthCheckEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of HealthCheckEvent-objects as value to a dart map
  static Map<String, List<HealthCheckEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<HealthCheckEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = HealthCheckEvent.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'connection_id',
    'created_at',
    'type',
  };

  @override
  // TODO: implement props
  List<Object?> get props => [cid, connectionId, createdAt, receivedAt, type];
}

/// Returns a valid [T] value found at the specified Map [key], null otherwise.
T? mapValueOfType<T>(dynamic map, String key) {
  final dynamic value = map is Map ? map[key] : null;
  if (T == double && value is int) {
    return value.toDouble() as T;
  }
  return value is T ? value : null;
}

/// Returns a valid Map<K, V> found at the specified Map [key], null otherwise.
Map<K, V>? mapCastOfType<K, V>(dynamic map, String key) {
  final dynamic value = map is Map ? map[key] : null;
  return value is Map ? value.cast<K, V>() : null;
}

/// Returns a valid [DateTime] found at the specified Map [key], null otherwise.
DateTime? mapDateTime(dynamic map, String key, [String? pattern]) {
  final dynamic value = map is Map ? map[key] : null;
  if (value != null) {
    int? millis;
    if (value is int) {
      millis = value;
    } else if (value is String) {
      if (_isEpochMarker(pattern)) {
        millis = int.tryParse(value);
      } else {
        return DateTime.tryParse(value);
      }
    }
    if (millis != null) {
      return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
    }
  }
  return null;
}

const _dateEpochMarker = 'epoch';
bool _isEpochMarker(String? pattern) =>
    pattern == _dateEpochMarker || pattern == '/$_dateEpochMarker/';

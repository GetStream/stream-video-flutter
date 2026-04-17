//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WSAuthMessage {
  /// Returns a new [WSAuthMessage] instance.
  WSAuthMessage({
    this.products = const [],
    required this.token,
    required this.userDetails,
  });

  /// List of products to subscribe to. One of: chat, video, feeds
  List<WSAuthMessageProductsEnum> products;

  /// JWT token for authentication
  String token;

  ConnectUserDetailsRequest userDetails;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WSAuthMessage &&
          _deepEquality.equals(other.products, products) &&
          other.token == token &&
          other.userDetails == userDetails;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (products.hashCode) + (token.hashCode) + (userDetails.hashCode);

  @override
  String toString() =>
      'WSAuthMessage[products=$products, token=$token, userDetails=$userDetails]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'products'] = this.products;
    json[r'token'] = this.token;
    json[r'user_details'] = this.userDetails;
    return json;
  }

  /// Returns a new [WSAuthMessage] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WSAuthMessage? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'token'),
            'Required key "WSAuthMessage[token]" is missing from JSON.');
        assert(json[r'token'] != null,
            'Required key "WSAuthMessage[token]" has a null value in JSON.');
        assert(json.containsKey(r'user_details'),
            'Required key "WSAuthMessage[user_details]" is missing from JSON.');
        assert(json[r'user_details'] != null,
            'Required key "WSAuthMessage[user_details]" has a null value in JSON.');
        return true;
      }());

      return WSAuthMessage(
        products: WSAuthMessageProductsEnum.listFromJson(json[r'products']),
        token: mapValueOfType<String>(json, r'token')!,
        userDetails: ConnectUserDetailsRequest.fromJson(json[r'user_details'])!,
      );
    }
    return null;
  }

  static List<WSAuthMessage> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <WSAuthMessage>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WSAuthMessage.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WSAuthMessage> mapFromJson(dynamic json) {
    final map = <String, WSAuthMessage>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WSAuthMessage.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WSAuthMessage-objects as value to a dart map
  static Map<String, List<WSAuthMessage>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<WSAuthMessage>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WSAuthMessage.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'token',
    'user_details',
  };
}

class WSAuthMessageProductsEnum {
  /// Instantiate a new enum with the provided [value].
  const WSAuthMessageProductsEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const chat = WSAuthMessageProductsEnum._(r'chat');
  static const video = WSAuthMessageProductsEnum._(r'video');
  static const feeds = WSAuthMessageProductsEnum._(r'feeds');

  /// List of all possible values in this [enum][WSAuthMessageProductsEnum].
  static const values = <WSAuthMessageProductsEnum>[
    chat,
    video,
    feeds,
  ];

  static WSAuthMessageProductsEnum? fromJson(dynamic value) =>
      WSAuthMessageProductsEnumTypeTransformer().decode(value);

  static List<WSAuthMessageProductsEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <WSAuthMessageProductsEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WSAuthMessageProductsEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [WSAuthMessageProductsEnum] to String,
/// and [decode] dynamic data back to [WSAuthMessageProductsEnum].
class WSAuthMessageProductsEnumTypeTransformer {
  factory WSAuthMessageProductsEnumTypeTransformer() =>
      _instance ??= const WSAuthMessageProductsEnumTypeTransformer._();

  const WSAuthMessageProductsEnumTypeTransformer._();

  String encode(WSAuthMessageProductsEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a WSAuthMessageProductsEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  WSAuthMessageProductsEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'chat':
          return WSAuthMessageProductsEnum.chat;
        case r'video':
          return WSAuthMessageProductsEnum.video;
        case r'feeds':
          return WSAuthMessageProductsEnum.feeds;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [WSAuthMessageProductsEnumTypeTransformer] instance.
  static WSAuthMessageProductsEnumTypeTransformer? _instance;
}

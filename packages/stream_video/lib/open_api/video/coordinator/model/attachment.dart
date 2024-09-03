//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Attachment {
  /// Returns a new [Attachment] instance.
  Attachment({
    this.actions = const [],
    this.assetUrl,
    this.authorIcon,
    this.authorLink,
    this.authorName,
    this.color,
    this.custom = const {},
    this.fallback,
    this.fields = const [],
    this.footer,
    this.footerIcon,
    this.giphy,
    this.imageUrl,
    this.ogScrapeUrl,
    this.originalHeight,
    this.originalWidth,
    this.pretext,
    this.text,
    this.thumbUrl,
    this.title,
    this.titleLink,
    this.type,
  });

  List<Action> actions;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? assetUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? authorIcon;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? authorLink;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? authorName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? color;

  Map<String, Object> custom;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? fallback;

  List<Field> fields;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? footer;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? footerIcon;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Images? giphy;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? imageUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? ogScrapeUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? originalHeight;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? originalWidth;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? pretext;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? text;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? thumbUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? title;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? titleLink;

  /// Attachment type (e.g. image, video, url)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Attachment &&
    _deepEquality.equals(other.actions, actions) &&
    other.assetUrl == assetUrl &&
    other.authorIcon == authorIcon &&
    other.authorLink == authorLink &&
    other.authorName == authorName &&
    other.color == color &&
    _deepEquality.equals(other.custom, custom) &&
    other.fallback == fallback &&
    _deepEquality.equals(other.fields, fields) &&
    other.footer == footer &&
    other.footerIcon == footerIcon &&
    other.giphy == giphy &&
    other.imageUrl == imageUrl &&
    other.ogScrapeUrl == ogScrapeUrl &&
    other.originalHeight == originalHeight &&
    other.originalWidth == originalWidth &&
    other.pretext == pretext &&
    other.text == text &&
    other.thumbUrl == thumbUrl &&
    other.title == title &&
    other.titleLink == titleLink &&
    other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (actions.hashCode) +
    (assetUrl == null ? 0 : assetUrl!.hashCode) +
    (authorIcon == null ? 0 : authorIcon!.hashCode) +
    (authorLink == null ? 0 : authorLink!.hashCode) +
    (authorName == null ? 0 : authorName!.hashCode) +
    (color == null ? 0 : color!.hashCode) +
    (custom.hashCode) +
    (fallback == null ? 0 : fallback!.hashCode) +
    (fields.hashCode) +
    (footer == null ? 0 : footer!.hashCode) +
    (footerIcon == null ? 0 : footerIcon!.hashCode) +
    (giphy == null ? 0 : giphy!.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (ogScrapeUrl == null ? 0 : ogScrapeUrl!.hashCode) +
    (originalHeight == null ? 0 : originalHeight!.hashCode) +
    (originalWidth == null ? 0 : originalWidth!.hashCode) +
    (pretext == null ? 0 : pretext!.hashCode) +
    (text == null ? 0 : text!.hashCode) +
    (thumbUrl == null ? 0 : thumbUrl!.hashCode) +
    (title == null ? 0 : title!.hashCode) +
    (titleLink == null ? 0 : titleLink!.hashCode) +
    (type == null ? 0 : type!.hashCode);

  @override
  String toString() => 'Attachment[actions=$actions, assetUrl=$assetUrl, authorIcon=$authorIcon, authorLink=$authorLink, authorName=$authorName, color=$color, custom=$custom, fallback=$fallback, fields=$fields, footer=$footer, footerIcon=$footerIcon, giphy=$giphy, imageUrl=$imageUrl, ogScrapeUrl=$ogScrapeUrl, originalHeight=$originalHeight, originalWidth=$originalWidth, pretext=$pretext, text=$text, thumbUrl=$thumbUrl, title=$title, titleLink=$titleLink, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'actions'] = this.actions;
    if (this.assetUrl != null) {
      json[r'asset_url'] = this.assetUrl;
    } else {
      json[r'asset_url'] = null;
    }
    if (this.authorIcon != null) {
      json[r'author_icon'] = this.authorIcon;
    } else {
      json[r'author_icon'] = null;
    }
    if (this.authorLink != null) {
      json[r'author_link'] = this.authorLink;
    } else {
      json[r'author_link'] = null;
    }
    if (this.authorName != null) {
      json[r'author_name'] = this.authorName;
    } else {
      json[r'author_name'] = null;
    }
    if (this.color != null) {
      json[r'color'] = this.color;
    } else {
      json[r'color'] = null;
    }
      json[r'custom'] = this.custom;
    if (this.fallback != null) {
      json[r'fallback'] = this.fallback;
    } else {
      json[r'fallback'] = null;
    }
      json[r'fields'] = this.fields;
    if (this.footer != null) {
      json[r'footer'] = this.footer;
    } else {
      json[r'footer'] = null;
    }
    if (this.footerIcon != null) {
      json[r'footer_icon'] = this.footerIcon;
    } else {
      json[r'footer_icon'] = null;
    }
    if (this.giphy != null) {
      json[r'giphy'] = this.giphy;
    } else {
      json[r'giphy'] = null;
    }
    if (this.imageUrl != null) {
      json[r'image_url'] = this.imageUrl;
    } else {
      json[r'image_url'] = null;
    }
    if (this.ogScrapeUrl != null) {
      json[r'og_scrape_url'] = this.ogScrapeUrl;
    } else {
      json[r'og_scrape_url'] = null;
    }
    if (this.originalHeight != null) {
      json[r'original_height'] = this.originalHeight;
    } else {
      json[r'original_height'] = null;
    }
    if (this.originalWidth != null) {
      json[r'original_width'] = this.originalWidth;
    } else {
      json[r'original_width'] = null;
    }
    if (this.pretext != null) {
      json[r'pretext'] = this.pretext;
    } else {
      json[r'pretext'] = null;
    }
    if (this.text != null) {
      json[r'text'] = this.text;
    } else {
      json[r'text'] = null;
    }
    if (this.thumbUrl != null) {
      json[r'thumb_url'] = this.thumbUrl;
    } else {
      json[r'thumb_url'] = null;
    }
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
    if (this.titleLink != null) {
      json[r'title_link'] = this.titleLink;
    } else {
      json[r'title_link'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
    return json;
  }

  /// Returns a new [Attachment] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Attachment? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Attachment[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Attachment[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Attachment(
        actions: Action.listFromJson(json[r'actions']),
        assetUrl: mapValueOfType<String>(json, r'asset_url'),
        authorIcon: mapValueOfType<String>(json, r'author_icon'),
        authorLink: mapValueOfType<String>(json, r'author_link'),
        authorName: mapValueOfType<String>(json, r'author_name'),
        color: mapValueOfType<String>(json, r'color'),
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        fallback: mapValueOfType<String>(json, r'fallback'),
        fields: Field.listFromJson(json[r'fields']),
        footer: mapValueOfType<String>(json, r'footer'),
        footerIcon: mapValueOfType<String>(json, r'footer_icon'),
        giphy: Images.fromJson(json[r'giphy']),
        imageUrl: mapValueOfType<String>(json, r'image_url'),
        ogScrapeUrl: mapValueOfType<String>(json, r'og_scrape_url'),
        originalHeight: mapValueOfType<int>(json, r'original_height'),
        originalWidth: mapValueOfType<int>(json, r'original_width'),
        pretext: mapValueOfType<String>(json, r'pretext'),
        text: mapValueOfType<String>(json, r'text'),
        thumbUrl: mapValueOfType<String>(json, r'thumb_url'),
        title: mapValueOfType<String>(json, r'title'),
        titleLink: mapValueOfType<String>(json, r'title_link'),
        type: mapValueOfType<String>(json, r'type'),
      );
    }
    return null;
  }

  static List<Attachment> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Attachment>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Attachment.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Attachment> mapFromJson(dynamic json) {
    final map = <String, Attachment>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Attachment.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Attachment-objects as value to a dart map
  static Map<String, List<Attachment>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Attachment>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Attachment.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'custom',
  };
}


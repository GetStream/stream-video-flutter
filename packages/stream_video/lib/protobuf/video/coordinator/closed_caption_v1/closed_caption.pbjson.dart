///
//  Generated code. Do not modify.
//  source: video/coordinator/closed_caption_v1/closed_caption.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use termsDescriptor instead')
const Terms$json = const {
  '1': 'Terms',
  '2': const [
    const {'1': 'start', '3': 1, '4': 1, '5': 1, '10': 'start'},
    const {'1': 'end', '3': 2, '4': 1, '5': 1, '10': 'end'},
    const {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    const {'1': 'type', '3': 4, '4': 1, '5': 9, '10': 'type'},
    const {'1': 'conf', '3': 5, '4': 1, '5': 1, '10': 'conf'},
  ],
};

/// Descriptor for `Terms`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List termsDescriptor = $convert.base64Decode('CgVUZXJtcxIUCgVzdGFydBgBIAEoAVIFc3RhcnQSEAoDZW5kGAIgASgBUgNlbmQSEgoEdGV4dBgDIAEoCVIEdGV4dBISCgR0eXBlGAQgASgJUgR0eXBlEhIKBGNvbmYYBSABKAFSBGNvbmY=');
@$core.Deprecated('Use monologuewordsDescriptor instead')
const Monologuewords$json = const {
  '1': 'Monologuewords',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'terms', '3': 2, '4': 3, '5': 11, '6': '.stream.video.coordinator.closed_caption_v1.Terms', '10': 'terms'},
  ],
};

/// Descriptor for `Monologuewords`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List monologuewordsDescriptor = $convert.base64Decode('Cg5Nb25vbG9ndWV3b3JkcxIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSRwoFdGVybXMYAiADKAsyMS5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xvc2VkX2NhcHRpb25fdjEuVGVybXNSBXRlcm1z');
@$core.Deprecated('Use closedCaptionDescriptor instead')
const ClosedCaption$json = const {
  '1': 'ClosedCaption',
  '2': const [
    const {'1': 'timestamp', '3': 1, '4': 1, '5': 1, '10': 'timestamp'},
    const {'1': 'speaker_name', '3': 2, '4': 1, '5': 9, '10': 'speakerName'},
    const {'1': 'speaker_id', '3': 3, '4': 1, '5': 9, '10': 'speakerId'},
    const {'1': 'text', '3': 4, '4': 1, '5': 9, '10': 'text'},
    const {'1': 'monologue_words', '3': 5, '4': 1, '5': 11, '6': '.stream.video.coordinator.closed_caption_v1.Monologuewords', '10': 'monologueWords'},
  ],
};

/// Descriptor for `ClosedCaption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closedCaptionDescriptor = $convert.base64Decode('Cg1DbG9zZWRDYXB0aW9uEhwKCXRpbWVzdGFtcBgBIAEoAVIJdGltZXN0YW1wEiEKDHNwZWFrZXJfbmFtZRgCIAEoCVILc3BlYWtlck5hbWUSHQoKc3BlYWtlcl9pZBgDIAEoCVIJc3BlYWtlcklkEhIKBHRleHQYBCABKAlSBHRleHQSYwoPbW9ub2xvZ3VlX3dvcmRzGAUgASgLMjouc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsb3NlZF9jYXB0aW9uX3YxLk1vbm9sb2d1ZXdvcmRzUg5tb25vbG9ndWVXb3Jkcw==');
@$core.Deprecated('Use closedCaptionSettingsDescriptor instead')
const ClosedCaptionSettings$json = const {
  '1': 'ClosedCaptionSettings',
  '2': const [
    const {'1': 'available_languages', '3': 1, '4': 1, '5': 11, '6': '.stream.video.coordinator.closed_caption_v1.AvailableLanguages', '10': 'availableLanguages'},
    const {'1': 'preferred', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.closed_caption_v1.Language', '10': 'preferred'},
    const {'1': 'enabled', '3': 3, '4': 1, '5': 8, '9': 0, '10': 'enabled', '17': true},
  ],
  '8': const [
    const {'1': '_enabled'},
  ],
};

/// Descriptor for `ClosedCaptionSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closedCaptionSettingsDescriptor = $convert.base64Decode('ChVDbG9zZWRDYXB0aW9uU2V0dGluZ3MSbwoTYXZhaWxhYmxlX2xhbmd1YWdlcxgBIAEoCzI+LnN0cmVhbS52aWRlby5jb29yZGluYXRvci5jbG9zZWRfY2FwdGlvbl92MS5BdmFpbGFibGVMYW5ndWFnZXNSEmF2YWlsYWJsZUxhbmd1YWdlcxJSCglwcmVmZXJyZWQYAiABKAsyNC5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IuY2xvc2VkX2NhcHRpb25fdjEuTGFuZ3VhZ2VSCXByZWZlcnJlZBIdCgdlbmFibGVkGAMgASgISABSB2VuYWJsZWSIAQFCCgoIX2VuYWJsZWQ=');
@$core.Deprecated('Use languageDescriptor instead')
const Language$json = const {
  '1': 'Language',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `Language`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List languageDescriptor = $convert.base64Decode('CghMYW5ndWFnZRISCgRjb2RlGAEgASgJUgRjb2Rl');
@$core.Deprecated('Use availableLanguagesDescriptor instead')
const AvailableLanguages$json = const {
  '1': 'AvailableLanguages',
  '2': const [
    const {'1': 'languages', '3': 1, '4': 3, '5': 11, '6': '.stream.video.coordinator.closed_caption_v1.Language', '10': 'languages'},
  ],
};

/// Descriptor for `AvailableLanguages`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List availableLanguagesDescriptor = $convert.base64Decode('ChJBdmFpbGFibGVMYW5ndWFnZXMSUgoJbGFuZ3VhZ2VzGAEgAygLMjQuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLmNsb3NlZF9jYXB0aW9uX3YxLkxhbmd1YWdlUglsYW5ndWFnZXM=');

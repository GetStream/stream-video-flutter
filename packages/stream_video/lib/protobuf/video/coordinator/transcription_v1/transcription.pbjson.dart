///
//  Generated code. Do not modify.
//  source: video/coordinator/transcription_v1/transcription.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use transcriptionStorageDescriptor instead')
const TranscriptionStorage$json = const {
  '1': 'TranscriptionStorage',
  '2': const [
    const {'1': 'TRANSCRIPTION_STORAGE_S3_UNSPECIFIED', '2': 0},
  ],
};

/// Descriptor for `TranscriptionStorage`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List transcriptionStorageDescriptor = $convert.base64Decode('ChRUcmFuc2NyaXB0aW9uU3RvcmFnZRIoCiRUUkFOU0NSSVBUSU9OX1NUT1JBR0VfUzNfVU5TUEVDSUZJRUQQAA==');
@$core.Deprecated('Use transcriptionDescriptor instead')
const Transcription$json = const {
  '1': 'Transcription',
  '2': const [
    const {'1': 'call_type', '3': 1, '4': 1, '5': 9, '10': 'callType'},
    const {'1': 'call_id', '3': 2, '4': 1, '5': 9, '10': 'callId'},
    const {'1': 's3_file_url', '3': 3, '4': 1, '5': 9, '10': 's3FileUrl'},
    const {'1': 'start_time', '3': 4, '4': 1, '5': 9, '10': 'startTime'},
    const {'1': 'stop_time', '3': 5, '4': 1, '5': 9, '10': 'stopTime'},
  ],
};

/// Descriptor for `Transcription`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transcriptionDescriptor = $convert.base64Decode('Cg1UcmFuc2NyaXB0aW9uEhsKCWNhbGxfdHlwZRgBIAEoCVIIY2FsbFR5cGUSFwoHY2FsbF9pZBgCIAEoCVIGY2FsbElkEh4KC3MzX2ZpbGVfdXJsGAMgASgJUglzM0ZpbGVVcmwSHQoKc3RhcnRfdGltZRgEIAEoCVIJc3RhcnRUaW1lEhsKCXN0b3BfdGltZRgFIAEoCVIIc3RvcFRpbWU=');
@$core.Deprecated('Use transcriptionStorageOptionsDescriptor instead')
const TranscriptionStorageOptions$json = const {
  '1': 'TranscriptionStorageOptions',
  '2': const [
    const {'1': 'storage', '3': 1, '4': 1, '5': 14, '6': '.stream.video.coordinator.transcription_v1.TranscriptionStorage', '10': 'storage'},
    const {'1': 'access_key', '3': 2, '4': 1, '5': 9, '10': 'accessKey'},
    const {'1': 'secret_key', '3': 3, '4': 1, '5': 9, '10': 'secretKey'},
    const {'1': 'bucket_name', '3': 4, '4': 1, '5': 9, '10': 'bucketName'},
    const {'1': 'region', '3': 5, '4': 1, '5': 9, '10': 'region'},
    const {'1': 'path', '3': 6, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `TranscriptionStorageOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transcriptionStorageOptionsDescriptor = $convert.base64Decode('ChtUcmFuc2NyaXB0aW9uU3RvcmFnZU9wdGlvbnMSWQoHc3RvcmFnZRgBIAEoDjI/LnN0cmVhbS52aWRlby5jb29yZGluYXRvci50cmFuc2NyaXB0aW9uX3YxLlRyYW5zY3JpcHRpb25TdG9yYWdlUgdzdG9yYWdlEh0KCmFjY2Vzc19rZXkYAiABKAlSCWFjY2Vzc0tleRIdCgpzZWNyZXRfa2V5GAMgASgJUglzZWNyZXRLZXkSHwoLYnVja2V0X25hbWUYBCABKAlSCmJ1Y2tldE5hbWUSFgoGcmVnaW9uGAUgASgJUgZyZWdpb24SEgoEcGF0aBgGIAEoCVIEcGF0aA==');
@$core.Deprecated('Use transcriptionSettingsDescriptor instead')
const TranscriptionSettings$json = const {
  '1': 'TranscriptionSettings',
  '2': const [
    const {'1': 'enabled', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'enabled', '17': true},
    const {'1': 'storage', '3': 2, '4': 1, '5': 11, '6': '.stream.video.coordinator.transcription_v1.TranscriptionStorageOptions', '10': 'storage'},
    const {'1': 'available_languages', '3': 3, '4': 1, '5': 11, '6': '.stream.video.coordinator.transcription_v1.AvailableLanguages', '10': 'availableLanguages'},
    const {'1': 'preferred', '3': 4, '4': 1, '5': 11, '6': '.stream.video.coordinator.transcription_v1.Language', '10': 'preferred'},
  ],
  '8': const [
    const {'1': '_enabled'},
  ],
};

/// Descriptor for `TranscriptionSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transcriptionSettingsDescriptor = $convert.base64Decode('ChVUcmFuc2NyaXB0aW9uU2V0dGluZ3MSHQoHZW5hYmxlZBgBIAEoCEgAUgdlbmFibGVkiAEBEmAKB3N0b3JhZ2UYAiABKAsyRi5zdHJlYW0udmlkZW8uY29vcmRpbmF0b3IudHJhbnNjcmlwdGlvbl92MS5UcmFuc2NyaXB0aW9uU3RvcmFnZU9wdGlvbnNSB3N0b3JhZ2USbgoTYXZhaWxhYmxlX2xhbmd1YWdlcxgDIAEoCzI9LnN0cmVhbS52aWRlby5jb29yZGluYXRvci50cmFuc2NyaXB0aW9uX3YxLkF2YWlsYWJsZUxhbmd1YWdlc1ISYXZhaWxhYmxlTGFuZ3VhZ2VzElEKCXByZWZlcnJlZBgEIAEoCzIzLnN0cmVhbS52aWRlby5jb29yZGluYXRvci50cmFuc2NyaXB0aW9uX3YxLkxhbmd1YWdlUglwcmVmZXJyZWRCCgoIX2VuYWJsZWQ=');
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
    const {'1': 'languages', '3': 1, '4': 3, '5': 11, '6': '.stream.video.coordinator.transcription_v1.Language', '10': 'languages'},
  ],
};

/// Descriptor for `AvailableLanguages`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List availableLanguagesDescriptor = $convert.base64Decode('ChJBdmFpbGFibGVMYW5ndWFnZXMSUQoJbGFuZ3VhZ2VzGAEgAygLMjMuc3RyZWFtLnZpZGVvLmNvb3JkaW5hdG9yLnRyYW5zY3JpcHRpb25fdjEuTGFuZ3VhZ2VSCWxhbmd1YWdlcw==');

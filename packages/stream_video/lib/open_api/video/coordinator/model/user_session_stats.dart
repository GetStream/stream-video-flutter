//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserSessionStats {
  /// Returns a new [UserSessionStats] instance.
  UserSessionStats({
    this.browser,
    this.browserVersion,
    this.currentIp,
    this.currentSfu,
    this.deviceModel,
    this.deviceVersion,
    this.distanceToSfuKilometers,
    required this.freezeDurationSeconds,
    this.geolocation,
    this.jitter,
    this.latency,
    this.maxFirPerSecond,
    required this.maxFreezeFraction,
    required this.maxFreezesDurationSeconds,
    this.maxFreezesPerSecond,
    this.maxNackPerSecond,
    this.maxPliPerSecond,
    this.maxPublishingVideoQuality,
    this.maxReceivingVideoQuality,
    required this.minEventTs,
    this.os,
    this.osVersion,
    required this.packetLossFraction,
    this.pubSubHints,
    this.publishedTracks = const [],
    this.publisherAudioMos,
    this.publisherJitter,
    this.publisherLatency,
    this.publisherNoiseCancellationSeconds,
    required this.publisherPacketLossFraction,
    this.publisherQualityLimitationFraction,
    this.publisherVideoQualityLimitationDurationSeconds = const {},
    this.publishingAudioCodec,
    required this.publishingDurationSeconds,
    this.publishingVideoCodec,
    required this.qualityScore,
    this.receivingAudioCodec,
    required this.receivingDurationSeconds,
    this.receivingVideoCodec,
    this.sdk,
    this.sdkVersion,
    required this.sessionId,
    this.subscriberAudioMos,
    this.subscriberJitter,
    this.subscriberLatency,
    this.subscriberVideoQualityThrottledDurationSeconds,
    this.subsessions = const [],
    this.timeline,
    required this.totalPixelsIn,
    required this.totalPixelsOut,
    this.truncated,
    this.webrtcVersion,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? browser;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? browserVersion;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? currentIp;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? currentSfu;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? deviceModel;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? deviceVersion;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? distanceToSfuKilometers;

  int freezeDurationSeconds;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  GeolocationResult? geolocation;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TimeStats? jitter;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TimeStats? latency;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? maxFirPerSecond;

  double maxFreezeFraction;

  int maxFreezesDurationSeconds;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? maxFreezesPerSecond;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? maxNackPerSecond;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? maxPliPerSecond;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  VideoQuality? maxPublishingVideoQuality;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  VideoQuality? maxReceivingVideoQuality;

  int minEventTs;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? os;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? osVersion;

  double packetLossFraction;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MediaPubSubHint? pubSubHints;

  List<PublishedTrackInfo> publishedTracks;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MOSStats? publisherAudioMos;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TimeStats? publisherJitter;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TimeStats? publisherLatency;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? publisherNoiseCancellationSeconds;

  double publisherPacketLossFraction;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? publisherQualityLimitationFraction;

  Map<String, double> publisherVideoQualityLimitationDurationSeconds;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? publishingAudioCodec;

  int publishingDurationSeconds;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? publishingVideoCodec;

  double qualityScore;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? receivingAudioCodec;

  int receivingDurationSeconds;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? receivingVideoCodec;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? sdk;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? sdkVersion;

  String sessionId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MOSStats? subscriberAudioMos;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TimeStats? subscriberJitter;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TimeStats? subscriberLatency;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? subscriberVideoQualityThrottledDurationSeconds;

  List<Subsession> subsessions;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallTimeline? timeline;

  int totalPixelsIn;

  int totalPixelsOut;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? truncated;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? webrtcVersion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserSessionStats &&
    other.browser == browser &&
    other.browserVersion == browserVersion &&
    other.currentIp == currentIp &&
    other.currentSfu == currentSfu &&
    other.deviceModel == deviceModel &&
    other.deviceVersion == deviceVersion &&
    other.distanceToSfuKilometers == distanceToSfuKilometers &&
    other.freezeDurationSeconds == freezeDurationSeconds &&
    other.geolocation == geolocation &&
    other.jitter == jitter &&
    other.latency == latency &&
    other.maxFirPerSecond == maxFirPerSecond &&
    other.maxFreezeFraction == maxFreezeFraction &&
    other.maxFreezesDurationSeconds == maxFreezesDurationSeconds &&
    other.maxFreezesPerSecond == maxFreezesPerSecond &&
    other.maxNackPerSecond == maxNackPerSecond &&
    other.maxPliPerSecond == maxPliPerSecond &&
    other.maxPublishingVideoQuality == maxPublishingVideoQuality &&
    other.maxReceivingVideoQuality == maxReceivingVideoQuality &&
    other.minEventTs == minEventTs &&
    other.os == os &&
    other.osVersion == osVersion &&
    other.packetLossFraction == packetLossFraction &&
    other.pubSubHints == pubSubHints &&
    _deepEquality.equals(other.publishedTracks, publishedTracks) &&
    other.publisherAudioMos == publisherAudioMos &&
    other.publisherJitter == publisherJitter &&
    other.publisherLatency == publisherLatency &&
    other.publisherNoiseCancellationSeconds == publisherNoiseCancellationSeconds &&
    other.publisherPacketLossFraction == publisherPacketLossFraction &&
    other.publisherQualityLimitationFraction == publisherQualityLimitationFraction &&
    _deepEquality.equals(other.publisherVideoQualityLimitationDurationSeconds, publisherVideoQualityLimitationDurationSeconds) &&
    other.publishingAudioCodec == publishingAudioCodec &&
    other.publishingDurationSeconds == publishingDurationSeconds &&
    other.publishingVideoCodec == publishingVideoCodec &&
    other.qualityScore == qualityScore &&
    other.receivingAudioCodec == receivingAudioCodec &&
    other.receivingDurationSeconds == receivingDurationSeconds &&
    other.receivingVideoCodec == receivingVideoCodec &&
    other.sdk == sdk &&
    other.sdkVersion == sdkVersion &&
    other.sessionId == sessionId &&
    other.subscriberAudioMos == subscriberAudioMos &&
    other.subscriberJitter == subscriberJitter &&
    other.subscriberLatency == subscriberLatency &&
    other.subscriberVideoQualityThrottledDurationSeconds == subscriberVideoQualityThrottledDurationSeconds &&
    _deepEquality.equals(other.subsessions, subsessions) &&
    other.timeline == timeline &&
    other.totalPixelsIn == totalPixelsIn &&
    other.totalPixelsOut == totalPixelsOut &&
    other.truncated == truncated &&
    other.webrtcVersion == webrtcVersion;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (browser == null ? 0 : browser!.hashCode) +
    (browserVersion == null ? 0 : browserVersion!.hashCode) +
    (currentIp == null ? 0 : currentIp!.hashCode) +
    (currentSfu == null ? 0 : currentSfu!.hashCode) +
    (deviceModel == null ? 0 : deviceModel!.hashCode) +
    (deviceVersion == null ? 0 : deviceVersion!.hashCode) +
    (distanceToSfuKilometers == null ? 0 : distanceToSfuKilometers!.hashCode) +
    (freezeDurationSeconds.hashCode) +
    (geolocation == null ? 0 : geolocation!.hashCode) +
    (jitter == null ? 0 : jitter!.hashCode) +
    (latency == null ? 0 : latency!.hashCode) +
    (maxFirPerSecond == null ? 0 : maxFirPerSecond!.hashCode) +
    (maxFreezeFraction.hashCode) +
    (maxFreezesDurationSeconds.hashCode) +
    (maxFreezesPerSecond == null ? 0 : maxFreezesPerSecond!.hashCode) +
    (maxNackPerSecond == null ? 0 : maxNackPerSecond!.hashCode) +
    (maxPliPerSecond == null ? 0 : maxPliPerSecond!.hashCode) +
    (maxPublishingVideoQuality == null ? 0 : maxPublishingVideoQuality!.hashCode) +
    (maxReceivingVideoQuality == null ? 0 : maxReceivingVideoQuality!.hashCode) +
    (minEventTs.hashCode) +
    (os == null ? 0 : os!.hashCode) +
    (osVersion == null ? 0 : osVersion!.hashCode) +
    (packetLossFraction.hashCode) +
    (pubSubHints == null ? 0 : pubSubHints!.hashCode) +
    (publishedTracks.hashCode) +
    (publisherAudioMos == null ? 0 : publisherAudioMos!.hashCode) +
    (publisherJitter == null ? 0 : publisherJitter!.hashCode) +
    (publisherLatency == null ? 0 : publisherLatency!.hashCode) +
    (publisherNoiseCancellationSeconds == null ? 0 : publisherNoiseCancellationSeconds!.hashCode) +
    (publisherPacketLossFraction.hashCode) +
    (publisherQualityLimitationFraction == null ? 0 : publisherQualityLimitationFraction!.hashCode) +
    (publisherVideoQualityLimitationDurationSeconds.hashCode) +
    (publishingAudioCodec == null ? 0 : publishingAudioCodec!.hashCode) +
    (publishingDurationSeconds.hashCode) +
    (publishingVideoCodec == null ? 0 : publishingVideoCodec!.hashCode) +
    (qualityScore.hashCode) +
    (receivingAudioCodec == null ? 0 : receivingAudioCodec!.hashCode) +
    (receivingDurationSeconds.hashCode) +
    (receivingVideoCodec == null ? 0 : receivingVideoCodec!.hashCode) +
    (sdk == null ? 0 : sdk!.hashCode) +
    (sdkVersion == null ? 0 : sdkVersion!.hashCode) +
    (sessionId.hashCode) +
    (subscriberAudioMos == null ? 0 : subscriberAudioMos!.hashCode) +
    (subscriberJitter == null ? 0 : subscriberJitter!.hashCode) +
    (subscriberLatency == null ? 0 : subscriberLatency!.hashCode) +
    (subscriberVideoQualityThrottledDurationSeconds == null ? 0 : subscriberVideoQualityThrottledDurationSeconds!.hashCode) +
    (subsessions.hashCode) +
    (timeline == null ? 0 : timeline!.hashCode) +
    (totalPixelsIn.hashCode) +
    (totalPixelsOut.hashCode) +
    (truncated == null ? 0 : truncated!.hashCode) +
    (webrtcVersion == null ? 0 : webrtcVersion!.hashCode);

  @override
  String toString() => 'UserSessionStats[browser=$browser, browserVersion=$browserVersion, currentIp=$currentIp, currentSfu=$currentSfu, deviceModel=$deviceModel, deviceVersion=$deviceVersion, distanceToSfuKilometers=$distanceToSfuKilometers, freezeDurationSeconds=$freezeDurationSeconds, geolocation=$geolocation, jitter=$jitter, latency=$latency, maxFirPerSecond=$maxFirPerSecond, maxFreezeFraction=$maxFreezeFraction, maxFreezesDurationSeconds=$maxFreezesDurationSeconds, maxFreezesPerSecond=$maxFreezesPerSecond, maxNackPerSecond=$maxNackPerSecond, maxPliPerSecond=$maxPliPerSecond, maxPublishingVideoQuality=$maxPublishingVideoQuality, maxReceivingVideoQuality=$maxReceivingVideoQuality, minEventTs=$minEventTs, os=$os, osVersion=$osVersion, packetLossFraction=$packetLossFraction, pubSubHints=$pubSubHints, publishedTracks=$publishedTracks, publisherAudioMos=$publisherAudioMos, publisherJitter=$publisherJitter, publisherLatency=$publisherLatency, publisherNoiseCancellationSeconds=$publisherNoiseCancellationSeconds, publisherPacketLossFraction=$publisherPacketLossFraction, publisherQualityLimitationFraction=$publisherQualityLimitationFraction, publisherVideoQualityLimitationDurationSeconds=$publisherVideoQualityLimitationDurationSeconds, publishingAudioCodec=$publishingAudioCodec, publishingDurationSeconds=$publishingDurationSeconds, publishingVideoCodec=$publishingVideoCodec, qualityScore=$qualityScore, receivingAudioCodec=$receivingAudioCodec, receivingDurationSeconds=$receivingDurationSeconds, receivingVideoCodec=$receivingVideoCodec, sdk=$sdk, sdkVersion=$sdkVersion, sessionId=$sessionId, subscriberAudioMos=$subscriberAudioMos, subscriberJitter=$subscriberJitter, subscriberLatency=$subscriberLatency, subscriberVideoQualityThrottledDurationSeconds=$subscriberVideoQualityThrottledDurationSeconds, subsessions=$subsessions, timeline=$timeline, totalPixelsIn=$totalPixelsIn, totalPixelsOut=$totalPixelsOut, truncated=$truncated, webrtcVersion=$webrtcVersion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.browser != null) {
      json[r'browser'] = this.browser;
    } else {
      json[r'browser'] = null;
    }
    if (this.browserVersion != null) {
      json[r'browser_version'] = this.browserVersion;
    } else {
      json[r'browser_version'] = null;
    }
    if (this.currentIp != null) {
      json[r'current_ip'] = this.currentIp;
    } else {
      json[r'current_ip'] = null;
    }
    if (this.currentSfu != null) {
      json[r'current_sfu'] = this.currentSfu;
    } else {
      json[r'current_sfu'] = null;
    }
    if (this.deviceModel != null) {
      json[r'device_model'] = this.deviceModel;
    } else {
      json[r'device_model'] = null;
    }
    if (this.deviceVersion != null) {
      json[r'device_version'] = this.deviceVersion;
    } else {
      json[r'device_version'] = null;
    }
    if (this.distanceToSfuKilometers != null) {
      json[r'distance_to_sfu_kilometers'] = this.distanceToSfuKilometers;
    } else {
      json[r'distance_to_sfu_kilometers'] = null;
    }
      json[r'freeze_duration_seconds'] = this.freezeDurationSeconds;
    if (this.geolocation != null) {
      json[r'geolocation'] = this.geolocation;
    } else {
      json[r'geolocation'] = null;
    }
    if (this.jitter != null) {
      json[r'jitter'] = this.jitter;
    } else {
      json[r'jitter'] = null;
    }
    if (this.latency != null) {
      json[r'latency'] = this.latency;
    } else {
      json[r'latency'] = null;
    }
    if (this.maxFirPerSecond != null) {
      json[r'max_fir_per_second'] = this.maxFirPerSecond;
    } else {
      json[r'max_fir_per_second'] = null;
    }
      json[r'max_freeze_fraction'] = this.maxFreezeFraction;
      json[r'max_freezes_duration_seconds'] = this.maxFreezesDurationSeconds;
    if (this.maxFreezesPerSecond != null) {
      json[r'max_freezes_per_second'] = this.maxFreezesPerSecond;
    } else {
      json[r'max_freezes_per_second'] = null;
    }
    if (this.maxNackPerSecond != null) {
      json[r'max_nack_per_second'] = this.maxNackPerSecond;
    } else {
      json[r'max_nack_per_second'] = null;
    }
    if (this.maxPliPerSecond != null) {
      json[r'max_pli_per_second'] = this.maxPliPerSecond;
    } else {
      json[r'max_pli_per_second'] = null;
    }
    if (this.maxPublishingVideoQuality != null) {
      json[r'max_publishing_video_quality'] = this.maxPublishingVideoQuality;
    } else {
      json[r'max_publishing_video_quality'] = null;
    }
    if (this.maxReceivingVideoQuality != null) {
      json[r'max_receiving_video_quality'] = this.maxReceivingVideoQuality;
    } else {
      json[r'max_receiving_video_quality'] = null;
    }
      json[r'min_event_ts'] = this.minEventTs;
    if (this.os != null) {
      json[r'os'] = this.os;
    } else {
      json[r'os'] = null;
    }
    if (this.osVersion != null) {
      json[r'os_version'] = this.osVersion;
    } else {
      json[r'os_version'] = null;
    }
      json[r'packet_loss_fraction'] = this.packetLossFraction;
    if (this.pubSubHints != null) {
      json[r'pub_sub_hints'] = this.pubSubHints;
    } else {
      json[r'pub_sub_hints'] = null;
    }
      json[r'published_tracks'] = this.publishedTracks;
    if (this.publisherAudioMos != null) {
      json[r'publisher_audio_mos'] = this.publisherAudioMos;
    } else {
      json[r'publisher_audio_mos'] = null;
    }
    if (this.publisherJitter != null) {
      json[r'publisher_jitter'] = this.publisherJitter;
    } else {
      json[r'publisher_jitter'] = null;
    }
    if (this.publisherLatency != null) {
      json[r'publisher_latency'] = this.publisherLatency;
    } else {
      json[r'publisher_latency'] = null;
    }
    if (this.publisherNoiseCancellationSeconds != null) {
      json[r'publisher_noise_cancellation_seconds'] = this.publisherNoiseCancellationSeconds;
    } else {
      json[r'publisher_noise_cancellation_seconds'] = null;
    }
      json[r'publisher_packet_loss_fraction'] = this.publisherPacketLossFraction;
    if (this.publisherQualityLimitationFraction != null) {
      json[r'publisher_quality_limitation_fraction'] = this.publisherQualityLimitationFraction;
    } else {
      json[r'publisher_quality_limitation_fraction'] = null;
    }
      json[r'publisher_video_quality_limitation_duration_seconds'] = this.publisherVideoQualityLimitationDurationSeconds;
    if (this.publishingAudioCodec != null) {
      json[r'publishing_audio_codec'] = this.publishingAudioCodec;
    } else {
      json[r'publishing_audio_codec'] = null;
    }
      json[r'publishing_duration_seconds'] = this.publishingDurationSeconds;
    if (this.publishingVideoCodec != null) {
      json[r'publishing_video_codec'] = this.publishingVideoCodec;
    } else {
      json[r'publishing_video_codec'] = null;
    }
      json[r'quality_score'] = this.qualityScore;
    if (this.receivingAudioCodec != null) {
      json[r'receiving_audio_codec'] = this.receivingAudioCodec;
    } else {
      json[r'receiving_audio_codec'] = null;
    }
      json[r'receiving_duration_seconds'] = this.receivingDurationSeconds;
    if (this.receivingVideoCodec != null) {
      json[r'receiving_video_codec'] = this.receivingVideoCodec;
    } else {
      json[r'receiving_video_codec'] = null;
    }
    if (this.sdk != null) {
      json[r'sdk'] = this.sdk;
    } else {
      json[r'sdk'] = null;
    }
    if (this.sdkVersion != null) {
      json[r'sdk_version'] = this.sdkVersion;
    } else {
      json[r'sdk_version'] = null;
    }
      json[r'session_id'] = this.sessionId;
    if (this.subscriberAudioMos != null) {
      json[r'subscriber_audio_mos'] = this.subscriberAudioMos;
    } else {
      json[r'subscriber_audio_mos'] = null;
    }
    if (this.subscriberJitter != null) {
      json[r'subscriber_jitter'] = this.subscriberJitter;
    } else {
      json[r'subscriber_jitter'] = null;
    }
    if (this.subscriberLatency != null) {
      json[r'subscriber_latency'] = this.subscriberLatency;
    } else {
      json[r'subscriber_latency'] = null;
    }
    if (this.subscriberVideoQualityThrottledDurationSeconds != null) {
      json[r'subscriber_video_quality_throttled_duration_seconds'] = this.subscriberVideoQualityThrottledDurationSeconds;
    } else {
      json[r'subscriber_video_quality_throttled_duration_seconds'] = null;
    }
      json[r'subsessions'] = this.subsessions;
    if (this.timeline != null) {
      json[r'timeline'] = this.timeline;
    } else {
      json[r'timeline'] = null;
    }
      json[r'total_pixels_in'] = this.totalPixelsIn;
      json[r'total_pixels_out'] = this.totalPixelsOut;
    if (this.truncated != null) {
      json[r'truncated'] = this.truncated;
    } else {
      json[r'truncated'] = null;
    }
    if (this.webrtcVersion != null) {
      json[r'webrtc_version'] = this.webrtcVersion;
    } else {
      json[r'webrtc_version'] = null;
    }
    return json;
  }

  /// Returns a new [UserSessionStats] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserSessionStats? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserSessionStats[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserSessionStats[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserSessionStats(
        browser: mapValueOfType<String>(json, r'browser'),
        browserVersion: mapValueOfType<String>(json, r'browser_version'),
        currentIp: mapValueOfType<String>(json, r'current_ip'),
        currentSfu: mapValueOfType<String>(json, r'current_sfu'),
        deviceModel: mapValueOfType<String>(json, r'device_model'),
        deviceVersion: mapValueOfType<String>(json, r'device_version'),
        distanceToSfuKilometers: mapValueOfType<double>(json, r'distance_to_sfu_kilometers'),
        freezeDurationSeconds: mapValueOfType<int>(json, r'freeze_duration_seconds')!,
        geolocation: GeolocationResult.fromJson(json[r'geolocation']),
        jitter: TimeStats.fromJson(json[r'jitter']),
        latency: TimeStats.fromJson(json[r'latency']),
        maxFirPerSecond: mapValueOfType<double>(json, r'max_fir_per_second'),
        maxFreezeFraction: mapValueOfType<double>(json, r'max_freeze_fraction')!,
        maxFreezesDurationSeconds: mapValueOfType<int>(json, r'max_freezes_duration_seconds')!,
        maxFreezesPerSecond: mapValueOfType<double>(json, r'max_freezes_per_second'),
        maxNackPerSecond: mapValueOfType<double>(json, r'max_nack_per_second'),
        maxPliPerSecond: mapValueOfType<double>(json, r'max_pli_per_second'),
        maxPublishingVideoQuality: VideoQuality.fromJson(json[r'max_publishing_video_quality']),
        maxReceivingVideoQuality: VideoQuality.fromJson(json[r'max_receiving_video_quality']),
        minEventTs: mapValueOfType<int>(json, r'min_event_ts')!,
        os: mapValueOfType<String>(json, r'os'),
        osVersion: mapValueOfType<String>(json, r'os_version'),
        packetLossFraction: mapValueOfType<double>(json, r'packet_loss_fraction')!,
        pubSubHints: MediaPubSubHint.fromJson(json[r'pub_sub_hints']),
        publishedTracks: PublishedTrackInfo.listFromJson(json[r'published_tracks']),
        publisherAudioMos: MOSStats.fromJson(json[r'publisher_audio_mos']),
        publisherJitter: TimeStats.fromJson(json[r'publisher_jitter']),
        publisherLatency: TimeStats.fromJson(json[r'publisher_latency']),
        publisherNoiseCancellationSeconds: mapValueOfType<double>(json, r'publisher_noise_cancellation_seconds'),
        publisherPacketLossFraction: mapValueOfType<double>(json, r'publisher_packet_loss_fraction')!,
        publisherQualityLimitationFraction: mapValueOfType<double>(json, r'publisher_quality_limitation_fraction'),
        publisherVideoQualityLimitationDurationSeconds: mapCastOfType<String, double>(json, r'publisher_video_quality_limitation_duration_seconds') ?? const {},
        publishingAudioCodec: mapValueOfType<String>(json, r'publishing_audio_codec'),
        publishingDurationSeconds: mapValueOfType<int>(json, r'publishing_duration_seconds')!,
        publishingVideoCodec: mapValueOfType<String>(json, r'publishing_video_codec'),
        qualityScore: mapValueOfType<double>(json, r'quality_score')!,
        receivingAudioCodec: mapValueOfType<String>(json, r'receiving_audio_codec'),
        receivingDurationSeconds: mapValueOfType<int>(json, r'receiving_duration_seconds')!,
        receivingVideoCodec: mapValueOfType<String>(json, r'receiving_video_codec'),
        sdk: mapValueOfType<String>(json, r'sdk'),
        sdkVersion: mapValueOfType<String>(json, r'sdk_version'),
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        subscriberAudioMos: MOSStats.fromJson(json[r'subscriber_audio_mos']),
        subscriberJitter: TimeStats.fromJson(json[r'subscriber_jitter']),
        subscriberLatency: TimeStats.fromJson(json[r'subscriber_latency']),
        subscriberVideoQualityThrottledDurationSeconds: mapValueOfType<double>(json, r'subscriber_video_quality_throttled_duration_seconds'),
        subsessions: Subsession.listFromJson(json[r'subsessions']),
        timeline: CallTimeline.fromJson(json[r'timeline']),
        totalPixelsIn: mapValueOfType<int>(json, r'total_pixels_in')!,
        totalPixelsOut: mapValueOfType<int>(json, r'total_pixels_out')!,
        truncated: mapValueOfType<bool>(json, r'truncated'),
        webrtcVersion: mapValueOfType<String>(json, r'webrtc_version'),
      );
    }
    return null;
  }

  static List<UserSessionStats> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserSessionStats>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserSessionStats.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserSessionStats> mapFromJson(dynamic json) {
    final map = <String, UserSessionStats>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserSessionStats.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserSessionStats-objects as value to a dart map
  static Map<String, List<UserSessionStats>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserSessionStats>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserSessionStats.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'freeze_duration_seconds',
    'max_freeze_fraction',
    'max_freezes_duration_seconds',
    'min_event_ts',
    'packet_loss_fraction',
    'publisher_packet_loss_fraction',
    'publishing_duration_seconds',
    'quality_score',
    'receiving_duration_seconds',
    'session_id',
    'total_pixels_in',
    'total_pixels_out',
  };
}


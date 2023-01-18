import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

import 'sfu/data/models/sfu_connection_quality.dart';
import 'sfu/data/models/sfu_track_type.dart';

@immutable
class CallParticipantState {
  factory CallParticipantState({
    required String userId,
    required String role,
    required String name,
    String? profileImageURL,
    required String sessionId,
    required String trackIdPrefix,
    List<SfuTrackType> publishedTrackTypes = const [],
    bool isLocal = false,
    SfuConnectionQuality connectionQuality = SfuConnectionQuality.unspecified,
    bool isOnline = false,
    double audioLevel = 0,
    bool isSpeaking = false,
  }) {
    return CallParticipantState._(
      userId: userId,
      role: role,
      name: name,
      profileImageURL: profileImageURL,
      sessionId: sessionId,
      trackIdPrefix: trackIdPrefix,
      publishedTrackTypes: List.unmodifiable(publishedTrackTypes),
      isLocal: isLocal,
      connectionQuality: connectionQuality,
      isOnline: isOnline,
      audioLevel: audioLevel,
      isSpeaking: isSpeaking,
    );
  }

  /// TODO: Documentation
  const CallParticipantState._({
    required this.userId,
    required this.role,
    required this.name,
    this.profileImageURL,
    required this.sessionId,
    required this.trackIdPrefix,
    required this.publishedTrackTypes,
    this.isLocal = false,
    this.connectionQuality = SfuConnectionQuality.unspecified,
    this.isOnline = false,
    this.audioLevel = 0,
    this.isSpeaking = false,
  });

  final String userId;
  final String role;
  final String name;
  final String? profileImageURL;
  final String sessionId;
  final String trackIdPrefix;
  final List<SfuTrackType> publishedTrackTypes;
  final bool isLocal;
  final SfuConnectionQuality connectionQuality;
  final bool isOnline;
  final double audioLevel;
  final bool isSpeaking;

  /// Returns a copy of this [CallParticipantState] with the given fields
  /// replaced with the new values.
  CallParticipantState copyWith({
    String? userId,
    String? role,
    String? name,
    String? profileImageURL,
    String? sessionId,
    String? trackIdPrefix,
    List<SfuTrackType>? publishedTrackTypes,
    bool? isLocal,
    SfuConnectionQuality? connectionQuality,
    bool? isOnline,
    double? audioLevel,
    bool? isSpeaking,
  }) {
    return CallParticipantState(
      userId: userId ?? this.userId,
      role: role ?? this.role,
      name: name ?? this.name,
      profileImageURL: profileImageURL ?? this.profileImageURL,
      sessionId: sessionId ?? this.sessionId,
      trackIdPrefix: trackIdPrefix ?? this.trackIdPrefix,
      publishedTrackTypes: publishedTrackTypes ?? this.publishedTrackTypes,
      isLocal: isLocal ?? this.isLocal,
      connectionQuality: connectionQuality ?? this.connectionQuality,
      isOnline: isOnline ?? this.isOnline,
      audioLevel: audioLevel ?? this.audioLevel,
      isSpeaking: isSpeaking ?? this.isSpeaking,
    );
  }

  @override
  String toString() {
    return 'CallParticipantState{userId: $userId, role: $role, name: $name, '
        'profileImageURL: $profileImageURL, sessionId: $sessionId, '
        'trackIdPrefix: $trackIdPrefix, '
        'publishedTrackTypes: $publishedTrackTypes, '
        'isLocal: $isLocal, '
        'connectionQuality: $connectionQuality, isOnline: $isOnline, '
        'audioLevel: $audioLevel, isSpeaking: $isSpeaking}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallParticipantState &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          role == other.role &&
          name == other.name &&
          profileImageURL == other.profileImageURL &&
          sessionId == other.sessionId &&
          trackIdPrefix == other.trackIdPrefix &&
          publishedTrackTypes == other.publishedTrackTypes &&
          isLocal == other.isLocal &&
          connectionQuality == other.connectionQuality &&
          isOnline == other.isOnline &&
          audioLevel == other.audioLevel &&
          isSpeaking == other.isSpeaking;

  @override
  int get hashCode =>
      userId.hashCode ^
      role.hashCode ^
      name.hashCode ^
      profileImageURL.hashCode ^
      sessionId.hashCode ^
      trackIdPrefix.hashCode ^
      publishedTrackTypes.hashCode ^
      isLocal.hashCode ^
      connectionQuality.hashCode ^
      isOnline.hashCode ^
      audioLevel.hashCode ^
      isSpeaking.hashCode;
}

int startTime = 0;

void main() {
  startTime = DateTime.now().millisecondsSinceEpoch;
  final events = PublishSubject<int>();
  Stream<int>.periodic(const Duration(milliseconds: 100), (count) => 7 - count)
      .take(7)
      //.map((value) => 'event$value')
      .listen(events.add);

  events.listen((value) async {
    final delay = 50 * value;
    final event = 'event$value';
    log('${DateTime.now()} [onEvent] event: $event, delay: $delay');
    final result = await doSomeJob(event, delay);
    log('[onEvent] <<< result: $result');
  });
}

void log(String msg) {
  final elapsed = DateTime.now().millisecondsSinceEpoch - startTime;
  print('$elapsed - $msg');
}

Future<String> doSomeJob(String event, int delay) async {
  log('[doSomeJob1] event: $event');
  final result = await Future.delayed(
    Duration(milliseconds: delay),
    () => event,
  );
  //log('[doSomeJob1] finished($event)');
  return result;
}

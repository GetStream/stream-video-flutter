import 'dart:convert';

/// Represents a trace record for WebRTC events and operations.
/// Each record contains:
/// - tag: The name of the event (e.g. createOffer, setRemoteDescription)
/// - id: Peer Connection identifier (e.g. Publisher 1, Subscriber 2), null for non-PC events
/// - data: Associated data with the event
/// - timestamp: When the event occurred
class TraceRecord {
  const TraceRecord({
    this.id,
    required this.tag,
    required this.data,
    required this.timestamp,
  });

  factory TraceRecord.peerConnectionEvent({
    required String tag,
    required String id,
    required dynamic data,
  }) {
    return TraceRecord(
      tag: tag,
      id: id,
      data: data,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  final String tag;
  final String? id;
  final dynamic data;
  final int timestamp;

  /// Converts the trace record to a list format
  List<dynamic> toList() {
    return [tag, id, data, timestamp];
  }

  TraceRecord copyWith({
    String? tag,
    String? id,
    dynamic data,
    int? timestamp,
  }) {
    return TraceRecord(
      tag: tag ?? this.tag,
      id: id ?? this.id,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'TraceRecord(tag: $tag, id: $id, data: $data, timestamp: $timestamp)';
  }
}

extension TraceRecordListExtension on List<TraceRecord> {
  /// Converts a list of trace records to JSON string
  String toJsonString() {
    return json.encode(toJsonPayload());
  }

  /// The records as plain, isolate-sendable lists.
  ///
  /// Separated from [toJsonString] so the encode itself can be handed to
  /// another isolate — see `encodeStatsJson`.
  List<List<dynamic>> toJsonPayload() {
    return map((r) => r.toList()).toList();
  }
}

import 'trace_record.dart';

/// Represents a slice of trace records with the ability to rollback.
class TraceSlice {
  const TraceSlice({
    required this.snapshot,
    required this.rollback,
  });

  final List<TraceRecord> snapshot;
  final void Function() rollback;
}

class Tracer {
  Tracer(this.id);

  final String? id;
  List<TraceRecord> _buffer = [];
  bool _enabled = true;

  void setEnabled(bool enabled) {
    if (_enabled == enabled) return;
    _enabled = enabled;
    _buffer = [];
  }

  void trace(String tag, dynamic data) {
    if (!_enabled) return;

    _buffer.add(
      TraceRecord(
        tag: tag,
        id: id,
        data: data,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  TraceSlice take() {
    final snapshot = List<TraceRecord>.from(_buffer);
    _buffer = [];

    return TraceSlice(
      snapshot: snapshot,
      rollback: () {
        _buffer.insertAll(0, snapshot);
      },
    );
  }

  void dispose() {
    _buffer = [];
  }
}

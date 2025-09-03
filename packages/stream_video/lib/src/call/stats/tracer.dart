import 'dart:async';

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

  void traceMultiple(List<TraceRecord> entries) {
    if (!_enabled) return;
    _buffer.addAll(entries);
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

class TracerZone {
  TracerZone._();

  /// Runs [body] inside a Zone that carries [Tracer] optional [sequence].
  static Future<T> run<T>(
    Tracer tracer,
    int? sequence,
    Future<T> Function() body,
  ) {
    return runZoned(
      body,
      zoneValues: {#tracer: tracer, #sequence: sequence},
    );
  }

  static (Tracer? tracer, int? sequence) get currentTracer {
    final tracer = Zone.current[#tracer];
    if (tracer is Tracer) return (tracer, Zone.current[#sequence] as int);
    return (null, null);
  }
}

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class CallStateBuilder extends StatefulWidget {
  const CallStateBuilder({
    Key? key,
    required this.call,
    required this.builder,
  }) : super(key: key);
  final Call call;
  final Widget Function(BuildContext context, CallState data) builder;

  @override
  State<CallStateBuilder> createState() => _CallStateBuilderState();
}

class _CallStateBuilderState extends State<CallStateBuilder> {
  @override
  Widget build(BuildContext context) {
    return BetterStreamBuilder<CallState>(
      stream: widget.call.state.valueStream,
      builder: (BuildContext context, CallState state) {
        return widget.builder(context, state);
      },
    );
  }
}

/// A more efficient [StreamBuilder]
/// It requires [initialData] and will rebuild
/// only when the new data is different than the current data
/// The [comparator] is used to check if the new data is different
class BetterStreamBuilder<T extends Object> extends StatefulWidget {
  /// Creates a new BetterStreamBuilder
  const BetterStreamBuilder({
    required this.stream,
    required this.builder,
    this.initialData,
    this.noDataBuilder,
    this.errorBuilder,
    this.comparator,
    super.key,
  });

  /// The stream to listen to
  final Stream<T?>? stream;

  /// The initial data available
  final T? initialData;

  /// Comparator used to check if the new data is different than the last one
  final bool Function(T?, T?)? comparator;

  /// Builder that builds based on the new snapshot
  final Widget Function(BuildContext context, T data) builder;

  /// Builder that builds when the data is null
  final Widget Function(BuildContext context)? noDataBuilder;

  /// Builder used when there is an error
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  @override
  _BetterStreamBuilderState createState() => _BetterStreamBuilderState<T>();
}

class _BetterStreamBuilderState<T extends Object>
    extends State<BetterStreamBuilder<T>> {
  T? _lastEvent;
  StreamSubscription<T?>? _subscription;
  Object? _lastError;

  @override
  Widget build(BuildContext context) {
    final error = _lastError;
    if (error != null) {
      final errorBuilder = widget.errorBuilder;
      if (errorBuilder != null) {
        return errorBuilder(context, error);
      }
    }
    final event = _lastEvent;
    if (event == null) {
      return widget.noDataBuilder?.call(context) ?? const Offstage();
    }
    return widget.builder(context, event);
  }

  @override
  void initState() {
    _lastEvent = widget.initialData;
    _subscription = widget.stream?.listen(
      _onEvent,
      onError: _onError,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BetterStreamBuilder<T> oldWidget) {
    if (oldWidget.stream != widget.stream) {
      _subscription?.cancel();
      _subscription = widget.stream?.listen(
        _onEvent,
        onError: _onError,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _onError(error) {
    if (widget.errorBuilder != null && error != _lastError) {
      _lastError = error;
      if (mounted) {
        // ignore: no-empty-block
        setState(() {});
      }
    }
  }

  void _onEvent(T? event) {
    _lastError = null;
    final isEqual =
        widget.comparator?.call(_lastEvent, event) ?? event == _lastEvent;
    if (!isEqual) {
      _lastEvent = event;
      if (mounted) {
        setState(() {}); // ignore: no-empty-block
      }
    }
  }
}

/// Represents different call content based on the call state.
class StreamBuilder2 extends StatefulWidget {
  /// Creates a new instance of [StreamCallContainer].
  const StreamBuilder2({
    super.key,
    required this.call,
    this.callConnectOptions = const CallConnectOptions(),
    required this.builder,
  });

  final Call call;

  final CallConnectOptions callConnectOptions;
  final Widget Function(BuildContext context, CallState data) builder;

  @override
  State<StreamBuilder2> createState() => StreamBuilder2State();
}

class StreamBuilder2State extends State<StreamBuilder2> {
  final _logger = taggedLogger(tag: 'SV:StreamBuilder2');
  StreamSubscription<CallState>? _callStateSubscription;

  /// Represents a call.
  Call get call => widget.call;

  /// Holds information about the call.
  late CallState _callState;

  @override
  void initState() {
    super.initState();
    _callStateSubscription = call.state.listen(_setState);
    _callState = call.state.value;
    _connect();
  }

  @override
  void dispose() {
    _callStateSubscription?.cancel();
    _callStateSubscription = null;
    super.dispose();
  }

  void _setState(CallState callState) {
    _logger.v(() => '[setState] callState.status: ${callState.status}');
    setState(() {
      _callState = callState;
    });
    if (callState.status.isDisconnected) {
      _leave();
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _callState.status;
    _logger.v(() => '[build] status: $status');
    return widget.builder(context, _callState);
  }

  Future<void> _connect() async {
    if (_callState.status != CallStatus.connected() ||
        _callState.status != CallStatus.connecting()) {
      try {
        _logger.d(() => '[connect] no args');
        call.connectOptions = widget.callConnectOptions;
        final result = await call.connect();
        _logger.v(() => '[connect] completed: $result');
      } catch (e) {
        _logger.v(() => '[connect] failed: $e');
        await _leave();
      }
    }
  }

  Future<void> _leave() async {
    _logger.d(() => '[leave] no args');
    // play tone
    final bool popped;
    if (mounted) {
      popped = await Navigator.maybePop(context);
    } else {
      popped = false;
    }
    _logger.v(() => '[leave] popped: $popped');
  }
}

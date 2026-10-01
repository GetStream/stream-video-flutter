import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

final _logger = taggedLogger(tag: 'SV:PartialCallStateBuilder');

/// Convenience widget to build a part of the call screen based on a partial call state.
///
/// It wraps a [StreamBuilder] and uses the [call] and the [selector] to
/// rebuild the widget when the relevant state changes.
class PartialCallStateBuilder<T> extends StatelessWidget {
  const PartialCallStateBuilder({
    required this.call,
    required this.selector,
    required this.builder,
    super.key,
  });

  final Call call;
  final CallStateSelector<T> selector;
  final Widget Function(BuildContext context, T data) builder;

  @override
  Widget build(BuildContext context) {
    return _PartialCallStateListener<T>(
      call: call,
      selector: selector,
      builder: builder,
    );
  }
}

// Listens to the call's partial state while mounted, and subscribes again when
// [call] or [selector] changes, so every value comes from the current selector.
// A selector that keeps its identity across rebuilds, such as a method
// tear-off, keeps a single subscription. Holds the last selected value.
class _PartialCallStateListener<T> extends StatefulWidget {
  const _PartialCallStateListener({
    required this.call,
    required this.selector,
    required this.builder,
    super.key,
  });

  final Call call;
  final CallStateSelector<T> selector;
  final Widget Function(BuildContext context, T data) builder;

  @override
  State<_PartialCallStateListener<T>> createState() =>
      _PartialCallStateListenerState<T>();
}

class _PartialCallStateListenerState<T>
    extends State<_PartialCallStateListener<T>> {
  StreamSubscription<T>? _subscription;
  late T _data;

  T _select() => widget.selector(widget.call.state.value);

  @override
  void initState() {
    super.initState();
    _data = _select();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant _PartialCallStateListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.call != widget.call ||
        oldWidget.selector != widget.selector) {
      _data = _select();
      _subscribe();
    }
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = widget.call
        .partialState(widget.selector)
        .listen(
          (data) {
            if (!mounted || data == _data) return;
            setState(() => _data = data);
          },
          onError: (Object error) {
            _logger.e(
              () => '[PartialCallStateBuilder] partial state error: $error',
            );
          },
        );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _data);
  }
}

/// Convenience widget to build a part of the call screen from the call's
/// participants.
///
/// Reads [Call.participantsStream], which is rate-limited by participant count,
/// and seeds the first frame from `call.state.value.callParticipants`, since
/// the stream delivers its first value asynchronously.
///
/// Use this wherever the participants themselves get rendered. When only a
/// derived value is needed — a count, whether anyone is speaking — select that
/// through [PartialCallStateBuilder] instead, so the widget doesn't rebuild on
/// participant updates that leave it the same.
class CallParticipantsBuilder extends StatefulWidget {
  const CallParticipantsBuilder({
    required this.call,
    required this.builder,
    super.key,
  });

  final Call call;
  final Widget Function(
    BuildContext context,
    List<CallParticipantState> participants,
  )
  builder;

  @override
  State<CallParticipantsBuilder> createState() =>
      _CallParticipantsBuilderState();
}

class _CallParticipantsBuilderState extends State<CallParticipantsBuilder> {
  // Pins the stream identity across rebuilds, so `StreamBuilder` never tears
  // down its subscription and restarts the throttle window.
  late Stream<List<CallParticipantState>> _participants =
      widget.call.participantsStream;

  @override
  void didUpdateWidget(covariant CallParticipantsBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.call != oldWidget.call) {
      _participants = widget.call.participantsStream;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CallParticipantState>>(
      // `StreamBuilder` carries its snapshot across a stream swap, so without
      // this the previous call's participants render until the new stream
      // emits. A new key rebuilds it against the new `initialData`.
      key: ObjectKey(widget.call),
      stream: _participants,
      initialData: widget.call.state.value.callParticipants,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // `StreamBuilder` builds an error snapshot with no data, so fall back
          // to the current state rather than throwing a null check over the
          // real error — but don't let the error itself go unrecorded.
          _logger.e(
            () =>
                '[CallParticipantsBuilder] participantsStream error: '
                '${snapshot.error}',
          );
        }

        return widget.builder(
          context,
          snapshot.data ?? widget.call.state.value.callParticipants,
        );
      },
    );
  }
}

/// Builder for parts of the call screen that need a regular Widget.
typedef CallWidgetBuilder =
    Widget Function(
      BuildContext context,
      Call call,
    );

/// Builder for parts of the call screen that need a regular Widget.
/// The function also contains a data object that can be used to build the widget.
///
/// To prevent breaking changes we only add properties to the data object, but not to the function itself.
typedef CallWidgetBuilderWithData<T extends CallbackData> =
    Widget Function(
      BuildContext context,
      Call call,
      T data,
    );

/// Builder for parts of the call screen that need a regular Widget and has a prebuild child widget.
typedef CallWidgetChildBuilder =
    Widget Function(
      BuildContext context,
      Call call,
      Widget child,
    );

/// Builder for parts of the call screen that need a PreferredSizeWidget.
/// For example used to create a custom app bar.
typedef CallPreferredSizeWidgetBuilder =
    PreferredSizeWidget? Function(
      BuildContext context,
      Call call,
    );

/// Data that can be used to build a part of the call screen.
///
/// Making the data part of a sealed class makes sure we can easily add more fields later without breaking changes.
sealed class CallbackData {}

/// Data about participants in a call.
/// Used by incoming and outgoing call content.
class ParticipantsData extends CallbackData {
  ParticipantsData({
    required this.participants,
  });

  final List<UserInfo> participants;
}

abstract class PartialStateDeprecationMessage {
  static const callState = '''
It's no longer recommended to provide `callState`.
The widget can listen to more focussed partial state updates itself from the `call` object.
''';
}

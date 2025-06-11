import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

/// Convenience widget to build a part of the call screen based on a partial call state.
///
/// It wraps a [StreamBuilder] and uses the [call] and the [selector] to
/// rebuild the widget when the relevantstate changes.
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
    return StreamBuilder(
      stream: call.partialState(selector),
      initialData: selector(call.state.value),
      builder: (context, snapshot) => builder(context, snapshot.data as T),
    );
  }
}

/// Builder for parts of the call screen that need a regular Widget.
typedef CallWidgetBuilder = Widget Function(
  BuildContext context,
  Call call,
);

/// Builder for parts of the call screen that need a PreferredSizeWidget.
/// For example used to create a custom app bar.
typedef CallPreferredSizeWidgetBuilder = PreferredSizeWidget? Function(
  BuildContext context,
  Call call,
);

import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

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
    return StreamBuilder(
      stream: call.partialState(selector),
      initialData: selector(call.state.value),
      builder: (context, snapshot) => builder(context, snapshot.data as T),
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

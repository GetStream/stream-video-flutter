# Partial State Updates (non-breaking)
Changes made in Version 0.10.0

## Reason for the changes
The state of the `Call` object (`CallState`) contains a lot of different properties that can change all the time. Even though most of these changes are not relevant for your app, by listening to the `call.state` your app will update the widgets all the time. Because of this the `Call` object now contains a `partialState` to only listen to updates when they are relevant for that particular widget.

`StreamCallContainer` and `StreamCallContent` contain callbacks to build your own custom parts that contain the current state, for example like this:

```dart
StreamCallContainer(
  call: call,
  callContentBuilder: (context, call, callState) {
    return CustomCallContent();
  },
);
```

You expect this state to be up to date and because of that the `StreamCallContainer` will always rebuild everything when anything in the state changes. The previous builders have been replaced with new ones that no longer include a state object. When migrating to use these updated builders, you'll need to handle state observation within your own widgets. You can do this more efficiently by using `call.partialState` or the `PartialCallStateBuilder`. When none of the deprecated callbacks are used, the call container will no longer trigger a rebuild on every state change.

```dart
StreamCallContainer(
  call: call,
  callContentWidgetBuilder: (context, call) {
    return CustomCallContent();
  },
);
```

## Deprecations and recommended changes
For most of the changes automatic fixes are available, but not everywhere and not always automatic.

### Changes in `StreamCallContainer` and `StreamCallContent`
In `StreamCallContainer` the IDE should suggest changes to migrate from `incomingCallBuilder`, `outgoingCallBuilder` and `callContentBuilder` to the new `...WidgetBuilder` alternative. However, these changes are not applied automatically with `dart fix --apply` because you have to make changes in the callback itself.

The same is true for `StreamCallContent` and similar widgets like `StreamIncomingCallContent`. Here, it's also important that you no longer provide the deprecated `callState` parameter. If you do, it's assumed to always be up to date and the widget won't listen to the partial state directly. If you won't provide it, the widget will listen to relevant changes only using the partial state. The `callState` object is deprecated and `dart fix --apply` will also automatically remove the state object as it won't break any of your other code.

## Other recommended changes
Some of the other widgets have properties that are no longer required and now nullable.
For example `StreamCallParticipants` no longer requires `participants`, but will listen to the `callParticipants` in the `call` object. We have not completely removed this to keep the option for filtering participants shown in this widget. In the same way `StreamCallControls` no longer require a `localParticipant`, but you can still supply this when you want to use a different participant than the `localParticipant` from the call object. Because these objects are now optional they are not deprecated and are not automatically removed by `dart fix`.

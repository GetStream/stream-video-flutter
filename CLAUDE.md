# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Reading call state in widgets

`CallState` is one immutable object that is replaced on every change, which can be many times a second in a large call. A widget that rebuilds on every emission does work for changes it doesn't show.

Use `PartialCallStateBuilder` to build from part of the state. Use `call.partialState(selector)` when the value is consumed in code rather than in a build. Both run the selector on each emission and pass a value on only when it differs from the previous one.

### Pass a selector that keeps its identity

`PartialCallStateBuilder` subscribes again whenever its `selector` changes, so that every value comes from the current selector. An inline closure is a new object on every build. It makes the builder cancel its subscription and subscribe again each time the parent rebuilds.

Use a static method or a top-level function:

```dart
static bool _isRecording(CallState state) => state.isRecording;

@override
Widget build(BuildContext context) {
  return PartialCallStateBuilder(
    call: call,
    selector: _isRecording,
    builder: (context, isRecording) => ...,
  );
}
```

Don't use an instance method tear-off of a `StatelessWidget`. The widget is a new instance on every build, so its tear-off is too. A tear-off of a `State` method is stable, but a selector that reads widget fields is better written to take those values from the state it is given.

### Select the smallest value that the builder needs

- Select a value with value equality: a primitive, an enum, or a record of them. Records compare field by field, so `(isBackstage: state.isBackstage, hasEnded: state.endedAt != null)` only changes when one of the fields does.
- Lists are compared element by element. The elements need `==`, or the list is never equal to the previous one.
- Select a derived value rather than the collection it comes from. For example, select `state.callParticipants.length` when only the count is shown.
- For the participant list, use `CallParticipantsBuilder` or `Call.participantsStream`, which are throttled, rather than selecting `state.callParticipants`.

### Listening outside of build

`call.partialState(...)` returns a stream with its own selector chain, which ends when the subscription is cancelled. Subscribe in `initState`, and cancel the subscription in `dispose`.

# Ringing event payloads

The body each native plugin puts on the event channel for a call event
(`ACTION_CALL_INCOMING`, `ACCEPT`, `DECLINE`, `ENDED`, ...), for one known call.

Both sides of the channel test against the same file, so a key renamed on one
side fails on the other:

- `android_call_event.json`: produced by the Android receiver; checked in
  `android/src/test/.../IncomingCallBroadcastReceiverTest.kt`, read in
  `test/method_channel_event_test.dart`.
- `ios_call_event.json`: produced by `CallData.toJSON()`; checked in
  `example/ios/RunnerTests/CallDataTests.swift`, read in
  `test/method_channel_event_test.dart`.

The two platforms do not send the same keys. Android sends the handle as
`number` and no `isAccepted`; iOS sends `handle`, `isAccepted` and the call id
twice. The Dart test pins what that means for `CallData` on each platform.

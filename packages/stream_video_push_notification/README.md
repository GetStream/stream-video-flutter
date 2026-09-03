## Stream Video Push Notifications
Push notification support for Stream Video. Please see the official package `stream_video_flutter` for detailed information on how it can be used.

### Android Telecom integration

On Android the ringing flow can additionally register calls with the platform's
[Telecom stack](https://developer.android.com/develop/connectivity/telecom) through Jetpack Telecom.
This does not replace the incoming call notification or the full-screen ringing UI — it layers
system awareness on top of them, which gives the call proper audio focus, a place in the system call
state, and lets it be answered or hung up from a paired watch, a car head unit or a Bluetooth
headset.

Whether it is on by default depends on the Android version:

| Android version | Default | Why |
| --- | --- | --- |
| 17 and above | **On** — opt out with `enabled: false` | For an app targeting API 37, the platform will not play a ringtone from a service started by a push unless the call is in the Telecom stack, so ringing does not work correctly without it |
| Below 17 | **Off** — opt in with `enabled: true` | Ringing works without it, so nothing about an existing integration changes |

The default follows the Android version of the **device**, not your `targetSdk`, so it is also on
for an app targeting a lower API that happens to run on Android 17. That is deliberately
conservative: if you target below API 37 the restriction does not apply to you, and opting out
leaves the ringing flow exactly as it was.

An explicit `enabled` always wins on both. Leave it unset to take the default for whatever version
the app is running on:

```dart
StreamVideoPushNotificationManager.create(
  iosPushProvider: const StreamVideoPushProvider.apn(name: 'apn-provider'),
  androidPushProvider: const StreamVideoPushProvider.firebase(name: 'firebase-provider'),
  pushConfiguration: const StreamVideoPushConfiguration(
    android: AndroidPushConfiguration(
      telecom: TelecomPushConfiguration(
        // Optional. Omit to follow the table above, `true` to force it on below Android 17,
        // `false` to opt out on Android 17 and above.
        enabled: true,
        // Optional. URI scheme for the call address reported to Telecom, defaults to the
        // application id. `myapp` produces an address of `myapp:<callCid>`.
        schema: 'myapp',
      ),
    ),
  ),
);
```

Requirements and behaviour:

- Android 8.0 (API 26) or newer. On older versions the integration is skipped.
- The `MANAGE_OWN_CALLS` permission, which the plugin already declares for you.
- `BLUETOOTH_CONNECT` is optional and only affects Bluetooth device names, see below.
- Below Android 17 only, devices without a telephony stack or a default dialer (some tablets and TV
  devices) are skipped. From Android 17 the API level is the only requirement, because skipping the
  integration there would take working ringing with it.

In every skipped case the ringing flow behaves exactly as it does with Telecom disabled, so enabling
the option is safe across a mixed device fleet.

Jetpack Telecom uses `BLUETOOTH_CONNECT` to read the names of connected Bluetooth devices when it
reports the available audio endpoints. The plugin declares it, but from Android 12 (API 31) it is a
runtime permission, so it only takes effect once your app requests it — the SDK does not prompt,
since when to ask is your app's decision.

Nothing about ringing depends on it. `CallsManager.addCall` requires only `MANAGE_OWN_CALLS`, and
Jetpack Telecom checks the Bluetooth grant before every use and falls back cleanly. Without it, only
the active Bluetooth device is surfaced and its name falls back to a generic default.

Outgoing calls are registered when you call `startOutgoingCall`; the SDK does not call it for you.

### iOS call history

CallKit lists every call it displayed in the system Recents. Report how a call ended to control how
it is listed there — for example so an unanswered call shows up as a missed call rather than a
regular one:

```dart
await pushNotificationManager.reportCallEnded(
  uuid,
  reason: CallEndedReason.unanswered,
);
```

This is a no-op on Android.

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
| 17 and above | **On** — opt out with `enabled: false` | The platform refuses to play a ringtone from a service started by a push unless the call is in the Telecom stack, so ringing does not work correctly without it |
| Below 17 | **Off** — opt in with `enabled: true` | Ringing works without it, so nothing about an existing integration changes |

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
- Below Android 17 only, devices without a telephony stack or a default dialer (some tablets and TV
  devices) are skipped. From Android 17 the API level is the only requirement, because skipping the
  integration there would take working ringing with it.

In every skipped case the ringing flow behaves exactly as it does with Telecom disabled, so enabling
the option is safe across a mixed device fleet.

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

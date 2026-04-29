---
name: stream-video-flutter-ringing
description: |
  Use this skill whenever the user wants to add ringing calls, push
  notifications, CallKit, or missed-call handling to a Flutter app using the
  Stream Video SDK. Covers `stream_video_push_notification` setup, Firebase
  (Android FCM) and APNs / VoIP (iOS PushKit) configuration, the
  `ringing: true` call flow, foreground / background notification handling,
  iOS entitlements, AppDelegate setup (regular APNs + VoIP + foreground
  display), and the iOS `registerApnDeviceToken` requirement for missed-call
  pushes. TRIGGER on prompts like: "add ringing to my Flutter app",
  "incoming / outgoing call screen with Stream", "push notifications for
  Stream Video", "set up CallKit / VoIP push", "FCM background handler for
  ringing", "missed call notification", "why are call.missed pushes not
  arriving on iOS", "configure APNs / Firebase for Stream Video". Assumes
  the user has already integrated the core SDK — for installation,
  initialization, and call basics, defer to `stream-video-flutter`. For
  livestreaming, use `stream-video-flutter-livestream`.
---

# Stream Video Flutter SDK — Ringing & Push Notifications

You are helping wire up ringing calls and push notifications using
`stream_video_push_notification`. This skill assumes the core SDK is set up
— see `stream-video-flutter` for installation and initialization.

> **Authoritative documentation:**
> - Push notifications: <https://getstream.io/video/docs/flutter/advanced/push-notifications/>
> - CallKit: <https://getstream.io/video/docs/flutter/advanced/callkit-integration/>
> - General Flutter docs: <https://getstream.io/video/docs/flutter/>
>
> Consult these for anything not covered here (provider name registration in
> the Stream Dashboard, custom notification UI, alternate FCM clients,
> deeplinks, Firebase project setup details).

---

## Before you write any code — gather these

Push setup has many moving parts. Establish all of these first:

1. **Firebase project & `google-services.json`** for Android (FCM).
2. **APNs key + certificate**, **APNs auth key** uploaded to Stream
   Dashboard for iOS, with a registered provider name (the string you'll
   pass as `iosPushProvider.name`).
3. **Provider names** registered in the Stream Dashboard for both
   `apn` and `firebase`.
4. **Apple Developer account** with an App ID that has Push Notifications
   capability enabled (and ideally Voice over IP for VoIP push).
5. **Where stored credentials live** — for the background handler you need
   to reload `apiKey`, `userId`, `userToken` from secure storage without a
   live app session.

---

## Packages

```yaml
dependencies:
  stream_video_flutter: ^1.2.4
  stream_video_push_notification: ^1.2.4
  # plus your Firebase plumbing on Android:
  firebase_core: ^...
  firebase_messaging: ^...
```

```dart
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
```

---

## Initialize the client with push manager

```dart
StreamVideo(
  'API_KEY',
  user: user,
  userToken: token,
  options: const StreamVideoOptions(
    keepConnectionsAliveWhenInBackground: true,
  ),
  pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
    iosPushProvider: const StreamVideoPushProvider.apn(
      name: 'your-apn-provider-name',
    ),
    androidPushProvider: const StreamVideoPushProvider.firebase(
      name: 'your-firebase-provider-name',
    ),
    registerApnDeviceToken: true, // critical on iOS — see "Missed call" section
  ),
)..connect();
```

`keepConnectionsAliveWhenInBackground: true` is what lets the SDK stay
reachable for ringing while the app is suspended.

> **iOS-only critical:** if you support `call.missed` notifications, you
> **must** pass `registerApnDeviceToken: true` AND request the
> `Permission.notification` permission **before** constructing
> `StreamVideo(...)` — the SDK does a one-shot APNs token fetch during
> `connect()`. See [Missed-call setup](#missed-call-notifications) below.

---

## Make a ringing call

```dart
final call = StreamVideo.instance.makeCall(
  callType: StreamCallType.defaultType(),
  id: const Uuid().v4(),
);

await call.getOrCreate(
  memberIds: ['recipient-user-id'],
  ringing: true,
  video: true, // false for audio-only
);
```

The `ringing: true` flag triggers the push to all members — the SDK
delivers an incoming-call screen (via CallKit on iOS) on the recipient's
device.

## Observing ringing events

```dart
StreamVideo.instance.observeCoreRingingEvents(
  onCallAccepted: (call) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CallScreen(call: call)),
    );
  },
);
```

Use this in your home / shell route to navigate to the call screen when the
recipient accepts.

---

## Android — background handler

FCM data messages arrive via the Firebase background handler. Initialize a
**separate** `StreamVideo` via `StreamVideo.create(...)` (not the singleton
constructor) and dispose it after handling:

```dart
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final sv = StreamVideo.create(
    'API_KEY',
    user: storedUser,
    userToken: storedToken,
    options: const StreamVideoOptions(
      keepConnectionsAliveWhenInBackground: true,
    ),
    pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
      iosPushProvider: const StreamVideoPushProvider.apn(name: '...'),
      androidPushProvider: const StreamVideoPushProvider.firebase(name: '...'),
      registerApnDeviceToken: true, // keep parity with foreground init
    ),
  )..connect();

  sv.disposeAfterResolvingRinging();
  await sv.handleRingingFlowNotifications(message.data);
}
```

Register it in `main()`:

```dart
FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
```

For foreground FCM messages, also call
`handleRingingFlowNotifications(message.data)` from your
`FirebaseMessaging.onMessage` listener (using the singleton instance).

`handleRingingFlowNotifications()` knows the difference between `call.ring`
and `call.missed` types and dispatches accordingly when
`handleMissedCall: true` (the default).

---

## iOS — `AppDelegate.swift`

You must register for **both** VoIP push (PushKit) **and** regular APNs.
You must also explicitly tell iOS to display regular pushes in the
foreground, otherwise missed-call alerts are silently dropped while the app
is active.

```swift
import UIKit
import Flutter
import stream_video_push_notification

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // VoIP push (PushKit) — for incoming-call ringing
        StreamVideoPKDelegateManager.shared.registerForPushNotifications()

        // Regular APNs — required so the SDK can obtain an APNs device
        // token for `call.missed` and other non-VoIP pushes. Without this
        // call, FirebaseMessaging.instance.getAPNSToken() returns nil and
        // the backend never learns about this device.
        application.registerForRemoteNotifications()

        // Show regular APNs notifications while the app is in the foreground
        UNUserNotificationCenter.current().delegate = self

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let streamDict = notification.request.content.userInfo["stream"] as? [String: Any]
        if streamDict?["sender"] as? String != "stream.video" {
            return completionHandler([])
        }
        if #available(iOS 14.0, *) {
            completionHandler([.list, .banner, .sound])
        } else {
            completionHandler([.alert])
        }
    }
}
```

---

## iOS — entitlements

New Flutter projects do **not** create entitlements files. Without the
`aps-environment` entitlement, iOS silently refuses to deliver VoIP and
regular pushes.

Either:

**Recommended — let Xcode do it:** open `ios/Runner.xcworkspace` → Runner
target → **Signing & Capabilities** → **+ Capability** → **Push
Notifications**. Xcode generates the entitlements file and updates
`project.pbxproj`.

**Manual fallback:**

1. `ios/Runner/Runner.entitlements` (Release & Profile):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>aps-environment</key>
    <string>development</string>
</dict>
</plist>
```

2. `ios/Runner/RunnerDebug.entitlements` (Debug) — same content.
3. In each of the three Runner build configurations in `project.pbxproj`,
   add inside `buildSettings`:

```
// Debug
CODE_SIGN_ENTITLEMENTS = Runner/RunnerDebug.entitlements;
// Release & Profile
CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements;
```

`UIBackgroundModes` in `Info.plist` must include both `voip` and
`remote-notification` (the core skill `stream-video-flutter` already
covers the full list).

---

## Android — extras

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

On Android 13+ you must also request `Permission.notification` at
runtime before / during init.

The default `AndroidPushConfiguration` already enables missed-call
notifications with sensible defaults. To customize:

```dart
StreamVideoPushNotificationManager.create(
  iosPushProvider: ...,
  androidPushProvider: ...,
  pushConfiguration: const StreamVideoPushConfiguration(
    android: AndroidPushConfiguration(
      missedCallNotification: MissedCallNotificationParams(
        showNotification: true,
        subtitle: 'You missed a call',
        callbackText: 'Call back',
        showCallbackButton: true,
      ),
    ),
  ),
)
```

---

## Missed-call notifications

When a ringing call goes unanswered, Stream sends `call.missed` — a
**regular push notification**, not VoIP. iOS treats this very differently
from VoIP push, which is why the iOS setup has extra requirements.

### How it works

1. User A calls User B with `ringing: true`.
2. User B doesn't answer (or User A cancels).
3. Stream backend sends `call.missed` via regular APNs (iOS) or FCM data
   message (Android).
4. The SDK's `handleRingingFlowNotifications()` detects
   `type == 'call.missed'` and calls `showMissedCall()`.

### Android

`call.missed` is a normal FCM data message — same channel as `call.ring`.
`handleRingingFlowNotifications()` handles it automatically when
`handleMissedCall: true` (the default). No extra Android-side setup beyond
the standard ringing config.

### iOS — three things must all be true

1. **`registerApnDeviceToken: true`** in
   `StreamVideoPushNotificationManager.create()`. By default the SDK only
   registers the **VoIP** token; without this flag the backend has no APNs
   token and cannot deliver `call.missed`.

2. **`application.registerForRemoteNotifications()` in AppDelegate.**
   `StreamVideoPKDelegateManager.shared.registerForPushNotifications()`
   only handles VoIP via PushKit. The regular APNs token comes from
   `registerForRemoteNotifications()`. Without it,
   `FirebaseMessaging.instance.getAPNSToken()` returns `nil` and the SDK
   cannot send the token to the Stream backend.

3. **Permission requested BEFORE `StreamVideo(...)` is constructed.**
   `registerDevice()` runs once during `connect()` and does a **one-shot**
   `getAPNSToken()` — there is no retry or listener. If notification
   permissions are requested after init, the token is `nil` at registration
   time and the device is never registered for regular pushes.

```dart
// CORRECT — permissions first
await [
  Permission.camera,
  Permission.microphone,
  Permission.notification, // triggers registerForRemoteNotifications on iOS
  if (CurrentPlatform.isAndroid) Permission.phone,
].request();

final streamVideo = StreamVideo(
  apiKey,
  user: user,
  userToken: token,
  pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
    iosPushProvider: const StreamVideoPushProvider.apn(name: '...'),
    androidPushProvider: const StreamVideoPushProvider.firebase(name: '...'),
    registerApnDeviceToken: true,
  ),
);

// WRONG — token is nil at registration time
final streamVideo = StreamVideo(apiKey, user: user, userToken: token, ...);
await Permission.notification.request(); // too late
```

The `application.registerForRemoteNotifications()` call in `AppDelegate`
acts as a safety net (it can produce a token without the user permission
prompt), but the Flutter-side permission request should still come first.

**Apply the same `registerApnDeviceToken: true`** in the background
handler's `StreamVideo.create(...)`.

---

## Summary checklist

| Requirement | Android | iOS |
|---|---|---|
| `keepConnectionsAliveWhenInBackground: true` | yes | yes |
| `handleRingingFlowNotifications(message.data)` in foreground FCM listener | yes | n/a (APNs) |
| Same call in background FCM handler | yes | n/a |
| `StreamVideo.create(...)` (not singleton) in background handler | yes | n/a |
| `registerApnDeviceToken: true` | n/a | **yes — critical** |
| `application.registerForRemoteNotifications()` in `AppDelegate` | n/a | **yes — critical** |
| Request `Permission.notification` **before** `StreamVideo(...)` | n/a | **yes — critical** |
| `UNUserNotificationCenter.current().delegate = self` | n/a | yes (foreground display) |
| `willPresent` delegate | n/a | yes (foreground display) |
| Push entitlements (`aps-environment`) | n/a | yes |
| `POST_NOTIFICATIONS` runtime permission | yes (Android 13+) | n/a |
| `UIBackgroundModes`: `voip`, `remote-notification` | n/a | yes |
| Provider names registered in Stream Dashboard | yes | yes |

---

## Common pitfalls

| Mistake | Fix |
|---|---|
| Calling `StreamVideo(...)` (singleton) in the background handler | Use `StreamVideo.create(...)`; it does not replace the foreground singleton. |
| Hardcoding tokens in the background handler | Reload `apiKey`, `userId`, `userToken` from secure storage. |
| `call.missed` not arriving on iOS | Set `registerApnDeviceToken: true`, call `registerForRemoteNotifications()`, request notification permission **before** init. |
| Missed-call pushes silent in foreground on iOS | Set `UNUserNotificationCenter.current().delegate = self` and implement `willPresent`. |
| `getAPNSToken()` returns nil | Permission requested after `StreamVideo(...)` was created — always permissions first. |
| Forgetting `aps-environment` entitlement | Add via Xcode capability or manually in `Runner.entitlements` + `project.pbxproj`. |
| iOS build error about iOS 13.0 vs `stream_video_push_notification` 14.0 | Update all three build configurations in `project.pbxproj` to `IPHONEOS_DEPLOYMENT_TARGET = 14.0`. |
| Skipping `keepConnectionsAliveWhenInBackground: true` | Calls drop while suspended — required for ringing. |
| Not calling `disposeAfterResolvingRinging()` in the background handler | Connection leaks across pushes. |
| Custom FCM channel without `handleRingingFlowNotifications` | The SDK won't process the payload; ringing screens never appear. |

---

## Key APIs

| API | Purpose |
|---|---|
| `StreamVideoPushNotificationManager.create(...)` | Builds the push manager (provider names + flags). |
| `StreamVideoPushProvider.apn(name:)` / `.firebase(name:)` | Provider configs (names match Stream Dashboard). |
| `registerApnDeviceToken: true` | Enables regular APNs token registration on iOS (required for `call.missed`). |
| `StreamVideoOptions(keepConnectionsAliveWhenInBackground: true)` | Keeps the connection alive for ringing. |
| `call.getOrCreate(memberIds:, ringing: true, video:)` | Creates and rings a call. |
| `StreamVideo.instance.observeCoreRingingEvents(onCallAccepted:)` | Hook into accept events. |
| `handleRingingFlowNotifications(message.data)` | Process FCM data payloads (foreground & background). |
| `disposeAfterResolvingRinging()` | Auto-dispose background-handler client. |
| `StreamVideo.create(...)` | Auxiliary client for background isolates. |
| `StreamVideoPKDelegateManager.shared.registerForPushNotifications()` | iOS VoIP / PushKit registration. |
| `application.registerForRemoteNotifications()` | iOS regular APNs registration (for `call.missed`). |
| `UNUserNotificationCenter.willPresent` | Show regular pushes in foreground. |
| `MissedCallNotificationParams` / `AndroidPushConfiguration` | Customize Android missed-call UX. |

---

## When to consult docs

For provider name registration in the Stream Dashboard, RTMP push,
deeplinking from the notification into a specific screen, custom
notification content, or alternate push backends — fetch the relevant page
from <https://getstream.io/video/docs/flutter/advanced/push-notifications/>
and <https://getstream.io/video/docs/flutter/advanced/callkit-integration/>
before guessing.

## When to defer

- **Core SDK setup, install, init, generic calling** → `stream-video-flutter`.
- **Livestreaming, audio rooms, HLS, feed UI** → `stream-video-flutter-livestream`.

## Tone & style

Diagnostic and checklist-driven. Push setup fails silently when one piece
is missing, so when the user reports "ringing doesn't work" or "missed call
isn't showing on iOS", walk the [Summary checklist](#summary-checklist) row
by row before suggesting code changes. Always name **which** of the three
iOS missed-call requirements is most likely missing rather than dumping all
of them again.

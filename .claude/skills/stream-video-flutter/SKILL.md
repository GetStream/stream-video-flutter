---
name: stream-video-flutter
description: |
  Use this skill whenever the user wants to build, scaffold, or extend a Flutter
  app that uses the Stream Video SDK — including 1:1 / group video calling,
  audio-only calls, joining or creating calls, rendering call UI, and
  customizing call controls or theming. Covers initial setup (pubspec, iOS /
  Android permissions, deployment targets), client initialization, call
  lifecycle (`makeCall` → `getOrCreate` → `join` → `leave` / `end`), the
  pre-built widgets (`StreamCallContainer`, `StreamCallContent`,
  `StreamCallParticipants`, `PartialCallStateBuilder`), and common pitfalls.
  TRIGGER on prompts like: "add video calling to my Flutter app", "build a
  Flutter app with Stream Video", "integrate Stream Video SDK", "add audio /
  video to an existing Flutter project", "create a call screen with Stream",
  "set up `stream_video_flutter`", "show participants / mute mic / flip
  camera", "customize Stream call UI / theme", "join a call by ID". For
  livestreaming or audio rooms, defer to `stream-video-flutter-livestream`.
  For ringing / push notifications / CallKit, defer to
  `stream-video-flutter-ringing`.
---

# Stream Video Flutter SDK — Setup & Core Calling

You are helping integrate the **Stream Video Flutter SDK** into a Flutter
application. This skill covers everything needed to ship a working 1:1, group,
or audio-only call. For livestreaming, audio rooms, or ringing flows, defer
to the dedicated sibling skills.

> **Versions assumed:** `stream_video_flutter ^1.2.x` · Dart ≥ 3.8 ·
> Flutter ≥ 3.32 · iOS ≥ 14 · Android `minSdk 24`. Always check the latest
> version on [pub.dev](https://pub.dev/packages/stream_video_flutter).

> **Authoritative documentation:**
> <https://getstream.io/video/docs/flutter/> — consult this before guessing
> any API surface that is not in this skill (UI cookbook, advanced APIs,
> dashboard configuration, server-side token issuance, etc.).

---

## Before you write any code

1. **Confirm the call type**. The SDK supports `default` (video / audio
   calls), `livestream`, `audio_room`, `development`, and custom types. If the
   user wants a livestream or audio room, switch to
   `stream-video-flutter-livestream`. If they want incoming-call ringing or
   CallKit, switch to `stream-video-flutter-ringing`.
2. **Confirm credentials**. The SDK needs an `apiKey`, a `userId`, and a
   `userToken` (JWT). Ask the user where the token comes from — for production
   it must come from their backend via `tokenLoader`, never hardcoded.
3. **Confirm target platforms**. iOS needs deployment target 14.0 and the
   permission keys in `Info.plist`. Android needs `minSdk 24` and the
   manifest permissions.

---

## Packages

| Package | Purpose |
|---|---|
| `stream_video_flutter` | **Primary.** Pre-built UI widgets + re-exports `stream_video`. Use this for almost every app. |
| `stream_video` | Low-level client only. Use directly only when building entirely custom UI. |
| `stream_video_push_notification` | Push / CallKit / ringing. See `stream-video-flutter-ringing`. |
| `stream_video_noise_cancellation` | Optional AI noise cancellation. |

**Import rule:** only import `stream_video_flutter` — it re-exports everything
from `stream_video`, so importing both is a mistake.

```dart
import 'package:stream_video_flutter/stream_video_flutter.dart';
```

### `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  stream_video_flutter: ^1.2.4
```

---

## Platform setup

### iOS — `ios/Podfile`

```ruby
platform :ios, '14.0'
```

New Flutter projects default `IPHONEOS_DEPLOYMENT_TARGET` to `13.0` in
`ios/Runner.xcodeproj/project.pbxproj`. Update **all three** build
configurations (Debug, Release, Profile) to `14.0`, otherwise the build
fails with: *"Compiling for iOS 13.0, but module
'stream_video_push_notification' has a minimum deployment target of iOS 14"*.

### iOS — `ios/Runner/Info.plist`

```xml
<key>NSCameraUsageDescription</key>
<string>$(PRODUCT_NAME) Camera Usage</string>
<key>NSMicrophoneUsageDescription</key>
<string>$(PRODUCT_NAME) Microphone Usage</string>
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
    <string>fetch</string>
    <string>processing</string>
    <string>remote-notification</string>
    <string>voip</string>
</array>
```

### Android — `android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-feature android:name="android.hardware.camera"/>
<uses-feature android:name="android.hardware.camera.autofocus"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS"/>
<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
```

Set `minSdkVersion 24` in `android/app/build.gradle` (already the Flutter
default in recent versions).

---

## Initialization

```dart
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Creates the singleton AND auto-connects to Stream's backend.
  StreamVideo(
    'YOUR_API_KEY',
    user: User.regular(userId: 'user-id', name: 'Jane Doe'),
    userToken: 'USER_JWT_TOKEN',
  );

  runApp(const MyApp());
}
```

### Canonical initialization rules

1. **`WidgetsFlutterBinding.ensureInitialized()`** must run before
   `StreamVideo(...)` in `main()`.
2. **`StreamVideo(...)` is a singleton.** Access it anywhere with
   `StreamVideo.instance`. Do **not** wrap it in a provider / GetIt / Riverpod
   for storage — just use the singleton.
3. **Auto-connect is on by default.** Disable with
   `options: StreamVideoOptions(autoConnect: false)` and call
   `StreamVideo.instance.connect()` later.
4. **Provide either `userToken` (JWT string) or `tokenLoader` (async
   callback).** Never both. Use `tokenLoader` in production so tokens can be
   refreshed.
5. **One singleton at a time.** Calling `StreamVideo(...)` while one exists
   throws. To switch users: `await StreamVideo.reset(disconnect: true)` first,
   or pass `failIfSingletonExists: false`.
6. **For background isolates** (e.g. push handlers) use `StreamVideo.create(...)`
   — it does not replace the main singleton.

### `StreamVideoOptions` — notable fields

```dart
StreamVideoOptions(
  autoConnect: true,
  keepConnectionsAliveWhenInBackground: false, // set true for ringing apps
  muteVideoWhenInBackground: false,
  muteAudioWhenInBackground: false,
  logPriority: Priority.none,                  // Priority.debug for dev
)
```

---

## Smallest working call (copy-pasteable)

```dart
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StreamVideo(
    'YOUR_API_KEY',
    user: User.regular(userId: 'john', name: 'John Doe'),
    userToken: 'USER_JWT',
  );

  runApp(const MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Join Call'),
          onPressed: () async {
            final call = StreamVideo.instance.makeCall(
              callType: StreamCallType.defaultType(),
              id: 'my-call-123',
            );
            await call.getOrCreate();

            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: StreamCallContainer(call: call),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
```

`StreamCallContainer` handles the full lifecycle: lobby → outgoing → incoming
→ active → disconnected. It calls `join()` for you.

---

## The Call lifecycle

```
makeCall() → getOrCreate() → join() → [active call] → leave() / end()
```

| Step | What it does |
|---|---|
| `StreamVideo.instance.makeCall(callType:, id:)` | Creates a local `Call` object — no network. |
| `call.getOrCreate(...)` | Creates the call on Stream servers (or returns existing). |
| `call.join(...)` | Connects WebRTC, publishes/subscribes to tracks. |
| `call.leave()` | Disconnects this user; call continues for others. |
| `call.end()` | Terminates the call for everyone. |

**Critical rules:**

- If you use `StreamCallContainer`, do **not** call `call.join()` yourself —
  it joins automatically. Only call `getOrCreate()` before navigating.
- If you build fully custom UI without `StreamCallContainer`, you must call
  both `getOrCreate()` and `join()`.
- Always call `call.leave()` when the user leaves the call screen.

### Call types

| Factory | String | Use case |
|---|---|---|
| `StreamCallType.defaultType()` | `default` | Video / audio calls (1:1 or group) |
| `StreamCallType.liveStream()` | `livestream` | Livestreaming (see livestream skill) |
| `StreamCallType.audioRoom()` | `audio_room` | Twitter Spaces / Clubhouse-style |
| `StreamCallType.development()` | `development` | Testing |
| `StreamCallType.custom('my_type')` | custom | Custom dashboard type |

Configure call-type permissions and features in the [Stream Dashboard](https://dashboard.getstream.io/).

---

## Creating & joining calls

### Standard call

```dart
final call = StreamVideo.instance.makeCall(
  callType: StreamCallType.defaultType(),
  id: 'unique-call-id',
);
await call.getOrCreate();
// Navigate to a screen with StreamCallContainer(call: call)
```

### With pre-invited members

```dart
await call.getOrCreate(memberIds: ['alice', 'bob']);
```

### Custom track options

```dart
await call.join(
  connectOptions: CallConnectOptions(
    camera: TrackOption.enabled(),
    microphone: TrackOption.disabled(),
  ),
);
```

Or pass them to `StreamCallContainer`:

```dart
StreamCallContainer(
  call: call,
  callConnectOptions: CallConnectOptions(
    camera: TrackOption.enabled(),
    microphone: TrackOption.disabled(),
  ),
)
```

### `TrackOption` values

| Value | Meaning |
|---|---|
| `TrackOption.enabled()` | Start the track on join |
| `TrackOption.disabled()` | Keep the track off on join |
| `TrackOption.provided(localTrack)` | Use a pre-created local track |

---

## Pre-built widgets

### `StreamCallContainer` — all-in-one

Manages lobby → outgoing → incoming → active → disconnected.

```dart
Scaffold(
  body: StreamCallContainer(
    call: call,
    callConnectOptions: CallConnectOptions(
      camera: TrackOption.enabled(),
      microphone: TrackOption.enabled(),
    ),
    onCallDisconnected: (_) => Navigator.pop(context),
  ),
)
```

### `StreamCallContent` — active call only

For finer control. Renders app bar + participants grid + controls.

```dart
StreamCallContent(
  call: call,
  layoutMode: ParticipantLayoutMode.grid,   // or .spotlight
  callAppBarWidgetBuilder: (context, call) => CallAppBar(call: call),
  callParticipantsWidgetBuilder: (context, call) =>
    StreamCallParticipants(call: call),
  callControlsWidgetBuilder: (context, call) =>
    StreamCallControls.withDefaultOptions(call: call),
)
```

### `StreamCallParticipants` / `StreamCallParticipant`

Render participant tiles (grid or spotlight) or a single tile.

---

## Reactive state — `PartialCallStateBuilder`

`call.state` is a `StateEmitter<CallState>`. **Always prefer
`PartialCallStateBuilder`** over raw `StreamBuilder` on
`call.state.valueStream` — it rebuilds only when the selected slice changes.

```dart
PartialCallStateBuilder(
  call: call,
  selector: (state) => state.callParticipants.length,
  builder: (context, count) => Text('$count participants'),
)
```

### Useful `CallState` properties

| Property | Type | Description |
|---|---|---|
| `callParticipants` | `List<CallParticipantState>` | All participants |
| `localParticipant` | `CallParticipantState?` | Local user |
| `otherParticipants` | `List<CallParticipantState>` | Remote |
| `activeSpeakers` | `List<CallParticipantState>` | Currently speaking |
| `isBackstage` | `bool` | Backstage mode active |
| `isRecording` | `bool` | Recording in progress |
| `isBroadcasting` | `bool` | HLS broadcasting active |
| `status` | `CallStatus` | Connection status |
| `createdByMe` | `bool` | Current user created the call |
| `callId` | `String` | The call ID |
| `startsAt` / `endedAt` | `DateTime?` | Schedule / end time |

---

## Call controls

Pre-built option widgets — drop them into `StreamCallControls.options`:

| Widget | Purpose |
|---|---|
| `ToggleMicrophoneOption` | Mute / unmute microphone |
| `ToggleCameraOption` | Enable / disable camera |
| `FlipCameraOption` | Switch front / rear camera |
| `ToggleScreenShareOption` | Start / stop screen sharing |
| `ToggleSpeakerphoneOption` | Toggle speakerphone |
| `LeaveCallOption` | Leave the call |
| `AddReactionOption` | Send emoji reactions |
| `ToggleRecordingOption` | Start / stop recording |
| `ToggleLayoutOption` | Switch grid / spotlight |
| `ToggleClosedCaptionsOption` | Toggle closed captions |
| `CallControlOption` | Generic custom button |

Custom set:

```dart
StreamCallControls(
  options: [
    ToggleMicrophoneOption(call: call),
    ToggleCameraOption(call: call),
    FlipCameraOption(call: call),
    LeaveCallOption(
      call: call,
      onLeaveCallTap: () => call.leave(),
    ),
  ],
)
```

### Programmatic control

```dart
await call.setMicrophoneEnabled(enabled: false);
await call.setCameraEnabled(enabled: true);
await call.setScreenShareEnabled(enabled: true);
```

---

## Screen sharing, recording, broadcasting

```dart
ToggleScreenShareOption(
  call: call,
  screenShareConstraints: const ScreenShareConstraints(
    useiOSBroadcastExtension: true,
    captureScreenAudio: true,
  ),
)

await call.startRecording();
await call.stopRecording();
final recordings = await call.listRecordings();

await call.startHLS();
final hlsUrl = call.state.value.egress.hlsPlaylistUrl;
```

For HLS-driven livestream viewers, see `stream-video-flutter-livestream`.

---

## Permissions & moderation

```dart
call.hasPermission(CallPermission.sendAudio);

await call.requestPermissions([CallPermission.sendAudio]); // listener
await call.grantPermissions(                                // host
  userId: 'user-id',
  permissions: [CallPermission.sendAudio],
);

call.onPermissionRequest = (request) { /* request.user, request.permissions */ };

await call.muteUsers(userIds: ['user-id'], track: TrackType.audio);
await call.muteAllUsers();
await call.blockUser('user-id');
await call.unblockUser('user-id');
```

---

## Theming

```dart
MaterialApp(
  builder: (context, child) {
    return StreamVideoTheme(
      data: StreamVideoThemeData.fromColorScheme(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      child: child!,
    );
  },
  home: const HomeScreen(),
)
```

Component-level theming is documented in the [UI Cookbook](https://getstream.io/video/docs/flutter/ui-cookbook/overview/).

---

## Cleanup & logout

```dart
await call.leave();                       // Leave current call
await StreamVideo.instance.disconnect();  // Disconnect from backend
await StreamVideo.reset();                // Destroy singleton (required before re-init for a new user)
```

---

## Common pitfalls

| Mistake | Fix |
|---|---|
| Calling `call.join()` AND using `StreamCallContainer` | The container joins automatically — only call `getOrCreate()` first. |
| Creating multiple `StreamVideo(...)` singletons | `await StreamVideo.reset(disconnect: true)` first, or `failIfSingletonExists: false`. |
| Importing both `stream_video` and `stream_video_flutter` | Only import `stream_video_flutter`. |
| Forgetting `WidgetsFlutterBinding.ensureInitialized()` | Must run before `StreamVideo(...)`. |
| Using `StreamBuilder` on `call.state.valueStream` | Use `PartialCallStateBuilder` with a `selector`. |
| Not calling `call.getOrCreate()` before `join()` | Call must exist on the server first. |
| Audio rooms invisible to listeners | Call `call.goLive()` after joining (`audio_room` and `livestream` start in backstage). |
| Using `StreamCallContent` for a livestream viewer | Use `LivestreamPlayer` — see `stream-video-flutter-livestream`. |
| Hardcoded tokens in production | Use `tokenLoader` (async callback that fetches a fresh JWT). |
| Not disposing calls | Always call `call.leave()` when leaving the call screen. |

---

## Quick reference — key classes

| Class / Function | Package | Purpose |
|---|---|---|
| `StreamVideo(apiKey, user:, userToken:)` | `stream_video` | Singleton constructor |
| `StreamVideo.instance` | `stream_video` | Access singleton |
| `StreamVideo.reset()` | `stream_video` | Destroy singleton |
| `StreamVideo.instance.makeCall(callType:, id:)` | `stream_video` | Create local Call |
| `Call.getOrCreate(...)` | `stream_video` | Create / fetch call |
| `Call.join(connectOptions:)` | `stream_video` | Connect WebRTC |
| `Call.leave()` / `.end()` / `.goLive()` / `.stopLive()` | `stream_video` | Lifecycle |
| `Call.state` | `stream_video` | Reactive `CallState` |
| `CallConnectOptions` | `stream_video` | Camera / mic / screen config |
| `TrackOption.enabled()` / `.disabled()` / `.provided(...)` | `stream_video` | Track config |
| `StreamCallType.defaultType()` | `stream_video` | Call type factory |
| `User.regular(userId:, name:)` | `stream_video` | Authenticated user |
| `StreamCallContainer` | `stream_video_flutter` | All-in-one call UI |
| `StreamCallContent` | `stream_video_flutter` | Active call content |
| `StreamCallParticipants` / `StreamCallParticipant` | `stream_video_flutter` | Participant tiles |
| `StreamCallControls` | `stream_video_flutter` | Controls bar |
| `PartialCallStateBuilder` | `stream_video_flutter` | Reactive state builder |
| `StreamVideoTheme` | `stream_video_flutter` | Theme provider |
| `LivestreamPlayer` | `stream_video_flutter` | Livestream viewer (see livestream skill) |
| `MemberRequest` / `CallPermission` | `stream_video` | Members & permissions |

---

## When to defer to other skills

- **Livestreaming, audio rooms, HLS viewer, TikTok-style feed** →
  `stream-video-flutter-livestream`.
- **Ringing, push notifications, CallKit, missed-call handling** →
  `stream-video-flutter-ringing`.
- **AI voice agents** → see [AI Voice Agents docs](https://getstream.io/video/docs/api/voice-agents/).

## When to consult the docs site

If a question is **not covered by this skill** — e.g. SFU configuration,
custom UI cookbook recipes, advanced theming, dashboard setup, server-side
SDKs, dynascale / simulcast tuning, recording layouts, transcription, custom
events — fetch the relevant page from
<https://getstream.io/video/docs/flutter/> instead of guessing. Useful entry
points:

- Tutorials: <https://getstream.io/video/docs/flutter/tutorials/>
- UI Cookbook: <https://getstream.io/video/docs/flutter/ui-cookbook/overview/>
- Core concepts: <https://getstream.io/video/docs/flutter/core/>
- API reference: <https://getstream.io/video/docs/api/>
- pub.dev: <https://pub.dev/packages/stream_video_flutter>
- GitHub: <https://github.com/GetStream/stream-video-flutter>
- Dashboard: <https://dashboard.getstream.io/>

## Tone & style

Concise, code-first answers. Prefer pre-built widgets over custom builds
unless the user explicitly asks for full customization. Always cite the
exact widget / method name. When the user's setup is incomplete, point at
the **specific** missing step (Podfile target, manifest permission, token
source) rather than dumping the full setup again.

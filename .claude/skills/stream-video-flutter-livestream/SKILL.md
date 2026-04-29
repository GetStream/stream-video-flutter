---
name: stream-video-flutter-livestream
description: |
  Use this skill whenever the user wants to add livestreaming, audio rooms,
  HLS broadcasting, or a TikTok-style vertical livestream feed to a Flutter
  app using the Stream Video SDK. Covers the host (publisher) side, the
  viewer side with `LivestreamPlayer`, backstage / go-live transitions,
  participant filtering for the broadcast view, HLS playback URLs, and the
  call-switching `CallManager` pattern for swipeable feeds. TRIGGER on
  prompts like: "add livestreaming to my app", "build a livestream with
  Stream", "create an audio room / Twitter Spaces clone", "build a TikTok-
  style live feed", "go live / publish a livestream from Flutter", "watch a
  livestream in Flutter", "implement HLS playback", "host vs viewer
  experience", "swipe between live channels". Assumes the user has already
  set up the SDK — for installation, initialization, permissions, and core
  call concepts, defer to `stream-video-flutter`. For ringing /
  CallKit / push, use `stream-video-flutter-ringing`.
---

# Stream Video Flutter SDK — Livestreaming & Audio Rooms

You are helping implement a livestream, audio room, or live feed using the
**Stream Video Flutter SDK**. This skill assumes core SDK setup is already
done — see `stream-video-flutter` for installation, permissions, and
initialization.

> **Authoritative documentation:**
> - Livestreaming: <https://getstream.io/video/docs/flutter/livestreaming/>
> - Audio rooms: <https://getstream.io/video/docs/flutter/audio-room/>
> - General Flutter docs: <https://getstream.io/video/docs/flutter/>
>
> Consult these for anything not covered by this skill (advanced HLS
> configuration, recording layouts, viewer-count APIs, custom backstage UI,
> moderation tooling, dashboard call-type configuration).

---

## Pick the right shape first

| What the user wants | Call type | Viewer widget | Host widget |
|---|---|---|---|
| 1-to-many video stream | `liveStream()` | `LivestreamPlayer` | `StreamCallContent` (filtered) |
| Twitter Spaces / Clubhouse | `audioRoom()` | `StreamCallContent` audio-only | `StreamCallContent` audio-only |
| TikTok-style swipe feed | `liveStream()` + `CallManager` | `LivestreamPlayer` | `StreamCallContent` (filtered) |
| 1:1 / group calling | `defaultType()` | (use `stream-video-flutter`) | (use `stream-video-flutter`) |

Both `liveStream` and `audio_room` call types **start in backstage mode**.
The host must call `call.goLive()` for viewers / listeners to see or hear
anything.

---

## Audio rooms

```dart
final call = StreamVideo.instance.makeCall(
  callType: StreamCallType.audioRoom(),
  id: 'room-42',
);

await call.getOrCreate(
  members: [
    MemberRequest(
      userId: StreamVideo.instance.currentUser.id,
      role: 'host',
    ),
  ],
);

await call.join(
  connectOptions: CallConnectOptions(
    microphone: TrackOption.enabled(),
    camera: TrackOption.disabled(),
  ),
);

await call.goLive(); // Allow listeners to join
```

Key points:

- Listeners join with mic / camera disabled.
- Listeners need `call.requestPermissions([CallPermission.sendAudio])` to
  speak; the host grants with `call.grantPermissions(userId:, permissions:)`.
- Use `call.stopLive()` to return to backstage (paused, not ended).

---

## Livestream — host (publisher)

```dart
final call = StreamVideo.instance.makeCall(
  callType: StreamCallType.liveStream(),
  id: 'stream-abc',
);

await call.getOrCreate(
  members: [
    MemberRequest(
      userId: StreamVideo.instance.currentUser.id,
      role: 'host',
    ),
  ],
);

await call.join(
  connectOptions: CallConnectOptions(
    camera: TrackOption.enabled(),
    microphone: TrackOption.enabled(),
  ),
);

await call.goLive(); // Backstage → live
```

### Host broadcast UI — filter by `isVideoEnabled`

If you render `StreamCallContent` as-is, viewer tiles (with disabled
cameras) appear in the host's layout. Filter participants so only those
with active video are shown:

```dart
PartialCallStateBuilder(
  call: call,
  selector: (state) => state.callParticipants
      .where((p) => p.isVideoEnabled)
      .toList(),
  builder: (context, hosts) {
    if (hosts.isEmpty) {
      return const Center(child: Text('Host video is not available'));
    }
    return StreamCallContent(
      call: call,
      callParticipantsWidgetBuilder: (context, call) =>
        StreamCallParticipants(call: call, participants: hosts),
      callControlsWidgetBuilder: (_, __) => const SizedBox.shrink(),
      callAppBarWidgetBuilder: (_, __) => const SizedBox.shrink(),
    );
  },
)
```

> **Why `isVideoEnabled` and not `roles.contains('host')`?** Filtering by
> role works only when roles are perfectly assigned. `isVideoEnabled`
> correctly excludes any participant joining with a disabled camera —
> matching the visual contract of "only show people who are broadcasting".

### Host controls

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    ToggleMicrophoneOption(call: call),
    ToggleCameraOption(call: call),
    FlipCameraOption(call: call),
    // Custom "End Live" button → await call.stopLive(); await call.leave();
  ],
)
```

### Ending the broadcast

```dart
await call.stopLive(); // Return to backstage (stream paused, not ended)
await call.leave();    // Disconnect from SFU
// or:
await call.end();      // Terminate for everyone
```

---

## Livestream — viewer (subscriber)

**Always use `LivestreamPlayer`** for the viewer side. It is the SDK's
purpose-built widget — it joins the call, renders the host full-screen,
and handles backstage / ended / no-host states. **Do not** use
`StreamCallContent` or `StreamCallContainer` for viewers.

### Simple viewer (player auto-joins)

```dart
final call = StreamVideo.instance.makeCall(
  callType: StreamCallType.liveStream(),
  id: 'stream-abc',
);
await call.getOrCreate();

LivestreamPlayer(
  call: call,
  onCallDisconnected: (_) => Navigator.pop(context),
)
```

### Manual join (e.g. inside a feed manager)

```dart
await call.join(
  connectOptions: CallConnectOptions(
    camera: TrackOption.disabled(),
    microphone: TrackOption.disabled(),
  ),
);

// Then in the widget tree:
LivestreamPlayer(call: call, onCallDisconnected: (_) {});
```

### Detect "no host yet" before showing the player

```dart
PartialCallStateBuilder(
  call: call,
  selector: (state) =>
      state.otherParticipants.where((p) => p.isVideoEnabled).isNotEmpty,
  builder: (context, hasHost) {
    if (!hasHost) return const _OfflineOverlay();
    return LivestreamPlayer(call: call, onCallDisconnected: (_) {});
  },
)
```

Always check `otherParticipants.where((p) => p.isVideoEnabled).isNotEmpty`,
not just `otherParticipants.isNotEmpty` — viewers also count as
participants.

---

## Backstage & live state

```dart
await call.goLive();   // backstage → live
await call.stopLive(); // live → backstage (paused)
await call.leave();    // host leaves; stream continues if co-hosts remain
await call.end();      // terminate for everyone
```

Reactive view:

```dart
PartialCallStateBuilder(
  call: call,
  selector: (state) => state.isBackstage,
  builder: (context, isBackstage) =>
    isBackstage ? const Text('Backstage') : const Text('Live'),
)
```

---

## HLS broadcasting

Use HLS when you need to deliver to non-WebRTC players (web embeds, native
video players, very large audiences).

```dart
final result = await call.startHLS();
if (result.isSuccess) {
  final url = call.state.value.egress.hlsPlaylistUrl;
}

await call.stopHLS();
```

Note: HLS introduces ~10-30s latency vs WebRTC. For low-latency viewers,
keep `LivestreamPlayer` (WebRTC).

---

## TikTok-style livestream feed

The hard part of a swipeable live feed is switching calls fast: leave the
current SFU connection, join the next, and survive rapid swipes where the
user blows past intermediate channels.

### Architecture

```
FeedScreen (PageView vertical)
  └─ CallManager (ChangeNotifier)
       ├─ currentCall: Call?
       ├─ state: idle | connecting | connected | failure
       ├─ _version: int  (incremented on every switch)
       └─ switchToCall(callId)

Each page (_LivestreamPage)
  └─ ListenableBuilder(callManager)
       → connected:   LivestreamPlayer(call: callManager.currentCall!)
       → connecting:  _ConnectingOverlay()
       → other:       _OfflineOverlay()
```

### Design principles

1. **Single active connection.** Only one SFU connection at a time. Leave
   the old call (fire-and-forget) before starting the new one.
2. **Version-based cancellation.** Each `switchToCall` increments
   `_version`. After every `await` in `_connectCall`, check
   `_isStale(version, call)` — if a newer switch happened, abandon the
   in-flight connection and `leave()` the call.
3. **No queue.** Rapid swipes simply make the latest `switchToCall` win;
   earlier in-flight connections detect they are stale and clean up.

### Reference implementation

```dart
class CallManager extends ChangeNotifier {
  CallManagerState _state = CallManagerState.idle;
  Call? _currentCall;
  String? _currentCallId;
  int _version = 0;
  bool _disposed = false;

  CallManagerState get state => _state;
  Call? get currentCall => _currentCall;
  String? get currentCallId => _currentCallId;

  void switchToCall(String callId) {
    if (_currentCallId == callId && _state != CallManagerState.failure) return;

    final version = ++_version;

    final oldCall = _currentCall;
    _currentCall = null;
    _currentCallId = callId;
    _state = CallManagerState.connecting;
    _safeNotify();

    oldCall?.leave();

    _connectCall(callId, version);
  }

  Future<void> _connectCall(String callId, int version) async {
    final call = StreamVideo.instance.makeCall(
      callType: StreamCallType.liveStream(),
      id: callId,
    );

    _currentCall = call;

    try {
      final getResult = await call.getOrCreate();
      if (_isStale(version, call)) return;
      if (getResult.isFailure) { _fail(version); return; }

      final joinResult = await call.join(
        connectOptions: CallConnectOptions(
          camera: TrackOption.disabled(),
          microphone: TrackOption.disabled(),
        ),
      );
      if (_isStale(version, call)) return;
      if (joinResult.isFailure) { _fail(version); return; }
    } catch (_) {
      if (_isStale(version, call)) return;
      _fail(version);
      return;
    }

    _state = CallManagerState.connected;
    _safeNotify();
  }

  bool _isStale(int version, Call call) {
    if (version != _version || _disposed) {
      call.leave();
      return true;
    }
    return false;
  }

  void _fail(int version) {
    if (version != _version || _disposed) return;
    _state = CallManagerState.failure;
    _safeNotify();
  }

  void _safeNotify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _currentCall?.leave();
    super.dispose();
  }
}

enum CallManagerState { idle, connecting, connected, failure }
```

### Wiring the `PageView`

```dart
PageView.builder(
  controller: _pageController,
  scrollDirection: Axis.vertical,
  itemCount: AppConfig.channels.length,
  onPageChanged: (index) =>
      _callManager.switchToCall(AppConfig.channels[index].id),
  itemBuilder: (context, index) => _LivestreamPage(
    channel: AppConfig.channels[index],
    callManager: _callManager,
  ),
)
```

In `initState`, prime the first channel:

```dart
@override
void initState() {
  super.initState();
  _pageController = PageController();
  _callManager.switchToCall(AppConfig.channels[0].id);
}
```

### Per-page rendering

```dart
ListenableBuilder(
  listenable: callManager,
  builder: (context, _) {
    final isActive    = callManager.currentCallId == channel.id;
    final isConnected = isActive && callManager.state == CallManagerState.connected;
    final isConnecting = isActive && callManager.state == CallManagerState.connecting;

    if (isConnected && callManager.currentCall != null) {
      return _ActiveVideo(call: callManager.currentCall!);
    }
    if (isConnecting) return const _ConnectingOverlay();
    return const _OfflineOverlay();
  },
)
```

A complete reference app lives at
[`packages/video_livestream_feed/`](https://github.com/GetStream/flutter-video-samples/tree/main/packages/video_livestream_feed)
in the [flutter-video-samples](https://github.com/GetStream/flutter-video-samples)
repo.

---

## Critical rules

1. **Viewers join with camera & mic DISABLED.**
2. **Viewers use `LivestreamPlayer`** — never `StreamCallContent` or
   `StreamCallContainer`.
3. **Hosts filter participants by `isVideoEnabled`** so viewer tiles don't
   show in the broadcast layout.
4. **Host must call `goLive()`** — `liveStream` and `audio_room` start
   backstage.
5. **Always `leave()` the old call before joining a new one.** Only one
   SFU connection at a time.
6. **Use a version counter for rapid switching**, not a debounced queue —
   in-flight connections check staleness after each `await`.
7. **Always check `.isFailure` on `getOrCreate()` and `join()`** results
   instead of assuming success.
8. **Specify `role: 'host'`** in `MemberRequest` for the broadcaster, or
   they may not have permission to go live.

---

## Common pitfalls

| Mistake | Fix |
|---|---|
| Using `StreamCallContent` for the viewer | Use `LivestreamPlayer` — purpose-built for livestream consumption. |
| Using `StreamCallContainer` in a feed | Use `LivestreamPlayer`; manage join/leave via `CallManager`. |
| Showing all participants in host view | Filter via `callParticipantsWidgetBuilder` + `isVideoEnabled`. |
| Filtering by `roles.contains('host')` | Filter by `isVideoEnabled` instead — robust regardless of role assignment. |
| Joining without leaving the previous call | Always `leave()` first. |
| Checking `otherParticipants.isNotEmpty` for "live" | Check `otherParticipants.where((p) => p.isVideoEnabled).isNotEmpty`. |
| Debounced queue for switching | Use a version counter + staleness checks after each `await`. |
| Skipping `.isFailure` checks | `getOrCreate()` and `join()` return result objects — handle failures. |
| Re-connecting on every swipe | Skip if `_currentCallId == callId` and not in failure state. |
| Forgetting `goLive()` | Viewers see nothing until the host goes live. |
| Missing `role: 'host'` | Host may lack permission to go live. |
| `notifyListeners()` after dispose | Guard with a `_disposed` flag and a `_safeNotify()` helper. |

---

## Key APIs

| API | Purpose |
|---|---|
| `StreamCallType.liveStream()` / `.audioRoom()` | Call type factories |
| `MemberRequest(userId:, role: 'host')` | Assign host role |
| `call.goLive()` / `.stopLive()` | Backstage transitions |
| `call.startHLS()` / `.stopHLS()` | HLS broadcasting |
| `call.state.value.egress.hlsPlaylistUrl` | HLS playback URL |
| `LivestreamPlayer(call:, onCallDisconnected:)` | Pre-built viewer |
| `StreamCallContent` + `callParticipantsWidgetBuilder` | Host broadcast UI |
| `StreamCallParticipants(call:, participants:)` | Render filtered tile list |
| `PartialCallStateBuilder` | Reactive state slice |
| `CallState.callParticipants` / `.otherParticipants` / `.isBackstage` | State |
| `CallParticipantState.isVideoEnabled` | Filter for active broadcasters |
| `ToggleMicrophoneOption` / `ToggleCameraOption` / `FlipCameraOption` | Controls |

---

## When to consult docs

If a request goes beyond this skill — recording layouts, transcription,
viewer-count APIs, RTMP ingest, dashboard call-type configuration, custom
backstage screens — fetch the relevant page from
<https://getstream.io/video/docs/flutter/livestreaming/> or the broader
<https://getstream.io/video/docs/flutter/> documentation tree before
guessing.

## When to defer

- **Core SDK setup, install, init, permissions, generic calls** →
  `stream-video-flutter`.
- **Ringing, push, CallKit** → `stream-video-flutter-ringing`.

## Tone & style

Architectural and code-first. Lead with the right widget choice
(`LivestreamPlayer` vs `StreamCallContent`) — it determines almost
everything else. When the user's design conflicts with the SDK's
opinionated viewer / host split, call it out directly.

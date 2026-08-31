---
name: video-smoke-test
description: >
  Run a basic smoke test of the Stream Video Flutter SDK by driving the dogfooding app through a
  two-party call on an Android emulator and an iOS simulator. Covers join, mute/unmute, microphone
  input and dominant speaker, speaking-while-muted detection, camera on/off, reactions, video
  filter, stats, chat, Picture-in-Picture, reconnect after network loss, deep link joins, and clean
  teardown. Does not test ringing.
disable-model-invocation: true
allowed-tools:
  - Bash
  - Read
  - mcp__Claude_Code_iOS_Simulator__control
---

# Video SDK smoke test

Drive the dogfooding app through one two-party call and assert SDK behaviour from logs.
Android is fully scripted. iOS is driven by you through the simulator tool using the
**exact coordinates in the tables below**.

Budget: ~2 minutes of checks once both apps are built. The iOS build dominates a cold run.

## Prerequisites

Three things live outside the scripts, and without them the audio checks fail:

- **Host microphone access on the AVD**, and **restart the emulator after enabling it**. Emulator
  window > Extended controls (`...`) > Microphone > **"Enable Host Microphone Access"**. The
  setting only takes effect on a fresh boot — enabling it on a running emulator leaves the
  microphone silent, which is exactly what a broken SDK looks like. The emulator console has no
  microphone command, so nothing can verify this for you.
- **macOS must allow the emulator to use the microphone**: System Settings > Privacy & Security >
  Microphone. Easy to miss, because macOS does not fail an unpermitted recording — it returns
  silence.
- **The host must be able to make an audible noise.** The audio checks speak through the Mac's
  speakers (`say`) so the host microphone has something to hear. Output volume up, input not muted,
  no headphones in the way.

Even with all three in place, microphone input into the emulator is **intermittent**: the same AVD
instance delivered audio for two runs and then went silent for a third with no configuration
change, and only an emulator restart brought it back. So `dominant-speaker-a2b` and
`swm-detect-android` report `KNOWN-FAIL` — *not verified this run* — when no audio arrives, rather
than failing the run. A `PASS` on either is real news: it means host sound travelled the whole
path. A `KNOWN-FAIL` means check the three things above, and restart the emulator. No other check
is affected either way.

## Rules — read before doing anything

1. **Do not investigate failures during the run.** A check fails, you record it and move on.
   Root-cause only if the user asks afterwards.
2. **Do not read logs looking for problems.** The scripts assert what matters. Do not grep for
   extra errors, do not comment on warnings.
3. **Do not interpret screenshots.** They are evidence for the human. The only screenshot you look
   at is the one in step 4.
4. **Do not improvise coordinates.** Every tap is in a table here. If a tap misses, report `FAIL`
   for that step and continue — do not hunt for the control.
5. **Do not deviate from the step order.** State depends on it: sheets stay open, keyboards move
   layouts.
6. **Never send a second BACK press on Android inside a call.** One closes the keyboard; a second
   closes the sheet; a third leaves the call.
7. **Out of scope:** ringing, CallKit, push, screen sharing. Do not test them and do not list them
   as gaps.
8. If a setup phase (preflight, launch, android_join) exits non-zero, **stop** and report the single
   `FATAL:` line. Do not repair the environment beyond what the scripts already do.

## Known non-issues — never report these as findings

- **iOS simulator has no camera.** iOS joins audio-only with the camera control already red. Camera
  on/off is an Android-only check.
- **iOS simulator supports neither PiP nor CallKit.** PiP is Android-only here.
- **Emulator camera output is blocky colour bands.** That is the AVD's synthetic camera.
- **Krisp logs `Failed to set wt file`** on the emulator. Emulator-specific.
- **A browsable `https` intent opens Chrome, not the app.** A debug build is not a verified App
  Links handler, so `finish.sh` names the activity explicitly. Not a deep link defect.

## Steps

### 1. Preflight

```bash
.claude/skills/video-smoke-test/scripts/preflight.sh
```

Pins the emulator serial (so a plugged-in phone cannot break the run), forces Flutter's Swift
Package Manager off (the iOS build cannot link with it on), and pre-grants mic/camera/notification/
phone permissions on both platforms so **no system dialog can swallow a tap**. On `FATAL:`, relay
that line and stop.

### 2. Launch both apps

```bash
.claude/skills/video-smoke-test/scripts/launch.sh
```

Blocks until both report a Dart VM Service. Cold iOS run ~10 min (CocoaPods + compile); warm ~1 min.
Wipes Android app state so the login screen is guaranteed. It waits — do not poll it.

### 3. Android: log in and create the call

```bash
.claude/skills/video-smoke-test/scripts/android_join.sh
```

Prints `CALL_ID=<id>`. Keep it for step 4. A `retry n/4` line is normal, not a failure.

### 4. iOS: join the same call

Take one screenshot. Confirm the tool reports a **402x874** coordinate space — if not, stop and ask
for an iPhone 17 simulator, because these coordinates will not work.

Then pick a branch:

- Shows **"Enter Username"** → do 4a, then 4b.
- Shows **"Start New Call"** with an **empty** call-id field → do 4b only.
- Shows a **non-empty call-id field** → the app is not freshly launched. The field cannot be cleared
  with the tools available, so **re-run `launch.sh`** and start step 4 again.

**4a. Log in**

| # | Action | Coordinate |
|---|--------|-----------|
| 1 | tap username field | `201, 532` |
| 2 | type | `smoke_b1` |
| 3 | tap "Sign up with username" | `201, 594` |

**4b. Join by call ID**

| # | Action | Coordinate |
|---|--------|-----------|
| 1 | tap "Enter call id" field | `131, 622` |
| 2 | type | the `CALL_ID` from step 3 |
| 3 | tap "Join call" | `325, 621` |
| 4 | tap "Start a test call" | `201, 774` |

Confirm with **one** command — do not screenshot to check:

```bash
grep -c sfuJoinResponse /tmp/stream-video-smoke/ios.log
```

Non-zero means joined. Zero means `FAIL join-ios`; record it and continue anyway.

### 5. Android: all in-call checks

```bash
.claude/skills/video-smoke-test/scripts/android_checks.sh
```

Microphone level and dominant speaker, mute/unmute with speaking-while-muted detection, camera
off/on, reaction, blur filter, stats, PiP enter+restore, the full network-loss reconnect cycle, and
chat send plus its delivery to iOS. One `PASS`/`FAIL` line per check, ~3 min. Read only those lines.

The audio checks talk out loud through the Mac's speakers — that is the script, not a stray
process. It stops on its own.

**Run it exactly once per call.** The chat step deliberately leaves the chat sheet open, so a second
run's early taps would land on that sheet instead of the control bar.

### 6. iOS: mute, unmute, chat, leave

Control bar is at **y = 818**. If iOS is not showing the call, tap the app icon at `247, 223`.

Step 7 is not optional. The chat sheet opened in step 3 covers the lower screen and dims the
rest; END CALL is visible above it but sits under the sheet's scrim, so tapping it just dismisses
the sheet and the call keeps running. Swipe the sheet away first.

| # | Action | Coordinate | Why |
|---|--------|-----------|-----|
| 1 | tap mic (mute) | `158, 818` | must take the Apple ADM mute path, not stop the track |
| 2 | wait ~2s, tap mic (unmute) | `158, 818` | |
| 3 | tap chat | `371, 818` | opens the chat sheet |
| 4 | tap composer | `227, 815` | |
| 5 | type | `smoke_ios_1` | exact string — `finish.sh` greps for it |
| 6 | tap send | `361, 824` | |
| 7 | swipe down `201, 325` → `201, 790` | grabber → below | closes the chat sheet; END CALL is behind its scrim and a tap there is eaten by the sheet |
| 8 | tap end call | `371, 90` | |
| 9 | dismiss the feedback modal | `362, 181` | a "We Value Your Feedback!" sheet appears after every leave and blocks the screen |

Do not verify any of this yourself — `finish.sh` asserts it from the log.

### 7. Finish

```bash
.claude/skills/video-smoke-test/scripts/finish.sh
```

Asserts the iOS-side behaviour, the iOS chat send and its delivery to Android, Android leave, then
joins the same call again through a deep link and leaves it, and finally that no call foreground
service or ongoing-call notification leaked. Prints the summary; exits non-zero on unexpected failure.
It also stops the run's background processes.

### If the run is abandoned partway

A failed phase is normally retried, so the phases between `launch.sh` and `finish.sh` deliberately
leave the apps running — killing them would cost another full build. When a run is given up on
instead of retried, run:

```bash
.claude/skills/video-smoke-test/scripts/stop.sh
```

It stops `adb logcat` and both `flutter run` supervisors (with their build children), and re-enables
the emulator's network in case the run died inside the reconnect step. Logs and screenshots are
kept. `launch.sh` also calls it implicitly at the start of the next run.

## Reporting

Terminal only, in this order, nothing more:

1. One line: `N passed, N failed, N known-fail` plus wall-clock.
2. **The table `finish.sh` prints, relayed verbatim** — one row per check, what it verifies, and
   whether it works. Do not rebuild it by hand, do not reorder or reword rows, do not drop the
   rows that passed: the point is that the reader sees the whole surface that was covered, not
   only the damage.
3. One sentence per failure on what it means for the SDK. No speculation about cause.
4. The screenshot directory path.

If everything passed, the table plus one sentence is the whole report. No padding, no
recommendations, no suggested follow-ups unless something failed. Publish an artifact **only if
asked**.

## What each check proves

| id | proves |
|----|--------|
| `join-android` / `join-ios` | SFU join handshake completes on both platforms |
| `publish-audio-*` / `publish-video-android` | local tracks reach the SFU |
| `peer-seen-*` | both clients see each other in call state |
| `dominant-speaker-a2b` | sound from the emulator's microphone travels capture → publish → SFU → peer, and the peer marks the speaking participant dominant — the state the "who is talking" indicator binds to |
| `mute-android` / `unmute-android` | mute unpublishes and republishes the audio track |
| `swm-detection-started-android` / `swm-detection-stopped-android` | muting arms the speaking-while-muted recognizer and unmuting tears it down |
| `swm-detect-android` | speech while muted actually fires the recognizer (needs the microphone prerequisites) |
| `adm-mute-ios` / `adm-unmute-ios` | iOS mutes at the audio-device-module level and keeps the track alive — the path speaking-while-muted detection depends on |
| `camera-off-android` / `camera-on-android` | video track unpublish/republish |
| `reaction-android` | custom event round-trips through the coordinator |
| `filter-android` | video frame processor initialises on the capture pipeline |
| `stats-android` | the stats route opens and closes without hanging or dropping the call (numbers are for a human, in shot 13) |
| `pip-android` / `pip-restore-android` | PiP entry and restore keep the call alive |
| `reconnect-detect-android` | network loss triggers reconnect / ICE restart scheduling |
| `reconnect-recover-android` | the call recovers and rejoins the SFU (fast-vs-full strategy is reported as info, not asserted — it legitimately varies) |
| `chat-send-android` / `chat-send-ios` | the call's chat channel accepts an outgoing message |
| `chat-a2b` / `chat-b2a` | the peer actually receives it — a `message.new` event lands on the other client |
| `deeplink-route-android` | a `/join/<callId>` link resolves the call and lands on its lobby, with no router error and no emptied navigation stack |
| `deeplink-join-android` | the call reached through a link joins the SFU |
| `deeplink-leave-android` | leaving a call a link opened tears down without emptying the stack |
| `leave-*` | call teardown runs |
| `no-service-leak` / `no-notif-leak` | no orphaned call foreground service or ongoing-call notification |

## Traps already handled (do not "fix" these)

These are encoded in the scripts for reasons found the hard way:

- Android username must contain a digit/underscore — the emulator IME autocorrects `smokea` to
  `smokes`.
- The soft keyboard covers the sign-up button; it is dismissed before tapping.
- Navigation taps use `tap_until` (retry until the log confirms), never a fixed `sleep`.
- Selecting a **filter leaves the options sheet open**; selecting a **reaction closes it**. The stats
  step relies on the sheet still being open — do not add a `MORE` tap between them.
- **A modal sheet eats the first tap outside it.** The chat sheet (iOS and Android) and the options
  sheet (Android) are modal: a tap on the dimmed area only closes that sheet, it does not reach the
  control underneath. iOS closes the chat sheet with a swipe (step 6, row 7); Android's `finish.sh`
  uses `tap_until` on END CALL so the first taps peel off the sheets and the last one lands.
- The stats screen is left via the **top-left** back arrow. The top-right X sits ~16px from END CALL,
  and if stats ever fails to open that tap silently ends the call.
- PiP is detected from the task's current `mode=pinned`, never from a `PICTURE_IN_PICTURE_ENTER`
  logcat line (stale forever) or from `windowingMode=pinned` (does not match in practice).
- **Chat receipt is asserted from the receiver's `message.new` event, never from the message text.**
  No client logs the body of a message it *receives*, so grepping the peer's log for the text can
  never pass — that assertion, not the SDK, is what made chat look like a "send-only" defect. Each
  direction is checked in a window marked before that send, because a sender gets a `message.new`
  for its own message too.
- **The Android send tap is retried across both composer rows** (`android_chat_send`): the soft
  keyboard does not always open, which moves the SEND button, and a missed tap leaves the text in
  the composer as a draft. Do not assert an Android send by grepping logcat for the bare message
  text — logcat echoes the `input text` command itself, so that passes with nothing sent.
- **The service-leak check names `StreamCallService` and polls for 25s.** `grep ServiceRecord` also
  matches the app's unrelated short-lived services and a call service still unwinding, so it reports
  normal teardown as a leak.
- **The speaking-while-muted checks live inside the mute step and cannot be moved**: the recognizer
  is only armed while the user is muted. They read the recognizer's own log lines
  (`[startRecognition]`, `isSpeakingWhileMuted: true`, `[stopRecognition]`), because the detection
  surfaces in the app only as a snackbar, which no log records.
- **The dominant-speaker check reads the iOS log while Android speaks.** The SFU reports a
  participant's level and dominance to the *other* participants, not back to the speaker: Android
  never sees its own, so asserting on the Android log looks right and fails with a perfectly good
  microphone. It is the server's own measurement, so it cannot pass with a dead microphone the way
  a track-publish line can.
- **Do not add an audio-level assertion.** Levels arrive as high-frequency events that update call
  state without logging, and `audioLevel:` surfaces only inside the state dumps that track
  publish/unpublish print — so a speech window usually contains nothing to match even with a
  working microphone. That is what made an earlier `audio-level` check fail while the microphone was
  demonstrably fine. Dominant speaker is the low-frequency signal that is actually logged.
- **A successful speaking-while-muted detection puts a snackbar over the control bar.** The app's
  floating "You are muted. Unmute to speak." covers the bottom bar, so the next tap hits the
  snackbar instead of the mic button. The mute step waits for it to expire — without that, unmute,
  camera-on and the filter step all fail for reasons that have nothing to do with them.
- **The deep link is delivered to the activity by name**, not as a browsable intent: a debug build
  is not a verified App Links handler, so a plain `am start` opens Chrome and the check would fail
  for a reason that has nothing to do with the SDK.
- **The deep link phase runs after the call is over**, so a link cannot disturb the in-call checks,
  and before the leak checks, so those still judge a finished call.
- **Android runtime permissions are granted twice, and the second time is the one that counts.**
  `flutter run`'s install resets them, so a grant from before it silently does nothing and the
  camera dialog appears on the first Start New Call — which reads as "Lobby did not open".
  `launch.sh` therefore grants again once both apps report a VM service, and warns if a grant did
  not take. (The single `retry 1/4` line on Start New Call is unrelated: the first tap lands while
  the home screen is still building. `tap_until` exists for exactly that.)
- `ANDROID_SERIAL` is pinned in preflight; otherwise plugging in a phone mid-run makes every `adb`
  call ambiguous and screenshots come back 0 bytes.

## Files

`/tmp/stream-video-smoke/`: `results.tsv`, `android.log`, `ios.log`, `shots/*.png`. Reset by
`launch.sh`, so re-running it after a failed attempt starts a clean report.
`service-leak.txt` is written only when `no-service-leak` fails.

---
name: video-ringing-test
description: >
  Run a smoke test of the Stream Video Flutter ringing flow on an Android emulator by placing real
  ringing calls through the coordinator and asserting what the SDK does with them. Covers push
  delivery, the incoming call notification, Telecom registration, accept, decline and ring-out with a
  missed call notification, the Android 17 ringing foreground service,
  and leak-free teardown — with the app foregrounded, backgrounded and terminated. Rings come from a
  real second instance of the app through its Direct Call button, on a second emulator or the iOS
  simulator. The device under test is always Android: iOS CallKit cannot be tested on a simulator.
disable-model-invocation: true
allowed-tools:
  - Bash
  - Read
---

# Ringing flow smoke test

Place real ringing calls at a dogfooding app on an emulator and assert the SDK's response from
native logs and live `dumpsys` probes. Fully scripted — there are no coordinate tables to follow
and no iOS half.

Budget: ~4 minutes of checks after the build. Five rings, one per app state.

## How this differs from `video-smoke-test`

That skill drives a two-party call under `flutter run` and explicitly excludes ringing. This one
inverts three of its choices, each for a reason that matters here:

- **The app runs standalone** (`adb install` + `am start`), never under `flutter run`. The whole
  point is to kill the app and have a push revive it; `flutter run` owns the process and detaches
  when it dies, taking the run with it.
- **The ring comes from a real second instance of the app**, through its Direct Call button, so call
  creation and ring targeting go through the SDK instead of being simulated. That instance runs on a
  second emulator by default, or on the iOS simulator.
- **Taps on the ringing UI resolve by resource id** through `uiautomator dump`, not fixed
  coordinates. The full-screen incoming call and the notification are native Android views, so their
  ids (`ivAcceptCall`, `llDecline`, …) are visible and stable across screen sizes. The caller's
  Flutter screens are not — Flutter publishes no semantics tree unless an accessibility service is
  running — so the Direct Call flow is the one place coordinates are unavoidable.

It reuses `video-smoke-test/scripts/lib.sh` for results, log assertions, geometry and permission
grants, and its login sequence. Both skills must not run at once — each pins the emulator and wipes
app state.

## Prerequisites

- **Two booted emulators**, both Play-enabled: the first is the device under test, the second runs
  the caller. Without Google Play services FCM cannot deliver and every check fails for one reason
  that has nothing to do with the SDK. Preflight refuses to run otherwise.
  With `RING_CALLER_PLATFORM=ios`, boot **one** emulator and one iPhone 17 simulator instead.
- **API 26 or newer** on the device under test. Below that Telecom does not exist.
- **Network access to `pronto.getstream.io`** for token minting.
- **No host microphone or speakers.** None of the traps that make the other skill's audio checks
  intermittent apply here.

Optional: an **API 37 emulator** to cover the Android 17 ringing foreground service. On anything
lower those checks report `SKIP`, which is correct rather than a gap.

## Rules — read before doing anything

1. **Do not investigate failures during the run.** Record and move on. Root-cause only if asked.
2. **Do not read logs looking for problems.** The scripts assert what matters. Do not grep for extra
   errors and do not comment on warnings.
3. **Do not interpret screenshots.** They are evidence for the human.
4. **Each `checks.sh` run places a real call.** Do not run a state twice to "confirm" a pass.
5. If a setup phase (`preflight.sh`, `install.sh`) exits non-zero, **stop** and relay the single
   `FATAL:` line. Do not repair the environment beyond what the scripts already do.
6. **Out of scope:** iOS, CallKit, in-call behaviour (mute, camera, chat, PiP, reconnect). Do not
   test them and do not list them as gaps — `video-smoke-test` covers the in-call surface.

## Known non-issues — never report these as findings

- **No entry appears in the phone's call history.** Correct, and not a defect. Self-managed Telecom
  calls are excluded from the system `CallLog` unless the `PhoneAccount` carries
  `EXTRA_LOG_SELF_MANAGED_CALLS`, and `androidx.core.telecom` builds that account internally with no
  way to set it. The React Native and native Android SDKs behave identically.
- **`ring-fgs-*` reports `SKIP` below API 37.** The ringing foreground service is gated on
  Android 17 by design.
- **The full-screen incoming call UI is never exercised.** Android only shows it over a keyguard, and
  no scenario here locks the device, so every ring resolves through its notification. Verify the
  full-screen UI by hand.
- **`telecom-*` reports `SKIP`.** Telecom is opt-in via `AndroidPushConfiguration.telecom`. The run
  reports this once as `telecom-config` rather than silently passing checks that assert nothing.
- **Answering from a watch or Bluetooth headset is not covered.** The emulator has no Wear pairing
  or real Bluetooth, so the system-originated answer path (`source=SYS`) cannot be reached here. It
  stays a manual check.
- **The ringtone's audibility is not asserted.** Audio cannot be heard over adb. `ring-fgs-type-*`
  asserts the mechanism the Android 17 fix actually changes — a `phoneCall` foreground service
  rather than `shortService` — which is the assertable half.

## Steps

### 1. Preflight

```bash
.claude/skills/video-ringing-test/scripts/preflight.sh
```

Pins the emulator, refuses without Play services or below API 26, checks the token endpoint is
reachable, and grants runtime permissions plus the `USE_FULL_SCREEN_INTENT` appop on API 34+. On
`FATAL:`, relay that line and stop.

### 2. Build, install, register for push

```bash
.claude/skills/video-ringing-test/scripts/install.sh
```

Builds the APK once and installs it on both devices. Logs the callee in and waits for
`createDevice` — the run's foundation, because the ring is delivered to the token registered there —
then logs the caller in on its own device. Also reports whether Telecom is enabled.

The caller has to log in for two reasons: it is what places the ring, and it is what brings the
caller *user* into existence. The coordinator rejects a ringing call whose caller or members do not
exist, and minting a token does not create a user — connecting does.

Cold build ~4 min, warm ~1 min. It waits — do not poll it.

**2b. iOS caller only.** With `RING_CALLER_PLATFORM=ios`, `install.sh` prints `ACTION REQUIRED` and
you log the simulator in yourself. Take one screenshot first and confirm the tool reports a
**402x874** coordinate space; if it does not, stop and ask for an iPhone 17 simulator.

| # | Action | Coordinate |
|---|--------|-----------|
| 1 | tap username field | `201, 532` |
| 2 | type | the caller id printed by preflight (`ring_caller1` by default) |
| 3 | tap "Sign up with username" | `201, 594` |

Rows 1 and 3 are the smoke test's verified login coordinates.

If the simulator is **already logged in** as some other user, that user is the caller — either log
out and in as `RING_CALLER`, or point the run at the existing one with
`RING_CALLER=<that user> ./preflight.sh`. The two only have to agree because teardown mints a token
for `RING_CALLER` to end calls; a mismatch leaves calls to expire on their own.

### 3. One ring per app state

Run all five, in this order. Each is independent and can be retried alone.

A case is `<app-state>-<action>`. The two are orthogonal: the app state decides how the ring is
surfaced, the action decides how it ends. The six that make up the core matrix:

```bash
for state in foreground background terminated; do
  for action in accept decline timeout; do
    .claude/skills/video-ringing-test/scripts/checks.sh "$state-$action"
  done
done
```

Run them one at a time when driving the ring by hand from the iOS simulator — each waits for its own
ring.

| app-state | the app is | how the ring appears |
|-----------|-----------|----------------------|
| `foreground` | open and visible | a shade notification and a status-bar icon — the SDK shows no ring UI of its own |
| `background` | running, home pressed | a heads-up notification |
| `terminated` | process killed, revived by the push | notification, after a cold start |

| action | ends the ring by | additionally asserts |
|--------|------------------|----------------------|
| `accept` | tapping the answer action | Telecom recorded the answer as app-initiated |
| `decline` | tapping the decline action | Telecom disconnected with `REJECTED` |
| `timeout` | nothing — the ring expires | **a missed call notification is shown** |

`terminated-*` is the one that matters most: it is the only state where the push itself has to start
the process, and the only one that exercises the persisted-configuration path.

A locked-screen state is **deliberately out of scope**. It needs a PIN configured on the AVD to
produce a keyguard at all, doze disabled so FCM is not deferred while the screen is off, and a
coordinate fallback because `uiautomator` reports only `com.android.systemui` behind a keyguard and
cannot see the full-screen call UI. That is a lot of harness for one state, and it was slow and
flaky enough to be worth testing by hand instead.

**3b. iOS caller only.** Each `checks.sh` run prints `>>> RING NOW` and then waits up to 90s.
**Wait for that line before touching the simulator.** Ringing earlier does not help and actively
breaks a `timeout` case: those clear existing notifications first, and an early ring gets cleared
along with them, after which the run waits out its 90s for a call that is already gone.

Place the ring during the wait:

Coordinates below are verified on an **iPhone 17e (390x844pt)**. Confirm the panel reports that
space before tapping; on another device, screenshot and re-measure.

| # | Action | Coordinate | Note |
|---|--------|-----------|------|
| 0 | dismiss "We Value Your Feedback!" if present | `350, 144` | see below — it blocks every tap |
| 1 | tap "Direct Call" | `195, 742` | below "Start New Call" |
| 2 | tap the "User ID" field | `195, 437` | hint text is `User ID` |
| 3 | type | — | the callee id (`ring_callee1` by default) |
| 4 | tap "Call" | `251, 502` | right-aligned in the dialog |

**Step 0 is not optional after the first accepted call.** The app shows a "We Value Your Feedback!"
modal every time a call ends, and it covers the whole home screen — the Direct Call taps then land on
its star rating instead, no ring is placed, and the state fails with `no ring arrived within 90s`
for a reason that has nothing to do with the SDK. Screenshot before ringing if unsure.

The script asserts delivery on the Android side, so a missed tap fails the state rather than passing
quietly.

### 4. Finish

```bash
.claude/skills/video-ringing-test/scripts/finish.sh
```

Asserts nothing leaked once every ring is over — no ringing foreground service, no posted
notification, no call left in Telecom — checks for platform-channel type errors and native crashes,
then prints two tables and stops the background logcat. Exits non-zero if anything failed.

The first table is one row per check: its id, result, and what it proves. The second is the scenario
matrix, which is the answer:

```
               accept         decline        timeout
-------------- -------------- -------------- --------------
foreground     PASS 10/10     PASS 10/10     PASS 11/11
background     PASS 10/10     PASS 10/10     PASS 11/11
terminated     PASS 12/12     PASS 12/12     PASS 13/13
```

A scenario is PASS only when every check carrying its suffix passed; one failure anywhere in it makes
the whole scenario FAIL.

### If the run is abandoned partway

Phases deliberately leave the app installed and logged in so a single state can be retried without
another build. When giving up instead of retrying:

```bash
.claude/skills/video-ringing-test/scripts/stop.sh
```

Stops logcat, ends any call still ringing, and restores the screen. Logs and screenshots are kept.

## Calibrating the caller's Direct Call taps

Four coordinates drive the caller's Direct Call flow. They are **derived from the widget tree** in
`dogfooding/lib/screens/home_screen.dart`, not confirmed on a device, because Flutter screens cannot
be addressed by resource id. Verify them once per AVD model:

```bash
.claude/skills/video-ringing-test/scripts/calibrate.sh
```

It walks the flow without placing a call and screenshots each step, then prints the current values
and the scale factor to convert a measured pixel back into the 1080x2424 reference space. Correct
`A_DIRECT_*` / `A_DLG_*` in `scripts/lib.sh` and re-run.

A wrong value is not silent: `ring_from_caller_app` asserts `getOrCreateCall` in the caller's log,
retries the whole sequence three times, and then fails pointing at this section.

## Release mode

Debug is the default because release signing needs `dogfooding/android/key.properties`, which is not
in the repo. Debug does not weaken any check here — every assertion reads native logcat or a
`dumpsys` probe, neither of which depends on the Dart build mode.

Run release when a keystore is available, because it additionally proves R8 kept the plugin
(`consumer-rules.pro`) and that the timings hold without JIT warmup:

```bash
RING_BUILD_MODE=release .claude/skills/video-ringing-test/scripts/preflight.sh
RING_BUILD_MODE=release .claude/skills/video-ringing-test/scripts/install.sh
RING_BUILD_MODE=release .claude/skills/video-ringing-test/scripts/checks.sh terminated
```

`RING_BUILD_MODE` also selects the package name, so it must be set for every phase of a run.

## Reporting

Terminal only, in this order, nothing more:

1. One line: `N passed, N failed, N skipped, N known-fail` plus wall-clock.
2. **The scenario matrix `finish.sh` prints, relayed verbatim**, followed by the per-check table.
   Do not rebuild either, do not reorder them, and do not drop the rows that passed — the reader
   needs to see the whole surface that was covered, not only the damage.
3. One sentence per failure on what it means for the SDK. No speculation about cause.
4. The screenshot directory path.

If everything passed, the table plus one sentence is the whole report. Publish an artifact **only if
asked**.

## What each check proves

| id | proves |
|----|--------|
| `login` | the callee reaches a connected coordinator session |
| `push-register` | the device token is registered with Stream — without it no ring can arrive |
| `telecom-config` | whether Telecom is opted in, so the `telecom-*` results can be read honestly |
| `caller-login` | the caller instance is connected and can place calls |
| `ring-placed-*` | a real second app instance created a ringing call through Direct Call |
| `ring-delivered-*` | the push arrived and the SDK surfaced an incoming call, in that app state |
| `cold-start-terminated` | a push started the app process from dead |
| `ring-notif-*` | an incoming call notification is actually posted, read from current state |
| `telecom-register-*` | the call reached the Telecom stack and its scope started |
| `telecom-live-*` | the platform holds a self-managed call for this app while it rings |
| `ring-fgs-*` | the ringing service runs in the foreground on Android 17 |
| `ring-fgs-type-*` | it runs as `phoneCall`, not `shortService` — the type Android 17 requires for the ringtone not to be muted |
| `fullscreen-locked` | the full-screen incoming call shows over the keyguard |
| `accept-*` / `decline-*` | the ringing UI's controls resolve the call |
| `telecom-timeout-*` | Telecom is released when a ring expires |
| `telecom-answer-*` | Telecom recorded the answer, tagged app-initiated rather than echoed back |
| `telecom-reject-*` | a decline disconnects Telecom with `REJECTED` (`cause=6`) |
| `timeout-*` | an unanswered ring expires and rejects the call |
| `missed-notif-*` | a missed call notification is shown after a ring nobody answered |
| `ring-fgs-stopped-*` | the ringing foreground service does not outlive the call |
| `no-ring-service-leak` / `no-notif-leak` / `no-telecom-leak` | nothing orphaned once every ring is over |
| `no-channel-type-error` | no platform channel type cast failed — invisible unless something looks for it |
| `no-native-crash` | no native crash during the run |

## Traps already handled (do not "fix" these)

- **`am kill`, never `force-stop`.** `force-stop` puts the package into the stopped state, after
  which whether FCM still reaches it is version dependent — the run would be measuring the harness
  instead of the SDK. `am kill` drops the process and leaves the package runnable, which is what
  swiping the app away actually does.
- **Every probe reads current state, never a historical log line.** logcat keeps events forever, so
  a "notification posted" from an earlier ring would satisfy a check that should have failed. This is
  the same trap the other skill documents for PiP, and it applies to every one of the five rings.
- **Delivery is asserted from the native receiver, not the Dart event.** On a cold start the native
  side runs first, and `debugPrint` — which the SDK's logger uses — throttles to roughly 1KB/s, so
  under `Priority.debug` Dart lines lag seconds behind reality. Anything timing-sensitive must
  assert on a native tag or a `dumpsys` probe.
- **The install re-grants permissions.** `adb install` resets them, so preflight's grant is already
  gone by the time the app launches; `install.sh` grants again. A permission dialog on top of the
  ringing UI eats the accept tap.
- **`USE_FULL_SCREEN_INTENT` is an appop, not a runtime permission.** `pm grant` does not touch it,
  and without it the full-screen incoming call never launches while the app is backgrounded on
  API 34+.
- **Accept and decline are looked for in two places.** The controls live either in the full-screen
  activity (`ivAcceptCall` / `ivDeclineCall`) or the notification's RemoteViews
  (`llAccept` / `llDecline`), depending on how the system surfaced the ring. `accept_ring` tries the
  activity, then expands the shade — a check must not assume which one appeared.
- **`app state` is rebuilt per ring, not carried over.** Accepted calls are cancelled at the end of
  each state so the next ring does not arrive into a live call.
- **Both users must exist server-side before a ring is placed.** A minted token does not create a
  user — connecting does. `install.sh` logs both in, which is what creates them; do not change
  `RING_CALLER`/`RING_CALLEE` without running it again. Skipping the caller login gives
  `404 the user ... does not exist`, and an unknown callee gives
  `400 The following users ... don't exist`.
- **Do not set `RING_CALLER` equal to `RING_CALLEE`.** The coordinator rejects it with
  `Duplicate members passed to get or create call`.
- **Flutter screens are invisible to `uiautomator`.** No semantics tree is published unless an
  accessibility service is running, so `tap_id` works on the native ringing UI and nowhere else.
  Do not "improve" the Direct Call flow to use ids — it will silently find nothing.
- **The whole Direct Call sequence retries, not the last tap.** A missed tap leaves the dialog
  half-filled, and repeating only the final tap cannot recover from that.
- **The call id is read off the callee's log**, because the caller app chooses it. Do not try to
  pass one in.
- **REST is still used for teardown** (`mark_ended`), and only there. Ending a call is not a path
  the SDK is being judged on, and one deterministic request beats three taps that can miss.
- **`SMOKE_DIR` is redirected before sourcing the reused library**, so a ringing run cannot overwrite
  the other skill's results, logs or screenshots.
- **A ring lives about 24 seconds**, not a minute, and the resolution loop is bounded by that
  clock rather than by an attempt count. `checks.sh` stamps `RING_START` when the ring is first
  seen and `_ring_action` stops as soon as it is past `RING_TTL`. This matters more than it looks:
  one attempt through the shade costs ~28s on an idle device and ~73s on a loaded one, because a
  single `uiautomator dump` runs 2-11s and the old path did five of them per attempt. A blind three
  attempts therefore spent minutes tapping at a call that had already died — read as a hang, and
  reported `could not accept` for a mechanism that works. Every state resolves through the UI,
  foreground included.
- **The full-screen incoming call activity only appears on a LOCKED screen.** Android honours a
  full-screen intent when the device is locked and substitutes a heads-up notification when the app
  is merely backgrounded — which is why every scenario here resolves through the shade, and why
  `ivAcceptCall`/`ivDeclineCall` are tried first but essentially never match.
- **A dozing emulator defers FCM.** `preflight.sh` runs `dumpsys deviceidle disable` and `stop.sh`
  restores it; without that a ring can simply never arrive.
- **Notification action labels are not the strings you expect.** They arrive wrapped in Unicode bidi
  isolates with an icon glyph (`text="<LRI><icon> <FSI>Decline<PDI><PDI>"`), and the answer action is
  named after the call type — a video call's accept button reads **"Video"**, not "Accept". Hence the
  substring match and the label alternation.
- **`tap_text` only considers Button nodes.** The notification's app-name line reads "Stream Video
  Calls (Flutter)", so a bare match on "Video" hits that TextView and taps the notification body,
  which launches the app and lets the ring time out.
- **A ring that times out looks like a decline.** The SDK ends an unaccepted call by rejecting it, so
  `lifecycleCallDisconnected`, `Rejected{byUserId: <self>}` and even Telecom's `cause=6` all appear
  without anyone touching the UI. Only assert a *user* decline inside a short window after the tap.
- **`lifecycleCallAccepted` is never logged.** An accept goes
  `lifecycleCallConnecting` -> `lifecycleCallJoining` -> `sfuJoinResponse`; waiting on
  "accepted" fails on an accept that plainly worked.
- **The foreground-service type is `types=0x00000004`**, a bitmask — not `foregroundServiceType=`
  and not a name. Bit `0x4` is phoneCall. Test it as a bit so a combined mask still matches.
- **`telecom_call_present` reads only the `mCalls:` block.** Grepping the whole `dumpsys telecom`
  for the package matches the permanently-registered PhoneAccounts and the `>>>Target PhoneAccount`
  history lines, so it answers true with nothing ringing — which made `telecom-live-*` a false pass
  and `no-telecom-leak` a false failure. A live ring looks like
  `[Call id=…, state=RINGING, handle=streamvideo:…, prop=[ self_mng]], voip=true`.
- **One PhoneAccount is registered for this app**, core-telecom's, and it stays registered for the
  whole process lifetime. It is not evidence of a live call — see `telecom_call_present` above.
- **Whether Telecom is enabled is recorded in env.sh by `install.sh`.** The `[init]` line it is read
  from is only emitted at app startup, and `start_logcat` clears logcat — so re-deriving it later
  silently degrades every `telecom-*` check to SKIP.
- **`finish.sh` deduplicates results by check id, keeping the last.** `results.tsv` is append-only
  and only truncated by `preflight.sh`, so a retried case leaves its earlier failure behind and the
  summary counts it as current.
- **Start `checks.sh` through a supervisor that outlives the shell.** Launching it with a plain `&`
  from a one-shot shell kills the `adb logcat` child when that shell exits, and because the pid file
  survives, the next case does not restart logging and asserts against a frozen log.

## Files

`/tmp/stream-video-ringing/`: `results.tsv`, `android.log` (device under test), `caller.log`,
`build.log`, `env.sh`, `ui.xml` (the last hierarchy dump), `shots/*.png`.

`results.tsv` is truncated by `preflight.sh` and `android.log` by each `start_logcat`, so re-running
from preflight gives a clean report. Screenshots accumulate across runs on purpose — a failed
attempt's evidence is usually what you want to compare against.

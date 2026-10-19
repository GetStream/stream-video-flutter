---
name: video-smoke-test
description: >
  Run a basic smoke test of the Stream Video Flutter SDK by driving the dogfooding app through a
  two-party call on an Android emulator and an iOS simulator. Covers join, mute/unmute, microphone
  input and dominant speaker, speaking-while-muted detection, camera on/off, reactions, raise hand,
  noise cancellation, closed captions, video filter, stats, chat, Picture-in-Picture, reconnect
  after network loss, deep link joins, end-to-end encryption, and clean teardown. Does not test
  ringing.
disable-model-invocation: true
allowed-tools:
  - Bash
  - Read
  - mcp__Claude_Code_iOS_Simulator__control
---

# Video SDK smoke test

Drive the dogfooding app through two two-party calls — one plain, one end-to-end encrypted — and
assert SDK behaviour from logs and from the app's own accessibility tree. Android is fully
scripted. iOS is driven by you through the simulator tool using the **exact coordinates in the
tables below**.

Budget: ~5 minutes of checks once both apps are built. The iOS build dominates a cold run.

The plain call is the diagnostic baseline and the encrypted call is a separate round on top of it.
That split is deliberate: encryption sits on top of the ordinary publish/subscribe path, so running
every check inside an encrypted call would cover more code — and would also turn one E2EE
regression into a wholly red report that hides whatever else broke.

**Where the coordinates come from.** Android controls that carry a semantics label are resolved at
run time from the accessibility tree (`ui_tap`, `ui_find`, `ui_wait` in `lib.sh`), not from a pixel
table, so a screen growing a new section does not break them. Only unlabelled icons — the in-call
control bar, the options-sheet reaction and filter rows, the lobby's encryption switch — are still
coordinates. Reading the tree is not screenshot interpretation: it is exact text from the app's own
semantics, and rule 3 below still stands.

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
2. **Do not read logs looking for problems yourself — `report.sh`'s log digest does it.** The
   scripts assert what matters, and the digest lists every SDK warning/error and app crash that
   `scripts/log_noise.tsv` does not explain. Relay its UNEXPLAINED section; do not grep beyond it
   during the run. If the user asks afterwards, digging into an entry is fair game.
3. **Do not interpret screenshots.** They are evidence for the human. The only screenshots you look
   at are the two in step 4 and the encrypted lobby in step 9, and each is checked against a
   stated expectation rather than read for problems. Reading the Android accessibility tree is not
   screenshot interpretation and is what the scripts already do.
4. **Do not improvise coordinates.** Every tap is in a table here. If a tap misses, report `FAIL`
   for that step and continue — do not hunt for the control.
5. **Do not deviate from the step order.** State depends on it: sheets stay open, keyboards move
   layouts.
6. **Never send a second BACK press on Android inside a call.** One closes the keyboard; a second
   closes the sheet; a third leaves the call.
7. **Out of scope:** ringing, CallKit, push, screen sharing. Do not test them and do not list them
   as gaps.
8. If a setup phase (preflight, launch, android_join, the iOS join in step 4) fails, **stop** and report the
   `FATAL:` or `FAIL` line it ended on. Do not repair the environment beyond what the scripts
   already do — except for one case the scripts themselves warn about: if `launch.sh` printed
   `WARN: permissions not granted`, grant them and retry the phase once, because a permission
   dialog eats the first taps and the failure that follows names the wrong thing.

## Known non-issues — never report these as findings

- **iOS simulator has no camera.** iOS joins audio-only with the camera control already red. Camera
  on/off is an Android-only check.
- **iOS simulator supports neither PiP nor CallKit.** PiP is Android-only here.
- **Emulator camera output is blocky colour bands.** That is the AVD's synthetic camera.
- **Krisp logs `Failed to set wt file`** on the emulator. Emulator-specific.
- **A browsable `https` intent opens Chrome, not the app** on Android. A debug build is not a
  verified App Links handler, so `finish.sh` names the activity explicitly. Not a deep link defect.
  iOS does not have this problem: `open_url` opens the app directly, which is why step 9 uses it.
- **The iOS keyboard autocapitalises** the first character of what you type (`Smoke_ios_1`). The
  assertions match case-insensitively.
- **The iOS lobby's camera control is already red** and the preview shows an avatar. Simulator, no
  camera.

## Steps

### 1. Preflight

```bash
.claude/skills/video-smoke-test/scripts/preflight.sh
```

Pins the emulator serial (so a plugged-in phone cannot break the run), forces Flutter's Swift
Package Manager on (the dogfooding iOS app is SPM-only; with it off Flutter falls back to CocoaPods), and pre-grants mic/camera/notification/
phone permissions on both platforms so system dialogs cannot swallow taps. On `FATAL:`, relay that
line and stop.

Two gaps it does not close, both handled in the step tables rather than here:
the **iOS notification dialog** still appears once after the first login (step 4a row 4), and
`flutter run`'s install resets the **Android** runtime grants — `launch.sh` re-grants afterwards and
prints `WARN: permissions not granted` if that did not take. Heed that warning: an ungranted camera
permission surfaces three steps later as "Lobby did not open".

### 2. Launch both apps

```bash
.claude/skills/video-smoke-test/scripts/launch.sh
```

Blocks until both report a Dart VM Service. Cold iOS run ~10 min (SPM resolve + compile); warm ~1 min.
Wipes Android app state so the login screen is guaranteed. It waits — do not poll it.

### 3. Android: log in and create the call

```bash
.claude/skills/video-smoke-test/scripts/android_join.sh
```

Prints `CALL_ID=<id>`. Keep it for step 4. A `retry n/4` line is normal, not a failure.

The lobby is now where the call is *created*, not just previewed — since #1312 the encryption mode
is fixed at creation, so "Start New Call" only opens the lobby and `getOrCreateCall` fires on
"Start a test call". `lobby-android` and `create-android` are separate checks for that reason.

### 4. iOS: join the same call

Take one screenshot. Confirm the tool reports a **402x874** coordinate space — if not, stop and ask
for an iPhone 17 simulator, because these coordinates will not work.

**Pace every iOS action.** The debug build renders slowly on the simulator: a tap lands, but the
screen it produces can take a second or two to draw, and a screenshot taken straight after it still
shows the old screen. Wait **~2 s after every tap** before the next tap, `text` or screenshot, and
**never repeat a tap because the screen looks unchanged** — the first one almost certainly landed,
and the repeat toggles it back (it closes the chat panel it opened, or lands on whatever the new
screen has at that spot). The same goes for `text`: it only types into a field that already has
focus, so it needs the 2 s after the field tap.

Then pick a branch:

- Shows **"Enter user ID"** → do 4a, then 4b.
- Shows **"Start New Call"** with an **empty** call-id field → do 4b only.
- Shows a **non-empty call-id field** → the app is not freshly launched. The field cannot be cleared
  with the tools available, so **re-run `launch.sh`** and start step 4 again.

**4a. Log in**

| # | Action | Coordinate |
|---|--------|-----------|
| 1 | tap user ID field | `201, 532` |
| 2 | type | `smoke_b1` |
| 3 | tap "Sign up with username" | `201, 594` |
| 4 | wait ~3 s, take one screenshot | |
| 5 | **only if** the notifications dialog is showing: tap **Allow** | `275, 543` |

Rows 4–5: on a simulator that has never granted it, iOS asks for notification permission the first
time the app reaches the home screen, and preflight's pre-grant does not cover it. The dialog sits
over the call-id field, so without dismissing it every tap in 4b lands on the dialog. Once granted it
never comes back — and then a blind tap at `275, 543` lands on the right edge of the call-id field,
which is why it is conditional. This screenshot is checked against that one expectation only.

**4b. Join by call ID**

| # | Action | Coordinate |
|---|--------|-----------|
| 1 | tap "Enter call id" field | `144, 568` |
| 2 | type | the `CALL_ID` from step 3 |
| 3 | wait ~2 s, take one screenshot | check it for an on-screen keyboard — see below |
| 4 | tap "Join call" | `337, 568` |
| 5 | wait ~3 s for the lobby | |
| 6 | tap "Start a test call" | `201, 786` |

Row 3 is checked against one expectation only: **no on-screen keyboard**. Every iOS coordinate in
this skill assumes the Simulator shows none. If one is up, it lifts the layout as soon as a field
has focus — the call-id field, the encrypted lobby's key field, the chat composer — and the taps
that follow land on the keyboard or in empty space while the log shows a perfectly healthy app.
Row 3 is the first moment a field has focus, so it is the cheapest place to catch it. If a keyboard
is showing, **stop**: run `stop.sh`, report `FATAL: iOS on-screen keyboard is showing`, and ask the
user to turn it off in the Simulator — I/O > Keyboard > **Connect Hardware Keyboard** (⇧⌘K) on, and
**Toggle Software Keyboard** (⌘K) off. Both have to be right: the software-keyboard toggle shows the
keyboard even with a hardware keyboard connected. The call-id field now holds text, so the rerun
starts again from step 1.

No swipe: the plain-call lobby fits on screen, and "Start a test call" is fully visible. `201, 778`
— the old position — is the bottom edge of **Direct Call** on the home screen, so a row 4 that
misses turns row 6 into a ringing call.

Confirm with **one** command — do not screenshot to check:

```bash
grep -c sfuJoinResponse /tmp/stream-video-smoke/ios.log
```

Non-zero means joined. Zero means `FAIL join-ios`, and **the run stops there**: every check from
step 5 on is two-party (peer seen, dominant speaker, chat delivery, E2EE decrypt), so with one side
missing they would fail or pass for reasons that say nothing about the SDK. Run `stop.sh` (see "If
the run is abandoned partway") and report the checks that passed so far plus `join-ios` failed. Do
not run `report.sh` — it asserts an iOS leave that never had a join to follow.

### 5. Android: all in-call checks

```bash
.claude/skills/video-smoke-test/scripts/android_checks.sh
```

Microphone level and dominant speaker, mute/unmute with speaking-while-muted detection, camera
off/on, reaction, raise hand, noise cancellation, closed captions, blur filter, stats, PiP
enter+restore, the full network-loss reconnect cycle, and chat send plus its delivery to iOS. One
`PASS`/`FAIL` line per check, ~4 min. Read only those lines.

The audio checks talk out loud through the Mac's speakers — that is the script, not a stray
process. It stops on its own.

**Run it exactly once per call.** The chat step deliberately leaves the chat panel open, so a second
run's early taps would land on that panel instead of the call screen.

### 6. iOS: mute, unmute, chat, leave

Control bar is at **y = 803**: more `36` · mic `84` · camera `132` · participants `318` · chat
`366`. If iOS is not showing the call, tap the app icon at `247, 223`.

Rows 7 and 8 tap the same spot on purpose. Chat is a full-height panel, not a sheet: it replaces the
call's top bar, and its close X sits exactly where END CALL is. The first tap closes chat, the
second ends the call — so wait the full 2 s between them, or the second tap lands mid-transition.

| # | Action | Coordinate | Why |
|---|--------|-----------|-----|
| 1 | tap mic (mute) | `84, 803` | must take the Apple ADM mute path, not stop the track |
| 2 | wait ~2s, tap mic (unmute) | `84, 803` | |
| 3 | tap chat | `366, 803` | opens the chat panel |
| 4 | tap composer | `227, 728` | |
| 5 | type | `smoke_ios_1` | exact string — `finish.sh` greps for it |
| 6 | tap send | `362, 728` | the send arrow appears inside the composer once it has text |
| 7 | tap the chat panel's X | `366, 98` | closes chat; END CALL is hidden while it is open |
| 8 | tap end call | `366, 98` | |
| 9 | dismiss the feedback modal | `362, 201` | a "We Value Your Feedback!" modal appears after every leave and blocks the screen |

With the call screen showing, `227, 728` is the collapsed "Your Meeting is Live!" banner, and a tap
there expands it over the call. That only happens if row 3 did not open chat; leave it, it does not
affect the checks.

Do not verify any of this yourself — `finish.sh` asserts it from the log.

### 7. Finish the plain call

```bash
.claude/skills/video-smoke-test/scripts/finish.sh
```

Asserts the iOS-side behaviour, the iOS chat send and its delivery to Android, Android leave, then
joins the same call again through a deep link and leaves it, and finally that no call foreground
service or ongoing-call notification leaked.

This no longer prints the summary or stops anything — the run continues into the encrypted round,
and `report.sh` (step 11) is the single place that reports.

### 8. Android: create the encrypted call

```bash
.claude/skills/video-smoke-test/scripts/e2ee_start.sh
```

Turns on the lobby's end-to-end-encryption switch, reads back the key the app generated, creates
and joins the call, and asserts the encryption manager and the publish-side encryptors. Prints
`E2EE_CALL_ID=<id>` and `E2EE_KEY=<words>`. Keep both for step 9.

### 9. iOS: join the encrypted call

**Use the deep link, not the call-id field.** The field still holds the plain call's id from step 4
and cannot be cleared with the tools available; the link routes straight to the right lobby and
costs nothing. `open_url` opens the app directly on iOS — it does not bounce to Safari the way the
Android browsable intent does.

| # | Action | Value |
|---|--------|-------|
| 1 | `open_url` | `https://pronto.getstream.io/join/<E2EE_CALL_ID>` |
| 2 | wait ~4 s, take one screenshot | check it against the expectation below |
| 3 | tap the "Shared room key" field | `184, 687` |
| 4 | type | the `E2EE_KEY` from step 8 |
| 5 | tap "Start a test call" | `201, 835` |

No swipe: the whole encrypted lobby fits on screen. "Start a test call" is greyed out until the key
field has text.

The lobby must show a **blue, closed** lock, the title "End-to-end encryption" with no switch, an
empty "Shared room key" field, and the hint "Ask the call creator for the shared key, then enter it
here to join." That is the created-and-encrypted variant. An **open** lock with a switch and "This
call was created without encryption" means the link opened the wrong call — check the id before
typing the key.

Do not screenshot to confirm the join; step 10 asserts it.

### 10. Verify and tear down the encrypted call

```bash
.claude/skills/video-smoke-test/scripts/e2ee_verify.sh
```

Asserts both sides attached a manager, both encrypt what they publish, both attached a **decryptor
for the peer**, and that no decryption failure or cleartext-frame event fired on either. Then
Android leaves.

Then end the call on iOS — it is still in it, because the decryptor assertions need the peer
present while that script runs:

| # | Action | Coordinate |
|---|--------|-----------|
| 1 | tap end call | `366, 98` |
| 2 | dismiss the feedback modal | `362, 201` |

### 11. Report

```bash
.claude/skills/video-smoke-test/scripts/report.sh
```

Asserts the iOS leave, prints the summary table for the whole run, and stops the run's background
processes. Exits non-zero if anything failed.


### If the run is abandoned partway

A failed phase is normally retried, so the phases between `launch.sh` and `report.sh` deliberately
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
2. **The table `report.sh` prints, relayed verbatim** — one row per check, what it verifies, and
   whether it works. Do not rebuild it by hand, do not reorder or reword rows, do not drop the
   rows that passed: the point is that the reader sees the whole surface that was covered, not
   only the damage.
3. One sentence per failure on what it means for the SDK. No speculation about cause.
4. **The log digest's UNEXPLAINED section, relayed verbatim**, then one sentence per entry that
   looks like an SDK defect rather than a known quirk. Skip the EXPECTED section unless asked —
   it is there so a reader can audit what was excused. A `LOG MISSING` / `LOG EMPTY` entry, or
   `LOG DIGEST FAILED TO RUN` in place of the digest, means the logs were never read: relay it as
   such and do not call the run clean.
5. The screenshot directory path.

An UNEXPLAINED entry is not a failure and does not change the exit code. Do **not** add a rule to
`log_noise.tsv` to make one go away on your own: propose it, with the reason, and add it once the
user agrees the line is benign.

If everything passed and the digest has nothing unexplained, the table plus one sentence is the
whole report. No padding, no
recommendations, no suggested follow-ups unless something failed. Publish an artifact **only if
asked**.

## What each check proves

| id | proves |
|----|--------|
| `lobby-android` | "Start New Call" reaches the lobby (asserted from the UI tree — this transition logs nothing) |
| `lobby-e2ee-offered-android` | the lobby offers the encryption switch while the mode is still choosable |
| `create-android` | the lobby creates the call, which is where the encryption mode is fixed |
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
| `raise-hand-android` | the raise-hand row sends a reaction (the type is never logged, so this proves "a reaction", not "that emoji") |
| `noise-cancellation-android` | toggling noise cancellation flips the call's audio-processing state |
| `closed-captions-android` | closed captions start and stop |
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
| `e2ee-enable-android` | the lobby switch arms encryption before the call is created |
| `e2ee-key-android` | the lobby generates a shared key |
| `e2ee-join-*` | both clients join the encrypted call |
| `e2ee-manager-*` | both attach an encryption manager before any peer connection exists |
| `e2ee-encrypt-*` | both attach an encryptor to what they publish — the SDK refuses to publish cleartext, so a miss means no encryptor or a refused publish |
| `e2ee-decrypt-*` | each side attached a decryptor **for the peer** — only possible once the peer's encrypted media actually arrived, so this is the half a single client cannot prove |
| `e2ee-clean-*` | no missing-key, decryption-failure or cleartext-frame event fired on either side while both were in the call |
| `e2ee-teardown-clean-ios` | no cleartext or undecryptable frame reached iOS while the encrypted call was torn down — Android leaves first, so this is media escaping encryption on the way out |
| `e2ee-leave-*` | the encrypted call tears down on both sides |

## Traps already handled (do not "fix" these)

- **`android.log` must have exactly one writer.** A second `adb logcat` appending to the same file
  (one left over from an interrupted run, or another skill's) replays every line, and then the
  line-number marks `wait_log` / `assert_log_since` / `tap_until` take are unsound: a replayed
  `[leave] reason` or `sfuJoinResponse` landing after a mark satisfies a later check. `launch.sh`
  stops any other process writing the file before it starts its own capture. The digest still
  dedupes on the SDK's own timestamp, and its windows are by time, as a second line of defence.

These are encoded in the scripts for reasons found the hard way:

- **The lobby, not the home screen, creates the call.** Since #1312 "Start New Call" only pushes the
  lobby route, because the encryption mode is fixed at creation and the lobby is where it is chosen.
  Waiting for `getOrCreateCall` after that tap — which this skill used to do — can never succeed,
  and the whole run died on "Lobby did not open" against a perfectly healthy app. The transition is
  asserted from the UI tree instead; `getOrCreateCall` is asserted on the lobby's join button.
- **Labelled controls are resolved from the accessibility tree, not from pixels.** The same #1312
  change pushed the lobby's "Start a test call" down 195px and every tap from the old table landed
  in dead space. Do not convert `ui_tap` calls back into coordinates to "make them faster".
- **Enabling encryption grows the Android lobby's card** and moves its join button; Android finds it
  with `ui_scroll_to` and taps it by label. The iOS lobbies fit on screen in both variants, so the
  iOS tables have no swipe.
- **Noise cancellation and closed captions are asserted from the sheet, not the log.** The SFU noise
  cancellation RPC logs at verbose and closed captions only log on failure, and the app runs at
  `Priority.debug` — so in the success case there is nothing in the log at all, and a log-based
  check would "pass" while observing nothing. Both rows render their own live state ("… On" /
  "… Off"), which is what `assert_menu_toggle` reads.
- **Raise hand cannot be asserted on the reaction type.** The SDK logs the raw event type
  (`call.reaction_new`) and nothing of the payload, so `raise-hand` never appears in any log. The
  check is scoped to a mark taken after the emoji reaction, which is what makes the second event
  attributable — it proves a reaction was sent, not which one.
- **iOS joins the encrypted call by deep link, not by typing the id.** The call-id field still holds
  the plain call's id and cannot be cleared with the available tools. On iOS `open_url` opens the
  app directly, so unlike the Android browsable intent there is no Safari detour.
- **The iOS notification dialog appears after the first login** on a simulator that has never
  granted it, and preflight's pre-grant does not cover it. It covers the call-id field, so an
  undismissed dialog reads as "the join taps did nothing". Step 4a checks for it before tapping
  Allow, because once granted it never returns and the blind tap would hit the call-id field.
- **The iOS screenshot lags the tap.** The debug build draws the next screen a second or two after
  the tap lands, so a screenshot taken immediately shows the old screen. Re-tapping because of that
  undoes the first tap. Step 4's pacing rule exists for this.
- **`text` on iOS only reaches a field that already has focus.** Sent too soon after the field tap,
  the characters go nowhere and the field stays empty.
- **An iOS on-screen keyboard silently breaks every tap after a text field.** It lifts the layout,
  so "Join call", the encrypted lobby's "Start a test call" and the chat send button all move, and
  the taps land on the keyboard instead. Nothing fails loudly: the log shows the text arriving
  (chat even logs `typing.start`) and then no join or send at all, which reads like an SDK defect.
  Two separate Simulator toggles cause it — Connect Hardware Keyboard (⇧⌘K) off, or Toggle Software
  Keyboard (⌘K) on — and only the first one lands in a `defaults` key a script could read. Step 4b
  row 3 checks for it with a screenshot instead.
- **Bad E2EE events are matched by log level, not by name** — any `(E|W)/…): [e2ee]` line, held
  once in `E2EE_BAD_RE` in `lib.sh`. `CallE2EE` logs exactly the bad events at E/W and the benign
  ones at D. A pattern built on the Dart enum names (`unencryptedFrame`) matched nothing, so
  `e2ee-clean-*` passed over a cleartext frame; the wire name the log prints comes from native and
  can be empty, so names are not relied on at all.
- **E2EE teardown is judged separately, in `report.sh`.** `e2ee-clean-*` runs while both sides are
  still in the call, so it cannot see a frame sent while one of them leaves. `e2ee_verify.sh` marks
  the iOS log just before Android leaves; `report.sh` checks that window once iOS has left too.
- **`e2ee-peer-seen` deliberately does not exist.** `assert_two_participants` counts distinct user
  ids across the whole log, and both rounds use the same two users, so in the encrypted round it
  would pass on the plain call's participants without the peer ever arriving. `e2ee-decrypt-android`
  is the stronger claim and cannot be true unless the peer's media showed up.
- **The summary lives in `report.sh`, not `finish.sh`.** The run has two calls to get through, and
  one place that reports on both.
- Android username must contain a digit/underscore — the emulator IME autocorrects `smokea` to
  `smokes`.
- The soft keyboard covers the sign-up button; it is dismissed before tapping.
- Navigation taps use `tap_until` (retry until the log confirms), never a fixed `sleep`.
- Selecting a **filter leaves the options sheet open**; selecting a **reaction closes it**. The stats
  step relies on the sheet still being open — do not add a `MORE` tap between them.
- **Chat and stats put their close X exactly where END CALL is.** Chat is a full-height panel on both
  platforms, and stats a full screen on Android; both replace the call's top bar, and both close
  with an X at END CALL's position. iOS taps that spot twice in step 6 (close chat, then leave), and
  Android's `finish.sh` uses `tap_until` on END CALL so the first tap closes chat and a later one
  lands. Stats has no other way out any more, so `android_checks.sh` taps its X **only after**
  confirming the stats screen opened ("Call latency" in the tree) — if stats failed to open, that
  same tap would silently end the call.
- **The Android options sheet covers the control bar.** It reaches down to y=2361, so a MORE tap to
  close it lands on its "Incoming video quality" row instead. `close_options_sheet` closes it with
  the sheet's own labelled "Close" X, and is a no-op when the sheet is already gone.
- **The options-sheet toggles are labelled "Noise cancellation On/Off" and "Closed captions
  On/Off"** — no "Toggle" prefix any more. `ui_find` matches case-sensitively, so a stale pattern
  does not fail: it reports the row as not offered and the check silently skips.
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

`/tmp/stream-video-smoke/`: `results.tsv`, `android.log`, `ios.log`, `ui.xml` (the last
accessibility-tree dump), `shots/*.png`. Reset by `launch.sh`, so re-running it after a failed
attempt starts a clean report.
`service-leak.txt` is written only when `no-service-leak` fails.

`scripts/log_digest.py` builds the digest; `scripts/log_noise.tsv` is the known-noise list it
excuses (platform, scope, regex, reason). A `reconnect`-scoped rule only applies between
`RECONNECT_FROM` and `RECONNECT_TO`, which `android_checks.sh` writes to `env.sh` around the
network-loss step — so a DNS failure anywhere else in the run is still listed.

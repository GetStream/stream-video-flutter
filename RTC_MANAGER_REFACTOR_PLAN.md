# v2 refactor: RtcManager

Parent issue: [FLU-1046](https://linear.app/stream/issue/FLU-1046) · Linear project
P-FLU-442 (Flutter Video tech debt) · Analysis and decisions:
[v2 refactoring: RtcManager](https://claude.ai/artifact/9e3fBe5xLhnDkeqd62mcFx)

This file tracks the **order** of the 13 sub-issues and how each one is
delivered, the way `V2_REFACTOR_PLAN.md` did for FLU-859. What a ticket changes
is in the ticket itself and in the analysis doc. The decisions in FLU-1046 are
proposed there; settle them before T1 starts and do not reopen them after.

This is the v2 major release, so a ticket may break the public API when that
makes it safer or simpler. `RtcManager` itself is not exported, so only T13 is
expected to need a `### ⚠️ Breaking` changelog line and a `!` in its commit
title. Tickets marked zero behaviour change (T2 to T12) stay that way.

Line numbers in the tickets refer to `v2` at `f4864c3a5` and drift as the stack
grows; search by symbol name.

## The stack

One PR per ticket, each based on the branch of the ticket before it. The first
PR targets `v2`. Tick a box in the ticket's own commit. T4 to T10 are
independent slices: if two people work on this, they can run on their own
branches off `v2` instead of in the stack, as long as T11 waits for all of them.

| # | Ticket | Branch (proposed) | PR |
|---|---|---|---|
| 1 | T1 | `test/flu-1047-rtc-manager-characterisation-tests` | [#1543](https://github.com/GetStream/stream-video-flutter/pull/1543) |
| 2 | T2 | `refactor/flu-1048-rtc-manager-media-part` | [#1544](https://github.com/GetStream/stream-video-flutter/pull/1544) |
| 3 | T3 | `refactor/flu-1049-rtc-manager-facade` | [#1546](https://github.com/GetStream/stream-video-flutter/pull/1546) |
| 4 | T4 | `refactor/flu-1050-publish-quality` | [#1547](https://github.com/GetStream/stream-video-flutter/pull/1547) |
| 5 | T5 | `refactor/flu-1051-announced-tracks` | [#1548](https://github.com/GetStream/stream-video-flutter/pull/1548) |
| 6 | T6 | `refactor/flu-1052-capture-dimension` | [#1549](https://github.com/GetStream/stream-video-flutter/pull/1549) |
| 7 | T7 | `refactor/flu-1053-apple-audio` | [#1551](https://github.com/GetStream/stream-video-flutter/pull/1551) |
| 8 | T8 | `refactor/flu-1054-remote-track-decryptor` | [#1554](https://github.com/GetStream/stream-video-flutter/pull/1554) |
| 9 | T9 | `refactor/flu-1055-rtc-session-telemetry` | |
| 10 | T10 | `refactor/flu-1056-local-track-acquirer` | |
| 11 | T11 | `refactor/flu-1057-rtc-subscriber` | |
| 12 | T12 | `refactor/flu-1058-rtc-publisher` | |
| 13 | T13 | `fix/flu-1059-one-publish-path` | |

- [x] 1. **T1** [FLU-1047](https://linear.app/stream/issue/FLU-1047): characterisation tests for the untested paths (M). Gates every move; pins bugs 1 to 3 of FLU-1046 as they behave today.
- [x] 2. **T2** [FLU-1048](https://linear.app/stream/issue/FLU-1048): device facade to a part file, dead code out (S). Pure file split.
- [x] 3. **T3** [FLU-1049](https://linear.app/stream/issue/FLU-1049): close the facade: `localTracks`, `remoteTracks`, `markNegotiated`, `getGenericSdp` to the factory (S). Before any class move, so `CallSession` does not change again later.
- [x] 4. **T4** [FLU-1050](https://linear.app/stream/issue/FLU-1050): publish quality and audio bitrate as pure functions (S). The two highest complexity scores, with no tests until T1.
- [x] 5. **T5** [FLU-1051](https://linear.app/stream/issue/FLU-1051): announced tracks builder (S–M). Audio settings as a value; the `mid` workarounds named as a plugin seam.
- [x] 6. **T6** [FLU-1052](https://linear.app/stream/issue/FLU-1052): capture dimension resolver with an injected screen size (S). `package:flutter/widgets.dart` leaves the manager.
- [x] 7. **T7** [FLU-1053](https://linear.app/stream/issue/FLU-1053): Apple ADM mute and audio session out (S). The facade keeps `@internal` delegates.
- [x] 8. **T8** [FLU-1054](https://linear.app/stream/issue/FLU-1054): remote track decryption out (S). Participant lookup as a callback.
- [ ] 9. **T9** [FLU-1055](https://linear.app/stream/issue/FLU-1055): telemetry wiring out (S).
- [ ] 10. **T10** [FLU-1056](https://linear.app/stream/issue/FLU-1056): local track acquisition and the single flight out (S). The publisher never opens a device after this.
- [ ] 11. **T11** [FLU-1057](https://linear.app/stream/issue/FLU-1057): `RtcSubscriber` (M). Splits the track map; `rtc_audio_api/` stays behind its two seams. Update the `RtcManager` class doc (added in T3) for what moved out.
- [ ] 12. **T12** [FLU-1058](https://linear.app/stream/issue/FLU-1058): `RtcPublisher` (L, high risk). Verbatim; the facade ends at about 300 lines. Rewrite the `RtcManager` class doc as the facade over `RtcPublisher` and `RtcSubscriber`. Audio bitrate profile as a getter.
- [ ] 13. **T13** [FLU-1059](https://linear.app/stream/issue/FLU-1059): one publish path and one recreate path (M, behaviour change). Fixes bugs 1 to 3 (and 6 if T12 left it); the T1 tests that pinned them are updated here. Also makes `StreamPeerConnectionFactory.getGenericSdp` throw a `StateError` naming the direction instead of returning `''`, so join and fast reconnect fail with the cause (from the review of #1546).

### After the stack

Not part of this plan; each starts once the ticket it depends on has merged.

- FLU-681 phase 2 (the serial media queue and the publish path inside the negotiation lock), after T13.
- The CallState refactor runs alongside: decision 10 keeps the new classes free of the state notifier.
- The WebRTC plugin refactor, after T12: decision 11 lists the workarounds that then leave `stream_video` one helper at a time; `rtc_audio_api/` is the largest.
- [FLU-1001](https://linear.app/stream/issue/FLU-1001) in `RtcSubscriber` after T11, [FLU-1008](https://linear.app/stream/issue/FLU-1008) in the mute path after T12.

## Working on a ticket

Each ticket runs in a fresh context, so one ticket's reading does not crowd
out the next.

1. **Start.** Open this file and take the first unchecked ticket. Read the
   Linear ticket in full and the sections of the analysis doc it links to.
   Check that the branch of the previous ticket is checked out and clean.
2. **Branch** off the previous ticket's branch, using the name from the table
   above (or the same pattern). Run `git branch --unset-upstream` if it
   picked up a tracking ref, so a bare `git push` cannot land on someone
   else's branch.
3. **Plan the ticket first.** Enter plan mode and write a plan for this ticket
   only: the code that moves or changes (by symbol, re-located on the current
   branch), the tests that pin it before the change, the tests it adds, and
   anything in the ticket that turned out stale. Get it approved before
   touching code. That plan is not committed.
4. **Implement**, tests first where the ticket says so. Before committing:
   - `melos run analyze:error` (the CI gate) and `melos run format`, after
     `git add` for new files.
   - `flutter test` in `packages/stream_video`; `stream_video_flutter` too when
     a call site there moves (none is expected).
   - New non-public classes under `lib/src` get `@internal`.
   - A changelog line in `packages/stream_video/CHANGELOG.md` under
     `## Upcoming (major)` only for a change an app can observe (T13). Pure
     moves get none.
5. **Commit** with a Conventional Commit title: `test(llc):` for T1,
   `refactor(llc):` for a move, `fix(llc):` for T13. Tick the ticket's box in
   this file in the same commit.
6. **Push and open the PR**, asking for confirmation first, each time:
   - Confirm the remote branch name before the first push.
   - Open a **draft** PR with `--base` set to the previous ticket's branch
     (`v2` for T1).
   - The PR body starts with `Fixes FLU-<id>` on its own line, so Linear moves
     the sub-issue to In Review when the PR opens. Below that: a link to
     FLU-1046, the position in the stack (`3/13, stacked on #…`), what moved or
     changed, and the tests.
   - Once the PR exists, fill in its number in the PR column in a follow-up
     commit on the same branch, and push it.
7. **Finish.** Report the PR link, then ask the user to run `/compact`
   before the next ticket starts. Do not begin the next ticket in the same
   context.

## Keeping the stack healthy

- **A review fix on a lower PR** goes on that PR's branch as a new commit.
  Then restack the branches above it, from the bottom up, with
  `git rebase --update-refs` from the top branch so every intermediate
  branch moves with it. Ask before force-pushing the restacked branches.
- **When the bottom PR merges** into `v2` (squash), rebase the next branch
  onto `origin/v2` with `git rebase --onto origin/v2 <old bottom branch>` and
  retarget its PR with `gh pr edit <n> --base v2`.
- **When `v2` moves** under the stack, rebase only when a conflict or a needed
  commit forces it; otherwise rebase once the bottom PR merges.
- If a ticket turns out to depend on one later in the order, stop and propose a
  reorder here before working around it.

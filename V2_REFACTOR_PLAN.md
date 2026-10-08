# v2 refactor: StreamVideo and Call

Parent issue: [FLU-859](https://linear.app/stream/issue/FLU-859) · Linear project
P-FLU-555 · Analysis and decisions:
[v2 refactoring: StreamVideo and Call](https://claude.ai/code/artifact/8c46054e-44ad-46ef-bcca-9cc834640ad4)

This file tracks the **order** of the 26 sub-issues in the stack and how each one is
delivered. What a ticket changes is in the ticket itself and in the analysis
doc. The decisions in FLU-859 are settled; do not reopen them.

This is the v2 major release, so a ticket may break the public API when that
makes it safer or simpler. Each break gets a `### ⚠️ Breaking` changelog line
and a `!` in its commit title. Tickets marked zero behaviour change, such as A2,
stay that way.

Tickets 5-8 are bugs found in the B2 review (FLU-924 to FLU-928). FLU-925 is
folded into A6. Tickets 13 and 15 came out of checking A5 against the other SDKs
and the SFU (FLU-931, FLU-932). Ticket 14 (FLU-936) is a dogfooding tool to
simulate connection failures, for checking the connection tickets on a device.
Ticket 16 (FLU-938) came out of checking FLU-932 on a device.

Prerequisites, both done: #1381 (single join at a time) is on `v2` as
`7afb1dea`, #1341 (push handler helper) as `1d0c0803`. Line numbers in the
tickets refer to `v2` at `9d5e71a7` and drift as the stack grows; search by
symbol name.

## The stack

One PR per ticket, each based on the branch of the ticket before it. The first
PR targets `v2`. Tick a box in the ticket's own commit.

The stack is split in two after ticket 18. Tickets 1-18 (#1405 to #1429) are the
connection work and have merged into `v2`. Ticket 19 (B1) starts the second
stack, branched off and targeting `v2`. The numbering continues across both
stacks.

| # | Ticket | Branch (proposed) | PR |
|---|---|---|---|
| 1 | A1 | `feat/flu-847-call-characterisation-tests` | #1405 |
| 2 | B4 | `feat/flu-850-call-pass-through-extensions` | #1406 |
| 3 | B5 | `feat/flu-851-e2ee-claims` | #1408 |
| 4 | B2 | `feat/flu-849-call-event-router` | #1409 |
| 5 | FLU-924 | `fix/flu-924-log-coordinator-event-errors` | #1411 |
| 6 | FLU-926 | `fix/flu-926-moderation-mute-failure` | #1412 |
| 7 | FLU-927 | `fix/flu-927-closed-captions-reset` | #1413 |
| 8 | FLU-928 | `fix/flu-928-captions-zero-duration` | #1414 |
| 9 | A2 | `feat/flu-855-call-connection-coordinator` | #1415 |
| 10 | A3 | `feat/flu-860-connection-phase` | #1417 |
| 11 | A4 | `fix/flu-864-single-leave-decision` | #1418 |
| 12 | A5 | `feat/flu-865-serial-join-executor` | #1419 |
| 13 | FLU-931 | `fix/flu-931-rejoin-on-peer-connection-failure` | #1421 |
| 14 | FLU-936 | `feat/flu-936-connection-failure-simulator` | #1422 |
| 15 | FLU-932 | `fix/flu-932-migration-complete-old-socket` | #1424 |
| 16 | FLU-938 | `fix/flu-938-reuse-local-tracks` | #1426 |
| 17 | A6 | `fix/flu-861-session-ownership` | #1427 |
| 18 | A7 | `feat/flu-862-call-dispose` | #1429 |
| 19 | B1 | `feat/flu-848-local-media-controller` | #1434 |
| 20 | C2 | `feat/flu-853-stream-video-test-seams` | #1435 |
| 21 | C3 | `fix/flu-857-coordinator-connection` | #1436 |
| 22 | C1 | `feat/flu-856-ringing-call-coordinator` | |
| 23 | B3 | `feat/flu-863-call-ringing-controller` | |
| 24 | C4 | `feat/flu-858-app-lifecycle-controller` | |
| 25 | B6 | `feat/flu-852-call-host` | |
| 26 | C5 | `feat/flu-854-stream-video-constructor` | |

- [x] 1. **A1** [FLU-847](https://linear.app/stream/issue/FLU-847): characterisation tests for Call join, leave and reconnect (M). Gates A2, so it goes first. Ships with this plan.
- [x] 2. **B4** [FLU-850](https://linear.app/stream/issue/FLU-850): Call pass-throughs to extension methods (S, low risk). Removes about 380 lines from `call.dart` before the risky moves, with no overlap with the connection code.
- [x] 3. **B5** [FLU-851](https://linear.app/stream/issue/FLU-851): E2EE manager resolution and the claims registry out of Call (S, low risk).
- [x] 4. **B2** [FLU-849](https://linear.app/stream/issue/FLU-849): coordinator event router, and the reactions, closed captions and video moderation helpers (S, low risk). Takes `_reactionTimers` out before A6 has to deal with it.
- [x] 5. **Fix** [FLU-924](https://linear.app/stream/issue/FLU-924): log errors thrown while routing coordinator events (S, bug). Before A2, so A2 moves `_observeEvents` with the fix already in.
- [x] 6. **Fix** [FLU-926](https://linear.app/stream/issue/FLU-926): video moderation ignores a failed mic or camera mute (S, bug).
- [x] 7. **Fix** [FLU-927](https://linear.app/stream/issue/FLU-927): reset closed captions on leave and catch errors across the whole handler (S, bug). Closing the emitter stays with A7.
- [x] 8. **Fix** [FLU-928](https://linear.app/stream/issue/FLU-928): closed captions never show when the visibility duration is 0 (S, bug). Settle the option from the ticket in the plan; option 1 needs a changelog line.
- [x] 9. **A2** [FLU-855](https://linear.app/stream/issue/FLU-855): verbatim `CallConnectionCoordinator` (L, high risk). Zero behaviour change; existing tests and A1 stay green untouched.
- [x] 10. **A3** [FLU-860](https://linear.app/stream/issue/FLU-860): sealed `ConnectionPhase` replaces the connection flags (L, high risk). Leaving is final, which fixes bug 2 from FLU-859 here instead of in A4.
- [x] 11. **A4** [FLU-864](https://linear.app/stream/issue/FLU-864): one leave decision and one cancellation scope per attempt (M). Fixes bug 1 from FLU-859. Waits end on leave, and a remote end leaves like a local leave.
- [x] 12. **A5** [FLU-865](https://linear.app/stream/issue/FLU-865): serial executor for join and reconnect (M). A reconnect asked for during a join or another reconnect is held for it instead of dropped.
- [x] 13. **Fix** [FLU-931](https://linear.app/stream/issue/FLU-931): rejoin when a peer connection fails (S, bug). A failed connection state, or an ICE restart the SFU refuses, asks for rejoin, as the SFU and the other SDKs do; fast stays for a lost participant signal, and a restart that gets no answer from the SFU is only logged. A call offline past the fast-reconnect deadline rejoins right away. The strategy each cause asks for is documented on `_reconnect`.
- [x] 14. **Tool** [FLU-936](https://linear.app/stream/issue/FLU-936): simulate connection failures from the dogfooding app (S–M). An in-app menu backed by small SDK debug hooks (offline for N s, socket drop, peer connection failed, GoAway), and `tools/simulate_network_loss.sh` for real network loss. After FLU-931, because the hooks attach to `CallConnectionCoordinator`; it is how FLU-932 and the rest of the A chain get checked on a device.
- [x] 15. **Fix** [FLU-932](https://linear.app/stream/issue/FLU-932): wait for migration complete on the old SFU socket (S, bug). Confirmed on a device with a migration to another SFU. Before A6, so A6 reworks session ownership on top of the corrected order.
- [x] 16. **Fix** [FLU-938](https://linear.app/stream/issue/FLU-938): reuse local tracks across a migration and a rejoin (S–M). The new session takes over the old one's camera, microphone and screen-share tracks instead of opening them again. Right after FLU-932, whose order (the old session stays open until the old SFU confirms) is what the handover has to respect, and before A6 and B1, which then build on its `_startSession` and `_applyConnectOptions` changes.
- [x] 17. **A6** [FLU-861](https://linear.app/stream/issue/FLU-861): single session ownership and a complete teardown (S). Fixes bugs 3 and 5, and folds in [FLU-925](https://linear.app/stream/issue/FLU-925) (timers re-armed during leave). Also releases the session a migration started from when the migration's join fails: `_reconnectMigrate` returned before closing it, and the rejoin that followed only left the failed new session. The same went for a rejoin whose first attempt failed before the new session took the local tracks: the retry asked only the failed session for them, so it opened the devices again and the original session was never disposed.
- [x] 18. **A7** [FLU-862](https://linear.app/stream/issue/FLU-862): `Call.dispose` and the single-use-after-leave error (S, v2 breaking).
- [x] 19. **B1** [FLU-848](https://linear.app/stream/issue/FLU-848): `LocalMediaController` (M). After the A chain, so `_connectOptions` moves once with A2 and then gets one owner here.
- [x] 20. **C2** [FLU-853](https://linear.app/stream/issue/FLU-853): injection seams in StreamVideo (S). Needed to test C3 and C4.
- [x] 21. **C3** [FLU-857](https://linear.app/stream/issue/FLU-857): `CoordinatorConnection` with a real single-flight guard (M). Fixes bug 4.
- [x] 22. **C1** [FLU-856](https://linear.app/stream/issue/FLU-856): `RingingCallCoordinator` as `streamVideo.ringing` (L, v2 breaking). Its `ensureConnected` callback comes from C3.
- [ ] 23. **B3** [FLU-863](https://linear.app/stream/issue/FLU-863): `CallRingingController` (M). After C1, which takes the cross-call orchestration from `Call.accept`. The accept waits stop on leave, so a cancelled ring no longer logs a timeout error 25 s later.
- [ ] 24. **C4** [FLU-858](https://linear.app/stream/issue/FLU-858): `AppLifecycleController`; background mute and restore moves into Call (S).
- [ ] 25. **B6** [FLU-852](https://linear.app/stream/issue/FLU-852): `CallHost` interface (M). Late on purpose: after C1, B3 and C4 the interface no longer needs the ringing hooks or the mute maps.
- [ ] 26. **C5** [FLU-854](https://linear.app/stream/issue/FLU-854): StreamVideo constructor and options cleanup (M, v2 breaking). Last, because every earlier C ticket wires into the constructor. Also covers a client built for background push handling, which must do no media setup.

### Later, outside the stack

Same parent issue, but not part of the stack and not blocking anything above.
Pick them up after the stack, or alongside it on their own branch off `v2`.

- [ ] [FLU-933](https://linear.app/stream/issue/FLU-933): give up reconnecting after repeated rejoins (S). A rejoin rate limit like the other SDKs (10 per 120 s, then leave).
- [ ] [FLU-934](https://linear.app/stream/issue/FLU-934): keep backstage hosts in the call when a livestream ends (S, behaviour change). The SFU's call-ended reason is mapped but ignored.
- [ ] [FLU-939](https://linear.app/stream/issue/FLU-939): keep the participant tile order after a reconnect (S). The join response rebuilds the participants without their viewport visibility, pin and reaction.

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
   - Tests of every package the change touches; `stream_video` at least, and
     `stream_video_flutter` or `stream_video_push_notification` when their
     call sites move (C1, C5, B6).
   - A changelog line in `packages/stream_video/CHANGELOG.md` under
     `## Upcoming (major)` only for a public change (C1, A7, C5, anything
     else that breaks), one short sentence each. Pure moves get none.
5. **Commit** with a Conventional Commit title, `test(llc):` for A1 and
   `refactor(llc):` for a move, `fix(llc):` where the ticket's main point is a
   bug. Tick the ticket's box in this file in the same commit.
6. **Push and open the PR**, asking for confirmation first, each time:
   - Confirm the remote branch name before the first push.
   - Open a **draft** PR with `--base` set to the previous ticket's branch
     (`v2` for A1).
   - The PR body starts with `Fixes FLU-<id>` on its own line, so Linear moves
     the sub-issue to In Review when the PR opens. Below that: a link to
     FLU-859, the position in the stack (`2/22, stacked on #…`), what moved or
     changed, and the tests.
   - Once the PR exists, fill in its number in the PR column in a follow-up
     commit on the same branch, and push it (it is the top of the stack, so
     nothing needs restacking).
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

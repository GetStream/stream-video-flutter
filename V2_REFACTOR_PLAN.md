# v2 refactor: StreamVideo and Call

Parent issue: [FLU-859](https://linear.app/stream/issue/FLU-859) · Linear project
P-FLU-555 · Analysis and decisions:
[v2 refactoring: StreamVideo and Call](https://claude.ai/code/artifact/8c46054e-44ad-46ef-bcca-9cc834640ad4)

This file tracks the **order** of the 18 sub-issues and how each one is
delivered. What a ticket changes is in the ticket itself and in the analysis
doc. The decisions in FLU-859 are settled; do not reopen them.

Prerequisites, both done: #1381 (single join at a time) is on `v2` as
`7afb1dea`, #1341 (push handler helper) as `1d0c0803`. Line numbers in the
tickets refer to `v2` at `9d5e71a7` and drift as the stack grows; search by
symbol name.

## The stack

One PR per ticket, each based on the branch of the ticket before it. The first
PR targets `v2`. Tick a box in the ticket's own commit.

| # | Ticket | Branch (proposed) | PR |
|---|---|---|---|
| 1 | A1 | `feat/flu-847-call-characterisation-tests` | #1405 |
| 2 | B4 | `feat/flu-850-call-pass-through-extensions` | #1406 |
| 3 | B5 | `feat/flu-851-e2ee-claims` | #1408 |
| 4 | B2 | `feat/flu-849-call-event-router` | #1409 |
| 5 | A2 | `feat/flu-855-call-connection-coordinator` | |
| 6 | A3 | `feat/flu-860-connection-phase` | |
| 7 | A4 | `fix/flu-864-single-leave-decision` | |
| 8 | A5 | `feat/flu-865-serial-join-executor` | |
| 9 | A6 | `fix/flu-861-session-ownership` | |
| 10 | A7 | `feat/flu-862-call-dispose` | |
| 11 | B1 | `feat/flu-848-local-media-controller` | |
| 12 | C2 | `feat/flu-853-stream-video-test-seams` | |
| 13 | C3 | `fix/flu-857-coordinator-connection` | |
| 14 | C1 | `feat/flu-856-ringing-call-coordinator` | |
| 15 | B3 | `feat/flu-863-call-ringing-controller` | |
| 16 | C4 | `feat/flu-858-app-lifecycle-controller` | |
| 17 | B6 | `feat/flu-852-call-host` | |
| 18 | C5 | `feat/flu-854-stream-video-constructor` | |

- [x] 1. **A1** [FLU-847](https://linear.app/stream/issue/FLU-847): characterisation tests for Call join, leave and reconnect (M). Gates A2, so it goes first. Ships with this plan.
- [x] 2. **B4** [FLU-850](https://linear.app/stream/issue/FLU-850): Call pass-throughs to extension methods (S, low risk). Removes about 380 lines from `call.dart` before the risky moves, with no overlap with the connection code.
- [x] 3. **B5** [FLU-851](https://linear.app/stream/issue/FLU-851): E2EE manager resolution and the claims registry out of Call (S, low risk).
- [x] 4. **B2** [FLU-849](https://linear.app/stream/issue/FLU-849): coordinator event router, and the reactions, closed captions and video moderation helpers (S, low risk). Takes `_reactionTimers` out before A6 has to deal with it.
- [ ] 5. **A2** [FLU-855](https://linear.app/stream/issue/FLU-855): verbatim `CallConnectionCoordinator` (L, high risk). Zero behaviour change; existing tests and A1 stay green untouched.
- [ ] 6. **A3** [FLU-860](https://linear.app/stream/issue/FLU-860): sealed `ConnectionPhase` replaces the connection flags (L, high risk).
- [ ] 7. **A4** [FLU-864](https://linear.app/stream/issue/FLU-864): one leave decision and one cancellation scope per attempt (M). Fixes bugs 1 and 2 from FLU-859.
- [ ] 8. **A5** [FLU-865](https://linear.app/stream/issue/FLU-865): serial executor for join and reconnect (M).
- [ ] 9. **A6** [FLU-861](https://linear.app/stream/issue/FLU-861): single session ownership and a complete teardown (S). Fixes bugs 3 and 5.
- [ ] 10. **A7** [FLU-862](https://linear.app/stream/issue/FLU-862): `Call.dispose` and the single-use-after-leave error (S, v2 breaking).
- [ ] 11. **B1** [FLU-848](https://linear.app/stream/issue/FLU-848): `LocalMediaController` (M). After the A chain, so `_connectOptions` moves once with A2 and then gets one owner here.
- [ ] 12. **C2** [FLU-853](https://linear.app/stream/issue/FLU-853): injection seams in StreamVideo (S). Needed to test C3 and C4.
- [ ] 13. **C3** [FLU-857](https://linear.app/stream/issue/FLU-857): `CoordinatorConnection` with a real single-flight guard (M). Fixes bug 4.
- [ ] 14. **C1** [FLU-856](https://linear.app/stream/issue/FLU-856): `RingingCallCoordinator` as `streamVideo.ringing` (L, v2 breaking). Its `ensureConnected` callback comes from C3.
- [ ] 15. **B3** [FLU-863](https://linear.app/stream/issue/FLU-863): `CallRingingController` (M). After C1, which takes the cross-call orchestration from `Call.accept`.
- [ ] 16. **C4** [FLU-858](https://linear.app/stream/issue/FLU-858): `AppLifecycleController`; background mute and restore moves into Call (S).
- [ ] 17. **B6** [FLU-852](https://linear.app/stream/issue/FLU-852): `CallHost` interface (M). Late on purpose: after C1, B3 and C4 the interface no longer needs the ringing hooks or the mute maps.
- [ ] 18. **C5** [FLU-854](https://linear.app/stream/issue/FLU-854): StreamVideo constructor and options cleanup (M, v2 breaking). Last, because every earlier C ticket wires into the constructor.

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
     FLU-859, the position in the stack (`2/18, stacked on #…`), what moved or
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

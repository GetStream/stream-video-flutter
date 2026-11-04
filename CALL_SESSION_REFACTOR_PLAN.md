# v2 refactor: CallSession

Parent issue: [FLU-1060](https://linear.app/stream/issue/FLU-1060) · Linear project
P-FLU-442 (Flutter Video tech debt) · Analysis and decisions:
[v2 refactoring: CallSession](https://claude.ai/artifact/GBHSE31hFfLW9KkeopEiWG)

This file tracks the **order** of the 10 sub-issues and how each one is
delivered, the way `V2_REFACTOR_PLAN.md` did for FLU-859 and
`RTC_MANAGER_REFACTOR_PLAN.md` does for FLU-1046. What a ticket changes is in
the ticket itself and in the analysis doc. The decisions in FLU-1060 are
proposed there; settle them before CS1 starts and do not reopen them after.

This is the v2 major release, so a ticket may break the public API when that
makes it safer or simpler. `CallSession` is not exported, so only CS4 (the
join handshake) is expected to need a changelog line. Tickets marked zero
behaviour change (CS3, CS5 to CS8, and CS9 apart from closing the manager
subject in `close`) stay that way.

Line numbers in the tickets refer to `v2` at `f4864c3a5` and drift as the stack
grows; search by symbol name.

## Standalone or after the RtcManager plan

Standalone; the RtcManager stack (FLU-1046) is on `v2`.

## The stack

One PR per ticket, each based on the branch of the ticket before it. The first
PR targets `v2`. Tick a box in the ticket's own commit. CS3, CS5, CS7 and CS8
are independent slices and can run on their own branches off `v2` if two
people work on this; CS6 needs CS5, CS9 needs CS6 and CS8, CS10 needs all.

| # | Ticket | Branch (proposed) | PR |
|---|---|---|---|
| 1 | CS1 | `test/flu-1061-call-session-characterisation-tests` | #1563 |
| 2 | CS2 | `refactor/flu-1062-call-session-media-part` | #1564 |
| 3 | CS3 | `refactor/flu-1063-sfu-join-request-builder` | #1565 |
| 4 | CS4 | `fix/flu-1064-one-join-handshake` | #1566 |
| 5 | CS5 | `refactor/flu-1065-publisher-negotiator` | #1567 |
| 6 | CS6 | `refactor/flu-1066-session-signaling` | #1568 |
| 7 | CS7 | `refactor/flu-1067-publisher-connection-watchdog` | |
| 8 | CS8 | `refactor/flu-1068-session-track-controller` | |
| 9 | CS9 | `refactor/flu-1069-sfu-event-router` | |
| 10 | CS10 | `refactor/flu-1070-call-session-start-fast-reconnect` | |

- [x] 1. **CS1** [FLU-1061](https://linear.app/stream/issue/FLU-1061): characterisation tests for the untested paths (M). Gates every move; pins bugs 1 to 3 and 5 of FLU-1060 as they behave today.
- [x] 2. **CS2** [FLU-1062](https://linear.app/stream/issue/FLU-1062): media pass-throughs to a part file, the dead viewport path out, DTO mappers moved (S).
- [x] 3. **CS3** [FLU-1063](https://linear.app/stream/issue/FLU-1063): `SfuJoinRequestBuilder` (S). One `JoinRequest` and one `ReconnectDetails` builder for both join paths.
- [x] 4. **CS4** [FLU-1064](https://linear.app/stream/issue/FLU-1064): one join handshake (S, behaviour change). `start` gains the closed-socket fail-fast; changelog line.
- [x] 5. **CS5** [FLU-1065](https://linear.app/stream/issue/FLU-1065): `PublisherNegotiator` (M). The negotiation lock and the three rollback rules move verbatim.
- [x] 6. **CS6** [FLU-1066](https://linear.app/stream/issue/FLU-1066): `SessionSignaling` (S). Subscriber offer, ICE both ways, ICE restart, mute state. After CS5.
- [x] 7. **CS7** [FLU-1067](https://linear.app/stream/issue/FLU-1067): `PublisherConnectionWatchdog` (S).
- [ ] 8. **CS8** [FLU-1068](https://linear.app/stream/issue/FLU-1068): `SessionTrackController` (M). The suspend-or-start rule written once.
- [ ] 9. **CS9** [FLU-1069](https://linear.app/stream/issue/FLU-1069): `SfuEventRouter` (M). The events lock, the dispatch, the state forwards and the manager gate; after CS6 and CS8. Fixes bug 3, which flips its CS1 pin.
- [ ] 10. **CS10** [FLU-1070](https://linear.app/stream/issue/FLU-1070): `start` and `fastReconnect` on the new parts (M). One manager branch; device test with the FLU-936 simulator before it is marked ready.

### After the stack

- FLU-681 phase 2 (latest-wins mute state) in `SessionSignaling` and phase 3 (the events lock split) in `SfuEventRouter`.
- The CallState refactor touches `SfuEventRouter` only here.

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
   - `flutter test` in `packages/stream_video`.
   - New non-public classes under `lib/src` get `@internal`.
   - A changelog line in `packages/stream_video/CHANGELOG.md` under
     `## Upcoming (major)` only for a change an app can observe (CS4). Pure
     moves get none.
5. **Commit** with a Conventional Commit title: `test(llc):` for CS1,
   `refactor(llc):` for a move, `fix(llc):` for CS4. Tick the ticket's box in
   this file in the same commit.
6. **Push and open the PR**, asking for confirmation first, each time:
   - Confirm the remote branch name before the first push.
   - Open a **draft** PR with `--base` set to the previous ticket's branch
     (`v2` for CS1).
   - The PR body starts with `Fixes FLU-<id>` on its own line, so Linear moves
     the sub-issue to In Review when the PR opens. Below that: a link to
     FLU-1060, the position in the stack (`3/10, stacked on #…`), what moved or
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

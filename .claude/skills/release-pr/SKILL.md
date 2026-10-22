---
name: release-pr
description: >
  Open a release PR, for the stream_video packages (one shared version, tag stream-video-vX.Y.Z) or for one webrtc
  package (its own version, e.g. stream-webrtc-flutter-vX.Y.Z): bumps the versions, finalises CHANGELOGs, updates the
  SDK size badges for stream-video, opens a PR against main.
disable-model-invocation: true
argument-hint: "[product] [version]"
arguments: [product, version]
allowed-tools:
  - Bash(git *)
  - Bash(gh *)
  - Bash(melos *)
  - Bash(which *)
  - Bash(grep *)
  - Read
  - Edit
  - Write
---

# release-pr

Opens a release PR for stream-video-flutter. Branch `release/<tag>` → base `main` →
title `chore(repo): release <product> v<X.Y.Z>`.

The repo releases two kinds of product, each under its own tag:

| Product | Packages | Version | Tag |
|---|---|---|---|
| `stream-video` | the six `packages/stream_video*` packages | one shared `X.Y.Z` | `stream-video-vX.Y.Z` |
| `stream-webrtc-flutter` | `webrtc/stream_webrtc_flutter` | its own | `stream-webrtc-flutter-vX.Y.Z` |
| `dart-webrtc` | `webrtc/dart_webrtc` | its own | `dart-webrtc-vX.Y.Z` |
| `webrtc-interface` | `webrtc/webrtc_interface` | its own | `webrtc-interface-vX.Y.Z` |

A webrtc package's version is not aligned with the others or with stream-video, and it can take a major bump on its
own. `dart_webrtc` and `webrtc_interface` are not published by us yet (`lint:pub`, `release:pub` and
`release_tag.yml` skip them): refuse a release of either and tell the user.

`<tag>` below is `<product>-v<version>`, e.g. `stream-video-v2.0.0`.

**This skill only opens the PR.** After merge, tagging and pub.dev publishing happen via `release_tag.yml` +
`release_publish.yml` — automatic for both stable and pre-release.

If `$product` and `$version` are provided (e.g. `/release-pr stream-video 2.1.0` or
`/release-pr stream-webrtc-flutter 4.0.1`), use them. A bare version (`/release-pr 2.1.0`) means `stream-video`.
Accept the package name too (`stream_webrtc_flutter` → `stream-webrtc-flutter`). Strip any leading `v`. Otherwise ask
the user.

## Release types

| Type | Base | Version shape | Tagging |
|---|---|---|---|
| **Stable** | `main` | `X.Y.Z` | Auto via `release_tag.yml` on merge |
| **Pre-release** | `main` | `X.Y.Z-<name>.N` | Auto via `release_tag.yml` on merge (published as a GitHub pre-release) |

`app-distribute.yml` builds and distributes the dogfooding app — **not** a release. Don't use this skill for that.

## Inputs

1. **Product** — see the table above. Use `$product` if supplied, otherwise ask.
2. **Version** (`X.Y.Z` or `X.Y.Z-suffix`). Use `$version` if supplied, otherwise ask. Don't infer. A hyphen in the
   version makes it a pre-release.
3. **Previous tag** for the release-notes diff. Run `git tag --list '<product>-v*' --sort=-v:refname | head`; pick the
   most recent tag of the same train (stable = no hyphen in the version; pre-release = the same suffix prefix).
   stream-video releases before this tag scheme are plain `vX.Y.Z` tags: if no `stream-video-v*` tag of the train
   exists yet, use the most recent of those.

Base is always `main` — no branch derivation needed.

## Pre-flight

Run these checks. **If any fail, stop the skill, surface the failing check to the user, and do not try to auto-fix**
(no stashing uncommitted work, no force-pulling, no killing processes).

- `git status --short -uno` clean after `git checkout main` + `git pull --ff-only`.
- `which melos` succeeds.
- `gh auth status` succeeds.
- `gh pr list --head release/<tag> --state all --json number` returns `[]`.
- `git tag --list <tag>` is empty.
- Latest CI on `main` is green: `gh run list --branch main --limit 5` — no failures on the most recent runs.
- stream-video only: the latest `sdk_size` run on `main` finished successfully, so the size benchmark matches what is
  released:
  `gh run list --workflow sdk_size.yml --branch main --limit 1`.

## Steps

### 1. Branch off main

Pre-flight already left you on `main` with latest. Just create the release branch:

```bash
git checkout -b release/<tag>
```

### 2. Bump versions

Edit these by hand, then let `melos bs` propagate the rest.

**stream-video — edit:**

- Root `pubspec.yaml` — in the `melos.command.bootstrap.dependencies` block, bump all six `stream_video*: ^<version>`
  entries. Locate with `grep -n "stream_video.*: \^" pubspec.yaml`.
- Each `packages/*/pubspec.yaml` (6 files) — set `version: <version>`. Do **not** touch the intra-package
  `stream_video*` constraints, `packages/*/example/pubspec.yaml`, or `dogfooding/pubspec.yaml` — bootstrap syncs all
  of those from the deps block. (`dogfooding` has its own independent app version; bump it only if the app itself is
  being released.)

**A webrtc package — edit:**

- Its `webrtc/<package>/pubspec.yaml` — set `version: <version>`.
- Root `pubspec.yaml` — set its entry in the `melos.command.bootstrap.dependencies` block to `^<version>`. Bootstrap
  syncs that into the other webrtc packages and the stream_video packages that depend on it. Don't touch the
  stream_video versions.

**Then run:**

```bash
melos bs
```

`melos bs` does the rest:

- Propagates the root `pubspec.yaml` deps block into every workspace pubspec — each package's intra-package
  `stream_video*` constraints, every `packages/*/example/pubspec.yaml`, and `dogfooding/pubspec.yaml`.
- Fires the `command.bootstrap.hooks.post: melos run version:update` hook, which runs `tools/generate_version.dart`.
  It regenerates `streamVideoVersion` in `packages/stream_video/lib/globals.dart` and sets `s.version` in every
  package's `ios/` and `macos/` podspecs from its pubspec version. (Don't hand-edit `globals.dart` or the podspecs.)

Verify the diff shape matches the previous release PR of the same product. Find its number with:

```bash
gh pr list --search "chore(repo): release <product> in:title" --state merged --limit 5 --json number,title
```

(The first release of a product under this tag scheme has none; for stream-video, search
`chore(repo): release v in:title` instead.)

Then compare:

```bash
git diff --stat
gh pr diff <prev-release-pr-number> --name-only   # for comparison
```

### 3. Finalise the CHANGELOGs

**A webrtc package:** only its own `webrtc/<package>/CHANGELOG.md`. Rename the top `[Unreleased]` section to
`[<version>] - <date>`, keeping the file's existing heading and date format. If there is no `[Unreleased]` section,
ask the user what goes in it; don't release a package with an empty section. Then skip to step 4.

**stream-video:** six files: `packages/{stream_video, stream_video_flutter, stream_video_push_notification,
stream_video_noise_cancellation, stream_video_screen_sharing, stream_video_filters}/CHANGELOG.md`.

For each, **apply the first matching rule below** — it's a decision tree, not a sequence:

1. **Top section is `## Upcoming Changes` or `## Upcoming`** → rename to `## <version>`. Keep bullets.
2. **User-facing changes since `<prev-tag>`** — new APIs, bug fixes users would notice, deprecations. Check with
   `git log <prev-tag>..HEAD --oneline -- packages/<pkg>`. Add a `## <version>` header with bullets in the existing
   emoji-prefixed sections only (`### ✅ Added`, `### 🐞 Fixed`, `### 🔄 Changed`, `### ⚠️ Deprecated`,
   `### ✨ Refactor`). Don't invent new section names.
3. **No user-facing changes, but the package depends on `stream_video`** → add the dep-bump line:
   ```
   ## <version>

   - Updated `stream_video` dependency to [`<version>`](https://pub.dev/packages/stream_video/changelog).
   ```
4. **No user-facing changes and no `stream_video` dependency** → add the version-sync line:
   ```
   ## <version>

   - Sync version with `stream_video_flutter` <version>
   ```

Rules 3 and 4 are split by the **dependency**, not by how much changed. Internal-only churn (gradle bumps,
`analysis_options.yaml`, lints, test fixes) is not a user-facing change, so it does not promote a package to rule 2 —
it still lands on 3 or 4. Determine which with:

```bash
grep -l "^  stream_video:" packages/*/pubspec.yaml
```

`stream_video_screen_sharing` is the only package that does not depend on `stream_video`, so it is the only one that
ever gets the rule 4 line. Every other package falls to rule 3 when it has nothing user-facing of its own.

Neither line is `- Minor bug fixes and improvements`. That wording has been used in past releases but says nothing
useful to an integrator — don't reach for it, and don't invent a third variant.

**Every package gets a `## <version>` header**, even if it's only a dep-bump line. Empty version sections and
missing headers both fail pana.

#### Then: mirror `stream_video` into `stream_video_flutter`

This runs **after** the decision tree, on top of whatever rule 1 or 2 produced for `stream_video_flutter`.

Integrators read `stream_video_flutter`'s CHANGELOG as the changelog for the release — most never open
`stream_video`'s. So `stream_video_flutter`'s `## <version>` section must be the **union**: every bullet from
`stream_video`'s `## <version>` section, plus `stream_video_flutter`'s own.

- Copy the bullets **verbatim**. Don't re-summarise, re-word, or attribute them to `stream_video`.
- Merge into matching emoji-prefixed sections. Within a section put `stream_video_flutter`'s own bullets first, then
  the ones carried over from `stream_video`.
- If `stream_video` has a section `stream_video_flutter` lacks, add it, following the section order already used in
  the file.
- Skip any bullet already present in `stream_video_flutter` — don't duplicate.
- `stream_video`'s own `## <version>` section is left as-is; this copies out of it, never into it.

Verify: every bullet under `stream_video`'s `## <version>` appears under `stream_video_flutter`'s `## <version>`.

### 4. Sanity-check

```bash
melos run analyze
melos run lint:pub
```

If either fails, surface to the user and stop.

### 5. Commit and push

```bash
git add -A
git commit -m "chore(repo): release <product> v<version>"
git push -u origin release/<tag>
```

One release commit. `release_tag.yml` runs for a commit on `main` whose message starts with `chore(repo): release`,
so keep that prefix. The tags come from the unpublished package versions, not from the message.

### 5b. Update the SDK size badges (stream-video only)

The size badges in the root `README.md` show the latest `main` benchmark from the `sdk_size` workflow. The
`update_size_badges` workflow writes them and commits `chore(repo): update the SDK size badges` to the release branch.
Anyone releasing by hand runs the same workflow, from the Actions tab or with:

```bash
gh workflow run update_size_badges.yml --ref release/<tag> -f base_branch=main
```

See the run through before opening the PR:

```bash
gh run list --workflow update_size_badges.yml --branch release/<tag> --limit 1 --json databaseId,status
gh run watch <run-id> --exit-status
git pull --ff-only
```

If the badges already matched, the workflow commits nothing and the pull is a no-op. If the run fails, surface it to
the user and stop.

### 6. Generate the PR body

**A webrtc package:** the body is its `[<version>]` CHANGELOG section, as is. Write it to `/tmp/release-notes.md`
and go to step 7.

**stream-video:** the body **must be exactly what GitHub's release UI produces when you click "Generate release notes"** — no template
wrapper, no extra description, no CLA checkboxes. The "New Contributors" block GitHub auto-appends stays in; that's
part of the convention.

```bash
gh api repos/GetStream/stream-video-flutter/releases/generate-notes \
  -f tag_name=<tag> \
  -f previous_tag_name=<prev-tag> \
  -f target_commitish=main \
  --jq .body > /tmp/release-notes.md
```

- `tag_name`: the tag we'll create (need not exist yet).
- `previous_tag_name`: most recent tag of the same train.
- `target_commitish`: `main` — the notes should cover every commit between `previous_tag_name` and where the tag
  will land after merge.

Read the file once to skim. If a PR title looks wrong, fix it on the originating PR upstream and re-run the API
call; don't hand-edit `/tmp/release-notes.md`.

### 7. Open the PR

```bash
gh pr create \
  --base main \
  --head release/<tag> \
  --title "chore(repo): release <product> v<version>" \
  --body-file /tmp/release-notes.md
```

Return the PR URL and stop. Tagging is automatic on merge for both stable and pre-release — no manual tag step.

## After merge (FYI)

`release_tag.yml` tags every package version that isn't on pub.dev yet — one `stream-video-vX.Y.Z` tag for the
stream_video packages, one tag per webrtc package — and pushes them one at a time, in dependency order, with the bot
token. `release_publish.yml` runs per tag: it publishes that tag's packages with `melos run release:pub`, after
waiting for any in-workspace dependency to be live on pub.dev, and creates the GitHub release from the CHANGELOG
section (`stream_video_flutter`'s for stream-video). Hyphenated versions publish as pre-releases; only a stable
stream-video release is marked latest, and only it builds the prod dogfooding app.

## Don't

- **Never create a GitHub release** (`gh release create`, `POST /repos/.../releases`). Step 6 uses
  `generate-notes`, which is read-only. The release itself is created by `release_publish.yml` after the tag is
  pushed.
- **Never push a tag.** Tagging is automatic on merge.
- **Never run `melos run release:pub`.** That's the publish step, triggered by the workflow on tag push. Even if the
  user asks, refuse — running it locally publishes from an unreviewed working tree.
- **Never merge the PR.** Return the URL and stop.

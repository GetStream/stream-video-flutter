---
name: release-pr
description: >
  Open a release PR for stream-video-flutter: bumps the lockstep version across all packages, finalises CHANGELOGs,
  and opens a PR against main with auto-generated release notes.
disable-model-invocation: true
argument-hint: "[version]"
arguments: [version]
allowed-tools:
  - Bash(git *)
  - Bash(gh *)
  - Bash(dart *)
  - Bash(melos *)
  - Bash(which *)
  - Bash(grep *)
  - Read
  - Edit
  - Write
---

# release-pr

Opens a release PR for stream-video-flutter. Branch `release/v<X.Y.Z>` → base `main` →
title `chore(repo): release v<X.Y.Z>`.

The repo versions in **lockstep**: all six packages share one `X.Y.Z`, and a single `vX.Y.Z` tag releases them all.

**This skill only opens the PR.** After merge, `release_tag.yml` creates and pushes the tag, then
`release_publish.yml` publishes every package to pub.dev (via OIDC) and creates the GitHub release. Both stable and
pre-release (`vX.Y.Z-suffix`) tags are handled automatically — there is no manual tag step.

If `$version` is provided (e.g. `/release-pr 1.5.0`), use it. Strip any leading `v`. Otherwise ask the user — don't infer.

## Publishable packages (6)

`stream_video`, `stream_video_flutter`, `stream_video_push_notification`, `stream_video_noise_cancellation`,
`stream_video_screen_sharing`, `stream_video_filters`. (`dogfooding` and the `example` apps are `publish_to: none`.)

## Inputs

1. **Version** — `X.Y.Z` (stable) or `X.Y.Z-suffix` (pre-release, e.g. `1.5.0-beta.1`). A hyphen makes it a GitHub
   pre-release automatically.
2. **Previous tag** for the release-notes diff: `gh release list --limit 10` → the most recent `vX.Y.Z` tag.

## Pre-flight

Run these checks. **If any fail, stop, surface the failure to the user, and do not try to auto-fix** (no stashing,
no force-pull, no killing processes).

- `git status --short -uno` clean after `git checkout main` + `git pull --ff-only`.
- `gh auth status` succeeds.
- `gh pr list --head release/v<version> --state all --json number` returns `[]`.
- Latest CI on `main` is green: `gh run list --branch main --limit 5` — no failures on the most recent runs.

## Steps

### 1. Branch off main

```bash
git checkout -b release/v<version>
```

### 2. Bump the version everywhere

This repo has **no version-bump automation** — no `melos version` step, and no version-generation hook (unlike chat,
which regenerates `version.dart` via a post-bootstrap hook). Edit every version reference by hand, bumping each to
`<version>`:

- **`version:`** in each of the 6 `packages/*/pubspec.yaml`. Do **not** touch `packages/*/example/pubspec.yaml` or
  `dogfooding/pubspec.yaml` — `melos bootstrap` syncs those.
- **`stream_video*: ^<version>`** constraints — find them all with
  `grep -rn "stream_video[a-z_]*: \^" packages/*/pubspec.yaml pubspec.yaml | grep -v example`. This covers the
  intra-package deps (e.g. `stream_video_flutter` → `stream_video`) **and** the root `pubspec.yaml`
  `melos.command.bootstrap.dependencies` block.
- **`s.version`** in the 5 iOS podspecs: `packages/*/ios/*.podspec`.
- **`streamVideoVersion`** in `packages/stream_video/lib/globals.dart`.

Then propagate to the examples and dogfooding app:

```bash
dart run melos bootstrap
```

Verify the diff shape matches the previous release. Find it with:

```bash
gh pr list --search "chore(repo): release in:title" --state merged --limit 5 --json number,title
git diff --stat
```

### 3. Finalise the CHANGELOGs

One per package: `packages/{stream_video, stream_video_flutter, stream_video_push_notification,
stream_video_noise_cancellation, stream_video_screen_sharing, stream_video_filters}/CHANGELOG.md`.

For each, **apply the first matching rule** (it's a decision tree):

1. **Top section is `## Upcoming` / `## Upcoming Changes`** → rename to `## <version>`. Keep bullets.
2. **User-facing changes since `v<prev>`** (`git log v<prev>..HEAD --oneline -- packages/<pkg>`) → add a
   `## <version>` header with bullets under the existing emoji sections only (`### ✅ Added`, `### 🐞 Fixed`,
   `### 🔄 Changed`, `### ⚠️ Deprecated`, `### ✨ Refactor`). Don't invent section names.
3. **Only a `stream_video` dep bump** (no in-package changes) →
   ```
   ## <version>

   - Updated `stream_video` dependency to [`<version>`](https://pub.dev/packages/stream_video/changelog).
   ```
4. **Anything else** (internal-only, tests, refactors, or nothing) → `## <version>` + `- Minor bug fixes and improvements`.

**Every package gets a `## <version>` header**, even for a dep-bump-only entry. Empty sections and missing headers
both fail pana.

### 4. Sanity-check

```bash
dart run melos run analyze:error
dart run melos run lint:pub
```

`lint:pub` is a no-op until the versions are unpublished, so it mainly confirms nothing is broken. If either fails,
surface to the user and stop.

### 5. Commit and push

```bash
git add -A
git commit -m "chore(repo): release v<version>"
git push -u origin release/v<version>
```

Single commit. The message format is load-bearing: `release_tag.yml` parses `vX.Y.Z` from it after merge.

### 6. Generate the PR body

The body **must be exactly what GitHub's "Generate release notes" produces** — no template wrapper, no extra
description. The auto-appended "New Contributors" block stays in.

```bash
gh api repos/GetStream/stream-video-flutter/releases/generate-notes \
  -f tag_name=v<version> \
  -f previous_tag_name=v<previous> \
  -f target_commitish=main \
  --jq .body > /tmp/release-notes.md
```

Read it once to skim. If a PR title looks wrong, fix it on the originating PR upstream and re-run — don't hand-edit
the file.

### 7. Open the PR

```bash
gh pr create \
  --base main \
  --head release/v<version> \
  --title "chore(repo): release v<version>" \
  --body-file /tmp/release-notes.md
```

Return the PR URL and stop.

## After merge (FYI)

`release_tag.yml` extracts `vX.Y.Z` from the commit and pushes the tag with the bot token. `release_publish.yml`
then runs `melos run release:pub` and creates the GitHub release. Hyphenated tags publish as pre-releases.

## Don't

- **Never create a GitHub release** (`gh release create`, `POST /repos/.../releases`). Step 6 uses `generate-notes`,
  which is read-only. The release is created by `release_publish.yml` after the tag is pushed.
- **Never push a tag.** `release_tag.yml` does it on merge.
- **Never run `melos run release:pub`.** That's the publish step the workflow triggers on tag push. Even if asked,
  refuse — running it locally publishes from an unreviewed working tree.
- **Never merge the PR.** Return the URL and stop.

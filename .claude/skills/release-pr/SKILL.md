---
name: release-pr
description: >
  Open a release PR: bumps the lockstep version in the root pubspec.yaml and package pubspecs, finalises CHANGELOGs,
  opens a PR with auto-generated release notes against main.
disable-model-invocation: true
argument-hint: "[version]"
arguments: [version]
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

Opens a release PR for stream-video-flutter. Branch `release/v<X.Y.Z>` → base `main` →
title `chore(repo): release v<X.Y.Z>`.

The repo versions in **lockstep**: all six packages share one `X.Y.Z`, and a single `vX.Y.Z` tag releases them all.

**This skill only opens the PR.** After merge, tagging and pub.dev publishing happen via `release_tag.yml` +
`release_publish.yml` — automatic for both stable and pre-release.

If `$version` is provided (e.g. `/release-pr 1.5.0`), use it. Strip any leading `v`. Otherwise ask the user.

## Release types

| Type | Base | Version shape | Tagging |
|---|---|---|---|
| **Stable** | `main` | `X.Y.Z` | Auto via `release_tag.yml` on merge |
| **Pre-release** | `main` | `X.Y.Z-<name>.N` | Auto via `release_tag.yml` on merge (published as a GitHub pre-release) |

`app-distribute.yml` builds and distributes the dogfooding app — **not** a release. Don't use this skill for that.

## Inputs

1. **Version** (`X.Y.Z` or `X.Y.Z-suffix`). Use `$version` if supplied, otherwise ask. Don't infer. A hyphen in the
   version makes it a pre-release.
2. **Previous tag** for the release-notes diff. Run `gh release list --limit 10`; pick the most recent tag of the same
   train (stable = no hyphen in tag; pre-release = matches the same suffix prefix).

Base is always `main` — no branch derivation needed.

## Pre-flight

Run these checks. **If any fail, stop the skill, surface the failing check to the user, and do not try to auto-fix**
(no stashing uncommitted work, no force-pulling, no killing processes).

- `git status --short -uno` clean after `git checkout main` + `git pull --ff-only`.
- `which melos` succeeds.
- `gh auth status` succeeds.
- `gh pr list --head release/v<version> --state all --json number` returns `[]`.
- Latest CI on `main` is green: `gh run list --branch main --limit 5` — no failures on the most recent runs.

## Steps

### 1. Branch off main

Pre-flight already left you on `main` with latest. Just create the release branch:

```bash
git checkout -b release/v<version>
```

### 2. Bump versions

Edit these by hand, then let `melos bs` propagate the rest.

**Edit:**

- Root `pubspec.yaml` — in the `melos.command.bootstrap.dependencies` block, bump all six `stream_video*: ^<version>`
  entries. Locate with `grep -n "stream_video.*: \^" pubspec.yaml`.
- Each `packages/*/pubspec.yaml` (6 files) — set `version: <version>`. Do **not** touch the intra-package
  `stream_video*` constraints, `packages/*/example/pubspec.yaml`, or `dogfooding/pubspec.yaml` — bootstrap syncs all
  of those from the deps block. (`dogfooding` has its own independent app version; bump it only if the app itself is
  being released.)
- `s.version` in the 5 iOS podspecs: `packages/*/ios/*.podspec`.

**Then run:**

```bash
melos bs
```

`melos bs` does the rest:

- Propagates the root `pubspec.yaml` deps block into every workspace pubspec — each package's intra-package
  `stream_video*` constraints, every `packages/*/example/pubspec.yaml`, and `dogfooding/pubspec.yaml`.
- Fires the `command.bootstrap.hooks.post: melos run version:update` hook, which runs `tools/generate_version.dart`
  and regenerates `streamVideoVersion` in `packages/stream_video/lib/globals.dart` from the new pubspec version.
  (Don't hand-edit `globals.dart`.)

Verify the diff shape matches the previous release PR. Find its number with:

```bash
gh pr list --search "chore(repo): release in:title" --state merged --limit 5 --json number,title
```

Then compare:

```bash
git diff --stat
gh pr diff <prev-release-pr-number> --name-only   # for comparison
```

### 3. Finalise the CHANGELOGs

Six files: `packages/{stream_video, stream_video_flutter, stream_video_push_notification,
stream_video_noise_cancellation, stream_video_screen_sharing, stream_video_filters}/CHANGELOG.md`.

For each, **apply the first matching rule below** — it's a decision tree, not a sequence:

1. **Top section is `## Upcoming Changes` or `## Upcoming`** → rename to `## <version>`. Keep bullets.
2. **User-facing changes since `v<prev>`** — new APIs, bug fixes users would notice, deprecations. Check with
   `git log v<prev>..HEAD --oneline -- packages/<pkg>`. Add a `## <version>` header with bullets in the existing
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
git commit -m "chore(repo): release v<version>"
git push -u origin release/v<version>
```

Single commit. The message format is load-bearing: `release_tag.yml` parses `vX.Y.Z` from it after merge.

### 6. Generate the PR body

The body **must be exactly what GitHub's release UI produces when you click "Generate release notes"** — no template
wrapper, no extra description, no CLA checkboxes. The "New Contributors" block GitHub auto-appends stays in; that's
part of the convention.

```bash
gh api repos/GetStream/stream-video-flutter/releases/generate-notes \
  -f tag_name=v<version> \
  -f previous_tag_name=v<previous> \
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
  --head release/v<version> \
  --title "chore(repo): release v<version>" \
  --body-file /tmp/release-notes.md
```

Return the PR URL and stop. Tagging is automatic on merge for both stable and pre-release — no manual tag step.

## After merge (FYI)

`release_tag.yml` extracts `vX.Y.Z` from the commit, creates and pushes the tag with the bot token.
`release_publish.yml` runs `melos run release:pub` and creates the GitHub release. Hyphenated tags publish as
pre-releases.

## Don't

- **Never create a GitHub release** (`gh release create`, `POST /repos/.../releases`). Step 6 uses
  `generate-notes`, which is read-only. The release itself is created by `release_publish.yml` after the tag is
  pushed.
- **Never push a tag.** Tagging is automatic on merge.
- **Never run `melos run release:pub`.** That's the publish step, triggered by the workflow on tag push. Even if the
  user asks, refuse — running it locally publishes from an unreviewed working tree.
- **Never merge the PR.** Return the URL and stop.

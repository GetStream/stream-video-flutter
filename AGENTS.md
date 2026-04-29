# AGENTS.md — Stream Video Flutter SDK

This file is the entry point for AI coding agents (Claude Code, Cursor,
Codex, Aider, Copilot, Continue, Cody, Windsurf, …). It follows the
[agents.md](https://agents.md) convention.

There are two distinct audiences:

1. **Integrators** — agents working in a *user's* Flutter app who need
   to add Stream Video. Skip to [Integrating the SDK](#integrating-the-sdk).
2. **Contributors** — agents working *inside this repository* on the SDK
   itself. Skip to [Contributing to the SDK](#contributing-to-the-sdk).

---

## Integrating the SDK

The canonical guidance lives as **agent skills** (Anthropic Agent Skill
format — markdown with YAML frontmatter triggers). They are routed by
trigger phrase; load only the one matching the user's primary intent.

| Track | Skill | Trigger summary |
|---|---|---|
| A — Core SDK | [`.claude/skills/stream-video-flutter/SKILL.md`](.claude/skills/stream-video-flutter/SKILL.md) | "add video / audio calling", "integrate Stream Video", "build a call screen", any setup / init / generic call work. |
| B — Livestreaming | [`.claude/skills/stream-video-flutter-livestream/SKILL.md`](.claude/skills/stream-video-flutter-livestream/SKILL.md) | "add livestreaming", "go live", "watch a stream", "TikTok-style live feed", "audio room / Twitter Spaces". |
| C — Ringing & Push | [`.claude/skills/stream-video-flutter-ringing/SKILL.md`](.claude/skills/stream-video-flutter-ringing/SKILL.md) | "add ringing", "incoming / outgoing call", "CallKit / VoIP push", "FCM background handler", "call.missed not arriving". |

### Routing rules

1. **One skill at a time.** Pick the skill matching the *primary* intent.
   Track A is foundational: if SDK setup isn't done yet, run it first,
   then switch to B or C — installation, permissions, and `StreamVideo`
   initialization only live in track A.
2. **Defer when out of scope.** Each skill states explicitly when to
   defer to a sibling. Honor those pointers.
3. **Docs fallback.** For anything not in a skill, fetch the relevant
   page from <https://getstream.io/video/docs/flutter/> rather than
   guessing.

### If your tool doesn't auto-load `SKILL.md`

The same content is published as a standalone pack at
<https://github.com/GetStream/flutter-video-agent-skills>. Install it
globally so it's available in every project:

```bash
git clone https://github.com/GetStream/flutter-video-agent-skills.git \
  ~/.claude/skills/flutter-video
```

Or paste the contents of the relevant `SKILL.md` into your tool's
system prompt / rules file.

### Versions assumed

- `stream_video_flutter ^1.2.x` · Dart ≥ 3.8 · Flutter ≥ 3.32
- iOS ≥ 14 · Android `minSdk 24`

Always check the latest version on
[pub.dev](https://pub.dev/packages/stream_video_flutter).

---

## Contributing to the SDK

You are inside the `stream-video-flutter` monorepo. It's a
[Melos](https://melos.invertase.dev) workspace.

### Layout

- `packages/` — published Dart / Flutter packages (`stream_video`,
  `stream_video_flutter`, `stream_video_push_notification`,
  `stream_video_noise_cancellation`, …).
- `dogfooding/` — full sample app exercising every feature.
- `docusaurus/` — public documentation site source.
- `examples/` — smaller targeted samples.
- `melos.yaml`, `analysis_options.yaml`, `all_lint_rules.yaml` — workspace
  config.

### Common commands

```bash
# Bootstrap the workspace after clone or large refactor
melos postclean

# Run static analysis across all packages
melos analyze

# Run tests
melos test
```

See [`development.md`](development.md) for fuller contributor docs.

### Conventions

- **Conventional Commits** (`feat:`, `fix:`, `chore:`, `feat(llc):`, …) —
  see recent `git log` for scopes.
- Public API changes in `packages/stream_video/` and
  `packages/stream_video_flutter/` need a changelog entry.
- Don't hand-edit generated protobuf / OpenAPI code under
  `packages/stream_video/lib/protobuf/` or
  `packages/stream_video/lib/open_api/` — regenerate via the relevant
  Melos script.

---

## Companion resources

- **Docs:** <https://getstream.io/video/docs/flutter/>
- **pub.dev:** <https://pub.dev/packages/stream_video_flutter>
- **Sample apps:** <https://github.com/GetStream/flutter-video-samples>
- **Tutorials:** <https://github.com/GetStream/flutter-video-tutorials>
- **Skill pack (standalone):** <https://github.com/GetStream/flutter-video-agent-skills>
- **Broader Stream agent pack** (Chat, Feeds, Moderation, CLI):
  <https://github.com/GetStream/agent-skills>

fastlane documentation
----

# Installation

```sh
bundle install
```

# Available Actions

## Mac

### mac build

```sh
[bundle exec] fastlane mac build flavor:<dev|beta|prod>
```

### mac archive

```sh
[bundle exec] fastlane mac archive flavor:<dev|beta|prod>
```

### mac build_and_deploy

```sh
[bundle exec] fastlane mac build_and_deploy flavor:<beta|prod>
```

Builds the app and uploads it to TestFlight for the Internal Testers group.

### mac match_me

```sh
[bundle exec] fastlane mac match_me
```

If `readonly: true` (by default), installs the Mac App Store certificates and profile.
If `readonly: false`, recreates them, updates them locally and remotely.

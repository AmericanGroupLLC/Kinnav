fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios test

```sh
[bundle exec] fastlane ios test
```

Run the Flutter test suite

### ios build

```sh
[bundle exec] fastlane ios build
```

Build a signed App Store IPA (manual signing)

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Build + upload to TestFlight

### ios upload

```sh
[bundle exec] fastlane ios upload
```

Upload the existing .ipa to TestFlight (no rebuild)

### ios metadata

```sh
[bundle exec] fastlane ios metadata
```

Push listing metadata only — no binary, no screenshots

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

Push screenshots only — no binary, no metadata

### ios release

```sh
[bundle exec] fastlane ios release
```

Build + upload binary, metadata and screenshots (does NOT submit)

----


## Android

### android beta

```sh
[bundle exec] fastlane android beta
```

Build + upload the AAB to the Play internal track

### android release

```sh
[bundle exec] fastlane android release
```

Build + upload the AAB straight to production

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

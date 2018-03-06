# Bonjour Browser Patcher

Update Bonjour Browser (http://www.tildesoft.com) with new services

## Usage

### Automated Patcher

An automated patch program is provided. This expects to be run against a clean version of Bonjour Browser, so either run any earlier patch versions' revert steps, or download it fresh.

You can then download the zip file, right-click the application and choose "Open", and the patcher will find Bonjour Browser and apply the patch.

### Manual

If you're suspicious of the automatic patcher or generally feel okay with using the command line, you can do the following:

1. Open a terminal to the directory in which Bonjour Browser is installed
2. Run `patch -p1 -i /path/to/bonjour-browser.patch`

## Changes

This adds a bunch of services which have popped up on Apple and other devices since the last update to Bonjour Browser (2006!).

Eventually, I hope to convert this from being a raw patch file to being a list of services people can update and edit, but for now patches must be applied to... the patch file.

## Producing the patch

The patch is built by mounting the disk image of the unpatched Bonjour Browser version, whilst having the modified version in `~/Applications`.

The command to create the patch is then as follows:

```bash
(
  set -euo pipefail
  cd ~/Applications
  diff \
    --unified \
    --recursive \
    --ignore-blank-lines \
    "/Volumes/Bonjour Browser/Bonjour Browser.app/Contents/Resources" \
    "./Bonjour Browser.app/Contents/Resources"
) > bonjour-browser.patch
```

## Building the patcher

The patcher is written in AppleScript, and relies upon the `patch` utility being available on the user's computer. You can build a copy of it by checking out the repository and running `build.sh`. The application will be created in an Applications folder under the repository.

## Disclaimer

This is in no way affiliated with the original author of Bonjour Browser and is in no way supported by them.

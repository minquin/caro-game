#!/usr/bin/env bash
# Netlify build: fetch (or reuse) the Flutter SDK, then build the web release.
set -euo pipefail

# Reuse a Flutter SDK left over from a previous build if it is usable; otherwise start from a clean clone.
if [ ! -x flutter/bin/flutter ]; then
  rm -rf flutter
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi
export PATH="$PATH:$(pwd)/flutter/bin"

# Make sure Flutter has written its version cache, then repair it if the SDK version could not be detected.
flutter --version > /dev/null || true
node scripts/fix-flutter-version.cjs flutter

flutter build web --release

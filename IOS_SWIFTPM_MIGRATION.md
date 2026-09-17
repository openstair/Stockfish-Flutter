# iOS Swift Package Manager migration

This version uses Swift Package Manager for iOS. CocoaPods is not part of the
Stockfish plugin.

## NNUE files

The Stockfish NNUE files are intentionally **not committed to Git** and are
not stored in Git LFS.

Before building the iOS package, run:

```bash
cd ios/stockfish
./download_nnue.sh
```

The script downloads the two required networks into:

```text
ios/stockfish/Sources/stockfish/Stockfish/src/nnue_embedded/
```

It verifies both files with SHA-256 before allowing the build to continue.

The NNUE files are then embedded into the native Stockfish binary at compile
time with `incbin.h`. They are not runtime resources and are not downloaded by
the app.

### Flutter Pub cache

When the plugin is consumed as a Git dependency, Flutter checks it out under
`~/.pub-cache/git/Stockfish-Flutter-<commit>/`.

Run the script from that checkout:

```bash
CACHE="$(ls -d ~/.pub-cache/git/Stockfish-Flutter-* | head -1)"
"$CACHE/ios/stockfish/download_nnue.sh"
```

If the download server is unavailable, manually place the two verified NNUE
files in the `nnue_embedded` directory shown above.

## Important SwiftPM limitation

SwiftPM package build plugins cannot be used here as an automatic replacement
for the old CocoaPods `script_phase`: network access for a build-time plugin is
sandboxed. Therefore the download is an explicit package setup step rather than
a hidden network operation during compilation.

## Native API

The existing exported FFI functions and Dart API are unchanged:

- `stockfish_init`
- `stockfish_main`
- `stockfish_stdin_write`
- `stockfish_stdout_read`

## iOS package

The Swift package is:

`ios/stockfish/Package.swift`

The package uses Flutter's generated `FlutterFramework` local package
dependency.

## Build

After downloading the NNUE files into the package checkout:

```bash
flutter clean
flutter pub get --no-example
flutter build ipa
```

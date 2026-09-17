# iOS Swift Package Manager migration

This version adds Swift Package Manager support for the iOS Stockfish plugin.

## Important

The two Stockfish NNUE files are committed under:

`ios/stockfish/Sources/stockfish/Stockfish/src/`

They are **not** Swift package runtime resources. Stockfish's `incbin.h` embeds
the default networks into the native binary at compile time.

The plugin therefore does not download NNUE files during build or runtime.

## iOS package

The Swift package is:

`ios/stockfish/Package.swift`

It uses Flutter's generated `FlutterFramework` local package dependency.

## Legacy CocoaPods

`ios/stockfish.podspec` is retained for compatibility with Flutter projects
that still use CocoaPods. It points to the same migrated source tree and no
longer contains NNUE download script phases.

## Native API

The existing exported FFI functions and Dart API are preserved:

- `stockfish_init`
- `stockfish_main`
- `stockfish_stdin_write`
- `stockfish_stdout_read`

The iOS implementation continues to use `DynamicLibrary.process()`.

## Recommended verification

Use Flutter 3.44 or later.

```bash
flutter clean
flutter pub get
flutter run
```

For an archive:

```bash
flutter build ipa
```

In Xcode, verify that the generated `FlutterGeneratedPluginSwiftPackage`
contains the `stockfish` package and that the package builds for the intended
device/simulator architecture.

## Important limitation

This environment cannot run Xcode/iOS builds, so this ZIP has been checked
structurally and the Swift package manifest has been prepared, but an actual
Xcode compile/archive still needs to be performed on macOS with Xcode.

# SwiftPM migration manifest

## Added

- `ios/stockfish/Package.swift`
- `ios/stockfish/Sources/stockfish/include/stockfish/StockfishPlugin.h`
- `ios/stockfish/Sources/stockfish/StockfishPlugin.mm`
- `ios/stockfish/Sources/stockfish/FlutterStockfish/ffi.cpp`
- `ios/stockfish/Sources/stockfish/FlutterStockfish/ffi.h`
- `ios/stockfish/Sources/stockfish/Stockfish/src/**`
- `ios/stockfish/Sources/stockfish/Stockfish/src/nn-c288c895ea92.nnue`
- `ios/stockfish/Sources/stockfish/Stockfish/src/nn-37f18f62d772.nnue`
- `IOS_SWIFTPM_MIGRATION.md`

## Modified

- `ios/stockfish.podspec`

The podspec now points to the migrated source tree and no longer downloads
NNUE files.

## Removed

The old iOS native source locations were removed after being moved into the
SwiftPM package:

- `ios/Classes/`
- `ios/FlutterStockfish/`
- `ios/Stockfish/`
- `ios/Assets/`

## Not changed

- Dart API
- Android implementation
- Stockfish C++ source logic
- FFI exported function names
- `pubspec.yaml`

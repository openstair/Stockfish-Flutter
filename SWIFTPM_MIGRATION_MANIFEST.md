# SwiftPM migration manifest

## Added

- `ios/stockfish/Package.swift`
- `ios/stockfish/Sources/stockfish/include/stockfish/StockfishPlugin.h`
- `ios/stockfish/Sources/stockfish/StockfishPlugin.mm`
- `ios/stockfish/Sources/stockfish/FlutterStockfish/ffi.cpp`
- `ios/stockfish/Sources/stockfish/FlutterStockfish/ffi.h`
- `ios/stockfish/Sources/stockfish/Stockfish/src/**` (with `main.cpp` renamed to `stockfish_main.cpp` to keep the SwiftPM target a library)
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


## NNUE integrity

The bundled networks are the exact files supplied for this migration:

- `nn-c288c895ea92.nnue` — SHA-256 `c288c895ea924429ea9092e3f36b2b3c1f00f2a3a4c759ff7e57e79e3b43e4a7`
- `nn-37f18f62d772.nnue` — SHA-256 `37f18f62d772f3107e1d6aaca3898c130c3c86f2ab63e6555fbbca20635a899d`

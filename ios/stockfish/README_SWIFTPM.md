# Swift Package Manager migration notes

## NNUE embedding

The Stockfish NNUE networks are bundled in `Sources/stockfish/Stockfish/src/`:

- `nn-c288c895ea92.nnue`
- `nn-37f18f62d772.nnue`

Stockfish's `incbin.h` embeds these files into the native binary at compile time. SwiftPM/Xcode compile C++ sources from a derived build directory, so the assembler cannot find a source-adjacent `.incbin` file using only the C++ header search path.

`Package.swift` therefore derives the package's absolute `Stockfish/src` path from `#filePath` and passes it to Clang's integrated assembler with:

```text
-Wa,-I,<package>/Sources/stockfish/Stockfish/src
```

This is the critical fix for Xcode's:

```text
Could not find incbin file 'nn-c288c895ea92.nnue'
```

and

```text
Could not find incbin file 'nn-37f18f62d772.nnue'
```

No runtime download is required.

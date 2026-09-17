# Swift Package Manager migration notes

## NNUE embedding

The NNUE networks are stored as normal Git files under:

`Sources/stockfish/Stockfish/src/nnue_embedded/`

The large network is split into three files because GitHub's normal Git blob
limit is 100 MiB:

- `nn-c288c895ea92.part01`
- `nn-c288c895ea92.part02`
- `nn-c288c895ea92.part03`

The smaller network is stored directly as:

- `nn-37f18f62d772.nnue`

`network.cpp` uses `.incbin` consecutively with no padding between the three
large-network parts, so the embedded byte stream is identical to the original
109 MB NNUE file.

`Package.swift` derives the package's absolute path from `#filePath` and passes
the four NNUE paths to the C++ compiler. No Git LFS, runtime download, or
build-time network download is required.

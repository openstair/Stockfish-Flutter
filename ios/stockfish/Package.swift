// swift-tools-version: 5.9
//
// Swift Package Manager support for the Flutter Stockfish plugin.
//
// Stockfish is a C++ engine. Its standalone CLI entry point is kept as
// stockfish_main.cpp (rather than main.cpp) so SwiftPM treats this target
// as a library. The Flutter FFI bridge calls main(argc, argv) directly.
// The NNUE files are committed as normal Git files. The large network is split
// into three parts and embedded consecutively at compile time; they are not
// runtime package resources.

import PackageDescription
import Foundation

// SwiftPM compiles C++ sources from a derived directory. The assembler's
// .incbin paths therefore use absolute package-resolved paths supplied below.
let packageRoot = URL(fileURLWithPath: #filePath).deletingLastPathComponent().path
let stockfishSourcePath = "\(packageRoot)/Sources/stockfish/Stockfish/src"

let package = Package(
    name: "stockfish",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(
            name: "stockfish",
            targets: ["stockfish"]
        )
    ],
    dependencies: [
        .package(
            name: "FlutterFramework",
            path: "../FlutterFramework"
        )
    ],
    targets: [
        .target(
            name: "stockfish",
            dependencies: [
                .product(
                    name: "FlutterFramework",
                    package: "FlutterFramework"
                )
            ],
            exclude: [
                "Stockfish/src/incbin/UNLICENCE"
            ],
            publicHeadersPath: "include",
            cxxSettings: [
                .headerSearchPath("include/stockfish"),
                .headerSearchPath("FlutterStockfish"),
                .headerSearchPath("Stockfish/src"),

                .define("USE_PTHREADS"),
                .define("IS_64BIT"),
                .define("USE_POPCNT"),

                .unsafeFlags([
                    "-fno-exceptions",
                    "-DNDEBUG",
                    "-O3",
                    "-DUSE_NEON=8",
                    "-flto=full"
                ], .when(configuration: .release)),

                // The large NNUE is split into normal Git files (<100 MiB each).
                // network.cpp embeds the three parts consecutively with .incbin.
                .unsafeFlags([
                    "-DSTOCKFISH_NNUE_BIG_PART01_PATH=\"\(stockfishSourcePath)/nnue_embedded/nn-c288c895ea92.part01\"",
                    "-DSTOCKFISH_NNUE_BIG_PART02_PATH=\"\(stockfishSourcePath)/nnue_embedded/nn-c288c895ea92.part02\"",
                    "-DSTOCKFISH_NNUE_BIG_PART03_PATH=\"\(stockfishSourcePath)/nnue_embedded/nn-c288c895ea92.part03\"",
                    "-DSTOCKFISH_NNUE_SMALL_PATH=\"\(stockfishSourcePath)/nnue_embedded/nn-37f18f62d772.nnue\""
                ])
            ],
            linkerSettings: [
                .linkedLibrary("c++")
            ]
        )
    ],
    cxxLanguageStandard: .cxx17
)

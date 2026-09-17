// swift-tools-version: 5.9
//
// Swift Package Manager support for the Flutter Stockfish plugin.
//
// Stockfish is a C++ engine. Its standalone CLI entry point is kept as
// stockfish_main.cpp (rather than main.cpp) so SwiftPM treats this target
// as a library. The Flutter FFI bridge calls main(argc, argv) directly.
// The NNUE files are source-adjacent because Stockfish embeds them with
// incbin.h at compile time; they are not runtime package resources.

import PackageDescription
import Foundation

// SwiftPM compiles C++ sources from a derived build directory. Stockfish
// uses the assembler-level .incbin directive, whose relative lookup is based
// on the assembler search path rather than the C++ source file location.
// Add the package's Stockfish/src directory to the assembler include path so
// the bundled NNUE files are found in both Xcode and command-line builds.
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

                // network.cpp uses incbin.h, which expands to assembler .incbin
                // directives. SwiftPM/Xcode assembles from a derived directory,
                // so an assembler search path alone is not reliable for inline
                // assembly. Pass the package-resolved absolute file paths to the
                // C++ source instead. The paths are only build-time metadata; the
                // NNUE bytes are still embedded into the engine binary.
                .unsafeFlags([
                    "-DSTOCKFISH_NNUE_BIG_PATH=\"\(stockfishSourcePath)/nn-c288c895ea92.nnue\"",
                    "-DSTOCKFISH_NNUE_SMALL_PATH=\"\(stockfishSourcePath)/nn-37f18f62d772.nnue\""
                ])
            ],
            linkerSettings: [
                .linkedLibrary("c++")
            ]
        )
    ],
    cxxLanguageStandard: .cxx17
)

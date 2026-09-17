// swift-tools-version: 5.9
//
// Swift Package Manager support for the Flutter Stockfish plugin.
//
// The Stockfish NNUE files are intentionally NOT stored in Git.
// download_nnue.sh downloads them into the package checkout before Xcode
// compiles the target. The files are then embedded into the native binary
// at compile time using incbin.h.

import PackageDescription
import Foundation

let packageRoot = URL(fileURLWithPath: #filePath).deletingLastPathComponent().path
let stockfishSourcePath = "\(packageRoot)/Sources/stockfish/Stockfish/src"
let nnuePath = "\(stockfishSourcePath)/nnue_embedded"

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

                // The NNUE files are downloaded by download_nnue.sh into the
                // package checkout. They are embedded at compile time; they
                // are never runtime resources.
                .unsafeFlags([
                    "-DSTOCKFISH_NNUE_BIG_PATH=\"\(nnuePath)/nn-c288c895ea92.nnue\"",
                    "-DSTOCKFISH_NNUE_SMALL_PATH=\"\(nnuePath)/nn-37f18f62d772.nnue\""
                ])
            ],
            linkerSettings: [
                .linkedLibrary("c++")
            ]
        )
    ],
    cxxLanguageStandard: .cxx17
)

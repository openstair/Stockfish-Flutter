// swift-tools-version: 5.9
//
// Swift Package Manager support for the Flutter Stockfish plugin.
//
// The Stockfish C++ engine and the NNUE files are intentionally kept in the
// same target. Stockfish's incbin.h embeds the default NNUE files directly
// into the native binary at compile time; they are not runtime resources.

import PackageDescription

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
                    "-std=c++17"
                ]),

                .unsafeFlags([
                    "-fno-exceptions",
                    "-DNDEBUG",
                    "-O3",
                    "-DUSE_NEON=8",
                    "-flto=full"
                ], .when(configuration: .release))
            ],
            linkerSettings: [
                .linkedLibrary("c++")
            ]
        )
    ]
)

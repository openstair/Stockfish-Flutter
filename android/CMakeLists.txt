cmake_minimum_required(VERSION 3.4.1)
project(stockfish)

# Enable 16KB page size support for Android (required for Google Play)
add_link_options(-Wl,-z,max-page-size=16384)
add_link_options(-Wl,-z,common-page-size=16384)

file(GLOB_RECURSE cppPaths "../ios/stockfish/Sources/stockfish/Stockfish/src/*.cpp")
add_library(
  stockfish
  SHARED
  ../ios/stockfish/Sources/stockfish/FlutterStockfish/ffi.cpp
  ${cppPaths}
)

target_include_directories(stockfish PRIVATE
  ../ios/stockfish/Sources/stockfish/FlutterStockfish
  ../ios/stockfish/Sources/stockfish/Stockfish/src
  ${CMAKE_BINARY_DIR}
)

if(ANDROID_ABI STREQUAL arm64-v8a)
  if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_options(stockfish PRIVATE -DUSE_PTHREADS -DIS_64BIT -DUSE_POPCNT -DUSE_NEON=8)
  else()
    target_compile_options(stockfish PRIVATE -fno-exceptions -DUSE_PTHREADS -DNDEBUG -O3 -DIS_64BIT -DUSE_POPCNT -DUSE_NEON=8)
  endif()
else()
  if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_options(stockfish PRIVATE -DUSE_PTHREADS)
  else()
    target_compile_options(stockfish PRIVATE -fno-exceptions -DUSE_PTHREADS -DNDEBUG -O3)
  endif()
endif()

if(NOT EXISTS "${CMAKE_BINARY_DIR}/nn-c288c895ea92.nnue")
  file(DOWNLOAD https://tests.stockfishchess.org/api/nn/nn-c288c895ea92.nnue ${CMAKE_BINARY_DIR}/nn-c288c895ea92.nnue)
endif()
if(NOT EXISTS "${CMAKE_BINARY_DIR}/nn-37f18f62d772.nnue")
  file(DOWNLOAD https://tests.stockfishchess.org/api/nn/nn-37f18f62d772.nnue ${CMAKE_BINARY_DIR}/nn-37f18f62d772.nnue)
endif()

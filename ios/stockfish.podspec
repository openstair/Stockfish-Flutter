#
# CocoaPods compatibility manifest.
#
# Swift Package Manager is the primary iOS package manager for this plugin.
# This podspec remains so older Flutter projects can continue to consume the
# plugin while they migrate to Swift Package Manager.
#
require 'yaml'

pubspec = YAML.load(File.read(File.join(__dir__, '../pubspec.yaml')))

Pod::Spec.new do |s|
  s.name             = pubspec['name']
  s.version          = pubspec['version']
  s.summary          = pubspec['description']
  s.homepage         = pubspec['homepage']
  s.license          = { :file => '../LICENSE', :type => 'GPL-3.0' }
  s.author           = 'Arjan Aswal'
  s.source = { :git => pubspec['repository'], :tag => s.version.to_s }

  s.source_files = 'stockfish/Sources/stockfish/**/*.{h,m,mm,c,cc,cpp,cxx}'
  s.public_header_files = 'stockfish/Sources/stockfish/include/stockfish/**/*.h'
  s.exclude_files = 'stockfish/Sources/stockfish/Stockfish/src/incbin/UNLICENCE'

  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.ios.deployment_target = '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }

  # NNUE files are committed as normal Git files. The large network is split
  # into three parts and network.cpp embeds the parts consecutively.
  nnue_dir = '${PODS_TARGET_SRCROOT}/stockfish/Sources/stockfish/Stockfish/src/nnue_embedded'
  nnue_flags = "-DSTOCKFISH_NNUE_BIG_PART01_PATH=\"#{nnue_dir}/nn-c288c895ea92.part01\" " \
               "-DSTOCKFISH_NNUE_BIG_PART02_PATH=\"#{nnue_dir}/nn-c288c895ea92.part02\" " \
               "-DSTOCKFISH_NNUE_BIG_PART03_PATH=\"#{nnue_dir}/nn-c288c895ea92.part03\" " \
               "-DSTOCKFISH_NNUE_SMALL_PATH=\"#{nnue_dir}/nn-37f18f62d772.nnue\""

  s.library = 'c++'

  s.xcconfig = {
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'CLANG_CXX_LIBRARY' => 'libc++',

    'OTHER_CPLUSPLUSFLAGS[config=Debug]' =>
      "$(inherited) #{nnue_flags} -std=c++17 -DUSE_PTHREADS -DIS_64BIT -DUSE_POPCNT -I\"${PODS_TARGET_SRCROOT}/stockfish/Sources/stockfish/Stockfish/src\"",

    'OTHER_LDFLAGS[config=Debug]' =>
      '$(inherited) -std=c++17 -DUSE_PTHREADS -DIS_64BIT -DUSE_POPCNT',

    'OTHER_CPLUSPLUSFLAGS[config=Release]' =>
      "$(inherited) #{nnue_flags} -fno-exceptions -std=c++17 -DUSE_PTHREADS -DNDEBUG -O3 -DIS_64BIT -DUSE_POPCNT -DUSE_NEON=8 -flto=full -I\"${PODS_TARGET_SRCROOT}/stockfish/Sources/stockfish/Stockfish/src\"",

    'OTHER_LDFLAGS[config=Release]' =>
      '$(inherited) -fno-exceptions -std=c++17 -DUSE_PTHREADS -DNDEBUG -O3 -DIS_64BIT -DUSE_POPCNT -DUSE_NEON=8 -flto=full'
  }
end

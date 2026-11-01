#!/usr/bin/env bash
# Установка современного Objective-C окружения на Linux (Debian/Ubuntu):
#   clang + libobjc2 (рантайм GNUstep) + libdispatch (GCD) + GNUstep Make + GNUstep Base (Foundation).
# Даёт ARC, блоки, литералы @[] @{} @42, lightweight generics и GCD — то же, что на macOS.
#
# Использование:   sudo ./install-toolchain.sh
# Без apt (зависимости уже стоят):   sudo SKIP_APT=1 ./install-toolchain.sh
set -euo pipefail

LIBOBJC2_TAG=v2.3
LIBDISPATCH_TAG=swift-6.4.0-RELEASE
MAKE_TAG=make-2_9_3
BASE_TAG=base-1_31_1
PREFIX=/usr/local
WORK=${WORK:-/tmp/objc-build}

if [ "${SKIP_APT:-0}" != "1" ]; then
  apt-get update
  apt-get install -y --no-install-recommends \
    clang cmake ninja-build make git ca-certificates pkg-config libffi-dev libcurl4-openssl-dev
fi

export CC=clang CXX=clang++
mkdir -p "$WORK" && cd "$WORK"

clone() { # clone <repo> <tag> <dir>
  rm -rf "$3"; git clone --quiet --depth 1 --branch "$2" "https://github.com/$1" "$3"
}

# 1. Рантайм libobjc2 (объектная модель, objc_msgSend, ARC, блоки)
clone gnustep/libobjc2 "$LIBOBJC2_TAG" libobjc2
(cd libobjc2 && git submodule update --init --depth 1 --quiet)
cmake -S libobjc2 -B libobjc2/build -G Ninja -DCMAKE_BUILD_TYPE=Release \
      -DTESTS=OFF -DCMAKE_INSTALL_PREFIX="$PREFIX"
ninja -C libobjc2/build install

# 2. libdispatch (Grand Central Dispatch), использует блоки из libobjc2
clone swiftlang/swift-corelibs-libdispatch "$LIBDISPATCH_TAG" libdispatch
cmake -S libdispatch -B libdispatch/build -G Ninja -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_TESTING=OFF -DINSTALL_PRIVATE_HEADERS=YES \
      -DBlocksRuntime_INCLUDE_DIR="$PREFIX/include" \
      -DBlocksRuntime_LIBRARIES="$PREFIX/lib/libobjc.so" \
      -DCMAKE_INSTALL_PREFIX="$PREFIX"
ninja -C libdispatch/build install

# 3. GNUstep Make (система сборки + gnustep-config)
clone gnustep/tools-make "$MAKE_TAG" tools-make
(cd tools-make && ./configure --prefix="$PREFIX" --with-layout=fhs \
    --disable-importing-config-file --enable-native-objc-exceptions \
    --enable-objc-arc --with-library-combo=ng-gnu-gnu && make install)

# 4. GNUstep Base (Foundation: NSString, NSArray, NSFileManager, NSThread, ...)
#    Минимальная сборка: без XML, TLS и ICU — для примеров курса не нужны.
clone gnustep/libs-base "$BASE_TAG" libs-base
(cd libs-base && ./configure --prefix="$PREFIX" --disable-xml --disable-tls --disable-icu \
    && make -j"$(nproc)" && make install)

ldconfig
echo
echo "Готово. Проверка:  gnustep-config --objc-flags"

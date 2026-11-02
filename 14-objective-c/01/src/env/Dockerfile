# Образ с современным Objective-C на Linux: clang + libobjc2 + libdispatch + GNUstep Base.
#
#   docker build -t objc-dev env/            # из каталога src/ (один раз, ~5-10 минут)
#   docker run --rm -it -v "$PWD":/work objc-dev            # интерактивная оболочка
#   docker run --rm -v "$PWD":/work objc-dev make run       # собрать и запустить все примеры
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
COPY install-toolchain.sh /tmp/install-toolchain.sh
RUN chmod +x /tmp/install-toolchain.sh \
 && /tmp/install-toolchain.sh \
 && rm -rf /tmp/objc-build /var/lib/apt/lists/*

WORKDIR /work
CMD ["bash"]

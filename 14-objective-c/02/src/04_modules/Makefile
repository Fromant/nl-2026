# Библиотека Geometry: статическая (.a) и динамическая (.so) + приложения.
#   make && ./app_static && ./app_shared && ./app_modules
CC        = clang
OBJCFLAGS := $(shell gnustep-config --objc-flags) -fobjc-arc -IGeometry
LIBS      := $(shell gnustep-config --base-libs)

GEO_SRC := $(wildcard Geometry/*.m)
GEO_OBJ := $(GEO_SRC:.m=.o)

all: app_static app_shared app_modules

# [lib]
Geometry/%.o: Geometry/%.m
	$(CC) $(OBJCFLAGS) -fvisibility=hidden -c $< -o $@

libGeometry.a: $(GEO_OBJ)                  # статическая библиотека = архив .o
	ar rcs $@ $^

libGeometry.so: $(GEO_OBJ)                 # динамическая библиотека
	$(CC) -shared $^ -o $@ $(LIBS)

app_static: main.m libGeometry.a
	$(CC) $(OBJCFLAGS) main.m libGeometry.a -o $@ $(LIBS)

app_shared: main.m libGeometry.so
	$(CC) $(OBJCFLAGS) main.m -L. -lGeometry -Wl,-rpath,'$$ORIGIN' -o $@ $(LIBS)
# [/lib]

app_modules: main_modules.m libGeometry.a
	$(CC) $(OBJCFLAGS) -fmodules -fmodules-cache-path=.modcache \
	      main_modules.m libGeometry.a -o $@ $(LIBS)

exports: libGeometry.so
	nm -D --defined-only libGeometry.so | grep -i gm

clean:
	rm -rf Geometry/*.o Geometry/*.d *.d libGeometry.* app_* .modcache geometry_demo obj

.PHONY: all clean exports

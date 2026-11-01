# Сборка примеров: clang + GNUstep (libobjc2) на Linux.
#   make            — собрать все *.m
#   make run        — собрать и запустить по очереди
#   make 05_functions && ./05_functions  — один пример
# Файлы *_mrc.m собираются без ARC (ручное управление памятью).

CC        = clang
OBJCFLAGS := $(shell gnustep-config --objc-flags) -fobjc-arc
LIBS      := $(shell gnustep-config --base-libs) -ldispatch

SRC := $(wildcard *.m)
BIN := $(SRC:.m=)

all: $(BIN)

%_mrc: %_mrc.m
	$(CC) $(filter-out -fobjc-arc,$(OBJCFLAGS)) -fno-objc-arc $< -o $@ $(LIBS)

%: %.m
	$(CC) $(OBJCFLAGS) $< -o $@ $(LIBS)

run: all
	@for b in $(BIN); do echo "===== $$b"; ./$$b < /dev/null; done

clean:
	rm -f $(BIN) *.d

.PHONY: all run clean

# Тот же проект на системе сборки GNUstep Make:  make -f gnustep.mk && ./obj/geometry_demo
# [gnustepmake]
# по умолчанию GNUstep Make ищет файл GNUmakefile
MAKEFILE_NAME = gnustep.mk
GNUSTEP_MAKEFILES ?= $(shell gnustep-config --variable=GNUSTEP_MAKEFILES)
include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = geometry_demo
geometry_demo_OBJC_FILES = main.m Geometry/GMPoint.m Geometry/GMCircle.m
geometry_demo_OBJCFLAGS  = -fobjc-arc -IGeometry

include $(GNUSTEP_MAKEFILES)/tool.make
# [/gnustepmake]

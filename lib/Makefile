#
# lib-directory Makefile for idlpgr_cx
#
# Modification History
# 07/21/2013 Written by David G. Grier, New York University
# 06/19/2015 DGG Updated for idlpgr_cx
#
# Copyright (c) 2013-2015 David G. Grier
#
TARGET = idlpgr_cx
SRC = $(TARGET).c

#SYS  = $(shell uname -s | tr '[:upper:]' '[:lower:]')
#ARCH = $(shell uname -m)
#LIBRARY = $(TARGET).$(SYS).$(ARCH).so
LIBRARY = $(TARGET).so

IDL = idl -quiet
INSTALL = install
DESTINATION = lib

all: $(LIBRARY)

$(LIBRARY): $(SRC)
	@mkdir build 2>/dev/null ||:
	@$(IDL) compile_$(TARGET)

install: $(LIBRARY)
	sudo $(INSTALL) -d $(DESTINATION)
	sudo $(INSTALL) $(LIBRARY) $(DESTINATION)

uninstall:
	sudo rm $(DESTINATION)/*
	sudo rmdir $(DESTINATION)

test: $(TARGET)
	@$(IDL) testpgr

clean:
	-rm $(LIBRARY)
	-rmdir build

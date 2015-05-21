#
# Top-level Makefile for idlpgr_cx
#
# Modification History
# 07/21/2013 Written by David G. Grier, New York University
# 05/19/2015 DGG Revised for cx branch.
#
# Copyright (c) 2013-2015 David G. Grier
#
LIB = idlpgr_cx.so
IDLDIR = /usr/local/IDL
PRODIR = $(IDLDIR)/idlpgr_cx
LIBDIR = $(PRODIR)

all:
	make -C lib
	make -C idl

install: all
	make -C idl install DESTINATION=$(PRODIR)
	make -C lib install DESTINATION=$(LIBDIR)

uninstall:
	make -C idl uninstall DESTINATION=$(PRODIR)
	make -C lib uninstall DESTINATION=$(LIBDIR)

clean:
	make -C idl clean
	make -C lib clean

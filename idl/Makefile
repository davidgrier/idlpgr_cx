#
# IDL-directory Makefile for idlpgr
#
# Modification History
# 07/21/2013 Written by David G. Grier, New York University
# 05/19/2015 DGG Updated for idlpgr_cx
#
# Copyright (c) 2013-2015 David G. Grier
#
INSTALL = install
DESTINATION = pro
FILES = open_pgrcx.pro \
        close_pgrcx.pro \
        read_pgrcx.pro \
        dgghwpgrcx__define.pro

all:

clean:
	-rm *~

install: all
	sudo $(INSTALL) -d $(DESTINATION)
	sudo $(INSTALL) -m 644 $(FILES) $(DESTINATION)

uninstall:
	sudo rm $(DESTINATION)/$(FILES)
	sudo rmdir $(DESTINATION)

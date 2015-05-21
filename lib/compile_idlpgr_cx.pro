;;;;;
;
; compile_idlpgr_cx.pro
;
; IDL batch file to compile the shared library that provides
; an IDL interface for Point Grey cameras.
;
; Modification History:
; 07/19/2013 Written by David G. Grier, New York University
; 05/19/2015 DGG Updated for idlpgr_cx
;
; Copyright (c) 2013-2015 David G. Grier
;
project_directory = './'
compile_directory = './build'
infiles = 'idlpgr_cx'
outfile = 'idlpgr_cx'
ern = ['pgr_open', 'pgr_close', 'pgr_read']

extra_cflags = '-I/usr/include/flycapture'
extra_lflags = '-lflycapture-c -lflycapture'

;;;;;
;
; Build the library
make_dll, infiles, outfile, ern, $
          extra_cflags = extra_cflags, $
          extra_lflags = extra_lflags, $
	  input_directory = project_directory, $
          output_directory = project_directory, $
          compile_directory = compile_directory

exit

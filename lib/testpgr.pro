;;;;;
;
; testpgr
;
; Simple routine to test the IDL interface for
; Point Grey cameras
;
; MODIFICATION HISTORY:
; 07/22/2013 Written by David G. Grier, New York University
; 05/19/2015 DGG Updated for idlpgr_cx.
;
; Copyright (c) 2013-2015 David G. Grier
;

camera = DGGhwPGRcx()
print, "Acquiring 100 frames ..."
tic
for i = 0, 99 do $
  a = camera.read()
toc
print, "... done"
exit

idlpgr_cx

This package provides a rudimentary IDL interface for
Point Gray cameras based on the FlyCapture2_C API.
The preferred interface is through the DGGhwPGRcx
object:

camera = DGGhwPGRcx() ; object associated with first camera
tvscl, camera.read()  ; display the next image

To use this package, make sure that your IDL_PATH includes
/usr/local/IDL/idlpgr_cg

This package is written and maintained by David G. Grier
(david.grier@nyu.edu)

INSTALLATION
Requires the FlyCapture2 API to be installed, a working
installation of IDL, and administrator (sudo) authorization.
1. unpack the distribution in a convenient directory.
2. cd idlpgr_cx
3. make
4. make install

UNINSTALLATION
Requires administrator (sudo) authorization.
1. cd idlpgr_cx
2. make uninstall

//
// idlpgr_cx.c
//
// IDL-callable library implementing frame capturing
// from Point Grey cameras.  Based on the flycapture2 library.
//
// Modification History:
// 07/19/2013 Written by David G. Grier, New York University
// 05/19/2015 DGG Updated for idlpgr_cx
//
// Copyright (c) 2013-2015 David G. Grier
//
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

// IDL support
#include "idl_export.h"

// Point Grey support
#include "C/FlyCapture2_C.h"

fc2Context context;
fc2PGRGuid guid;
fc2Image   image;

//
// PGR_OPEN
//
// Initiates communication with Point Grey camera
// and returns parameters describing image geometry.
//
// argv[0]: OUT width
// argv[1]: OUT height
//
IDL_INT IDL_CDECL pgr_open(int argc, char *argv[])
{
  fc2Error error;
  unsigned int ncameras = 0;

  error = fc2CreateContext(&context);
  error = fc2GetNumOfCameras(context, &ncameras);
  if (ncameras != 1) {
	fprintf(stderr, "%d cameras found\n", ncameras);
	return (IDL_INT) -2;
  }	
  error = fc2GetCameraFromIndex(context, 0, &guid);
  error = fc2Connect(context, &guid);
  error = fc2StartCapture(context);
  error = fc2CreateImage(&image);
  error = fc2RetrieveBuffer(context, &image);

  // return information about video
  *(IDL_INT *) argv[0] = (IDL_INT) image.cols;
  *(IDL_INT *) argv[1] = (IDL_INT) image.rows;

  return (IDL_INT) error;
}

//
// PGR_CLOSE
//
// End communication with Point Grey camera
//
IDL_INT IDL_CDECL pgr_close(void)
{
  fc2Error error;

  error = fc2DestroyImage(&image);
  error = fc2StopCapture(context);
  error = fc2DestroyContext(context);
  return (IDL_INT) error;
}

//
// PGR_READ
//
// Acquire next video frame from camera
//
// argv[0]: OUT image data
//
IDL_INT IDL_CDECL pgr_read(int argc, char *argv[])
{
  fc2Error error;
  unsigned char *data;

  data = argv[0];
  error = fc2RetrieveBuffer(context, &image);
  memcpy(data, image.pData, (size_t) image.dataSize);

  return (IDL_INT) error;
}

//
// PGR_GETPROPERTY
//
// Described in /usr/include/flycapture/C/FlyCapture2Defs_C.h
//
// argv[0]: IN property type
// argv[1]: OUT present
// argv[2]: OUT absControl
// argv[3]: OUT onePush
// argv[4]: OUT onOff
// argv[5]: OUT autoManualMode
// argv[6]: OUT valueA
// argv[7]: OUT valueB
// argv[8]: OUT absValue
//
IDL_INT IDL_CDECL pgr_getproperty(int argc, char *argv[])
{
  fc2Error error;
  fc2Property property;

  property.type = (fc2PropertyType) * (IDL_LONG *) argv[0];
  error = fc2GetProperty(context, &property);
  *(IDL_LONG *) argv[1] = (IDL_LONG) property.present;
  *(IDL_LONG *) argv[2] = (IDL_LONG) property.absControl;
  *(IDL_LONG *) argv[3] = (IDL_LONG) property.onePush;
  *(IDL_LONG *) argv[4] = (IDL_LONG) property.onOff;
  *(IDL_LONG *) argv[5] = (IDL_LONG) property.autoManualMode;
  *(IDL_ULONG *) argv[6] = (IDL_ULONG) property.valueA;
  *(IDL_ULONG *) argv[7] = (IDL_ULONG) property.valueB;
  *(float *) argv[8] = property.absValue;

  return (IDL_INT) error;
}

//
// PGR_GETPROPERTYINFO
//
// argv[0]: IN property type
// argv[1]: OUT present
// argv[2]: OUT autosupported
// argv[3]: OUT manualsupported
// argv[4]: OUT onoffsupported
// argv[5]: OUT onepushsupported
// argv[6]: OUT readoutsupported
// argv[7]: OUT MIN
// argv[8]: OUT MAX
// argv[9]: OUT ABSMIN
// argv[10]: OUT ABSMAX
//
IDL_INT IDL_CDECL pgr_getpropertyinfo(int argc, char *argv[])
{
  fc2Error error;
  fc2PropertyInfo info;

  info.type = (fc2PropertyType) * (IDL_LONG *) argv[0];
  error = fc2GetPropertyInfo(context, &info);
  *(IDL_LONG *) argv[1] = (IDL_LONG) info.present;
  *(IDL_LONG *) argv[2] = (IDL_LONG) info.autoSupported;
  *(IDL_LONG *) argv[3] = (IDL_LONG) info.manualSupported;
  *(IDL_LONG *) argv[4] = (IDL_LONG) info.onOffSupported;
  *(IDL_LONG *) argv[5] = (IDL_LONG) info.onePushSupported;
  *(IDL_LONG *) argv[6] = (IDL_LONG) info.absValSupported;
  *(IDL_LONG *) argv[7] = (IDL_LONG) info.readOutSupported;
  *(IDL_ULONG *) argv[8] = (IDL_ULONG) info.min;
  *(IDL_ULONG *) argv[9] = (IDL_ULONG) info.max;
  *(float *) argv[10] = info.absMin;
  *(float *) argv[11] = info.absMax;

  return (IDL_INT) error;
}
// Really all we care about is gain, exposure time and frame rate

//
// PGR_SETPROPERTY
//

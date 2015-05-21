;+
; NAME:
;    DGGhwPGRcx
;
; PURPOSE:
;    Object interface to a Point Grey video camera
;
; CATEGORY:
;    Hardware automation, Video processing
;
; CALLING SEQUENCE:
;    a = DGGhwPGRcx()
;
; PROPERTIES:
;    dim   [ G ] dimensions of the image returned by the camera
;                dim[0]: width [pixels]
;                dim[2]: height [pixels]
;
;    data  [ G ] [nx, ny] array of byte-valued data
;    
; [ G ] grayscale: flag: grayscale if set
;
; METHODS:
;    GetProperty
;    SetProperty
;
;    Read(): acquire next image from camera and return the data
;    Read  : acquire next image from camera
;
; MODIFICATION HISTORY:
; 07/21/2013 Written by David G. Grier, New York University
; 05/19/2015 DGG Updated for idlpgr_cx.
;
; Copyright (c) 2013-2015 David G. Grier
;-

;;;;;
;
; DGGhwPGRcx::Read
;
; Acquire next video frame from camera
;
pro DGGhwPGRcx::Read

  COMPILE_OPT IDL2, HIDDEN

  error = call_external(self.dlm, 'pgr_read', *self._data)
end

;;;;;
;
; DGGhwPGRcx::Read()
;
; Return next video frame from camera
;
function DGGhwPGRcx::Read

  COMPILE_OPT IDL2, HIDDEN

  self.DGGhwPGRcx::read
  return, *self._data
end

;;;;;
;
; DGGhwPGRcx::GetProperty
;
pro DGGhwPGRcx::GetProperty, data = data, $
                             dim = dim, $
                             grayscale = grayscale
  COMPILE_OPT IDL2, HIDDEN

  if arg_present(data) then data = *self._data
  if arg_present(dim) then dim = self.dim
  if arg_present(grayscale) then grayscale = self.grayscale
end

;;;;;
;
; DGGhwPGRcx::Init()
;
; Initialize FlyCapture2_C library, connect to camera
;
function DGGhwPGRcx::Init

  COMPILE_OPT IDL2, HIDDEN

  self.dlm = '/usr/local/IDL/idlpgr_cx/idlpgr_cx.so'
  nx = 0
  ny = 0
  error = call_external(self.dlm, 'pgr_open', nx, ny) 
  if error then $
     return, 0B

  self.dim = [nx, ny]
  self.grayscale = 1L

  data = bytarr(nx, ny)
  self._data = ptr_new(data, /no_copy)

  return, 1B
end

;;;;;
;
; DGGhwPGRcx::Cleanup
;
; Free resources from FlyCapture2_C library
;
pro DGGhwPGRcx::Cleanup

  COMPILE_OPT IDL2, HIDDEN

  if ptr_valid(self._data) then $
     ptr_free, self._data

  error = call_external(self.dlm, 'pgr_close')
end

;;;;;
;
; DGGhwPGRcx__define
;
; Object for acquiring images from a Point Grey camera
;
pro DGGhwPGRcx__define

  COMPILE_OPT IDL2

  struct = {DGGhwPGRcx, $
            dlm: '', $
            dim: [0, 0], $
            _data: ptr_new(), $
            grayscale: 1L $
           }
end

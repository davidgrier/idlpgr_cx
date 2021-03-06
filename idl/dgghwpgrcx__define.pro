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
; DGGhwPGRcx::GetPGRProperty()
;
function DGGhwPGRcx::GetPGRProperty, type

  COMPILE_OPT IDL2, HIDDEN

  present = 0L
  abscontrol = 0L
  onepush = 0L
  onoff = 0L
  automanual = 0L
  valueA = 0UL
  valueB = 0UL
  absvalue = 0.
  error = call_external(self.dlm, 'pgr_getproperty', type, $
                        present, abscontrol, onepush, onoff, automanual, $
                        valueA, valueB, absvalue)
  return, {present:present, $
           abscontrol:abscontrol, $
           onepush:onepush, $
           onoff:onoff, $
           automanual:automanual, $
           valueA:valueA, $
           valueB:valueB, $
           absvalue:absvalue}
end

;;;;;
;
; DGGhwPGRcx::PropertyInfo
;
function DGGhwPGRcx::PropertyInfo, property

  COMPILE_OPT IDL2, HIDDEN

  present = 0L
  autosupported = 0L
  manualsupported = 0L
  onoffsupported = 0L
  onepushsupported = 0L
  absvalsupported = 0L
  readoutsupported = 0L
  min = 0UL
  max = 0UL
  absmin = 0.
  absmax = 0.

  if self.properties.haskey(property) then begin
     type = self.properties[property]
     error = call_external(self.dlm, 'pgr_getpropertyinfo', long(type), $
                           present, autosupported, manualsupported, $
                           onoffsupported, onepushsupported, $
                           absvalsupported, readoutsupported, $
                           min, max, absmin, absmax)
  endif

  return, {present:present, $
           autosupported:autosupported, $
           manualsupported:manualsupported, $
           onoffsupported:onoffsupported, $
           onepushsupported:onepushsupported, $
           absvalsupported:absvalsupported, $
           readoutsupported:readoutsupported, $
           min:min, max:max, $
           absmin:absmin, absmax:absmax}
end

;;;;;
;
; DGGhwPGRcx::GetProperty
;
pro DGGhwPGRcx::GetProperty, properties = properties, $
                             data = data, $
                             dim = dim, $
                             grayscale = grayscale, $
                             _ref_extra = propertylist
  COMPILE_OPT IDL2, HIDDEN

  if arg_present(data) then $
     data = *self._data
  if arg_present(dim) then $
     dim = self.dim
  if arg_present(grayscale) then $
     grayscale = self.grayscale
  if arg_present(properties) then $
     properties = self.properties.keys()
  
  if isa(propertylist) then begin
     foreach name, strlowcase(propertylist) do begin
        if self.properties.haskey(name) then begin
           type = self.properties[name]
           info = self.getpgrproperty(type)
           (scope_varfetch(name, /ref_extra)) = (info.present) ? $
                                                ((info.abscontrol) ? $
                                                 info.absvalue : $
                                                 info.valueA) : 0
        endif
      endforeach
   endif
end

;;;;;
;
; DGGhwPGRcx::SetProperty
;
pro DGGhwPGRcx::SetProperty, _ref_extra = propertylist

  COMPILE_OPT IDL2, HIDDEN

  if isa(propertylist) then begin
     foreach name,  strlowcase(propertylist) do begin
        if self.properties.haskey(name) then begin
           info = self.propertyinfo(name)
           if ~info.present then $
              continue
           if info.absvalsupported then begin
              absvalue = 1L
              value = float(scope_varfetch(name, /ref_extra))
              value >= info.absmin
              value <= info.absmax
           endif else begin
              absvalue = 0L
              value = long(scope_varfetch(name, /ref_extra))
              value >= info.min
              value <= info.max
           endelse
           type = self.properties[name]
           error = call_external(self.dlm, 'pgr_setproperty', $
                                 type, value, absvalue)
        endif
      endforeach
   endif
end

;;;;;
;
; DGGhwPGRcx::ControlProperty
;
pro DGGhwPGRcx::ControlProperty, property, $
                                 on = on, $
                                 off = off, $
                                 auto = auto, $
                                 manual = manual, $
                                 onepush = onepush

  COMPILE_OPT IDL2, HIDDEN

  if n_params() ne 1 then $
     return

  if ~self.properties.haskey(property) then $
     return

  type = self.properties[property]

  info = self.propertyinfo(property)

  onOff = -1L
  autoManual = -1L
  onePush = -1L

  if isa(on, /number, /scalar) && info.onoffsupported then $
     onOff = ~keyword_set(on)

  if isa(off, /number, /scalar) && info.onoffsupported then $
     onOff = keyword_set(off)

  if isa(auto, /number, /scalar) && info.autosupported then $
     autoManual = keyword_set(auto)

  if isa(manual, /number, /scalar) && info.autosupported then $
     autoManual = ~keyword_set(manual)

  if isa(onepush, /number, /scalar) && info.onepushsupported then $
     onePush = 1L

  error = call_external(self.dlm, 'pgr_controlproperty', type, $
                        onOff, autoManual, onePush)
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

  properties = ['brightness',    $
                'auto_exposure', $
                'sharpness',     $
                'white_balance', $
                'hue',           $
                'saturation',    $
                'gamma',         $
                'iris',          $
                'focus',         $
                'zoom',          $
                'pan',           $
                'tilt',          $
                'shutter',       $
                'gain',          $
                'trigger_mode',  $
                'trigger_delay', $
                'frame_rate',    $
                'temperature']
  indexes = indgen(n_elements(properties))
  self.properties = orderedhash(properties, indexes)

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
            grayscale: 1L, $
            properties: obj_new() $
           }
end

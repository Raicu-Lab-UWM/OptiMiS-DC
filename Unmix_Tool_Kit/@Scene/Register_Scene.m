function Obj = Register_Scene(Obj, Path, Name, nFrame, Spectrum, UnMix_Method, varargin)
if nargin >= 6, Info_File_Name              = varargin{1}; else [Info_File_Name, Path]              = uigetfile([Path '\*.txt'], 'Acquisition Information File');        end;
if nargin >= 7, CH_WL_Calibration_File_Name = varargin{2}; else [CH_WL_Calibration_File_Name, Path] = uigetfile([Path '\*.txt'], 'Wavelength Channel Calibration File'); end;

Obj.Path                      = [Obj.Path, Path];
Obj.Name                      = [Obj.Name, Name];
Obj.Frame_No                  = [Obj.Frame_No, nFrame];
Obj.Aqu_Info                  = [Obj.Aqu_Info, Obj.Load_Aqu_Info(Path, Info_File_Name)];
[Obj.Wavelength, Obj.wlOrder] = Obj.Load_Wavelength(Path, CH_WL_Calibration_File_Name);
Obj.currImage_Stack           = Obj.Load_Tiff_Image(Name, Path);
Obj.currImage_Stack           = Obj.currImage_Stack(:,:,Obj.wlOrder);
Obj.Bias                      = [Obj.Bias, min(Obj.currImage_Stack(:))*0.95];
Obj.currImage_Stack           = Obj.currImage_Stack - Obj.Bias;
Obj.currUnmix_Images          = Obj.UnMix(Obj.currImage_Stack, Spectrum, UnMix_Method);
Rshape_currUnmix_Images       = reshape(Obj.currUnmix_Images, size(Obj.currUnmix_Images,1), size(Obj.currUnmix_Images,2)*size(Obj.currUnmix_Images,3));
RShape_Fitted_Signal          = Rshape_currUnmix_Images'*Spectrum';
Fitted_Signal                 = reshape(RShape_Fitted_Signal,size(Obj.currUnmix_Images,2),size(Obj.currUnmix_Images,3),size(Obj.currImage_Stack,3));
if isempty(Obj.Noise_Dist)
    Obj.Noise_Dist(:,:,1)     = std(Obj.currImage_Stack-Fitted_Signal,0,3);
else
    Obj.Noise_Dist(:,:,end+1) = std(Obj.currImage_Stack-Fitted_Signal,0,3);
end;
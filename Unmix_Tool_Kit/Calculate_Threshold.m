% Calculating_Threshold is a function that zeros out the Tags coefficients
% based on a set threshold that is determind by the user. The thresold is
% applied to the signal to noise ratio (SNR). This function is run after
% unmixing of the data was processed.
% First the function is calculating the fitted curve using the unmixing
% information (tags Spectra and tags coefficients). Next, The measured
% curve is substracted from the fited curve the noise is extracted. The
% noise statistices is calculated such as standard deviation. Finally, the
% SNR is calculated by deviding the signal maxma for each tag by the
% standard devition of the noise (this process is done at pixel level). The
% SNR image is used as a mask for the Tags coefficients by seting the pixel
% within a certain tag coefficient image to zero when the SNR is lower then
% the input threshold. (The SNR is calculated for each tag).
%
% Input Parameters:
%
% Scene_Inst : is a Scene object. this object need to include the unmixed
%              information.
% Spectrum   : is a n x m matrix including the spectrum of the m individual
%              tags sampled at n different wavelengths.
% bgValue (Optional)   : is a scalar holding the background value (default is
%                        0).
% Threshold (Optional) : is a scalar holding the Thresold for the SNR of
%                        each tag calculated as discribed above(default is 0).
% Threshold_Method (Optional) : is a value representing the thresholding method, 1 is for signal to moise based and 2 for FD only 
%                               signal to noise basedscalar holding the Thresold for the SNR of (default is 1).
% Elem_Spect (Optional) : Hold the elementary spectra information including spectral integral, quantum yield and spectrua.
%                         This parameter is required when Threshold_Method equals 2.
%
% output Parameters
%
% Scene_Inst  : is the Scene object with the thresolded tags coefficients
%               images.
% Noise_STD   : is the image holding the standard deviation of the noise for
%               each pixel.
% Noise       : is a 3D matrix were dimensions 1 and 2 are the x and y cordinate
%               of each pixel and for each pixel the matrix hold the noise portion of the
%               signal along wavelength.
% cMax_Signal : is the matrix holding the maximal value of each pixel for all the
%               m elentary spectra emissions, i.e. max of the fitted signal image
% Reduced_Chi2 : pixel level reduced chi square;
%-----------------------------------------------------------------------------------
% Written by Gabriel Biener, 11/12/2014 Modified at 04/27/2016 older
% version can be found in Optimis_DC folder.
%-----------------------------------------------------------------------------------
function varargout = Calculate_Threshold (Scene_Inst, Spectrum, varargin)

% assigning variable variables.
if nargin > 2, bgValue          = varargin{1}; else bgValue           = 0;  end;
if nargin > 3, Threshold        = varargin{2}; else Threshold         = 0;  end;
if nargin > 4, Threshold_Method_Index = varargin{3}; else Threshold_Method_Index  = 1;  end;
if nargin > 5, Elem_Spect       = varargin{4}; else Elem_Spect        = []; end;

NoBG_Image    = Scene_Inst.currImage_Stack - bgValue;
cMax_Signal   = zeros(size(Scene_Inst.currImage_Stack,1),size(Scene_Inst.currImage_Stack,2),size(Spectrum,2));
Fitted_Signal = NoBG_Image*0;

% calculating the fitted signal 
for ii = 1:size(Spectrum,2)
    cSpectrum              = Spectrum(:,ii);
    Coeff                  = squeeze(Scene_Inst.currUnmix_Images(ii,:,:));
    Coeff_RSHP             = reshape(Coeff,size(Coeff,1)*size(Coeff,2),1);
    cFitted_Signal_RSHP    = Coeff_RSHP*cSpectrum';
    cFitted_Signal         = reshape(cFitted_Signal_RSHP,size(Coeff,1),size(Coeff,2),length(cSpectrum));
    cMax_Signal(:,:,ii)    = max(cFitted_Signal,[],3);
    Fitted_Signal          = Fitted_Signal + cFitted_Signal;
end;

% calculating noise statistics
Noise          = NoBG_Image - Fitted_Signal;
Noise_STD      = std(Noise,0,3);
Dark_Noise_STD = std2(NoBG_Image(:,:,1))/2.3548*2;

if Threshold_Method_Index == 3 && ~isempty(Elem_Spect)
    [~,Found]      = Elem_Spect.Find_Background_Tag;
    Bias_Coeff     = squeeze(Scene_Inst.currUnmix_Images(Found,:,:));
    Coeff_RSHP     = reshape(Coeff,size(Coeff,1)*size(Coeff,2),1);
    Bias_RSHP      = Coeff_RSHP*Spectrum(:,Found)';
    Bias           = reshape(Bias_RSHP,size(Bias_Coeff,1),size(Bias_Coeff,2),size(Spectrum,1));
    Fit_forChi2    = Fitted_Signal - Bias;
    Reduced_Chi2   = Calculate_ReducedChi2 (Noise, Fit_forChi2, Dark_Noise_STD, size(Spectrum,2));
end;

if Threshold_Method_Index == 2 && ~isempty(Elem_Spect)
    Donor    = Elem_Spect(1);
    if isempty(Donor.Quantum_Yield), Quantum_Yeild_D = 0.5; uiwait(msgbox('Donor quantum yield is missing value is set to 0.5','Unmixing Worning','modal'));
    else Quantum_Yeild_D = Donor.Quantum_Yield;
    end;
    if isempty(Donor.Spectral_Integral), dSI = 50; uiwait(msgbox('Donor spectral integral is missing value is set to 50','Unmixing Worning','modal'));
    else dSI = Donor.Spectral_Integral;
    end;
    Acceptor = Elem_Spect(2);
    if isempty(Acceptor.Quantum_Yield), Quantum_Yeild_A = 0.5; uiwait(msgbox('Acceptor quantum yield is missing value is set to 0.5','Unmixing Worning','modal'));
    else Quantum_Yeild_A = Acceptor.Quantum_Yield;
    end;
    if isempty(Acceptor.Spectral_Integral), aSI = 50; uiwait(msgbox('Acceptor spectral integral is missing value is set to 50','Unmixing Worning','modal'));
    else aSI = Acceptor.Spectral_Integral;
    end;
    
    FDA    = squeeze(Scene_Inst.currUnmix_Images(1,:,:))*dSI;
    FAD    = squeeze(Scene_Inst.currUnmix_Images(2,:,:))*aSI;
    FDonly = squeeze(FDA+FAD*Quantum_Yeild_D/Quantum_Yeild_A);
end;

% seting the emission coefficients pixels to zero for SNR lower then threshold.
for ii = 1:size(Spectrum,2)
    Coeff = squeeze(Scene_Inst.currUnmix_Images(ii,:,:));
    if Threshold_Method_Index == 1
        SNR = abs(cMax_Signal(:,:,ii)./Noise_STD);
        Coeff(SNR <= Threshold) = 0;
    elseif Threshold_Method_Index == 2 && ~isempty(Elem_Spect)
        SNR = FDonly./Noise_STD/(dSI+aSI);
        Coeff(SNR <= Threshold) = 0;
    elseif Threshold_Method_Index == 3 && ~isempty(Elem_Spect)
        SNR  = abs(Reduced_Chi2-1);
%         cMax = cMax_Signal(:,:,ii);
%         Coeff(cMax <= Dark_Noise_STD) = 0;
        Coeff(SNR >= Threshold) = 0;
    end;
    Scene_Inst.currUnmix_Images(ii,:,:) = Coeff;
end;

% assigning the output parameters.
if nargout > 0, varargout{1} = Scene_Inst; else varargout{1} = {}; end;
if nargout > 1, varargout{2} = Noise_STD;               end;
if nargout > 2, varargout{3} = Noise;                   end;
if nargout > 3, varargout{4} = cMax_Signal;             end;
if nargout > 4, varargout{5} = max(Fitted_Signal,[],3); end;
if nargout > 5, varargout{6} = Reduced_Chi2;            end;
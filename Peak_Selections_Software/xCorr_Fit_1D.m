function Smooth_Curve = xCorr_Fit_1D(Curve, Kernel, Sigma)

Mean  = ceil(length(Curve)/2) + mod(length(Curve)+1,2);
if nargin < 3, Sigma = 3; end;
Amp   = 1/Sigma/sqrt(2*pi);
XX    = 1:length(Curve);
if nargin < 2, Kernel = Amp*exp(-(XX-Mean).^2/2/Sigma^2); elseif isempty(Kernel), Kernel = Amp*exp(-(XX-Mean).^2/2/Sigma^2); end;

% Kernel           = rot90(Kernel,2);

fft_Kernel       = fft(Kernel, length(Curve));
fft_Curve        = fft(Curve);
fft_Smooth_Curve = conj(fft_Kernel).*fft_Curve;
Smooth_Curve     = fftshift(ifft2(fft_Smooth_Curve));
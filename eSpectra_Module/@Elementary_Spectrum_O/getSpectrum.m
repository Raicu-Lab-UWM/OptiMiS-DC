function Self = getSpectrum(Self, Spect_Images, First, Last)

if nargin < 3, Last = size(Spect_Images,3); elseif isempty(Last), Last = size(Spect_Images,3); end;
if nargin < 2, First = 1; elseif isempty(First), First = 1; end;

Spectrum      = zeros(Last-First+1,1);
Show_Wait_Bar = waitbar(0,'Calculating Spectrum. Please Wait.');
for ii = First : Last
    Image                = Spect_Images(:,:,ii-First+1);
    Spectrum(ii-First+1) = mean2(Image(Self.ROI_Sgnl==1))-mean2(Image(Self.ROI_Bkgd==1));
    waitbar((ii-First+1) / (Last-First+1), Show_Wait_Bar);
end 
close(Show_Wait_Bar);
Spectrum(Spectrum<0) = 0;
Self.Spectrum        = Spectrum/max(Spectrum);
if ~isempty(Self.iOriginal_WL), Self.Spectrum = Self.Spectrum(Self.iOriginal_WL); end;
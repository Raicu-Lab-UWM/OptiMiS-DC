function Binned_Spectrum = Bin_Spectrum(Spectrum, Bin_Size)

Num_Of_Spectral_Comp = size(Spectrum,2);
Original_Spect_Size  = size(Spectrum,1);
Binned_Spectrum      = [];

for ii = 1:Num_Of_Spectral_Comp
    rSpectrum             = reshape(Spectrum(:,ii), Bin_Size, Original_Spect_Size/Bin_Size);
    DS_Spectrum           = sum(rSpectrum,1)';
    Binned_Spectrum(:,ii) = DS_Spectrum/max(DS_Spectrum);
end;
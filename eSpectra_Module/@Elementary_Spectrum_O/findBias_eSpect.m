function [BG_Tag, Found] = findBias_eSpect(Self)
Found = 0;
for ii = 1:length(Self)
    Difference_Sum = sum(Self(ii).Spectrum(1:end-1)-Self(ii).Spectrum(2:end));
    if Difference_Sum == 0
        BG_Tag = Self(ii);
        Found  = ii;
    end;
end;
if isempty(BG_Tag.Spectrum)
    BG_Tag = Elementary_Spectrum_O;
    Found = 0;
end;
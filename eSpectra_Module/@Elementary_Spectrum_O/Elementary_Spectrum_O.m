classdef Elementary_Spectrum_O
    
    properties
        Name;
        Path;
        Description;
        Quantum_Yield;
        Spectral_Integral;
        rIntensity;
        Maker;
        Date_of_Prep;
        Method_of_Prep;
        Data_Folder;
        Spectrum;
        Wavelength;
        iOriginal_WL;
        nSpectra = 0;
        ROI_Sgnl;
        ROI_Bkgd;
        Fit;
    end
    methods (Static)
        [Em_Peak_Image, iPeakWL] = Find_Peak_Image (Spect_Images, First, Last)
    end
    methods
        Self = getPolygon(Self, Axes)
        Self = getWavelength(Self)
        Self = getSpectrum(Self, Spect_Images, First, Last)
        Self = loadobj(Self, Path, Name)
        Self = saveobj(Self, Save_Path)
        Self = expElementart_Spectrum(Self, Path)
        Self = expSpectrum(Self)
        [BG_Tag, Found] = findBias_eSpect(Self)
    end
end
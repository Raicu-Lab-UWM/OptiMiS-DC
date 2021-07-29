function Self = getWavelength(Self)
WL_File_Name = 'channel_wavelength calibration.txt';
if isempty(Self.Path), Self.Path = uigetdir('.\', 'Find Wavelength Path'); end;
Wave_Length  = load([Self.Path '\' WL_File_Name]);
[Self.Wavelength, Self.iOriginal_WL] = sort(Wave_Length(:,2));
if ~isempty(Self.Spectrum), Self.Spectrum = Self.Spectrum(Self.iOriginal_WL); end;

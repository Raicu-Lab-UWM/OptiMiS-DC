function [Wavelength, wlOrder] = Load_Wavelength(Path, Name)
if nargin == 0, [Name, Path] = uigetfile('*.txt', 'Wavelength Channel Calibration File');
elseif nargin == 1, [Name, Path] = uigetfile([Path '\*.txt'], 'Wavelength Channel Calibration File');
end;
            
wl_Channel_Calib      = importdata([Path '\' Name]);
[Wavelength, wlOrder] = sort(wl_Channel_Calib(:,2));
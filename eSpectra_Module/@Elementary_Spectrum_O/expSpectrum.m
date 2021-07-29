function Self = expSpectrum(Self)
if isempty(Self.Path)
    [Name, Path] = uiputfile('.\*_spc.txt', 'Save Elementary Spectrum to:');
elseif isempty(Self.Name)
    [Name, Path] = uiputfile([Self.Path '\*_spc.txt', 'Save Elementary Spectrum to:']);
else
    Name = [Self.Name '_spc.txt'];
end
fName = [Path '\' Name];
dlmwrite(fName, [Self.Wavelength, Self.Spectrum], 'delimiter', '\t', 'precision', 6);

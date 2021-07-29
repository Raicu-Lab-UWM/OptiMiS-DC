function Self = expElementart_Spectrum(Self, Path)

if nargin < 2, if ~isempty(Self.Path), Path = Self.Path; else Path = []; end;
elseif isempty(Path) && ~isempty(Self.Path), Path = Self.Path;
end;
if ~isempty(Self.Name), Name = [Self.Name '.txt']; else Name = '*.txt'; end;
if isempty(Path), [Name, Path] = uiputfile(['.\' Name] , 'Export Elementary Spectrum to:');
elseif strcmp(Name, '*.txt'), [Name, Path] = uiputfile([Path '\' Name], 'Export Elementary Spectrum to:');
end;

fName    = [Path '\' Name];
dlmwrite(fName, ['Name: ' Self.Name], 'delimiter', '');
dlmwrite(fName, ' ', 'delimiter', '\n',                                                   '-append');
dlmwrite(fName, ['Path: ' Self.Path], 'delimiter', '',                                    '-append');
dlmwrite(fName, ' ', 'delimiter', '\n',                                                   '-append');
dlmwrite(fName, ['Description: ' Self.Description], 'delimiter', '',                      '-append');
dlmwrite(fName, ' ', 'delimiter', '\n',                                                   '-append');
dlmwrite(fName, ['Quantum Yield: ' num2str(Self.Quantum_Yield)], 'delimiter', '',         '-append');
dlmwrite(fName, ' ', 'delimiter', '\n',                                                   '-append');
dlmwrite(fName, ['Spectral Integral: ' num2str(Self.Spectral_Integral)], 'delimiter', '', '-append');
dlmwrite(fName, ' ', 'delimiter', '\n',                                                   '-append');
dlmwrite(fName, ['Fabricator: ' Self.Maker], 'delimiter', '',                             '-append');
dlmwrite(fName, ' ', 'delimiter', '\n',                                                   '-append');
dlmwrite(fName, ['Date of Preparation: ' Self.Date_of_Prep], 'delimiter', '',             '-append');
dlmwrite(fName, ' ', 'delimiter', '\n',                                                   '-append');
dlmwrite(fName, ['Method of Preparation: ' Self.Method_of_Prep], 'delimiter', '',         '-append');
dlmwrite(fName, ' ', 'delimiter', '\n',                                                   '-append');
dlmwrite(fName, ['Data Folder: ' Self.Data_Folder], 'delimiter', '',                      '-append');
dlmwrite(fName, ' ', 'delimiter', '\n',                                                   '-append');
dlmwrite(fName, 'Spectrum: ', 'delimiter', '',                                            '-append');
dlmwrite(fName, [Self.Wavelength, Self.Spectrum], 'delimiter', '\t',                      '-append');
dlmwrite(fName, ' ', 'delimiter', '\n',                                                   '-append');
dlmwrite(fName, ['# of Spectra averaged: ' Self.nSpectra], 'delimiter', '',               '-append');
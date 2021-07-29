function Self = loadobj(Self, Path, Name)
if nargin < 2, [Name, Path] = uigetfile('.\*.tag', 'Load Elementary Spectrum File');
elseif nargin < 3
    if isempty(Path), [Name, Path] = uigetfile('.\*.tag', 'Load Elementary Spectrum File');
    else [Name, Path] = uigetfile([Path '\*.tag'], 'Load Elementary Spectrum File');
    end;
elseif isempty(Path), [Name, Path] = uigetfile('.\*.tag', 'Load Elementary Spectrum File');
elseif isempty(Name), [Name, Path] = uigetfile([Path '\*.tag'], 'Load Elementary Spectrum File');
end;

ES_Struct  = load([Path '\' Name], '-mat');
Field_Names = fieldnames(ES_Struct);
for ii = 1:size(Field_Names,1)
   if strcmp(Field_Names{ii},'Fabricator')
       Self.Maker = ES_Struct.(Field_Names{ii});
   elseif strcmp(Field_Names{ii},'Date_of_prep')
       Self.Date_of_Prep = ES_Struct.(Field_Names{ii});
   elseif strcmp(Field_Names{ii},'Amount_of_Spectra')
       Self.nSpectra = ES_Struct.(Field_Names{ii});
   elseif strcmp(Field_Names{ii},'Gauss_Fit_Params')
       Self.Fit = ES_Struct.(Field_Names{ii});
   else
       Self.(Field_Names{ii}) = ES_Struct.(Field_Names{ii});
   end;
end;
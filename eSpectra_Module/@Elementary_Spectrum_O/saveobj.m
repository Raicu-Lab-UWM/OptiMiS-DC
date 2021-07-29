function Self = saveobj(Self, Save_Path)
Tag_Obj = struct(Self);
if isempty(Self.Path)
    [Name, Self.Path] = uiputfile('.\*.tag', 'Save Elementary Spectrum in');
    Self.Name = Name(1:end-4);
elseif isempty(Self.Name)
    [Name, Self.Path] = uiputfile([Self.Path '\*.tag'], 'Save Elementary Spectrum in');
    Self.Name = Name(1:end-4);
end;
if isdir(Self.Path)
    save([Self.Path '\' Self.Name '.tag'], '-struct', 'Tag_Obj', '-mat');
else
    if isdir(Save_Path)
        Self.Path = Save_Path;
    else
        Self.Path = uigetdir('.\','Save Elementary Spectrum at:');
    end
    save([Self.Path '\' Self.Name '.tag'], '-struct', 'Tag_Obj', '-mat');
end;
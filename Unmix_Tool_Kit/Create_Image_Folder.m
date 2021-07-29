function Path = Create_Image_Folder(Ana_Path, Name, Separate_Dir)

fExt_Index     = strfind(Name,'.tiff');
if ~isempty(fExt_Index)
    Name = Name(1:fExt_Index-1);
end;
fExt_Index     = strfind(Name,'.tif');
if ~isempty(fExt_Index)
    Name = Name(1:fExt_Index-1);
end;

if Separate_Dir
    [Success, Messege, Message_ID] = mkdir(Ana_Path, Name);
    Path                           = [Ana_Path '\' Name];
else 
    Path = Ana_Path;
end;
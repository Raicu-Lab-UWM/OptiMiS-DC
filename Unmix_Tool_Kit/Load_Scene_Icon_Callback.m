function Load_Scene_Icon_Callback(hObject, eventdata)
handles = guidata(hObject);

handles.Scene_Index         = 1;
CH_WL_Calibration_File_Name = 'channel_wavelength calibration.txt';
Path                        = uigetdir(handles.currPath,'Load Scene/Multiple Scenes');
Images_Names_List           = {};
Root_Data_Info              = dir(Path);
Dirs_in_Root                = [Root_Data_Info.isdir];
Total_Dir_in_Root           = length(Dirs_in_Root(Dirs_in_Root == 1)) - 2;
Bar_Handle                  = waitbar(0);
handles.Images_Names_List   = Gen_Image_List_Names(Path, Path, Images_Names_List, Total_Dir_in_Root, Bar_Handle);
Images_Names_List_Path      = handles.Images_Names_List(:,1);
Images_Names_List_Name      = handles.Images_Names_List(:,2);
handles.Scene_Inst(length(Images_Names_List_Path))       = Scene;
handles.Scene_Inst(length(Images_Names_List_Path)+1:end) = [];

% populate the empty scene array with file names and file paths.
for ii = 1:length(Images_Names_List_Path)
    handles.Scene_Inst(ii).Path     = Images_Names_List_Path{ii};
    handles.Scene_Inst(ii).Name     = Images_Names_List_Name{ii};
    [handles.Scene_Inst(ii).Wavelength, handles.Scene_Inst(ii).wlOrder] = handles.Scene_Inst(ii).Load_Wavelength(Images_Names_List_Path{ii}, CH_WL_Calibration_File_Name);
end;

set(handles.Scene_List_lBox, 'String', Images_Names_List_Name);
handles.currPath = Path;

% Update handles structure
guidata(hObject, handles);
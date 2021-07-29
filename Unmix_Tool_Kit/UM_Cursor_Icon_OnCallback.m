function UM_Cursor_Icon_OnCallback(hObject, eventdata, Main_FigureH)

handles = guidata(Main_FigureH);

handles.Single_Pixel_UM_On = 1;

UM_Stack_sBar = findobj('Tag', 'UM_Stack_sBar');
if ~isempty(UM_Stack_sBar)
    handles.iFrame = UM_Stack_sBar.Value;
else
    handles.iFrame = 1;
end
Selected_Scene = handles.Scene_Inst(handles.Scene_Index(handles.iFrame));
if ~isfield(handles, 'currImage_Stack')
    Name = Selected_Scene.Name;
    if strcmp(Name(end-3:end),'.dat')
        Last = 999+length(Selected_Scene.Wavelength);
        Selected_Scene = Selected_Scene.Load_Dat_Images(Selected_Scene.Path, 1000, Last, handles.Hor_Shift);
    else
        Selected_Scene.currImage_Stack = Selected_Scene.Load_Tiff_Image(Name, Selected_Scene.Path, [], handles.Hor_Shift);
    end

elseif isempty(handles.currImage_Stack)
    Name = Selected_Scene.Name;
    if strcmp(Name(end-3:end),'.dat')
        Last = 999+length(Selected_Scene.Wavelength);
        Selected_Scene = Selected_Scene.Load_Dat_Images(Selected_Scene.Path, 1000, Last, handles.Hor_Shift);
    else
        Selected_Scene.currImage_Stack = Selected_Scene.Load_Tiff_Image(Name, Selected_Scene.Path, [], handles.Hor_Shift);
    end

end
handles.currImage_Stack  = Selected_Scene.currImage_Stack;

guidata(Main_FigureH, handles);
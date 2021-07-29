function Load_FICoS_Data_Icon_Callback(hObject, eventdata)
handles   = guidata(hObject);

mwHandles = guidata(handles.mwFigureH);
if strcmp(mwHandles.UM_Params.Analysis_Type,'FICoS')
    handles = Load_FICoS_Data_FNC(handles);
else
    handles = Load_FRET_Data_FNC(handles);
end

guidata(hObject, handles);
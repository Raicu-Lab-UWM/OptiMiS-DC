function handles = ES_Initiate(hObject, eventdata)
handles     = guidata(hObject);
Init_Params = Load_Param_frmText;

if handles.StandAlone
    handles.ES_Obj      = Elementary_Spectrum_O;
    handles.Hor_Shift   = Init_Params.Hor_Shift;
    handles.Sample_Type = Init_Params.Sample_Type;
    handles.curr_Path   = Init_Param.curr_Path;
end
function UM_Cursor_Icon_OffCallback(hObject, eventdata, Main_FigureH)

handles = guidata(Main_FigureH);

handles.Single_Pixel_UM_On = 0;

guidata(Main_FigureH, handles);
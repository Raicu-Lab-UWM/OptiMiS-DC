function Load_ES_pButton_Callback(hObject, eventdata)

handles    = guidata(hObject);

StandAlone = true; mwHandles = [];
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); StandAlone = false; end; end

ES_Obj            = Elementary_Spectrum_O;
if StandAlone, curr_Path = handles.curr_Path; else curr_Path = mwHandles.curr_Path; end

if isempty(curr_Path), curr_Path = '.\'; end;
[Name, curr_Path] = uigetfile([curr_Path '\*.tag; *.xls; *.xlsx'], 'Load Elementary Spectra File');

Name_Ext                  = Name(end-3:end);
switch Name_Ext
    case '.tag'
        ES_Obj = ES_Obj.loadobj(curr_Path, Name);
        if StandAlone, handles.ES_Obj = ES_Obj; else mwHandles.ES_Obj = ES_Obj; end
        if StandAlone, handles.curr_Path = curr_Path; else mwHandles.curr_Path = curr_Path; end
        guidata(handles.mwFigureH, mwHandles); guidata(hObject, handles);
        ES_Info_pButton_Callback(hObject, eventdata);
    case '.xls'
        [~, curr_Path, Spect_File_Name, Sheet, Upper_Left, Lower_Right] = Load_fromExcel(curr_Path);
        [Spect_Data, ES_Titles] = xlsread(Spect_File_Name, Sheet, [Upper_Left ':' Lower_Right]);
        [~, Num_of_Comp]        = size(Spect_Data);

        [Wavelength, Calib_Index] = sort(Spect_Data(:,1));
        ES_Obj.Wavelength         = Wavelength;

        for ii = 2:Num_of_Comp
            ES_Obj.Spectral_Integral = trapz(Wavelength,Spect_Data(:,ii));
            ES_Obj.Name              = char(ES_Titles(ii));
            ES_Obj.Path              = handles.curr_Path;
            Spectrum                 = Spect_Data(:,ii)/max(Spect_Data(:,ii));
            ES_Obj.Spectrum          = Spectrum(Calib_Index);
            if StandAlone, handles.ES_Obj = ES_Obj; else mwHandles.ES_Obj = ES_Obj; end
            if StandAlone, handles.curr_Path = curr_Path; else mwHandles.curr_Path = curr_Path; end
            guidata(handles.mwFigureH, mwHandles); guidata(hObject, handles);
            ES_Info_pButton_Callback(hObject, eventdata);
        end;
    case 'xlsx'
        [~, curr_Path, Spect_File_Name, Sheet, Upper_Left, Lower_Right] = Load_fromExcel(curr_Path);
        [Spect_Data, ES_Titles] = xlsread(Spect_File_Name, Sheet, [Upper_Left ':' Lower_Right]);
        [~, Num_of_Comp]        = size(Spect_Data);

        [Wavelength, Calib_Index] = sort(Spect_Data(:,1));
        ES_Obj.Wavelength         = Wavelength;

        for ii = 2:Num_of_Comp
            ES_Obj.Spectral_Integral = trapz(Wavelength,Spect_Data(:,ii));
            ES_Obj.Name              = char(ES_Titles(ii));
            ES_Obj.Path              = curr_Path;
            Spectrum                 = Spect_Data(:,ii)/max(Spect_Data(:,ii));
            ES_Obj.Spectrum          = Spectrum(Calib_Index);
            if StandAlone, handles.ES_Obj = ES_Obj; else mwHandles.ES_Obj = ES_Obj; end
            if StandAlone, handles.curr_Path = curr_Path; else mwHandles.curr_Path = curr_Path; end
            guidata(handles.mwFigureH, mwHandles); guidata(hObject, handles);
            ES_Info_pButton_Callback(hObject, eventdata);
        end;
    otherwise
end;

guidata(handles.mwFigureH, mwHandles); guidata(hObject, handles);
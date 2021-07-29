function Load_FRET_Hist_pButton_Callback(hObject, eventdata, FRET_Tool_Kit_FigH)
handles = guidata(FRET_Tool_Kit_FigH);

[Name, handles.curr_Path] = uigetfile([handles.curr_Path '\*.mfrt; *xlsx; *.xls; *.txt'], 'Load FRET Data From:');

Period_Loc = strfind(Name, '.');
File_Type  = Name(Period_Loc(end)+1:end);
switch File_Type
    case 'xlsx'
    case 'xls'
    case 'mfrt'
        FRET_Data_Struct = load([handles.curr_Path '\' Name], '-mat');
        handles.FRET_List = FRET_Data_Struct.FRET_List_Struct;
        FRET_Setting_Struct = FRET_Data_Struct.FRET_Setting_Struct;
        Field_Names = fieldnames(FRET_Setting_Struct);
        for ii = 1:length(Field_Names)
            handles.(Field_Names{ii}) = FRET_Setting_Struct.(Field_Names{ii});
        end
        Disp_Setting_Struct = FRET_Data_Struct.Disp_Setting_Struct;
        Field_Names = fieldnames(Disp_Setting_Struct);
        for ii = 1:length(Field_Names)
            handles.(Field_Names{ii}) = Disp_Setting_Struct.(Field_Names{ii});
        end
        if isfield(FRET_Data_Struct, 'TEW_Molecular_Info'), handles.TEW_Molecular_Info = FRET_Data_Struct.TEW_Molecular_Info; end
        if isfield(FRET_Data_Struct, 'Eapp_Hist_2D'), handles.Eapp_Hist_2D = FRET_Data_Struct.Eapp_Hist_2D; end
    case 'txt'
    otherwise
end

guidata(FRET_Tool_Kit_FigH, handles);
function handles = Load_FICoS_Data_FNC(handles)

FICoS_Loading_Pad = figure('Name', 'Load FICoS Data', 'Tag', 'FICoS_Loading_Pad', ...
                           'Position', [700, 200, 270, 270], 'Menubar', 'none', 'Toolbar' , 'none', 'numbertitle','off', ...
                           'CloseRequestFcn', {@FICoS_Loading_Pad_CloseRequestFcn});
lpHandles = guihandles(FICoS_Loading_Pad);

Load_CappMap_cBox  = uicontrol('Parent', FICoS_Loading_Pad, 'Style', 'checkbox', 'Tag', 'Load_CappMap_cBox', ...
                               'Units', 'Pixels', 'Position', [5 215 260 25], 'FontSize', 10, 'String', 'Load Capp Map', ...
                               'Callback', {@Load_CappMap_cBox_Callback});

Load_ConcMap_cBox  = uicontrol('Parent', FICoS_Loading_Pad, 'Style', 'checkbox', 'Tag', 'Load_ConcMap_cBox', ...
                               'Units', 'Pixels', 'Position', [5 175 260 25], 'FontSize', 10, 'String', 'Load Concentration Map', ...
                               'Callback', {@Load_ConcMap_cBox_Callback});

Load_FICoS_Data_cBox  = uicontrol('Parent', FICoS_Loading_Pad, 'Style', 'checkbox', 'Tag', 'Load_FICoS_Data_cBox', ...
                               'Units', 'Pixels', 'Position', [5 135 260 25], 'FontSize', 10, 'String', 'Load FICoS Data', ...
                               'Callback', {@Load_FICoS_Data_cBox_Callback});

lpHandles.Load_CappMap    = false;
lpHandles.Load_ConcMap    = false;
lpHandles.Load_FICoS_Data = false;

guidata(FICoS_Loading_Pad, lpHandles);

% wait until this window is closed
uiwait(FICoS_Loading_Pad);

lpHandles = guidata(FICoS_Loading_Pad);

if isfield(lpHandles, 'Load_CappMap')
    if lpHandles.Load_CappMap
        [Name, handles.curr_Path] = uigetfile([handles.curr_Path '\*.tif; *.tiff'], 'Load Capp Map');
        handles.Capp_Map = Load_Image(handles.curr_Path, Name);
    end
else
    lpHandles.Load_CappMap = false;    
end

if isfield(lpHandles, 'Load_ConcMap')
    if lpHandles.Load_ConcMap && lpHandles.Load_CappMap
        [Name, handles.curr_Path] = uigetfile([handles.curr_Path '\*.tif; *.tiff'], 'Load Concentration Map');
        handles.Conc_Map = Load_Image(handles.curr_Path, Name);
    end
else
    lpHandles.Load_ConcMap = false;
end

if isfield(lpHandles, 'Load_FICoS_Data')
    if lpHandles.Load_FICoS_Data && ~lpHandles.Load_CappMap
        [Name, handles.curr_Path] = uigetfile([handles.curr_Path '\*.fics; *.xlsx; *.xls; *.txt'], 'Load FICoS Data');
        
        Period_Loc = strfind(Name, '.');
        File_Type  = Name(Period_Loc(end)+1:end);

        switch File_Type
            case {'xlsx', 'xls'}
            case 'fics'
                FICoS_Data_Struct         = load([handles.curr_Path '/' Name], '-mat');
                handles.FICoS_List        = FICoS_Data_Struct.FICoS_List_Struct;
                FICoS_Setting_Struct      = FICoS_Data_Struct.FICoS_Setting_Struct;
                Field_Names               = fieldnames(FICoS_Setting_Struct);
                for ii = 1:length(Field_Names)
                    handles.(Field_Names{ii}) = FICoS_Setting_Struct.(Field_Names{ii});
                end
                Disp_Setting_Struct       = FICoS_Data_Struct.Disp_Setting_Struct;
                Field_Names               = fieldnames(Disp_Setting_Struct);
                for ii = 1:length(Field_Names)
                    handles.(Field_Names{ii}) = Disp_Setting_Struct.(Field_Names{ii});
                end
                if isfield(FICoS_Data_Struct, 'FICoS_Molecular_Info'), handles.TEW_Molecular_Info = FICoS_Data_Struct.TEW_Molecular_Info; end
                if isfield(FICoS_Data_Struct, 'Capp_Hist_2D'), handles.Capp_Hist_2D = FICoS_Data_Struct.Capp_Hist_2D; end
                if isfield(FICoS_Data_Struct, 'Scatter_Plot_Info'), handles.Scatter_Plot_Info = FICoS_Data_Struct.Scatter_Plot_Info; end
            case 'txt'
            otherwise
        end
    end
end

guidata(FICoS_Loading_Pad, lpHandles);

% Close window
close(FICoS_Loading_Pad)

function Load_CappMap_cBox_Callback (hObject, eventdata)
handles              = guidata(hObject);

handles.Load_CappMap = get(hObject, 'Value');

guidata(hObject, handles);

function Load_ConcMap_cBox_Callback (hObject, eventdata)
handles              = guidata(hObject);

handles.Load_ConcMap = get(hObject, 'Value');

guidata(hObject, handles);

function Load_FICoS_Data_cBox_Callback (hObject, eventdata)
handles = guidata(hObject);

handles.Load_FICoS_Data = get(hObject, 'Value');

guidata(hObject, handles);
                           
function FICoS_Loading_Pad_CloseRequestFcn(hObject, eventdata)
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end;
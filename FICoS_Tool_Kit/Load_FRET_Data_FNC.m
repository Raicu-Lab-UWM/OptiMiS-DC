function handles = Load_FRET_Data_FNC(handles)

FRET_Loading_Pad = figure('Name', 'Load FRET Data', 'Tag', 'FRET_Loading_Pad', ...
                           'Position', [700, 200, 270, 270], 'Menubar', 'none', 'Toolbar' , 'none', 'numbertitle','off', ...
                           'CloseRequestFcn', {@FRET_Loading_Pad_CloseRequestFcn});
lpHandles = guihandles(FRET_Loading_Pad);

Load_EappMap_cBox  = uicontrol('Parent', FRET_Loading_Pad, 'Style', 'checkbox', 'Tag', 'Load_EappMap_cBox', ...
                               'Units', 'Pixels', 'Position', [5 215 260 25], 'FontSize', 10, 'String', 'Load Eapp Map', ...
                               'Callback', {@Load_EappMap_cBox_Callback});

Load_FDA_WL1_cBox  = uicontrol('Parent', FRET_Loading_Pad, 'Style', 'checkbox', 'Tag', 'Load_FDA_WL1_cBox', ...
                               'Units', 'Pixels', 'Position', [5 175 260 25], 'FontSize', 10, 'String', 'Load FDA Ex. Wavelength 1 Image', ...
                               'Callback', {@Load_FDA_WL1_cBox_Callback});

Load_FAD_WL1_cBox  = uicontrol('Parent', FRET_Loading_Pad, 'Style', 'checkbox', 'Tag', 'Load_FAD_WL1_cBox', ...
                               'Units', 'Pixels', 'Position', [5 135 260 25], 'FontSize', 10, 'String', 'Load FAD Ex. Wavelength 1 Image', ...
                               'Callback', {@Load_FAD_WL1_cBox_Callback});

Load_FAD_WL2_cBox  = uicontrol('Parent', FRET_Loading_Pad, 'Style', 'checkbox', 'Tag', 'Load_FAD_WL2_cBox', ...
                               'Units', 'Pixels', 'Position', [5 95, 260 25], 'FontSize', 10, 'String', 'Load FAD Ex. Wavelength 2 Image', ...
                               'Callback', {@Load_FAD_WL2_cBox_Callback});

Load_FRET_Data_cBox  = uicontrol('Parent', FRET_Loading_Pad, 'Style', 'checkbox', 'Tag', 'Load_FRET_Data_cBox', ...
                               'Units', 'Pixels', 'Position', [5 55 260 25], 'FontSize', 10, 'String', 'Load FRET Data', ...
                               'Callback', {@Load_FRET_Data_cBox_Callback});

lpHandles.Load_EappMap   = false;
lpHandles.Load_FDA_WL1   = false;
lpHandles.Load_FAD_WL1   = false;
lpHandles.Load_FAD_WL2   = false;
lpHandles.Load_FRET_Data = false;

guidata(FRET_Loading_Pad, lpHandles);

% wait until this window is closed
uiwait(FRET_Loading_Pad);

lpHandles = guidata(FRET_Loading_Pad);

if isfield(lpHandles, 'Load_EappMap')
    if lpHandles.Load_EappMap
        [Name, handles.curr_Path] = uigetfile([handles.curr_Path '\*.tif; *.tiff'], 'Load Eapp Map');
        handles.Eapp_Map = Load_Image(handles.curr_Path, Name);
    end
else
    lpHandles.Load_EappMap = false;    
end

if isfield(lpHandles, 'Load_FDA_WL1')
    if lpHandles.Load_FDA_WL1
        [Name, handles.curr_Path] = uigetfile([handles.curr_Path '\*.tif; *.tiff'], 'Load FDA for Ex. Wavelength 1 Image');
        handles.FDA_WL1_Map = Load_Image(handles.curr_Path, Name);
    end
else
    lpHandles.Load_FDA_WL1 = false;
end

if isfield(lpHandles, 'Load_FAD_WL1')
    if lpHandles.Load_FAD_WL1
        [Name, handles.curr_Path] = uigetfile([handles.curr_Path '\*.tif; *.tiff'], 'Load FAD for Ex. Wavelength 1 Image');
        handles.FAD_WL1_Map = Load_Image(handles.curr_Path, Name);
    end
else
    lpHandles.Load_FAD_WL1 = false;
end

if isfield(lpHandles, 'Load_FDA_WL1')
    if lpHandles.Load_FAD_WL2
        [Name, handles.curr_Path] = uigetfile([handles.curr_Path '\*.tif; *.tiff'], 'Load FAD for Ex. Wavelength 2 Image');
        handles.FAD_WL2_Map = Load_Image(handles.curr_Path, Name);
    end
else
    lpHandles.Load_FAD_WL2 = false;
end

if isfield(lpHandles, 'Load_FRET_Data')
    if lpHandles.Load_FRET_Data && ~lpHandles.Load_EappMap
        [Name, handles.curr_Path] = uigetfile([handles.curr_Path '\*.mfrt; *.xlsx; *.xls; *.txt'], 'Load FRET Data');
        FRET_Data_Struct          = load([handles.curr_Path '\' Name], '-mat');
        handles.FRET_List         = FRET_Data_Struct.FICoS_List_Struct;
        FRET_Setting_Struct       = FRET_Data_Struct.FICoS_Setting_Struct;
        Field_Names               = fieldnames(FRET_Setting_Struct);
        for ii = 1:length(Field_Names)
            handles.(Field_Names{ii}) = FRET_Setting_Struct.(Field_Names{ii});
        end
        Disp_Setting_Struct       = FRET_Data_Struct.Disp_Setting_Struct;
        Field_Names               = fieldnames(Disp_Setting_Struct);
        for ii = 1:length(Field_Names)
            handles.(Field_Names{ii}) = Disp_Setting_Struct.(Field_Names{ii});
        end
        if isfield(FRET_Data_Struct, 'TEW_Molecular_Info'), handles.TEW_Molecular_Info = FRET_Data_Struct.TEW_Molecular_Info; end
        if isfield(FRET_Data_Struct, 'Eapp_Hist_2D'),       handles.Capp_Hist_2D       = FRET_Data_Struct.Capp_Hist_2D;       end
        if isfield(FRET_Data_Struct, 'Scatter_Plot_Info'),  handles.Scatter_Plot_Info  = FRET_Data_Struct.Scatter_Plot_Info;  end
        if isfield(FRET_Data_Struct, 'Eapp_vsXA_Info'),     handles.Capp_vsXA_Info     = FRET_Data_Struct.Capp_vsXA_Info;     end
    end
end

guidata(FRET_Loading_Pad, lpHandles);

% Close window
close(FRET_Loading_Pad)

function Load_EappMap_cBox_Callback (hObject, eventdata)
handles              = guidata(hObject);

handles.Load_EappMap = get(hObject, 'Value');

guidata(hObject, handles);

function Load_FDA_WL1_cBox_Callback (hObject, eventdata)
handles              = guidata(hObject);

handles.Load_FDA_WL1 = get(hObject, 'Value');

guidata(hObject, handles);

function Load_FAD_WL1_cBox_Callback (hObject, eventdata)
handles              = guidata(hObject);

handles.Load_FAD_WL1 = get(hObject, 'Value');

guidata(hObject, handles);

function Load_FAD_WL2_cBox_Callback (hObject, eventdata)
handles              = guidata(hObject);

handles.Load_FAD_WL2 = get(hObject, 'Value');

guidata(hObject, handles);

function Load_FRET_Data_cBox_Callback (hObject, eventdata)
handles = guidata(hObject);

handles.Load_FRET_Data = get(hObject, 'Value');

guidata(hObject, handles);
                           
function FRET_Loading_Pad_CloseRequestFcn(hObject, eventdata)
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end;
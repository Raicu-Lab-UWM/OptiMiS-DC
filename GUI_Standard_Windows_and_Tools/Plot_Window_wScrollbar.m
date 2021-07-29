function hFigure = Plot_Window_wScrollbar (Figure_Name, Figure_Tag, Calling_GUI_Figure, Plot_Type, Plot_Stack, Scroll_Range)

if nargin < 4, Plot_Type = 'Image'; elseif isempty(Plot_Type), Plot_Type = 'Image'; end
if nargin < 5, Plot_Stack = []; end
if nargin < 6 && length(size(Plot_Stack)) == 3, Scroll_Range = [1,size(Plot_Stack,3)]; end

hFigure = figure('Name', Figure_Name, 'Tag', Figure_Tag, 'MenuBar', 'none', 'ToolBar', 'figure', 'NumberTitle', 'off', ...
                 'Position', [650, 300, 700, 500]);

% Creating the handles structure
handles              = guihandles(hFigure);
handles.output       = hFigure;

% Adding an axes
handles.hAxes        = axes('Parent', hFigure, 'Position', [0.05, 0.05, 0.9, 0.9], 'HitTest', 'on', ...
                            'ButtonDownFcn', {@hAxes_ButtonDownFcn_Callback, Calling_GUI_Figure});

% Adding a plot
handles.Plot_Type    = Plot_Type;
handles.Plot_Stack   = Plot_Stack;
switch Plot_Type
    case 'Image'
        if isempty(Plot_Stack)
            [Name, Path]       = uigetfile(['.\*.tif;*.bmp;*.png;*.jpg', 'Load Image']);
            Image_Stack        = Load_Image(Path, Name, [], 1);
            handles.Plot_Stack = Field_ofView_O;
            Image_inStruct     = struct('Name', Name, 'Path', Path, 'Width', size(Image_Stack,1),...
                                        'Height', size(Image_Stack,2), 'Depth', size(Image_Stack,3));
            for ii = 1:size(Image_Stack,3);
                Image_inStruct.Frame_Number = ii;
                handles.Plot_Stack = handles.Plot_Stack.Add_FOV_toList(Image_Stack(:,:,ii), Image_inStruct);
            end;
        end
        if isnumeric(Plot_Stack)
            handles.hPlot = imagesc(Plot_Stack(:,:,1), 'Parent', handles.hAxes); colormap gray;
        elseif isa(Plot_Stack, 'Field_ofView_O')
            handles.hPlot = imagesc(Plot_Stack(1).raw_Data, 'Parent', handles.hAxes); colormap gray;
        end
    case 'Graph'
    otherwise
end

% Adding a scroll bar
minScroll_Range      = min(Scroll_Range);
maxScroll_Range      = max(Scroll_Range);
handles.hScrollBar   = uicontrol('Style', 'Slider', 'Parent', hFigure, 'Units', 'normalized', 'Position', [0, 0, 1, 0.05], ...
                                 'Value', minScroll_Range, 'Min', minScroll_Range, 'Max', maxScroll_Range, 'Tag', 'Image_Stack_sBar', ...
                                 'SliderStep', [1/(maxScroll_Range - minScroll_Range), 1/8], ...
                                 'Callback',{@hScrollBar_Callback, Calling_GUI_Figure});

Image_Window_Toolbar = findall(hFigure,'tag','FigureToolBar');
% Adding a snapshot icon
Snapshot_Icon        = uipushtool(Image_Window_Toolbar,'TooltipString','Snapshot', 'ClickedCallback', {@Snapshot_Icon_Callback, Calling_GUI_Figure, Figure_Name});
[cdata,~]            = imread('.\Icons\snapshot_16x16.png');
cdata(cdata == 0)    = 240;
Snapshot_Icon.CData  = cdata;

% I cons that are not utilized
ColorBar_Icon        = findall(hFigure, 'ToolTipString','Insert Colorbar'); set(ColorBar_Icon, 'Visible', 'off');
Save_Icon            = findall(hFigure, 'ToolTipString','Save Figure');     set(Save_Icon,     'Visible', 'off');
Legend_Icon          = findall(hFigure, 'ToolTipString','Insert Legend');   set(Legend_Icon,   'Visible', 'off');
Open_Icon            = findall(hFigure, 'ToolTipString','Open File');       set(Open_Icon,     'Visible', 'off');
Print_Icon           = findall(hFigure, 'ToolTipString','Print Figure');    set(Print_Icon,    'Visible', 'off');

guidata(hFigure, handles);
end

function Snapshot_Icon_Callback(hObject, eventdata, Calling_GUI_Figure, Figure_Name)
handles     = guidata(Calling_GUI_Figure);

Space_Index = strfind(Figure_Name, ' ');
File_Name   = Figure_Name;
File_Name(Space_Index)   = '_';
[Name, handles.Ana_Path] = uiputfile([handles.Ana_Path File_Name '.png'], 'Save Snapshot');
hToolBar    = hObject.Parent;
hFigure     = hToolBar.Parent;
hAxes       = findall(hFigure, 'Type', 'axes');
locPeriod   = strfind(Calling_GUI_Figure, '.'); File_Type   = Name(locPeriod(end)+1:end);
export_fig(hAxes, [handles.Ana_Path '\' Name], ['-' File_Type], '-transparent');

guidata(Calling_GUI_Figure, handles);
end

function hAxes_ButtonDownFcn_Callback(hObject, eventdata, Calling_GUI_Figure)

try
    hAxes_ButtonDownFun_Callback(hObject, eventdata, Calling_GUI_Figure);
catch ME
end

end

function hScrollBar_Callback(hObject, eventdata, Calling_GUI_Figure)

if isempty(Calling_GUI_Figure)
    handles = guidata(hObject);
elseif isvalid(Calling_GUI_Figure)
    handles  = guidata(Calling_GUI_Figure);
end

handles.Frame_Index = uint16(get(hObject, 'Value'));

if isnumeric(handles.Plot_Stack)
    Image_Frame = handles.Plot_Stack(:,:,handles.Frame_Index);
elseif isa(handles.Plot_Stack, 'Field_ofView_O')
    Image_Frame = handles.Plot_Stack(handles.Frame_Index).raw_Data;
    if isfield(Image_Frame, 'iName')
        if isempty(Image_Frame.iName)
            set(handles.output, 'Name', [num2str(handles.Frame_Index) '/' num2str(length(handles.Plot_Stack)) ' (' handles.Plot_Stack(handles.Frame_Index).Name ')'], 'NumberTitle', 'off');
        else
            set(handles.output, 'Name', [num2str(handles.Frame_Index) '/' num2str(length(handles.Plot_Stack)) ' (' handles.Plot_Stack(handles.Frame_Index).iName ')'], 'NumberTitle', 'off');
        end;
    else
        set(handles.output, 'Name', [num2str(handles.Frame_Index) '/' num2str(length(handles.Plot_Stack)) ' (' handles.Plot_Stack(handles.Frame_Index).Name ')'], 'NumberTitle', 'off');
    end;
end

set(handles.hPlot, 'CData', Image_Frame);

if isempty(Calling_GUI_Figure)
    guidata(hObject, handles);
elseif isvalid(Calling_GUI_Figure)
    guidata(Calling_GUI_Figure, handles);
end

end
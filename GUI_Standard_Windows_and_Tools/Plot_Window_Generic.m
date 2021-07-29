function hFigure = Plot_Window_Generic (Figure_Name, Main_Figure)

hFigure = figure('Name', Figure_Name, 'MenuBar', 'none', 'ToolBar', 'figure', 'NumberTitle', 'off', 'Position', [650, 300, 700, 500]);

Image_Window_Toolbar = findall(hFigure,'tag','FigureToolBar');
Snapshot_Icon        = uipushtool(Image_Window_Toolbar,'TooltipString','Snapshot', 'ClickedCallback', {@Snapshot_Icon_Callback, Main_Figure, Figure_Name});
[cdata,~]            = imread('.\Icons\snapshot_16x16.png');
cdata(cdata == 0)    = 240;
Snapshot_Icon.CData  = cdata;

ColorBar_Icon = findall(hFigure, 'ToolTipString','Insert Colorbar');
set(ColorBar_Icon, 'Visible', 'off');
Save_Icon     = findall(hFigure, 'ToolTipString','Save Figure');
set(Save_Icon, 'Visible', 'off');
Legend_Icon   = findall(hFigure, 'ToolTipString','Insert Legend');
set(Legend_Icon, 'Visible', 'off');
Open_Icon     = findall(hFigure, 'ToolTipString','Open File');
set(Open_Icon, 'Visible', 'off');
Print_Icon    = findall(hFigure, 'ToolTipString','Print Figure');
set(Print_Icon, 'Visible', 'off');

end

function Snapshot_Icon_Callback(hObject, eventdata, Main_Figure, Figure_Name)
handles = guidata(Main_Figure);

Space_Index = strfind(Figure_Name, ' ');
File_Name = Figure_Name;
File_Name(Space_Index) = '_';
if ~isfield(handles, 'Ana_Path'), handles.Ana_Path = '.\'; elseif isempty(handles.Ana_Path), handles.Ana_Path = '.\'; end
[Name, handles.Ana_Path] = uiputfile([handles.Ana_Path '\' File_Name '.png'], 'Save Snapshot');
hToolBar = hObject.Parent;
hFigure  = hToolBar.Parent;
hAxes    = findall(hFigure, 'Type', 'axes');
export_fig(hAxes, [handles.Ana_Path '\' Name], '-png', '-transparent');

guidata(Main_Figure, handles);
end
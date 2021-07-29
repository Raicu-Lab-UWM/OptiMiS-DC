%

%------------------------------------------------------------------------

% Copyright (C) 2018  Raicu Lab.
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU Affero General Public License as
%     published by the Free Software Foundation, either version 3 of the
%     License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU Affero General Public License for more details.
% 
%     You should have received a copy of the GNU Affero General Public License
%     along with this program.  If not, see <https://www.gnu.org/licenses/>.
%------------------------------------------------------------------------------
% Writen By: Gabriel Biener, PhD 
% Advisor and Group Leader: Prof. Valerica Raicu
% For technical questions contact biener@uwm.edu
%------------------------------------------------------------------------------
function handles = Init_ImageStack_Window(hObject, eventdata)
handles = guidata(hObject);

hFigure = size(handles.FOV_List(1).raw_Data,1);
lFigure = size(handles.FOV_List(1).raw_Data,2);
handles.Image_Frame_Index = 1;
if ~isfield(handles, 'ImPoly_figHand'), handles.ImPoly_figHand = []; end
if ~isempty(handles.ImPoly_figHand), if ~isvalid(handles.ImPoly_figHand), handles.ImPoly_figHand = []; end; end
if isempty(handles.ImPoly_figHand)
    handles.ImPoly_figHand = figure('Position', [400, 100, lFigure, (hFigure + 25)], 'MenuBar', 'none', 'ToolBar', 'figure', 'NumberTitle','off');
    if length(handles.FOV_List) > 1
        Image_Stack_sBar = uicontrol('Style', 'Slider', 'Parent', handles.ImPoly_figHand, 'Units', 'normalized', 'Position', [0, 0, 1, min([25/hFigure 0.05])], ...
                                     'Value', handles.Image_Frame_Index, 'Min', 1, 'Max', length(handles.FOV_List), 'Tag', 'Image_Stack_sBar', ...
                                     'SliderStep', [1/(length(handles.FOV_List)-1), 10/(length(handles.FOV_List)-1)], ...
                                     'Callback',{@Image_Stack_sBar_Callback, hObject});
    end
    Image_Window_Toolbar = findall(handles.ImPoly_figHand,'tag','FigureToolBar');
    ColorBar_Icon        = findall(handles.ImPoly_figHand, 'ToolTipString','Insert Colorbar');
    set(ColorBar_Icon, 'ClickedCallback', {@ColorBar_Icon_ClickedCallback, hObject});
    set(ColorBar_Icon, 'ToolTipString', 'Contrast Control');

    Save_Icon = findall(handles.ImPoly_figHand, 'ToolTipString','Save Figure');
    set(Save_Icon, 'ClickedCallback', {@Save_Icon_ClickedCallback, hObject});
    set(Save_Icon, 'ToolTipString', 'Save Image Stack');

    Snapshot_Icon       = uipushtool(Image_Window_Toolbar,'TooltipString','Snapshot', 'ClickedCallback', {@Snapshot_Icon_Callback, handles});
    [cdata,~]           = imread('.\Icons\snapshot_2_16x16.png');
    cdata(cdata == 0)   = 240;
    Snapshot_Icon.CData = cdata;

    Legend_Icon = findall(handles.ImPoly_figHand, 'ToolTipString','Insert Legend'); set(Legend_Icon, 'Visible', 'off');
    Cursor_Icon = findall(handles.ImPoly_figHand, 'ToolTipString','Data Cursor');   set(Cursor_Icon, 'Visible', 'off');
    Rotate_Icon = findall(handles.ImPoly_figHand, 'ToolTipString','Rotate 3D');     set(Rotate_Icon, 'Visible', 'off');
    Open_Icon   = findall(handles.ImPoly_figHand, 'ToolTipString','Open File');     set(Open_Icon,   'Visible', 'off');
    Print_Icon  = findall(handles.ImPoly_figHand, 'ToolTipString','Print Figure');  set(Print_Icon,  'Visible', 'off');
else
    Image_Stack_sBar = findobj('Tag', 'Image_Stack_sBar');
    if ~isempty(Image_Stack_sBar)
        if isvalid(Image_Stack_sBar)
            set(Image_Stack_sBar, 'Max', length(handles.FOV_List));
            set(Image_Stack_sBar, 'Value', 1);
            set(Image_Stack_sBar, 'SliderStep', [1/(length(handles.FOV_List)-1), 10/(length(handles.FOV_List)-1)]);
        end
    end    
end
set(handles.ImPoly_figHand, 'Name',[num2str(handles.Image_Frame_Index) '/' num2str(length(handles.FOV_List)) ' (' handles.FOV_List(1).Name ')'], 'NumberTitle', 'off');

if ~isfield(handles, 'Image_Stack_Axes'), handles.Image_Stack_Axes = []; end
if ~isempty(handles.Image_Stack_Axes), if ~isvalid(handles.Image_Stack_Axes), handles.Image_Stack_Axes = []; end; end
if isempty(handles.Image_Stack_Axes), handles.Image_Stack_Axes = axes('Parent', handles.ImPoly_figHand, 'Position', [0, 0.07, 1, hFigure/(hFigure + 25)]); end

if ~isfield(handles, 'FOV_hImage'), handles.FOV_hImage = []; end
if ~isempty(handles.FOV_hImage), if ~isvalid(handles.FOV_hImage), handles.FOV_hImage = []; end; end
if isempty(handles.FOV_hImage)
    handles.FOV_hImage = imagesc(handles.FOV_List(1).raw_Data, 'Parent', handles.Image_Stack_Axes); colormap gray;% truesize(handles.ImPoly_figHand);
    set(handles.FOV_hImage, 'HitTest', 'off');
else set(handles.FOV_hImage, 'CData', handles.FOV_List(1).raw_Data);
end
axis(handles.Image_Stack_Axes, 'equal', 'tight'); hold(handles.Image_Stack_Axes, 'all');
set(handles.Image_Stack_Axes,'Xtick',[],'Ytick',[]);
set(handles.Image_Stack_Axes, 'ButtonDownFcn', {@FOV_Axes_ButtonDownFcn_Callback, hObject}, 'HitTest', 'on');

All_Lines             = findall(handles.Image_Stack_Axes, 'Type', 'line'); set(All_Lines, 'Visible', 'off');
All_Titles            = findall(handles.Image_Stack_Axes, 'Type', 'text'); set(All_Titles, 'Visible', 'off');
Show_All_Poly_cBox    = findobj('Tag', 'Show_All_Poly_cBox');              set(Show_All_Poly_cBox, 'Value', 0);
handles.Show_All_Poly = 0;

guidata(hObject, handles);
end

function Snapshot_Icon_Callback(hObject, eventdata, handles)
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles), [Name, Path] = uiputfile([handles.Ana_Path '\Snapshot.png'], 'Save Snapshot'); 
else [Name, Path] = uiputfile([mwHandles.Ana_Path '\Snapshot.png'], 'Save Snapshot');
end
export_fig([Path '\' Name], '-png', handles.ImPoly_figHand);
end
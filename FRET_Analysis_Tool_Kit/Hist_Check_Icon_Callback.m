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
function Hist_Check_Icon_Callback (hObject, eventdata)
handles = guidata(hObject);

mwHandles = guidata(handles.mwFigureH);
if isfield(mwHandles, 'pcFigureH')
    if ~isempty(mwHandles.pcFigureH)
        pcHandles = guidata(mwHandles.pcFigureH);
        handles   = handles.FRET_.Initiate(handles, pcHandles);
    else
        msgbox('Open Polygon Console', 'Error');
    end
else
    msgbox('Open Polygon Console', 'Error');
end;
Poly_Selected_List = mwHandles.Polygon_List(mwHandles.Current_Polygon_Index);
crPolygon_Name     = Poly_Selected_List(1).Name;
Found = handles.FRET_List.Find_FRET_Item(crPolygon_Name);
% FRET_List_Eapp  = handles.FRET_List(handles.Current_Polygon_Index(1)).Histogram;
% Amp   = double(handles.FRET_List(handles.Current_Polygon_Index(1)).Amplitude);
% Sigma = double(handles.FRET_List(handles.Current_Polygon_Index(1)).Sigma);
% Mu    = double(handles.FRET_List(handles.Current_Polygon_Index(1)).Mu);
% x     = double(handles.FRET_List(handles.Current_Polygon_Index(1)).Bin_List);

if ~(Found == 0)
    FRET_List_Eapp  = handles.FRET_List(Found).Histogram;
    Amp   = double(handles.FRET_List(Found).Amplitude);
    Sigma = double(handles.FRET_List(Found).Sigma);
    Mu    = double(handles.FRET_List(Found).Mu);
    x     = double(handles.FRET_List(Found).Bin_List);
    FRET_List_HistFit = Amp(1)*sqrt(2*pi)*Sigma(1)*Gaussian_Fun(x,Mu(1),Sigma(1));
    % x = handles.FRET_List(handles.Current_Polygon_Index(1)).Bin_List;
    handles.IntHist_FigureH  = figure('Name','Brightness Multi Histogram Plot','NumberTitle','off', 'MenuBar', 'none', 'ToolBar', 'figure');
    handles.IntHist_AxesH    = axes('Parent', handles.IntHist_FigureH, 'Position', [0.07, 0.12, 0.9, 0.82]); hold on;
    handles.Hist_Curve_PlotH = plot(x, FRET_List_Eapp(:,1), 'bo', 'MarkerSize', 5, 'Parent', handles.IntHist_AxesH);
    handles.Fit_Curve_PlotH  = plot(x, FRET_List_HistFit, 'r-', 'Parent', handles.IntHist_AxesH);

    IntHist_Stack_sBar = uicontrol('Style', 'Slider', 'Parent', handles.IntHist_FigureH, 'Units', 'normalized', 'Position', [0 0 1 0.05], ...
                                   'Value', 1, 'Min', 1, 'Max', length(Amp), ...
                                   'SliderStep', [min([1/(length(Amp)-1), 1]), min([10/(length(Amp)-1), 1])], ...
                                   'Callback',{@IntHist_Stack_sBar_callback, hObject});

    Image_Window_Toolbar = findall(handles.IntHist_FigureH,'tag','FigureToolBar');
    Snapshot_Icon        = uipushtool(Image_Window_Toolbar,'TooltipString','Snapshot', 'ClickedCallback', {@Snapshot_Icon_Callback, handles});
    [cdata,~]            = imread('.\Icons\snapshot_2_16x16.png');
    cdata(cdata == 0)    = 240;
    Snapshot_Icon.CData  = cdata;

    ColorBar_Icon = findall(handles.IntHist_FigureH, 'ToolTipString','Insert Colorbar');
    set(ColorBar_Icon, 'Visible', 'off');
    Save_Icon = findall(handles.IntHist_FigureH, 'ToolTipString','Save Figure');
    set(Save_Icon, 'Visible', 'off');
    Legend_Icon = findall(handles.IntHist_FigureH, 'ToolTipString','Insert Legend');
    set(Legend_Icon, 'Visible', 'off');
    Rotate_Icon = findall(handles.IntHist_FigureH, 'ToolTipString','Rotate 3D');
    set(Rotate_Icon, 'Visible', 'off');
    Open_Icon = findall(handles.IntHist_FigureH, 'ToolTipString','Open File');
    set(Open_Icon, 'Visible', 'off');
    Print_Icon = findall(handles.IntHist_FigureH, 'ToolTipString','Print Figure');
    set(Print_Icon, 'Visible', 'off');

end

% x = handles.FRET_List(handles.Current_Polygon_Index(1)).Bin_List;
% handles.IntHist_FigureH  = figure('Name','Brightness Multi Histogram Plot','NumberTitle','off', 'MenuBar', 'none', 'ToolBar', 'figure');
% handles.IntHist_AxesH    = axes('Parent', handles.IntHist_FigureH, 'Position', [0.07, 0.12, 0.9, 0.82]); hold on;
% handles.Hist_Curve_PlotH = plot(x, FRET_List_Eapp(:,1), 'bo', 'MarkerSize', 5, 'Parent', handles.IntHist_AxesH);
% handles.Fit_Curve_PlotH  = plot(x, FRET_List_HistFit, 'r-', 'Parent', handles.IntHist_AxesH);
% 
% IntHist_Stack_sBar = uicontrol('Style', 'Slider', 'Parent', handles.IntHist_FigureH, 'Units', 'normalized', 'Position', [0 0 1 0.05], ...
%                                'Value', 1, 'Min', 1, 'Max', length(Amp), ...
%                                'SliderStep', [min([1/(length(Amp)-1), 1]), min([10/(length(Amp)-1), 1])], ...
%                                'Callback',{@IntHist_Stack_sBar_callback, FRET_FigureH});
% 
% Image_Window_Toolbar = findall(handles.IntHist_FigureH,'tag','FigureToolBar');
% Snapshot_Icon        = uipushtool(Image_Window_Toolbar,'TooltipString','Snapshot', 'ClickedCallback', {@Snapshot_Icon_Callback, handles});
% [cdata,~]            = imread('.\Icons\snapshot_2_16x16.png');
% cdata(cdata == 0)    = 240;
% Snapshot_Icon.CData  = cdata;
% 
% ColorBar_Icon = findall(handles.IntHist_FigureH, 'ToolTipString','Insert Colorbar');
% set(ColorBar_Icon, 'Visible', 'off');
% Save_Icon = findall(handles.IntHist_FigureH, 'ToolTipString','Save Figure');
% set(Save_Icon, 'Visible', 'off');
% Legend_Icon = findall(handles.IntHist_FigureH, 'ToolTipString','Insert Legend');
% set(Legend_Icon, 'Visible', 'off');
% Rotate_Icon = findall(handles.IntHist_FigureH, 'ToolTipString','Rotate 3D');
% set(Rotate_Icon, 'Visible', 'off');
% Open_Icon = findall(handles.IntHist_FigureH, 'ToolTipString','Open File');
% set(Open_Icon, 'Visible', 'off');
% Print_Icon = findall(handles.IntHist_FigureH, 'ToolTipString','Print Figure');
% set(Print_Icon, 'Visible', 'off');

guidata(hObject, handles);
end

function IntHist_Stack_sBar_callback(hObject, eventdata, FRET_FigureH)

handles    = guidata(FRET_FigureH);
if isfield(handles, 'mwFigureH')
    if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end;
else mwHandles = [];
end

if ~isempty(mwHandles)
    Polygon_List = mwHandles.Polygon_List(mwHandles.Current_Polygon_Index);
else
    Polygon_List = handles.Polygon_List(handles.Current_Polygon_Index);
end
sBar_Index = get(hObject, 'Value');
figure(handles.IntHist_FigureH);
delete(handles.Hist_Curve_PlotH);
delete(handles.Fit_Curve_PlotH);
crPoly_Name  = Polygon_List(1).Name;
Found        = handles.FRET_List.Find_FRET_Item(crPoly_Name);
if ~(Found == 0)
%     Bin_Values               = handles.FRET_List(handles.Current_Polygon_Index(1)).Bin_List;
%     IntHist_Curve            = handles.FRET_List(handles.Current_Polygon_Index(1)).Histogram;
    Bin_Values               = handles.FRET_List(Found).Bin_List;
    IntHist_Curve            = handles.FRET_List(Found).Histogram;
    handles.Hist_Curve_PlotH = plot(Bin_Values, IntHist_Curve(:,sBar_Index),...
                                    'bo', 'MarkerSize', 5, 'Parent', handles.IntHist_AxesH);

    Amp   = double(handles.FRET_List(Found).Amplitude);
    Sigma = double(handles.FRET_List(Found).Sigma);
    Mu    = double(handles.FRET_List(Found).Mu);
    x     = double(handles.FRET_List(Found).Bin_List);
    FRET_List_HistFit       = Amp(sBar_Index)*sqrt(2*pi)*Sigma(sBar_Index)*Gaussian_Fun(x,Mu(sBar_Index),Sigma(sBar_Index));
    handles.Fit_Curve_PlotH  = plot(Bin_Values, FRET_List_HistFit, 'r-', 'Parent', handles.IntHist_AxesH);

%     Sample_Name              = handles.FRET_List(handles.Current_Polygon_Index(1)).Master_Polygon;
    Sample_Name              = handles.FRET_List(Found).Master_Polygon;
    Curve_Number_STR         = num2str(sBar_Index);
    Title_String             = [Sample_Name ' - # Segment - ' Curve_Number_STR];
    UnderScore_Pos           = strfind(Title_String, '_');
    Title_String(UnderScore_Pos) = ' ';
    title(handles.IntHist_AxesH, Title_String);
end
            
guidata(handles.output, handles);
end

function Snapshot_Icon_Callback(hObject, eventdata, handles)
[Name, Path] = uiputfile([handles.Ana_Path '\Snapshot.png'], 'Save Snapshot');
export_fig(handles.IntHist_AxesH, [Path '\' Name], '-png', '-transparent');
end
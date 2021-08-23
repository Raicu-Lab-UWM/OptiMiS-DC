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
function handles = Segment_Setting_Tab_Fcn(Segment_Setting_Tab, ROI_Manager_WindowH)

handles = guidata(ROI_Manager_WindowH);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

Seg_Membrane_Thckness_Text = uicontrol('Parent', Segment_Setting_Tab, 'Style', 'text', 'String', 'Membrane Thickness', ...
                                       'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 300 165 25], 'FontSize', 10);
Seg_Membrane_Thckness_Edit = uicontrol('Parent', Segment_Setting_Tab, 'Style', 'edit', ...
                                       'Units', 'Pixels', 'Position', [175 300 50 25], 'FontSize', 10, ...
                                       'Callback', {@Seg_Membrane_Thckness_Edit_Callback, ROI_Manager_WindowH});

Seg_Method_Menu = {'Moving Square', 'Curve Guided', 'Curve Guided Shift', 'SLIC'};
Seg_Method_Text = uicontrol('Parent', Segment_Setting_Tab, 'Style', 'text', 'String', 'Method', ...
                            'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 260 105 25], 'FontSize', 10);
Seg_Method_popMenu = uicontrol('Parent', Segment_Setting_Tab, 'Style', 'popupmenu', 'String', Seg_Method_Menu, ...
                               'Units', 'Pixels', 'Position', [175 260 180 25], 'FontSize', 10, ...
                               'Callback', {@Seg_Method_popMenu_Callback, ROI_Manager_WindowH});

Seg_Type_Menu = {'Area', 'Number of Segments'};
Seg_Type_Text = uicontrol('Parent', Segment_Setting_Tab, 'Style', 'text', 'String', 'Segment By', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 220 110 25], 'FontSize', 10);
Seg_Type_popMenu = uicontrol('Parent', Segment_Setting_Tab, 'Style', 'popupmenu', 'String', Seg_Type_Menu, ...
                             'Units', 'Pixels', 'Position', [175 220 180 25], 'FontSize', 10, ...
                             'Callback', {@Seg_Type_popMenu_Callback, ROI_Manager_WindowH});
Seg_Split_Value_Text = uicontrol('Parent', Segment_Setting_Tab, 'Style', 'text', 'String', 'Value', ...
                                 'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [385 242 60 25], 'FontSize', 10);
Seg_Split_Value_Edit = uicontrol('Parent', Segment_Setting_Tab, 'Style', 'edit', ...
                                 'Units', 'Pixels', 'Position', [365 215 100 30], 'FontSize', 10, ...
                                 'Callback', {@Seg_Split_Value_Edit_Callback, ROI_Manager_WindowH});


Seg_nIterations_Text = uicontrol('Parent', Segment_Setting_Tab, 'Style', 'text', 'String', '# Iterations', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 180 155 25], 'FontSize', 10);
Seg_nIterations_Edit = uicontrol('Parent', Segment_Setting_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [175 180 50 25], 'FontSize', 10, ...
                               'Callback', {@Seg_nIterations_Edit_Callback, ROI_Manager_WindowH});

Seg_Intensity_Weight_Text = uicontrol('Parent', Segment_Setting_Tab, 'Style', 'text', 'String', 'Intensity Weighting', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 140 160 25], 'FontSize', 10);
Seg_Intensity_Weight_Edit = uicontrol('Parent', Segment_Setting_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [175 140 50 25], 'FontSize', 10, ...
                               'Callback', {@Seg_Intensity_Weight_Edit_Callback, ROI_Manager_WindowH});
Seg_nVert_inPoly_Text = uicontrol('Parent', Segment_Setting_Tab, 'Style', 'text', 'String', '# Vertices', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 100 100 25], 'FontSize', 10);
Seg_nVert_inPoly_Edit = uicontrol('Parent', Segment_Setting_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [175 100 50 25], 'FontSize', 10, ...
                               'Callback', {@Seg_nVert_inPoly_Edit_Callback, ROI_Manager_WindowH});

if isempty(mwHandles)
    Seg_Membrane_Thckness = handles.Seg_Membrane_Thckness;
    Seg_Method            = handles.Seg_Method;
    Seg_Type              = handles.Seg_Type;
    Seg_Split_Value       = handles.Seg_Split_Value;
    Seg_nIterations       = handles.Seg_nIterations;
    Seg_Intensity_Weight  = handles.Seg_Intensity_Weight;
    Seg_nVert_inPoly      = handles.Seg_nVert_inPoly;
else
    Seg_Membrane_Thckness = mwHandles.Seg_Membrane_Thckness;
    Seg_Method            = mwHandles.Seg_Method;
    Seg_Type              = mwHandles.Seg_Type;
    Seg_Split_Value       = mwHandles.Seg_Split_Value;
    Seg_nIterations       = mwHandles.Seg_nIterations;
    Seg_Intensity_Weight  = mwHandles.Seg_Intensity_Weight;
    Seg_nVert_inPoly      = mwHandles.Seg_nVert_inPoly;
end

set(Seg_Membrane_Thckness_Edit, 'String', num2str(Seg_Membrane_Thckness));
Seg_Method_Index = find(~cellfun(@isempty, strfind(Seg_Method_Menu, Seg_Method)));
set(Seg_Method_popMenu, 'Value', Seg_Method_Index);
Seg_Type_Index = find(~cellfun(@isempty, strfind(Seg_Type_Menu, Seg_Type)));
set(Seg_Type_popMenu, 'Value', Seg_Type_Index);
set(Seg_Split_Value_Edit, 'String', num2str(Seg_Split_Value));
set(Seg_nIterations_Edit, 'String', num2str(Seg_nIterations));
set(Seg_Intensity_Weight_Edit, 'String', num2str(Seg_Intensity_Weight));
set(Seg_nVert_inPoly_Edit, 'String', num2str(Seg_nVert_inPoly));
end

%------------------------- Callbacks for the Plot Setting Tab widgets --------------------------
% Callback function for the "fluctuation histogram bin" Field. this callback saves values into handles.
function Seg_Membrane_Thckness_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles), handles.Seg_Membrane_Thckness = str2double(get(hObject, 'String')); else mwHandles.Seg_Membrane_Thckness = str2double(get(hObject, 'String')); end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(Main_Figure, handles);
end

% Callback function for the "fluctuation fitting method" popup menu. this callback saves values into handles.
function Seg_Method_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

content = get(hObject, 'String');
if isempty(mwHandles), handles.Seg_Method = content{get(hObject, 'Value')}; else mwHandles.Seg_Method = content{get(hObject, 'Value')}; end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(Main_Figure, handles);
end

% Callback function for the "Fluctuation calculation method" popup menu. this callback saves values into handles.
function Seg_Type_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

content = get(hObject, 'String');
if isempty(mwHandles), handles.Seg_Type = content{get(hObject, 'Value')}; else mwHandles.Seg_Type = content{get(hObject, 'Value')}; end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(Main_Figure, handles);
end

% Callback function for the "monomeric brightness" Field. this callback saves values into handles.
function Seg_Split_Value_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles), handles.Seg_Split_Value = str2num(get(hObject, 'String')); else mwHandles.Seg_Split_Value = str2num(get(hObject, 'String')); end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(Main_Figure, handles);
end

% Callback function for the "Shot noise curve intercept value" Field. this callback saves values into handles.
function Seg_nIterations_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles), handles.Seg_nIterations = str2double(get(hObject, 'String')); else mwHandles.Seg_nIterations = str2double(get(hObject, 'String')); end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(Main_Figure, handles);
end

% Callback function for the "Shot noise curve slop value" Field. this callback saves values into handles.
function Seg_Intensity_Weight_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles), handles.Seg_Intensity_Weight = str2double(get(hObject, 'String')); else mwHandles.Seg_Intensity_Weight = str2double(get(hObject, 'String')); end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(Main_Figure, handles);
end


% Callback function for the "gamma factor" Field. this callback saves values into handles.
function Seg_nVert_inPoly_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles), handles.Seg_nVert_inPoly = str2double(get(hObject, 'String')); else mwHandles.Seg_nVert_inPoly = str2double(get(hObject, 'String')); end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(Main_Figure, handles);
end

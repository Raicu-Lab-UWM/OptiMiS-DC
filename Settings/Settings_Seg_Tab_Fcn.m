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
function handles = Settings_Seg_Tab_Fcn(handles)

Settings_Seg_Tab = handles.Settings_Seg_Tab;

Seg_Membrane_Thckness_Text = uicontrol('Parent', Settings_Seg_Tab, 'Style', 'text', 'String', 'Membrane Thickness', ...
                                       'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 300 165 25], 'FontSize', 10);
Seg_Membrane_Thckness_Edit = uicontrol('Parent', Settings_Seg_Tab, 'Style', 'edit', ...
                                       'Units', 'Pixels', 'Position', [175 300 50 25], 'FontSize', 10, ...
                                       'Callback', {@Seg_Membrane_Thckness_Edit_Callback, handles.output});

Seg_Method_Menu = {'Moving Square', 'Contour Guided Single Sample','Contour Guided Multiple Sample', 'SLIC'};
Seg_Method_Text = uicontrol('Parent', Settings_Seg_Tab, 'Style', 'text', 'String', 'Method', ...
                            'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 260 105 25], 'FontSize', 10);
Seg_Method_popMenu = uicontrol('Parent', Settings_Seg_Tab, 'Style', 'popupmenu', 'String', Seg_Method_Menu, ...
                               'Units', 'Pixels', 'Position', [175 260 180 25], 'FontSize', 10, ...
                               'Callback', {@Seg_Method_popMenu_Callback, handles.output});

Seg_Type_Menu = {'Area', 'Number of Segments'};
Seg_Type_Text = uicontrol('Parent', Settings_Seg_Tab, 'Style', 'text', 'String', 'Segment By', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 220 110 25], 'FontSize', 10);
Seg_Type_popMenu = uicontrol('Parent', Settings_Seg_Tab, 'Style', 'popupmenu', 'String', Seg_Type_Menu, ...
                             'Units', 'Pixels', 'Position', [175 220 180 25], 'FontSize', 10, ...
                             'Callback', {@Seg_Type_popMenu_Callback, handles.output});
                         
Seg_Split_Value_Text = uicontrol('Parent', Settings_Seg_Tab, 'Style', 'text', 'String', 'Value', ...
                                 'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [385 242 60 25], 'FontSize', 10);
Seg_Split_Value_Edit = uicontrol('Parent', Settings_Seg_Tab, 'Style', 'edit', ...
                                 'Units', 'Pixels', 'Position', [365 215 100 30], 'FontSize', 10, ...
                                 'Callback', {@Seg_Split_Value_Edit_Callback, handles.output});


Seg_nIterations_Text = uicontrol('Parent', Settings_Seg_Tab, 'Style', 'text', 'String', '# Iterations', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 180 155 25], 'FontSize', 10);
Seg_nIterations_Edit = uicontrol('Parent', Settings_Seg_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [175 180 50 25], 'FontSize', 10, ...
                               'Callback', {@Seg_nIterations_Edit_Callback, handles.output});

Seg_Intensity_Weight_Text = uicontrol('Parent', Settings_Seg_Tab, 'Style', 'text', 'String', 'Intensity Weighting', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 140 160 25], 'FontSize', 10);
Seg_Intensity_Weight_Edit = uicontrol('Parent', Settings_Seg_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [175 140 50 25], 'FontSize', 10, ...
                               'Callback', {@Seg_Intensity_Weight_Edit_Callback, handles.output});
                           
Seg_nVert_inPoly_Text = uicontrol('Parent', Settings_Seg_Tab, 'Style', 'text', 'String', '# Vertices', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 100 100 25], 'FontSize', 10);
Seg_nVert_inPoly_Edit = uicontrol('Parent', Settings_Seg_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [175 100 50 25], 'FontSize', 10, ...
                               'Callback', {@Seg_nVert_inPoly_Edit_Callback, handles.output});

if ~isfield(handles, 'Seg_Params'), handles.Seg_Params = struct('Seg_Membrane_Thckness', 10, 'Seg_Method', 'Moving Square', 'Seg_Type', 'Area', ...
                                                                'Seg_Split_Value', [30 30], 'Seg_nIterations', 10, 'Seg_Intensity_Weight', 1, ...
                                                                'Seg_nVert_inPoly', 15);
elseif isempty(handles.Seg_Params), handles.Seg_Params = struct('Seg_Membrane_Thckness', 10, 'Seg_Method', 'Moving Square', 'Seg_Type', 'Area', ...
                                                                'Seg_Split_Value', [30 30], 'Seg_nIterations', 10, 'Seg_Intensity_Weight', 1, ...
                                                                'Seg_nVert_inPoly', 15);
end;
if ~isfield(handles.Seg_Params, 'Seg_Membrane_Thckness'), handles.Seg_Params.Seg_Membrane_Thckness = 10; 
elseif isempty(handles.Seg_Params.Seg_Membrane_Thckness), handles.Seg_Params.Seg_Membrane_Thckness = 10;
end;
if ~isfield(handles.Seg_Params, 'Seg_Method'), handles.Seg_Params.Seg_Method = 'Moving Square';
elseif isempty(handles.Seg_Params.Seg_Method), handles.Seg_Params.Seg_Method = 'Moving Square';
end;
if ~isfield(handles.Seg_Params, 'Seg_Type'), handles.Seg_Params.Seg_Type = 'Area';
elseif isempty(handles.Seg_Params.Seg_Type), handles.Seg_Params.Seg_Type = 'Area';
end;
if ~isfield(handles.Seg_Params, 'Seg_Split_Value'), handles.Seg_Params.Seg_Split_Value = [30 30];
elseif isempty(handles.Seg_Params.Seg_Split_Value), handles.Seg_Params.Seg_Split_Value = [30 30];
end;
if ~isfield(handles.Seg_Params, 'Seg_nIterations'), handles.Seg_Params.Seg_nIterations = 10;
elseif isempty(handles.Seg_Params.Seg_nIterations), handles.Seg_Params.Seg_nIterations = 10;
end;
if ~isfield(handles.Seg_Params, 'Seg_Intensity_Weight'), handles.Seg_Params.Seg_Intensity_Weight = 1;
elseif isempty(handles.Seg_Params.Seg_Intensity_Weight), handles.Seg_Params.Seg_Intensity_Weight = 1;
end;
if ~isfield(handles.Seg_Params, 'Seg_nVert_inPoly'), handles.Seg_Params.Seg_nVert_inPoly = 15;
elseif isempty(handles.Seg_Params.Seg_nVert_inPoly), handles.Seg_Params.Seg_nVert_inPoly = 15;
end;

set(Seg_Membrane_Thckness_Edit, 'String', num2str(handles.Seg_Params.Seg_Membrane_Thckness));
Seg_Method_Index = find(~cellfun(@isempty, strfind(Seg_Method_Menu, handles.Seg_Params.Seg_Method)));
set(Seg_Method_popMenu, 'Value', Seg_Method_Index);
Seg_Type_Index = find(~cellfun(@isempty, strfind(Seg_Type_Menu, handles.Seg_Params.Seg_Type)));
set(Seg_Type_popMenu, 'Value', Seg_Type_Index);
set(Seg_Split_Value_Edit, 'String', num2str(handles.Seg_Params.Seg_Split_Value));
set(Seg_nIterations_Edit, 'String', num2str(handles.Seg_Params.Seg_nIterations));
set(Seg_Intensity_Weight_Edit, 'String', num2str(handles.Seg_Params.Seg_Intensity_Weight));
set(Seg_nVert_inPoly_Edit, 'String', num2str(handles.Seg_Params.Seg_nVert_inPoly));
end

%------------------------- Callbacks for the Plot Setting Tab widgets --------------------------
% Callback function for the "fluctuation histogram bin" Field. this callback saves values into handles.
function Seg_Membrane_Thckness_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Seg_Params.Seg_Membrane_Thckness = str2double(get(hObject, 'String'));

ROI_Manager_FigureH      = findobj('Name', 'ROI Manager');
if ~isempty(ROI_Manager_FigureH)
    if isvalid(ROI_Manager_FigureH)
        sgHandles                       = guidata(ROI_Manager_FigureH);
        sgHandles.Seg_Membrane_Thckness = handles.Seg_Params.Seg_Membrane_Thckness;
        guidata(ROI_Manager_FigureH, sgHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "fluctuation fitting method" popup menu. this callback saves values into handles.
function Seg_Method_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
content = get(hObject, 'String');
handles.Seg_Params.Seg_Method = content{get(hObject, 'Value')};

ROI_Manager_FigureH      = findobj('Name', 'ROI Manager');
if ~isempty(ROI_Manager_FigureH)
    if isvalid(ROI_Manager_FigureH)
        sgHandles            = guidata(ROI_Manager_FigureH);
        sgHandles.Seg_Method = handles.Seg_Params.Seg_Method;
        guidata(ROI_Manager_FigureH, sgHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Fluctuation calculation method" popup menu. this callback saves values into handles.
function Seg_Type_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
content = get(hObject, 'String');
handles.Seg_Params.Seg_Type = content{get(hObject, 'Value')};

ROI_Manager_FigureH      = findobj('Name', 'ROI Manager');
if ~isempty(ROI_Manager_FigureH)
    if isvalid(ROI_Manager_FigureH)
        sgHandles          = guidata(ROI_Manager_FigureH);
        sgHandles.Seg_Type = handles.Seg_Params.Seg_Type;
        guidata(ROI_Manager_FigureH, sgHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "monomeric brightness" Field. this callback saves values into handles.
function Seg_Split_Value_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Seg_Params.Seg_Split_Value = str2num(get(hObject, 'String'));

ROI_Manager_FigureH      = findobj('Name', 'ROI Manager');
if ~isempty(ROI_Manager_FigureH)
    if isvalid(ROI_Manager_FigureH)
        sgHandles                 = guidata(ROI_Manager_FigureH);
        sgHandles.Seg_Split_Value = handles.Seg_Params.Seg_Split_Value;
        guidata(ROI_Manager_FigureH, sgHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Shot noise curve intercept value" Field. this callback saves values into handles.
function Seg_nIterations_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Seg_Params.Seg_nIterations = str2double(get(hObject, 'String'));

ROI_Manager_FigureH      = findobj('Name', 'ROI Manager');
if ~isempty(ROI_Manager_FigureH)
    if isvalid(ROI_Manager_FigureH)
        sgHandles                 = guidata(ROI_Manager_FigureH);
        sgHandles.Seg_nIterations = handles.Seg_Params.Seg_nIterations;
        guidata(ROI_Manager_FigureH, sgHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Shot noise curve slop value" Field. this callback saves values into handles.
function Seg_Intensity_Weight_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Seg_Params.Seg_Intensity_Weight = str2double(get(hObject, 'String'));

ROI_Manager_FigureH      = findobj('Name', 'ROI Manager');
if ~isempty(ROI_Manager_FigureH)
    if isvalid(ROI_Manager_FigureH)
        sgHandles                      = guidata(ROI_Manager_FigureH);
        sgHandles.Seg_Intensity_Weight = handles.Seg_Params.Seg_Intensity_Weight;
        guidata(ROI_Manager_FigureH, sgHandles);
    end
end

guidata(Main_Figure, handles);
end


% Callback function for the "gamma factor" Field. this callback saves values into handles.
function Seg_nVert_inPoly_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Seg_Params.Seg_nVert_inPoly = str2double(get(hObject, 'String'));

ROI_Manager_FigureH      = findobj('Name', 'ROI Manager');
if ~isempty(ROI_Manager_FigureH)
    if isvalid(ROI_Manager_FigureH)
        sgHandles                  = guidata(ROI_Manager_FigureH);
        sgHandles.Seg_nVert_inPoly = handles.Seg_Params.Seg_nVert_inPoly;
        guidata(ROI_Manager_FigureH, sgHandles);
    end
end

guidata(Main_Figure, handles);
end
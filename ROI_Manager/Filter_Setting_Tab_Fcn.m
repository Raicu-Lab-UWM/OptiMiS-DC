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
function handles = Filter_Setting_Tab_Fcn(Filter_Setting_Tab, ROI_Manager_WindowH)

handles             = guidata(ROI_Manager_WindowH);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

Flt_Method_Menu     = {'X Square', 'SNR', 'Concentration'};
Flt_Method_Text     = uicontrol('Parent', Filter_Setting_Tab, 'Style', 'text', 'String', 'Method', ...
                                'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 300 60 25], 'FontSize', 10);
Flt_Method_popMenu  = uicontrol('Parent', Filter_Setting_Tab, 'Style', 'popupmenu', 'String', Flt_Method_Menu, ...
                                'Units', 'Pixels', 'Position', [75 304 130 25], 'FontSize', 10, ...
                                'Callback', {@Flt_Method_popMenu_Callback, ROI_Manager_WindowH});

Flt_LowPassCut_Text = uicontrol('Parent', Filter_Setting_Tab, 'Style', 'text', 'String', 'Cutoff', ...
                                'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 260 60 25], 'FontSize', 10);
Flt_LowCut_Edit     = uicontrol('Parent', Filter_Setting_Tab, 'Style', 'edit', ...
                                'Units', 'Pixels', 'Position', [75 263 60 25], 'FontSize', 10, ...
                                'Callback', {@Flt_LowCut_Edit_Callback, ROI_Manager_WindowH});
Flt_HighCut_Edit    = uicontrol('Parent', Filter_Setting_Tab, 'Style', 'edit', ...
                                'Units', 'Pixels', 'Position', [140 263 60 25], 'FontSize', 10, ...
                                'Callback', {@Flt_HighCut_Edit_Callback, ROI_Manager_WindowH});

if isempty(mwHandles)
    Flt_Method  = handles.Flt_Method;
    Flt_LowCut  = handles.Flt_LowCut;
    Flt_HighCut = handles.Flt_HighCut;
else
    Flt_Method  = mwHandles.Flt_Method;
    Flt_LowCut  = mwHandles.Flt_LowCut;
    Flt_HighCut = mwHandles.Flt_HighCut;
end

Flt_Method_Index    = find(~cellfun(@isempty, strfind(Flt_Method_Menu, Flt_Method)));
set(Flt_Method_popMenu, 'Value', Flt_Method_Index);
set(Flt_LowCut_Edit, 'String', num2str(Flt_LowCut));
set(Flt_HighCut_Edit, 'String', num2str(Flt_HighCut));
end

%------------------------- Callbacks for the Plot Setting Tab widgets --------------------------
% Callback function for the "Segment or cell filtering method" popup menu. this callback saves values into handles.
function Flt_Method_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

content = get(hObject, 'String');
if isempty(mwHandles), handles.Flt_Method = content{get(hObject, 'Value')}; else mwHandles.Flt_Method = content{get(hObject, 'Value')}; end

guidata(handles.mwFigureH, mwHandles);
guidata(Main_Figure, handles);
end

% Callback function for the "Low band cutoff" Field. this callback saves values into handles.
function Flt_LowCut_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles), handles.Flt_LowCut = str2num(get(hObject, 'String')); else mwHandles.Flt_LowCut = str2num(get(hObject, 'String')); end

guidata(handles.mwFigureH, mwHandles);
guidata(Main_Figure, handles);
end

% Callback function for the "High band cutoff" Field. this callback saves values into handles.
function Flt_HighCut_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles), handles.Flt_HighCut = str2num(get(hObject, 'String')); else mwHandles.Flt_HighCut = str2num(get(hObject, 'String')); end

guidata(handles.mwFigureH, mwHandles);
guidata(Main_Figure, handles);
end
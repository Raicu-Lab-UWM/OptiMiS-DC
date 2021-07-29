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
function handles = ES_Setting_Tab_Fcn(hObject, eventdata)
handles    = guidata(hObject);
StandAlone = true; mwHandles = [];
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); StandAlone = false; end; end

ES_Setting_Tab = handles.ES_Setting_Tab;

% ES histogram bin
ES_Hor_Shift_Text = uicontrol('Parent', ES_Setting_Tab, 'Style', 'text', 'String', 'Horizontal Shift', ...
                              'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 300 200 25], 'FontSize', 10);
ES_Hor_Shift_Edit = uicontrol('Parent', ES_Setting_Tab, 'Style', 'edit', ...
                              'Units', 'Pixels', 'Position', [130 300 50 25], 'FontSize', 10, ...
                              'Callback', {@ES_Hor_Shift_Edit_Callback, hObject});

% Method of fitting Popup Menu
ES_Sample_Type_Menu = {'Cells', 'Solution'};
ES_Sample_Type_Text = uicontrol('Parent', ES_Setting_Tab, 'Style', 'text', 'String', 'Sample Type', ...
                                'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 260 105 25], 'FontSize', 10);
ES_Sample_Type_popMenu = uicontrol('Parent', ES_Setting_Tab, 'Style', 'popupmenu', 'String', ES_Sample_Type_Menu, ...
                                   'Units', 'Pixels', 'Position', [130 260 180 25], 'FontSize', 10, ...
                                   'Callback', {@ES_Sample_Type_popMenu_Callback, hObject});

if StandAlone, set(handles.ES_Hor_Shift_Edit, 'String', num2str(handles.Hor_Shift));
    ES_Sample_Type_Index = find(~cellfun(@isempty, strfind(ES_Sample_Type_Menu, handles.Sample_Type)));
else set(ES_Hor_Shift_Edit, 'String', num2str(mwHandles.General_Params.Hor_Shift));
    ES_Sample_Type_Index = find(~cellfun(@isempty, strfind(ES_Sample_Type_Menu, mwHandles.General_Params.Sample_Type)));
end
set(ES_Sample_Type_popMenu, 'Value', ES_Sample_Type_Index);
end

%------------------------- Callbacks for the Plot Setting Tab widgets --------------------------
% Callback function for the "fluctuation histogram bin" Field. this callback saves values into handles.
function ES_Hor_Shift_Edit_Callback (hObject, eventdata, Main_Figure)
handles    = guidata(Main_Figure);
StandAlone = true; mwHandles = [];
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); StandAlone = false; end; end
if StandAlone, handles.Hor_Shift = str2double(get(hObject, 'String')); else mwHandles.General_Params.Hor_Shift = str2double(get(hObject, 'String')); end

guidata(handles.mwFigureH, mwHandles);
guidata(Main_Figure, handles);
end

% Callback function for the "fluctuation fitting method" popup menu. this callback saves values into handles.
function ES_Sample_Type_popMenu_Callback (hObject, eventdata, Main_Figure)
handles             = guidata(Main_Figure);
StandAlone          = true; mwHandles = [];
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); StandAlone = false; end; end
content             = get(hObject, 'String');
handles.Sample_Type = content{get(hObject, 'Value')};
if StandAlone, handles.Sample_Type = content{get(hObject, 'Value')}; else mwHandles.General_Params.Sample_Type = content{get(hObject, 'Value')}; end

guidata(handles.mwFigureH, mwHandles);
guidata(Main_Figure, handles);
end
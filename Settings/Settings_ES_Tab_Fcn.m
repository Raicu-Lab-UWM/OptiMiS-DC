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
function handles = Settings_ES_Tab_Fcn(handles)

Settings_ES_Tab = handles.Settings_ES_Tab;

% ES histogram bin
ES_Hor_Shift_Text = uicontrol('Parent', Settings_ES_Tab, 'Style', 'text', 'String', 'Horizontal Shift', ...
                              'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 300 200 25], 'FontSize', 10);
ES_Hor_Shift_Edit = uicontrol('Parent', Settings_ES_Tab, 'Style', 'edit', ...
                              'Units', 'Pixels', 'Position', [130 300 50 25], 'FontSize', 10, ...
                              'Callback', {@ES_Hor_Shift_Edit_Callback, handles.output});

% Method of fitting Popup Menu
ES_Sample_Type_Menu = {'Cells', 'Solution'};
ES_Sample_Type_Text = uicontrol('Parent', Settings_ES_Tab, 'Style', 'text', 'String', 'Sample Type', ...
                                'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 260 105 25], 'FontSize', 10);
ES_Sample_Type_popMenu = uicontrol('Parent', Settings_ES_Tab, 'Style', 'popupmenu', 'String', ES_Sample_Type_Menu, ...
                                   'Units', 'Pixels', 'Position', [130 260 180 25], 'FontSize', 10, ...
                                   'Callback', {@ES_Sample_Type_popMenu_Callback, handles.output});

if ~isfield(handles, 'ES_Params'), handles.ES_Params = struct('ES_Hor_Shift', 0, 'ES_Sample_Type', 'Cells');
elseif isempty(handles.ES_Params), handles.ES_Params = struct('ES_Hor_Shift', 0, 'ES_Sample_Type', 'Cells');
end;
if ~isfield(handles.ES_Params, 'ES_Hor_Shift'), handles.ES_Params.ES_Hor_Shift = 0; 
elseif isempty(handles.ES_Params.ES_Hor_Shift), handles.ES_Params.ES_Hor_Shift = 0;
end;
if ~isfield(handles.ES_Params, 'ES_Sample_Type'), handles.ES_Params.ES_Sample_Type = 'Cells';
elseif isempty(handles.ES_Params.ES_Sample_Type), handles.ES_Params.ES_Sample_Type = 'Cells';
end;

set(ES_Hor_Shift_Edit, 'String', num2str(handles.ES_Params.ES_Hor_Shift));
ES_Sample_Type_Index = find(~cellfun(@isempty, strfind(ES_Sample_Type_Menu, handles.ES_Params.ES_Sample_Type)));
set(ES_Sample_Type_popMenu, 'Value', ES_Sample_Type_Index);
end

%------------------------- Callbacks for the Plot Setting Tab widgets --------------------------
% Callback function for the "fluctuation histogram bin" Field. this callback saves values into handles.
function ES_Hor_Shift_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.ES_Params.ES_Hor_Shift = str2double(get(hObject, 'String'));

ES_Tool_Kit_FigH       = findobj('Tag', 'ES_Tool_Kit_FigH');
if ~isempty(ES_Tool_Kit_FigH)
    if isvalid(ES_Tool_Kit_FigH)
        esHandles              = guidata(ES_Tool_Kit_FigH);
        esHandles.ES_Hor_Shift = handles.ES_Params.ES_Hor_Shift;
        guidata(ES_Tool_Kit_FigH, esHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "fluctuation fitting method" popup menu. this callback saves values into handles.
function ES_Sample_Type_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
content = get(hObject, 'String');
handles.ES_Params.ES_Sample_Type = content{get(hObject, 'Value')};

ES_Tool_Kit_FigH         = findobj('Tag', 'ES_Tool_Kit_FigH');
if ~isempty(ES_Tool_Kit_FigH)
    if isvalid(ES_Tool_Kit_FigH)
        esHandles                = guidata(ES_Tool_Kit_FigH);
        esHandles.ES_Sample_Type = handles.ES_Params.ES_Sample_Type;
        guidata(ES_Tool_Kit_FigH, esHandles);
    end
end

guidata(Main_Figure, handles);
end
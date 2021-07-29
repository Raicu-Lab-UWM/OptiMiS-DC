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
function handles = UM_General_Setting_Tab_Fcn(handles)

General_Setting_Tab = handles.General_Setting_Tab;

Ana_Path_Text = uicontrol('Parent', General_Setting_Tab, 'Style', 'text', 'String', 'Analysis Path', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 295 115 25], 'FontSize', 10);
Ana_Path_Edit = uicontrol('Parent', General_Setting_Tab, 'Style', 'edit', 'Tag', 'Ana_Path_Edit', ...
                          'Units', 'Pixels', 'Position', [135 295 350 25], 'FontSize', 10, ...
                          'Callback', {@Ana_Path_Edit_Callback, handles.output});
Ana_Path_pButton = uicontrol('Parent', General_Setting_Tab, 'Style', 'push', 'String', '...', 'Tag', 'Ana_Path_pButton', ...
                             'Units', 'Pixels', 'Position', [495 295 25 25], 'FontSize', 10, ...
                             'Callback', {@Ana_Path_pButton_Callback, handles.output});
                         
Hor_Shift_Text = uicontrol('Parent', General_Setting_Tab, 'Style', 'text', 'String', 'Horizontal Shift', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 255 115 25], 'FontSize', 10);
Hor_Shift_Edit = uicontrol('Parent', General_Setting_Tab, 'Style', 'edit', 'Tag', 'Hor_Shift_Edit', ...
                          'Units', 'Pixels', 'Position', [135 255 50 25], 'FontSize', 10, ...
                          'Callback', {@Hor_Shift_Edit_Callback, handles.output});

Sample_Type_Menu = {'Cells', 'Solution'};
Sample_Type_Text = uicontrol('Parent', General_Setting_Tab, 'Style', 'text', 'String', 'Sample Type', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 215 115 25], 'FontSize', 10);
Sample_Type_popMenu = uicontrol('Parent', General_Setting_Tab, 'Style', 'popupmenu', 'String', Sample_Type_Menu, 'Tag', 'Sample_Type_popMenu', ...
                                   'Units', 'Pixels', 'Position', [135 215 180 25], 'FontSize', 10, ...
                                   'Callback', {@Sample_Type_popMenu_Callback, handles.output});

Pen_Size_Text = uicontrol('Parent', General_Setting_Tab, 'Style', 'text', 'String', 'Pen Size', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 175 115 25], 'FontSize', 10);
Pen_Size_Edit = uicontrol('Parent', General_Setting_Tab, 'Style', 'edit', 'Tag', 'Pen_Size_Edit', ...
                          'Units', 'Pixels', 'Position', [135 175 50 25], 'FontSize', 10, ...
                          'Callback', {@Pen_Size_Edit_Callback, handles.output});

Separate_Dir_cBox = uicontrol('Parent', General_Setting_Tab, 'Style', 'checkbox', 'String', 'Separate Paths', ...
                              'Units', 'Pixels', 'Position', [5 135 200 25], 'FontSize', 10, 'Tag', 'Separate_Dir_cBox', ...
                              'Callback', {@Separate_Dir_cBox_Callback, handles.output});
Inc_Sub_Dir_cBox = uicontrol('Parent', General_Setting_Tab, 'Style', 'checkbox', 'String', 'Include Sub Directories', ...
                              'Units', 'Pixels', 'Position', [5 95 200 25], 'FontSize', 10, 'Tag', 'Inc_Sub_Dir_cBox', ...
                              'Callback', {@Inc_Sub_Dir_cBox_Callback, handles.output});
Show_Warnings_cBox = uicontrol('Parent', General_Setting_Tab, 'Style', 'checkbox', 'String', 'Show Warnings', ...
                              'Units', 'Pixels', 'Position', [5 55 200 25], 'FontSize', 10, 'Tag', 'Show_Warnings_cBox', ...
                              'Callback', {@Show_Warnings_cBox_Callback, handles.output});

if ~isfield(handles, 'Ana_Path'), handles.Ana_Path = '.\'; elseif isempty(handles.Ana_Path), handles.Ana_Path = '.\'; end;
if ~isfield(handles, 'Hor_Shift'), handles.Hor_Shift = 0; elseif isempty(handles.Hor_Shift), handles.Hor_Shift = 0; end;
if ~isfield(handles, 'Sample_Type'), handles.Sample_Type = 'Cells'; elseif isempty(handles.Sample_Type), handles.Sample_Type = 'Cells'; end;
if ~isfield(handles, 'Pen_Size'), handles.Pen_Size = 1; elseif isempty(handles.Pen_Size), handles.Pen_Size = 1; end;
set(Ana_Path_Edit, 'String', num2str(handles.Ana_Path));
set(Hor_Shift_Edit, 'String', num2str(handles.Hor_Shift));
Sample_Type_Index = find(~cellfun(@isempty, strfind(Sample_Type_Menu, handles.Sample_Type)));
set(Sample_Type_popMenu, 'Value', Sample_Type_Index);
set(Pen_Size_Edit, 'String', num2str(handles.Pen_Size));
if ~isfield(handles, 'Separate_Dir'), handles.Separate_Dir = 1; elseif isempty(handles.Separate_Dir), handles.Separate_Dir = 1; end;
if ~isfield(handles, 'Inc_Sub_Dir'), handles.Inc_Sub_Dir = 1; elseif isempty(handles.Inc_Sub_Dir), handles.Inc_Sub_Dir = 1; end;
if ~isfield(handles, 'Show_Warnings'), handles.Show_Warnings = 0; elseif isempty(handles.Show_Warnings), handles.Show_Warnings = 0; end;
set(Separate_Dir_cBox, 'Value', handles.Separate_Dir);
set(Inc_Sub_Dir_cBox, 'Value', handles.Inc_Sub_Dir);
set(Show_Warnings_cBox, 'Value', handles.Show_Warnings);
end

%------------------------- Callbacks for the General Setting Tab widgets --------------------------
% Callback function for the "Setting Analysis Path" Field. this callback saves values into handles.
function Ana_Path_Edit_Callback (hObject, eventdata, Main_Figure)
handles          = guidata(Main_Figure);
handles.Ana_Path = get(hObject, 'String');

guidata(Main_Figure, handles);
end

% Callback function for the "Setting Analysis Path" Push button. this callback saves values into handles.
function Ana_Path_pButton_Callback (hObject, eventdata, Main_Figure)
handles          = guidata(Main_Figure);
handles.Ana_Path = uigetdir(handles.Ana_Path, 'Select Analysis Path');
Ana_Path_Edit    = findobj('Tag', 'Ana_Path_Edit');
set(Ana_Path_Edit, 'String', num2str(handles.Ana_Path));

guidata(Main_Figure, handles);
end

% Callback function for the "Horizontal Shift" Field. this callback saves values into handles.
function Hor_Shift_Edit_Callback (hObject, eventdata, Main_Figure)
handles           = guidata(Main_Figure);
handles.Hor_Shift = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "Histogram Bin Size" Field. this callback saves values into handles.
function Sample_Type_popMenu_Callback (hObject, eventdata, Main_Figure)
handles             = guidata(Main_Figure);
content             = get(hObject, 'String');
handles.Sample_Type = content{get(hObject, 'Value')};

guidata(Main_Figure, handles);
end

% Callback function for the "Pen Size" Field. this callback saves values into handles.
function Pen_Size_Edit_Callback (hObject, eventdata, Main_Figure)
handles          = guidata(Main_Figure);
handles.Pen_Size = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "Separate Path for each image" check box. this callback saves values into handles.
function Separate_Dir_cBox_Callback (hObject, eventdata, Main_Figure)
handles              = guidata(Main_Figure);
handles.Separate_Dir = get(hObject, 'Value');

guidata(Main_Figure, handles);
end

% Callback function for the "include Sub Directories" check box. this callback saves values into handles.
function Inc_Sub_Dir_cBox_Callback (hObject, eventdata, Main_Figure)
handles             = guidata(Main_Figure);
handles.Inc_Sub_Dir = get(hObject, 'Value');

guidata(Main_Figure, handles);
end

% Callback function for the "Show Warnings" check box. this callback saves values into handles.
function Show_Warnings_cBox_Callback (hObject, eventdata, Main_Figure)
handles               = guidata(Main_Figure);
handles.Show_Warnings = get(hObject, 'Value');

guidata(Main_Figure, handles);
end
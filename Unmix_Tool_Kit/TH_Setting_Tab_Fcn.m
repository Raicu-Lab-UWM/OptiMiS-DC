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
function handles = TH_Setting_Tab_Fcn(handles)

TH_Setting_Tab = handles.TH_Setting_Tab;

Min_Range_Text = uicontrol('Parent', TH_Setting_Tab, 'Style', 'text', 'String', 'min', ...
                           'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [155 317 50 25], 'FontSize', 10);
Max_Range_Text = uicontrol('Parent', TH_Setting_Tab, 'Style', 'text', 'String', 'max', ...
                           'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [215 317 50 25], 'FontSize', 10);
Inc_Size_Text = uicontrol('Parent', TH_Setting_Tab, 'Style', 'text', 'String', 'Increment', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [263 317 70 25], 'FontSize', 10);

Thresh_Val_Text = uicontrol('Parent', TH_Setting_Tab, 'Style', 'text', 'String', 'Threshold', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 295 115 25], 'FontSize', 10);
Thresh_Val_Min_Edit = uicontrol('Parent', TH_Setting_Tab, 'Style', 'edit', 'Tag', 'Thresh_Val_Min_Edit', ...
                          'Units', 'Pixels', 'Position', [145 295 50 25], 'FontSize', 10, ...
                          'Callback', {@Thresh_Val_Min_Edit_Callback, handles.output});
Thresh_Val_Max_Edit = uicontrol('Parent', TH_Setting_Tab, 'Style', 'edit', 'Tag', 'Thresh_Val_Max_Edit', ...
                                 'Units', 'Pixels', 'Position', [205 295 50 25], 'FontSize', 10, ...
                                 'Callback', {@Thresh_Val_Max_Edit_Callback, handles.output});
Thresh_Val_Inc_Edit = uicontrol('Parent', TH_Setting_Tab, 'Style', 'edit', 'Tag', 'Thresh_Val_Inc_Edit', ...
                                 'Units', 'Pixels', 'Position', [265 295 50 25], 'FontSize', 10, ...
                                 'Callback', {@Thresh_Val_Inc_Edit_Callback, handles.output});

TH_Method_Menu = {'Donor & Acceptor', 'Donor Only', 'Reduced Chi Square'};
TH_Method_Text = uicontrol('Parent', TH_Setting_Tab, 'Style', 'text', 'String', 'Threshold Method', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 255 140 25], 'FontSize', 10);
TH_Method_popMenu = uicontrol('Parent', TH_Setting_Tab, 'Style', 'popupmenu', 'String', TH_Method_Menu, ...
                                      'Units', 'Pixels', 'Position', [145 255 200 25], 'FontSize', 10, 'Tag', 'TH_Method_popMenu', ...
                                      'Callback', {@TH_Method_popMenu_Callback, handles.output});
                      
Save_TH_Images_cBox = uicontrol('Parent', TH_Setting_Tab, 'Style', 'checkbox', 'String', 'Save TH Images', ...
                              'Units', 'Pixels', 'Position', [5 175 200 25], 'FontSize', 10, 'Tag', 'Save_TH_Images_cBox', ...
                              'Callback', {@Save_TH_Images_cBox_Callback, handles.output});

if ~isfield(handles, 'TH_Value'), handles.TH_Value = [0,0,1]; elseif isempty(handles.TH_Value), handles.TH_Value = [0,0,1]; end;
if ~isfield(handles, 'Threshold_Method'), handles.Threshold_Method = 'Donor & Acceptor'; elseif isempty(handles.Threshold_Method), handles.Threshold_Method = 'Donor & Acceptor'; end;
if ~isfield(handles, 'Save_TH_Images'), handles.Save_TH_Images = 0; elseif isempty(handles.Save_TH_Images), handles.Save_TH_Images = 0; end;

set(Thresh_Val_Min_Edit, 'String', num2str(handles.TH_Value(1)));
set(Thresh_Val_Max_Edit, 'String', num2str(handles.TH_Value(2)));
set(Thresh_Val_Inc_Edit, 'String', num2str(handles.TH_Value(3)));
TH_Method_Index = find(~cellfun(@isempty, strfind(TH_Method_Menu, handles.Threshold_Method)));
set(TH_Method_popMenu, 'Value', TH_Method_Index);
set(Save_TH_Images_cBox, 'Value', handles.Save_TH_Images);
end

%------------------------- Callbacks for the General Setting Tab widgets --------------------------
% Callback function for the "Setting min threshold value" Field. this callback saves values into handles.
function Thresh_Val_Min_Edit_Callback (hObject, eventdata, Main_Figure)
handles             = guidata(Main_Figure);
handles.TH_Value(1) = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "Setting max threshold value" Field. this callback saves values into handles.
function Thresh_Val_Max_Edit_Callback (hObject, eventdata, Main_Figure)
handles             = guidata(Main_Figure);
handles.TH_Value(2) = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "Setting threshold increment value" Field. this callback saves values into handles.
function Thresh_Val_Inc_Edit_Callback (hObject, eventdata, Main_Figure)
handles             = guidata(Main_Figure);
handles.TH_Value(3) = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "fluctuation fitting method" popup menu. this callback saves values into handles.
function TH_Method_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
content = get(hObject, 'String');
handles.Threshold_Method = content{get(hObject, 'Value')};
handles.Threshold_Method_Index = get(hObject, 'Value');

guidata(Main_Figure, handles);
end

% Callback function for the "Separate Path for each image" check box. this callback saves values into handles.
function Save_TH_Images_cBox_Callback (hObject, eventdata, Main_Figure)
handles                = guidata(Main_Figure);
handles.Save_TH_Images = get(hObject, 'Value');

guidata(Main_Figure, handles);
end
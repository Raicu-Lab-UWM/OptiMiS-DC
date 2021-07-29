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
function handles = FRET_General_Setting_Tab_Fcn(handles)

General_Setting_Tab = handles.General_Setting_Tab;

Min_Range_Text = uicontrol('Parent', General_Setting_Tab, 'Style', 'text', 'String', 'min', ...
                           'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [130 317 50 25], 'FontSize', 10);
Max_Range_Text = uicontrol('Parent', General_Setting_Tab, 'Style', 'text', 'String', 'max', ...
                           'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [190 317 50 25], 'FontSize', 10);
Bin_Size_Text = uicontrol('Parent', General_Setting_Tab, 'Style', 'text', 'String', 'Bin Size', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [250 317 50 25], 'FontSize', 10);

Eapp_Range_Text = uicontrol('Parent', General_Setting_Tab, 'Style', 'text', 'String', 'Eapp',...
                            'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 295 150 25], 'FontSize', 10);
Eapp_minRange_Edit = uicontrol('Parent', General_Setting_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [120 295 50 25], 'FontSize', 10, ...
                               'Callback', {@Eapp_minRange_Edit_Callback, handles.output});
Eapp_maxRange_Edit = uicontrol('Parent', General_Setting_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [180 295 50 25], 'FontSize', 10, ...
                               'Callback', {@Eapp_maxRange_Edit_Callback, handles.output});
Eapp_BinSize_Edit = uicontrol('Parent', General_Setting_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [240 295 50 25], 'FontSize', 10, ...
                               'Callback', {@Eapp_BinSize_Edit_Callback, handles.output});

Conc_Range_Text = uicontrol('Parent', General_Setting_Tab, 'Style', 'text', 'String', 'Concentration', ...
                            'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 255 150 25], 'FontSize', 10);
Conc_minRange_Edit = uicontrol('Parent', General_Setting_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [120 255 50 25], 'FontSize', 10, ...
                               'Callback', {@Conc_minRange_Edit_Callback, handles.output});
Conc_maxRange_Edit = uicontrol('Parent', General_Setting_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [180 255 50 25], 'FontSize', 10, ...
                               'Callback', {@Conc_maxRange_Edit_Callback, handles.output});
Conc_BinSize_Edit = uicontrol('Parent', General_Setting_Tab, 'Style', 'edit', ...
                              'Units', 'Pixels', 'Position', [240 255 50 25], 'FontSize', 10, ...
                              'Callback', {@Conc_BinSize_Edit_Callback, handles.output});
Pixel_Size_Text = uicontrol('Parent', General_Setting_Tab, 'Style', 'text', 'String', 'Pixel Size', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [300 273 62 25], 'FontSize', 10);
Pixel_Size_Edit = uicontrol('Parent', General_Setting_Tab, 'Style', 'edit', ...
                              'Units', 'Pixels', 'Position', [300 255 50 25], 'FontSize', 10, ...
                              'Callback', {@Pixel_Size_Edit_Callback, handles.output});
Pr_MultFact_Text = uicontrol('Parent', General_Setting_Tab, 'Style', 'text', 'String', 'Proto. Mult. Factor', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [370 273 112 25], 'FontSize', 10);
Pr_MultFact_Edit = uicontrol('Parent', General_Setting_Tab, 'Style', 'edit', ...
                              'Units', 'Pixels', 'Position', [370 255 50 25], 'FontSize', 10, ...
                              'Callback', {@Pr_MultFact_Edit_Callback, handles.output});

Accum_Data_cBox = uicontrol('Parent', General_Setting_Tab, 'Style', 'checkbox', 'String', 'Accumulate Data', ...
                            'Units', 'Pixels', 'Position', [10 205 300 25], 'FontSize', 10, ...
                            'Callback', {@Accum_Data_cBox_Callback, handles.output});

if ~isfield(handles, 'Eapp_minRange'), handles.Eapp_minRange = 0; elseif isempty(handles.Eapp_minRange), handles.Eapp_minRange = 0; end;
if ~isfield(handles, 'Eapp_maxRange'), handles.Eapp_maxRange = 1; elseif isempty(handles.Eapp_maxRange), handles.Eapp_maxRange = 1; end;
if ~isfield(handles, 'Eapp_BinSize'), handles.Eapp_BinSize = 0.02; elseif isempty(handles.Eapp_BinSize), handles.Eapp_BinSize = 0.02; end;
set(Eapp_minRange_Edit, 'String', num2str(handles.Eapp_minRange));
set(Eapp_maxRange_Edit, 'String', num2str(handles.Eapp_maxRange));
set(Eapp_BinSize_Edit, 'String', num2str(handles.Eapp_BinSize));
if ~isfield(handles, 'Conc_minRange'), handles.Conc_minRange = 0; elseif isempty(handles.Conc_minRange), handles.Conc_minRange = 0; end;
if ~isfield(handles, 'Conc_maxRange'), handles.Conc_maxRange = 300; elseif isempty(handles.Conc_maxRange), handles.Conc_maxRange = 300; end;
if ~isfield(handles, 'Conc_BinSize'), handles.Conc_BinSize = 10; elseif isempty(handles.Conc_BinSize), handles.Conc_BinSize = 10; end;
set(Conc_minRange_Edit, 'String', num2str(handles.Conc_minRange));
set(Conc_maxRange_Edit, 'String', num2str(handles.Conc_maxRange));
set(Conc_BinSize_Edit, 'String', num2str(handles.Conc_BinSize));
set(Pixel_Size_Edit, 'String', num2str(handles.Pixel_Size));
set(Pr_MultFact_Edit, 'String', num2str(handles.Pr_MultFact));
if ~isfield(handles, 'Accum_Data'), handles.Accum_Data = 1; elseif isempty(handles.Accum_Data), handles.Accum_Data = 1; end;
set(Accum_Data_cBox, 'Value', handles.Accum_Data);
end

%------------------------- Callbacks for the General Setting Tab widgets --------------------------
% Callback function for the "Eapp range minimum" Field. this callback saves values into handles.
function Eapp_minRange_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Eapp_minRange = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "Eapp range minimum" Field. this callback saves values into handles.
function Eapp_maxRange_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Eapp_maxRange = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "Eapp range minimum" Field. this callback saves values into handles.
function Eapp_BinSize_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Eapp_BinSize = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "Concentration range minimum" Field. this callback saves values into handles.
function Conc_minRange_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Conc_minRange = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "Concentraion range minimum" Field. this callback saves values into handles.
function Conc_maxRange_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Conc_maxRange = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "Concentration range minimum" Field. this callback saves values into handles.
function Conc_BinSize_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Conc_BinSize = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "Concentration range minimum" Field. this callback saves values into handles.
function Pixel_Size_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Pixel_Size = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "Concentration range minimum" Field. this callback saves values into handles.
function Pr_MultFact_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Pr_MultFact = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "Accumulating Data check box" popup menu. this callback saves values into handles.
function Accum_Data_cBox_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Accum_Data = get(hObject, 'Value');

guidata(Main_Figure, handles);
end
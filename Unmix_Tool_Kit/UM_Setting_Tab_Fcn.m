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
function handles = UM_Setting_Tab_Fcn(handles)

UM_Setting_Tab = handles.UM_Setting_Tab;

Unmix_Method_Menu = {'Analytic', 'Iterative'};
Unmix_Method_Text = uicontrol('Parent', UM_Setting_Tab, 'Style', 'text', 'String', 'Unmixing Method', ...
                                   'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 295 130 25], 'FontSize', 10);
Unmix_Method_popMenu = uicontrol('Parent', UM_Setting_Tab, 'Style', 'popupmenu', 'String', Unmix_Method_Menu, ...
                                      'Units', 'Pixels', 'Position', [150 295 260 25], 'FontSize', 10, 'Tag', 'Unmix_Method_popMenu', ...
                                      'Callback', {@Unmix_Method_popMenu_Callback, handles.output});

Syst_Correct_Text = uicontrol('Parent', UM_Setting_Tab, 'Style', 'text', 'String', 'Systematics', ...
                              'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 255 115 25], 'FontSize', 10);
Syst_Correct_Edit = uicontrol('Parent', UM_Setting_Tab, 'Style', 'edit', 'Tag', 'Syst_Correct_Edit', ...
                              'Units', 'Pixels', 'Position', [150 255 350 25], 'FontSize', 10, ...
                              'Callback', {@Syst_Correct_Edit_Callback, handles.output});
Syst_Correct_pButton = uicontrol('Parent', UM_Setting_Tab, 'Style', 'push', 'String', '...', 'Tag', 'Syst_Correct_pButton', ...
                                 'Units', 'Pixels', 'Position', [510 255 25 25], 'FontSize', 10, ...
                                 'Callback', {@Syst_Correct_pButton_Callback, handles.output});
Use_Fitted_Spect_cBox = uicontrol('Parent', UM_Setting_Tab, 'Style', 'checkbox', 'Tag', 'Use_Fitted_Spect_cBox', ...
                                  'Units', 'Pixels', 'Position', [5 215 260 25], 'FontSize', 10, 'String', 'Use Fitted Spectra', ...
                                  'Callback', {@Use_Fitted_Spect_cBox_Callback, handles.output});
                         
if ~isfield(handles, 'Unmix_Method'), handles.Unmix_Method = 'Analytic'; elseif isempty(handles.Unmix_Method), handles.Unmix_Method = 'Analytic'; end;
if ~isfield(handles, 'Syst_Correct'), handles.Syst_Correct = ''; elseif isempty(handles.Syst_Correct), handles.Syst_Correct = ''; end;
if ~isfield(handles, 'Use_Fitted_Spect'), handles.Use_Fitted_Spect = 0; elseif isempty(handles.Use_Fitted_Spect), handles.Use_Fitted_Spect = 0; end;
Unmix_Method_Index = find(~cellfun(@isempty, strfind(Unmix_Method_Menu, handles.Unmix_Method)));
set(Unmix_Method_popMenu, 'Value', Unmix_Method_Index);
set(Syst_Correct_Edit, 'String', handles.Syst_Correct);
set(Use_Fitted_Spect_cBox, 'Value', handles.Use_Fitted_Spect);
end

%------------------------- Callbacks for the General Setting Tab widgets --------------------------
% Callback function for the "fluctuation fitting method" popup menu. this callback saves values into handles.
function Unmix_Method_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
content = get(hObject, 'String');
handles.Unmix_Method = content{get(hObject, 'Value')};
handles.Unmix_Method_Index = get(hObject, 'Value');

guidata(Main_Figure, handles);
end

% Callback function for the "Getting Systematics File" Field. this callback saves values into handles.
function Syst_Correct_Edit_Callback (hObject, eventdata, Main_Figure)
handles              = guidata(Main_Figure);
handles.Syst_Correct = get(hObject, 'String');

guidata(Main_Figure, handles);
end

% Callback function for the "Getting Systematics File" Push button. this callback saves values into handles.
function Syst_Correct_pButton_Callback (hObject, eventdata, Main_Figure)
handles              = guidata(Main_Figure);

[Name, Path]         = uigetfile(handles.Ana_Path, 'Select Analysis Path');
Syst_Correct_Edit    = findobj('Tag', 'Syst_Correct_Edit');
handles.Syst_Correct = [Path '\' Name];
set(Syst_Correct_Edit, 'String', handles.Syst_Correct);

guidata(Main_Figure, handles);
end

% Callback function for the "checking the unmixing choise using fitted spectra" check box. this callback saves values into handles.
function Use_Fitted_Spect_cBox_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);

handles.Use_Fitted_Spect = get(hObject, 'Value');

guidata(Main_Figure, handles);
end
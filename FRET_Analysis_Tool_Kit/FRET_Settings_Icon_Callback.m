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
function FRET_Settings_Icon_Callback(hObject, eventdata)

handles = guidata(hObject);
% Create a figure with no manu bar and no tool bar. The window title is Auto Fit Settings
Setting_FigureH = figure('Name','FRET Analysis Settings','NumberTitle','off', ...
                         'MenuBar', 'none', 'ToolBar', 'none', 'Units', 'Pixels', ...
                         'Position', [100, 100, 700, 400], 'Tag', 'Setting_FigureH',...
                         'CloseRequestFcn',@Close_Setting_Figure_Callback);
                     
% Create a tab group with 2 tabs one is with the title "Histogram" and the
% other with the title "Load from Excel"
tabgp                       = uitabgroup(Setting_FigureH,'Units', 'Pixels', ...
                                         'Position',[10 10 680 380]);
General_Setting_Tab         = uitab(tabgp,'Title','General');
FRET_Setting_Tab            = uitab(tabgp,'Title','FRET');
handles.General_Setting_Tab = General_Setting_Tab;
handles.FRET_Setting_Tab    = FRET_Setting_Tab;
%-------------------------- Plot Setting Tab --------------------------------------------------------------------------
% Create a field in the "Histogram" tab with the text "Bin Range" that will
% accept min and max values for the bin range. also pre setting the field.
% handles = guidata(handles.output);
handles = FRET_General_Setting_Tab_Fcn(handles); guidata(handles.output, handles);
handles = FRET_Setting_Tab_Fcn(hObject); guidata(handles.output, handles);

% wait until this window is closed
uiwait(Setting_FigureH)

% after window was closed save handles
handles = guidata(handles.output);
guidata(handles.output, handles);

% Close window
close(Setting_FigureH)
end

% Callback function for the closing request of the setting window (when clicking the x button on the top right).
function Close_Setting_Figure_Callback(hObject, eventdata)
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end;
end
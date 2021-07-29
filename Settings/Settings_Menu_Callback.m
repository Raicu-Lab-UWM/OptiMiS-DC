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
function Settings_Menu_Callback(hObject, eventdata, handles)

handles = guidata(hObject);
% Create a figure with no manu bar and no tool bar. The window title is Auto Fit Settings
Setting_FigureH = figure('Name','Settings', 'NumberTitle','off', ...
                         'MenuBar', 'none', 'ToolBar', 'none', 'Units', 'Pixels', ...
                         'Position', [100, 100, 700, 400], 'Tag', 'Setting_FigureH',...
                         'CloseRequestFcn',@Close_Setting_Figure_Callback);
                     
% Create a tab group with 2 tabs one is with the title "Histogram" and the
% other with the title "Load from Excel"
tabgp                       = uitabgroup(Setting_FigureH,'Units', 'Pixels', ...
                                         'Position',[10 10 680 380]);
Settings_General_Tab        = uitab(tabgp,'Title','General');
Settings_UM_Tab             = uitab(tabgp,'Title','unMix');
Settings_TH_Tab             = uitab(tabgp,'Title','Threshold');
Settings_Seg_Tab            = uitab(tabgp,'Title','Segment');
Settings_FICoS_Tab          = uitab(tabgp,'Title','FICoS/FRET');
Settings_Disp_Tab           = uitab(tabgp,'Title','Display');
if ~isfield(handles, 'Setting_Tab_Select'), handles.Setting_Tab_Select = 'General'; elseif isempty(handles.Setting_Tab_Select), handles.Setting_Tab_Select = 'General'; end;
switch handles.Setting_Tab_Select
    case 'General'
        set(tabgp, 'SelectedTab', Settings_General_Tab);
    case 'Unmix'
        set(tabgp, 'SelectedTab', Settings_UM_Tab);
    case 'Threshold'
        set(tabgp, 'SelectedTab', Settings_TH_Tab);
    case 'Segment'
        set(tabgp, 'SelectedTab', Settings_Seg_Tab);
    case 'FICoS/FRET'
        set(tabgp, 'SelectedTab', Settings_FICoS_Tab);
    case 'Disp'
        set(tabgp, 'SelectedTab', Settings_Disp_Tab);
    otherwise
end;
handles.Settings_General_Tab = Settings_General_Tab;
handles.Settings_UM_Tab      = Settings_UM_Tab;
handles.Settings_TH_Tab      = Settings_TH_Tab;
handles.Settings_Seg_Tab     = Settings_Seg_Tab;
handles.Settings_FICoS_Tab   = Settings_FICoS_Tab;
handles.Settings_Disp_Tab    = Settings_Disp_Tab;
%-------------------------- Plot Setting Tab --------------------------------------------------------------------------
% Create a field in the "Histogram" tab with the text "Bin Range" that will
% accept min and max values for the bin range. also pre setting the field.
% handles = guidata(handles.output);
handles = Settings_General_Tab_Fcn(handles);
handles = Settings_UM_Tab_Fcn(handles);
handles = Settings_TH_Tab_Fcn(handles);
handles = Settings_Seg_Tab_Fcn(handles);
handles = Settings_FICoS_Tab_Fcn(handles);
handles = Settings_Disp_Tab_Fcn(handles);
guidata(handles.output, handles);

% wait until this window is closed
uiwait(Setting_FigureH)

% after window was closed save handles
handles = guidata(hObject);
guidata(hObject, handles);

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
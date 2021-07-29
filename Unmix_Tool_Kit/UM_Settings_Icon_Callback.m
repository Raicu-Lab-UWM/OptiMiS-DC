function UM_Settings_Icon_Callback(hObject, eventdata)

handles = guidata(hObject);

% Create a figure with no manu bar and no tool bar. The window title is Auto Fit Settings
Setting_FigureH = figure('Name','UnMix Settings','NumberTitle','off', ...
                         'MenuBar', 'none', 'ToolBar', 'none', 'Units', 'Pixels', ...
                         'Position', [100, 100, 700, 400], 'Tag', 'Setting_FigureH',...
                         'CloseRequestFcn',@Close_Setting_Figure_Callback);
                     
% Create a tab group with 2 tabs one is with the title "Histogram" and the
% other with the title "Load from Excel"
tabgp                       = uitabgroup(Setting_FigureH,'Units', 'Pixels', ...
                                         'Position',[10 10 680 380]);
UM_General_Setting_Tab      = uitab(tabgp,'Title','General');
UM_Setting_Tab              = uitab(tabgp,'Title','Unmix');
TH_Setting_Tab              = uitab(tabgp,'Title','Threshold');
if ~isfield(handles, 'Setting_Tab_Select'), handles.Setting_Tab_Select = 'General'; elseif isempty(handles.Setting_Tab_Select), handles.Setting_Tab_Select = 'General'; end;
switch handles.Setting_Tab_Select
    case 'General'
        set(tabgp, 'SelectedTab', UM_General_Setting_Tab);
    case 'Unmix'
        set(tabgp, 'SelectedTab', UM_Setting_Tab);
    case 'Threshold'
        set(tabgp, 'SelectedTab', TH_Setting_Tab);
    otherwise
end;
handles.General_Setting_Tab = UM_General_Setting_Tab;
handles.UM_Setting_Tab      = UM_Setting_Tab;
handles.TH_Setting_Tab      = TH_Setting_Tab;

handles                     = UM_General_Setting_Tab_Fcn(handles);
handles                     = UM_Setting_Tab_Fcn(handles);
handles                     = TH_Setting_Tab_Fcn(handles);
guidata(handles.output, handles);

% wait until this window is closed
uiwait(Setting_FigureH)

% after window was closed save handles
handles                     = guidata(handles.output);
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
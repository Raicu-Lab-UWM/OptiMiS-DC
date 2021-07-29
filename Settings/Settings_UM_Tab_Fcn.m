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
function handles = Settings_UM_Tab_Fcn(handles)

Settings_UM_Tab        = handles.Settings_UM_Tab;

Unmix_Method_Menu      = {'Analytic', 'Iterative'};
Unmix_Method_Text      = uicontrol('Parent', Settings_UM_Tab, 'Style', 'text', 'String', 'Unmixing Method', ...
                                   'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 295 130 25], 'FontSize', 10);
Unmix_Method_popMenu   = uicontrol('Parent', Settings_UM_Tab, 'Style', 'popupmenu', 'String', Unmix_Method_Menu, ...
                                   'Units', 'Pixels', 'Position', [150 295 260 25], 'FontSize', 10, 'Tag', 'Unmix_Method_popMenu', ...
                                   'Callback', {@Unmix_Method_popMenu_Callback, handles.output});

Syst_Correct_Text      = uicontrol('Parent', Settings_UM_Tab, 'Style', 'text', 'String', 'Systematics', ...
                                   'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 255 115 25], 'FontSize', 10);
Syst_Correct_Edit      = uicontrol('Parent', Settings_UM_Tab, 'Style', 'edit', 'Tag', 'Syst_Correct_Edit', ...
                                   'Units', 'Pixels', 'Position', [150 255 350 25], 'FontSize', 10, ...
                                   'Callback', {@Syst_Correct_Edit_Callback, handles.output});
Syst_Correct_pButton   = uicontrol('Parent', Settings_UM_Tab, 'Style', 'push', 'String', '...', 'Tag', 'Syst_Correct_pButton', ...
                                   'Units', 'Pixels', 'Position', [510 255 25 25], 'FontSize', 10, ...
                                   'Callback', {@Syst_Correct_pButton_Callback, handles.output});
                          
Use_Fitted_Spect_cBox  = uicontrol('Parent', Settings_UM_Tab, 'Style', 'checkbox', 'Tag', 'Use_Fitted_Spect_cBox', ...
                                   'Units', 'Pixels', 'Position', [5 215 260 25], 'FontSize', 10, 'String', 'Use Fitted Spectra', ...
                                   'Callback', {@Use_Fitted_Spect_cBox_Callback, handles.output});
Analyze_Type_bGroup    = uibuttongroup('Parent', Settings_UM_Tab, 'Tag', 'Analyze_Type_bGroup', ...
                                       'Units', 'Pixels', 'Position', [5 150 155 50], ...
                                       'SelectionChangeFcn', {@Analyze_Type_bGroup_Callback, handles.output});
Analyze_wFICoS_rButton = uicontrol('Parent', Analyze_Type_bGroup, 'Style', 'Radio', 'Tag', 'Analyze_wFICoS_rButton', ...
                                   'Units', 'normalized', 'Position', [0.05 0.65 0.95 0.25], 'FontSize', 10, 'String', 'Analyze with FICoS', ...
                                   'Value', 1);
Analyze_wFRET_rButton  = uicontrol('Parent', Analyze_Type_bGroup, 'Style', 'Radio', 'Tag', 'Analyze_wFRET_rButton', ...
                                   'Units', 'normalized', 'Position', [0.05 0.1 0.95 0.25], 'FontSize', 10, 'String', 'Analyze with FRET', ...
                                   'Value', 0);

if ~isfield(handles, 'UM_Params'), handles.UM_Params = struct('Unmix_Method', 'Analytic', 'Syst_Correct', '', 'Use_Fitted_Spect', 0);
elseif isempty(handles.UM_Params), handles.UM_Params = struct('Unmix_Method', 'Analytic', 'Syst_Correct', '', 'Use_Fitted_Spect', 0);
end;
if ~isfield(handles.UM_Params, 'Unmix_Method'), handles.UM_Params.Unmix_Method = 'Analytic';
elseif isempty(handles.UM_Params.Unmix_Method), handles.UM_Params.Unmix_Method = 'Analytic';
end;
if ~isfield(handles.UM_Params, 'Syst_Correct'), handles.UM_Params.Syst_Correct = '';
elseif isempty(handles.UM_Params.Syst_Correct), handles.UM_Params.Syst_Correct = '';
end;
if ~isfield(handles.UM_Params, 'Use_Fitted_Spect'), handles.UM_Params.Use_Fitted_Spect = 0;
elseif isempty(handles.UM_Params.Use_Fitted_Spect), handles.UM_Params.Use_Fitted_Spect = 0;
end;
if ~isfield(handles.UM_Params, 'Analysis_Type'), handles.UM_Params.Analysis_Type = 'FICoS';
elseif isempty(handles.UM_Params.Analysis_Type), handles.UM_Params.Analysis_Type = 'FICoS';
end;

handles.UM_Params.Unmix_Method_Index = find(~cellfun(@isempty, strfind(Unmix_Method_Menu, handles.UM_Params.Unmix_Method)));
set(Unmix_Method_popMenu, 'Value', handles.UM_Params.Unmix_Method_Index);
set(Syst_Correct_Edit, 'String', handles.UM_Params.Syst_Correct);
set(Use_Fitted_Spect_cBox, 'Value', handles.UM_Params.Use_Fitted_Spect);
if strcmp(handles.UM_Params.Analysis_Type,'FICoS')
    set(Analyze_wFICoS_rButton, 'Value', 1);
    set(Analyze_wFRET_rButton, 'Value', 0);
else
    set(Analyze_wFICoS_rButton, 'Value', 0);
    set(Analyze_wFRET_rButton, 'Value', 1);
end

%------------------------- Callbacks for the General Setting Tab widgets --------------------------
% Callback function for the "fluctuation fitting method" popup menu. this callback saves values into handles.
function Unmix_Method_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
content = get(hObject, 'String');
handles.UM_Params.Unmix_Method = content{get(hObject, 'Value')};
handles.UM_Params.Unmix_Method_Index = get(hObject, 'Value');

UM_TK_FigureH = findobj('Tag', 'UM_TK_FigureH');
if ~isempty(UM_TK_FigureH)
    if isvalid(UM_TK_FigureH)
        umHandles                    = guidata(UM_TK_FigureH);
        umHandles.Unmix_Method       = handles.UM_Params.Unmix_Method;
        umHandles.Unmix_Method_Index = handles.UM_Params.Unmix_Method_Index;
        guidata(UM_TK_FigureH, umHandles);
    end
end

guidata(Main_Figure, handles);


% Callback function for the "Getting Systematics File" Field. this callback saves values into handles.
function Syst_Correct_Edit_Callback (hObject, eventdata, Main_Figure)
handles              = guidata(Main_Figure);
handles.UM_Params.Syst_Correct = get(hObject, 'String');

UM_TK_FigureH = findobj('Tag', 'UM_TK_FigureH');
if ~isempty(UM_TK_FigureH)
    if isvalid(UM_TK_FigureH)
        umHandles              = guidata(UM_TK_FigureH);
        umHandles.Syst_Correct = handles.UM_Params.Syst_Correct;
        guidata(UM_TK_FigureH, umHandles);
    end
end

guidata(Main_Figure, handles);


% Callback function for the "Getting Systematics File" Push button. this callback saves values into handles.
function Syst_Correct_pButton_Callback (hObject, eventdata, Main_Figure)
handles              = guidata(Main_Figure);
if ~isfield(handles.General_Params, 'Ana_Path'), handles.General_Parmas.Ana_Path = '.\';
elseif isempty(handles.General_Params.Ana_Path), handles.General_Parmas.Ana_Path = '.\';
end
[Name, handles.General_Params.Ana_Path] = uigetfile(handles.General_Params.Ana_Path, 'Select Analysis Path');
Syst_Correct_Edit    = findobj('Tag', 'Syst_Correct_Edit');
handles.UM_Params.Syst_Correct = [handles.General_Params.Ana_Path '\' Name];
set(Syst_Correct_Edit, 'String', handles.UM_Params.Syst_Correct);

UM_TK_FigureH = findobj('Tag', 'UM_TK_FigureH');
if ~isempty(UM_TK_FigureH)
    if isvalid(UM_TK_FigureH)
        umHandles              = guidata(UM_TK_FigureH);
        umHandles.Syst_Correct = handles.UM_Params.Syst_Correct;
        guidata(UM_TK_FigureH, umHandles);
    end
end

guidata(Main_Figure, handles);


% Callback function for the "checking the unmixing choise using fitted spectra" check box. this callback saves values into handles.
function Use_Fitted_Spect_cBox_Callback (hObject, eventdata, Main_Figure)
handles              = guidata(Main_Figure);

handles.UM_Params.Use_Fitted_Spect = get(hObject, 'Value');

UM_TK_FigureH = findobj('Tag', 'UM_TK_FigureH');
if ~isempty(UM_TK_FigureH)
    if isvalid(UM_TK_FigureH)
        umHandles                  = guidata(UM_TK_FigureH);
        umHandles.Use_Fitted_Spect = handles.UM_Params.Use_Fitted_Spect;
        guidata(UM_TK_FigureH, umHandles);
    end
end

guidata(Main_Figure, handles);


% Callback function for the "checking the unmixing choise using fitted spectra" check box. this callback saves values into handles.
function Analyze_Type_bGroup_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);

Selected_Analysis = hObject.SelectedObject;
if strcmp(Selected_Analysis.String, 'Analyze with FICoS')
    handles.UM_Params.Analysis_Type = 'FICoS';
    handles.Analysis_Type = 'FICoS';
else
    handles.UM_Params.Analysis_Type = 'FRET';
    handles.Analysis_Type = 'FRET';
end

guidata(Main_Figure, handles);

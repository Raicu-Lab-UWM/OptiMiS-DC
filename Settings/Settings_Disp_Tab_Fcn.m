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
function handles = Settings_Disp_Tab_Fcn(handles)

Settings_Disp_Tab = handles.Settings_Disp_Tab;

Min_Range_Text = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'text', 'String', 'min', ...
                           'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [130 317 50 25], 'FontSize', 10);
Max_Range_Text = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'text', 'String', 'max', ...
                           'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [190 317 50 25], 'FontSize', 10);
Bin_Size_Text = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'text', 'String', 'Bin Size', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [250 317 75 25], 'FontSize', 10);

Capp_Range_Text = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'text', 'String', 'Capp',...
                            'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 295 150 25], 'FontSize', 10);
Capp_minRange_Edit = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [120 295 50 25], 'FontSize', 10, ...
                               'Callback', {@Capp_minRange_Edit_Callback, handles.output});
Capp_maxRange_Edit = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [180 295 50 25], 'FontSize', 10, ...
                               'Callback', {@Capp_maxRange_Edit_Callback, handles.output});
Capp_BinSize_Edit = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [240 295 50 25], 'FontSize', 10, ...
                               'Callback', {@Capp_BinSize_Edit_Callback, handles.output});

Conc_Range_Text = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'text', 'String', 'Concentration', ...
                            'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 255 150 25], 'FontSize', 10);
Conc_minRange_Edit = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [120 255 50 25], 'FontSize', 10, ...
                               'Callback', {@Conc_minRange_Edit_Callback, handles.output});
Conc_maxRange_Edit = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'edit', ...
                               'Units', 'Pixels', 'Position', [180 255 50 25], 'FontSize', 10, ...
                               'Callback', {@Conc_maxRange_Edit_Callback, handles.output});
Conc_BinSize_Edit = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'edit', ...
                              'Units', 'Pixels', 'Position', [240 255 50 25], 'FontSize', 10, ...
                              'Callback', {@Conc_BinSize_Edit_Callback, handles.output});
Pixel_Size_Text = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'text', 'String', 'Pixel Size', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [300 273 62 25], 'FontSize', 10);
Pixel_Size_Edit = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'edit', ...
                              'Units', 'Pixels', 'Position', [300 255 50 25], 'FontSize', 10, ...
                              'Callback', {@Pixel_Size_Edit_Callback, handles.output});
Pr_MultFact_Text = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'text', 'String', 'Proto. Mult. Factor', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [370 273 112 25], 'FontSize', 10);
Pr_MultFact_Edit = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'edit', ...
                              'Units', 'Pixels', 'Position', [370 255 50 25], 'FontSize', 10, ...
                              'Callback', {@Pr_MultFact_Edit_Callback, handles.output});

Accum_Data_cBox = uicontrol('Parent', Settings_Disp_Tab, 'Style', 'checkbox', 'String', 'Accumulate Data', ...
                            'Units', 'Pixels', 'Position', [10 205 300 25], 'FontSize', 10, ...
                            'Callback', {@Accum_Data_cBox_Callback, handles.output});

if ~isfield(handles, 'Disp_Params'), handles.Disp_Params = struct('Capp_minRange', 0, 'Capp_maxRange', 1, 'Capp_BinSize', 0.02, ...
                                                                  'Conc_minRange', 0, 'Conc_maxRange', 300, 'Conc_BinSize', 10, 'Accum_Data', 1);
elseif isempty(handles.Disp_Params), handles.Disp_Params = struct('Capp_minRange', 0, 'Capp_maxRange', 1, 'Capp_BinSize', 0.02, ...
                                                                  'Conc_minRange', 0, 'Conc_maxRange', 300, 'Conc_BinSize', 10, 'Accum_Data', 1);
end;
if ~isfield(handles.Disp_Params, 'Capp_minRange'), handles.Disp_Params.Capp_minRange = 0; 
elseif isempty(handles.Disp_Params.Capp_minRange), handles.Disp_Params.Capp_minRange = 0;
end;
if ~isfield(handles.Disp_Params, 'Capp_maxRange'), handles.Disp_Params.Capp_maxRange = 1;
elseif isempty(handles.Disp_Params.Capp_maxRange), handles.Disp_Params.Capp_maxRange = 1;
end;
if ~isfield(handles.Disp_Params, 'Capp_BinSize'), handles.Disp_Params.Capp_BinSize = 0.02;
elseif isempty(handles.Disp_Params.Capp_BinSize), handles.Disp_Params.Capp_BinSize = 0.02;
end;
if ~isfield(handles.Disp_Params, 'Conc_minRange'), handles.Disp_Params.Conc_minRange = 0;
elseif isempty(handles.Disp_Params.Conc_minRange), handles.Disp_Params.Conc_minRange = 0;
end;
if ~isfield(handles.Disp_Params, 'Conc_maxRange'), handles.Disp_Params.Conc_maxRange = 300;
elseif isempty(handles.Disp_Params.Conc_maxRange), handles.Disp_Params.Conc_maxRange = 300;
end;
if ~isfield(handles.Disp_Params, 'Conc_BinSize'), handles.Disp_Params.Conc_BinSize = 10;
elseif isempty(handles.Disp_Params.Conc_BinSize), handles.Disp_Params.Conc_BinSize = 10;
end;
if ~isfield(handles.Disp_Params, 'Pixel_Size'), handles.Disp_Params.Pixel_Size = 1;
elseif isempty(handles.Disp_Params.Pixel_Size), handles.Disp_Params.Pixel_Size = 1;
end;
if ~isfield(handles.Disp_Params, 'Pr_MultFact'), handles.Disp_Params.Pr_MultFact = 1;
elseif isempty(handles.Disp_Params.Pr_MultFact), handles.Disp_Params.Pr_MultFact = 1;
end;
if ~isfield(handles.Disp_Params, 'Accum_Data'), handles.Disp_Params.Accum_Data = 1;
elseif isempty(handles.Disp_Params.Accum_Data), handles.Disp_Params.Accum_Data = 1;
end;

set(Capp_minRange_Edit, 'String', num2str(handles.Disp_Params.Capp_minRange));
set(Capp_maxRange_Edit, 'String', num2str(handles.Disp_Params.Capp_maxRange));
set(Capp_BinSize_Edit, 'String', num2str(handles.Disp_Params.Capp_BinSize));
set(Conc_minRange_Edit, 'String', num2str(handles.Disp_Params.Conc_minRange));
set(Conc_maxRange_Edit, 'String', num2str(handles.Disp_Params.Conc_maxRange));
set(Conc_BinSize_Edit, 'String', num2str(handles.Disp_Params.Conc_BinSize));
set(Pixel_Size_Edit, 'String', num2str(handles.Disp_Params.Pixel_Size));
set(Pr_MultFact_Edit, 'String', num2str(handles.Disp_Params.Pr_MultFact));
set(Accum_Data_cBox, 'Value', handles.Disp_Params.Accum_Data);
end

%------------------------- Callbacks for the General Setting Tab widgets --------------------------
% Callback function for the "Capp range minimum" Field. this callback saves values into handles.
function Capp_minRange_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Disp_Params.Capp_minRange = str2double(get(hObject, 'String'));

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        dspHandles               = guidata(FICoS_Tool_Kit_FigH);
        dspHandles.Capp_minRange = handles.Disp_Params.Capp_minRange;
        guidata(FICoS_Tool_Kit_FigH, dspHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Capp range minimum" Field. this callback saves values into handles.
function Capp_maxRange_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Disp_Params.Capp_maxRange = str2double(get(hObject, 'String'));

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        dspHandles               = guidata(FICoS_Tool_Kit_FigH);
        dspHandles.Capp_maxRange = handles.Disp_Params.Capp_maxRange;
        guidata(FICoS_Tool_Kit_FigH, dspHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Capp range minimum" Field. this callback saves values into handles.
function Capp_BinSize_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Disp_Params.Capp_BinSize = str2double(get(hObject, 'String'));

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        dspHandles              = guidata(FICoS_Tool_Kit_FigH);
        dspHandles.Capp_BinSize = handles.Disp_Params.Capp_BinSize;
        guidata(FICoS_Tool_Kit_FigH, dspHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Concentration range minimum" Field. this callback saves values into handles.
function Conc_minRange_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Disp_Params.Conc_minRange = str2double(get(hObject, 'String'));

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        dspHandles               = guidata(FICoS_Tool_Kit_FigH);
        dspHandles.Conc_minRange = handles.Disp_Params.Conc_minRange;
        guidata(FICoS_Tool_Kit_FigH, dspHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Concentraion range minimum" Field. this callback saves values into handles.
function Conc_maxRange_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Disp_Params.Conc_maxRange = str2double(get(hObject, 'String'));

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        dspHandles               = guidata(FICoS_Tool_Kit_FigH);
        dspHandles.Conc_maxRange = handles.Disp_Params.Conc_maxRange;
        guidata(FICoS_Tool_Kit_FigH, dspHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Concentration range minimum" Field. this callback saves values into handles.
function Conc_BinSize_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Disp_Params.Conc_BinSize = str2double(get(hObject, 'String'));

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        dspHandles              = guidata(FICoS_Tool_Kit_FigH);
        dspHandles.Conc_BinSize = handles.Disp_Params.Conc_BinSize;
        guidata(FICoS_Tool_Kit_FigH, dspHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Concentration range minimum" Field. this callback saves values into handles.
function Pixel_Size_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Disp_Params.Pixel_Size = str2double(get(hObject, 'String'));

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        dspHandles             = guidata(FICoS_Tool_Kit_FigH);
        dspHandles.Pixel_Size = handles.Disp_Params.Pixel_Size;
        guidata(FICoS_Tool_Kit_FigH, dspHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Concentration range minimum" Field. this callback saves values into handles.
function Pr_MultFact_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Disp_Params.Pr_MultFact = str2double(get(hObject, 'String'));

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        dspHandles             = guidata(FICoS_Tool_Kit_FigH);
        dspHandles.Pr_MultFact = handles.Disp_Params.Pr_MultFact;
        guidata(FICoS_Tool_Kit_FigH, dspHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Accumulating Data check box" popup menu. this callback saves values into handles.
function Accum_Data_cBox_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.Disp_Params.Accum_Data = get(hObject, 'Value');

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        dspHandles            = guidata(FICoS_Tool_Kit_FigH);
        dspHandles.Accum_Data = handles.Disp_Params.Accum_Data;
        guidata(FICoS_Tool_Kit_FigH, dspHandles);
    end
end

guidata(Main_Figure, handles);
end
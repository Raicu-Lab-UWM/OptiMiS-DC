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
function handles = Settings_FICoS_Tab_Fcn(handles)

Settings_FICoS_Tab = handles.Settings_FICoS_Tab;

% FICoS histogram bin
FICoS_Hist_Bin_Text = uicontrol('Parent', Settings_FICoS_Tab, 'Style', 'text', 'String', 'Histogram Bin', ...
                              'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 300 110 25], 'FontSize', 10);
FICoS_Hist_Bin_Edit = uicontrol('Parent', Settings_FICoS_Tab, 'Style', 'edit', ...
                                 'Units', 'Pixels', 'Position', [160 300 50 25], 'FontSize', 10, ...
                                 'Callback', {@FICoS_Hist_Bin_Edit_Callback, handles.output});

% FICoS meta histogram bin
FICoS_MetaHist_Bin_Text = uicontrol('Parent', Settings_FICoS_Tab, 'Style', 'text', 'String', 'Meta-Histogram Bin', ...
                              'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [240 300 150 25], 'FontSize', 10);
FICoS_MetaHist_Bin_Edit = uicontrol('Parent', Settings_FICoS_Tab, 'Style', 'edit', ...
                                 'Units', 'Pixels', 'Position', [400 300 50 25], 'FontSize', 10, ...
                                 'Callback', {@FICoS_MetaHist_Bin_Edit_Callback, handles.output});

% Number of Gaussians to fit intensity histogram
FICoS_nGaussians_Text = uicontrol('Parent', Settings_FICoS_Tab, 'Style', 'text', 'String', '# Gaussians/Peaks', ...
                           'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 260 142 25], 'FontSize', 10);
FICoS_nGaussians_Edit = uicontrol('Parent', Settings_FICoS_Tab, 'Style', 'edit', ...
                                 'Units', 'Pixels', 'Position', [160 260 50 25], 'FontSize', 10, ...
                                 'Callback', {@FICoS_nGaussians_Edit_Callback, handles.output});

% Method of fitting Popup Menu
FICoS_Fit_Method_Menu = {'Gaussian (Iterative)', 'Gaussian (Analytic)', 'Poisson (Analytic)'};
FICoS_Fit_Method_Text = uicontrol('Parent', Settings_FICoS_Tab, 'Style', 'text', 'String', 'Fitting Method', ...
                                   'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 220 105 25], 'FontSize', 10);
FICoS_Fit_Method_popMenu = uicontrol('Parent', Settings_FICoS_Tab, 'Style', 'popupmenu', 'String', FICoS_Fit_Method_Menu, ...
                                      'Units', 'Pixels', 'Position', [160 220 180 25], 'FontSize', 10, ...
                                      'Callback', {@FICoS_Fit_Method_popMenu_Callback, handles.output});

% Capp Fitting Range
FICoS_Fit_Range_Text = uicontrol('Parent', Settings_FICoS_Tab, 'Style', 'text', 'String', 'Fitting Range', ...
                           'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 180 100 25], 'FontSize', 10);
FICoS_Fit_Range_Edit = uicontrol('Parent', Settings_FICoS_Tab, 'Style', 'edit', ...
                                 'Units', 'Pixels', 'Position', [160 180 100 25], 'FontSize', 10, ...
                                 'Callback', {@FICoS_Fit_Range_Edit_Callback, handles.output});

% FICoS calculation method Popup Menu
FICoS_Method_Menu = {'Select peak wTH','Peak Pecking', 'Gaussian Fitting', 'Mode'}; % added by Dammar Peak Pecking TH
FICoS_Method_Text = uicontrol('Parent', Settings_FICoS_Tab, 'Style', 'text', 'String', 'Method', ...
                                   'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 140 60 25], 'FontSize', 10);
FICoS_Method_popMenu = uicontrol('Parent', Settings_FICoS_Tab, 'Style', 'popupmenu', 'String', FICoS_Method_Menu, ...
                                      'Units', 'Pixels', 'Position', [160 140 180 25], 'FontSize', 10, ...
                                      'Callback', {@FICoS_Method_popMenu_Callback, handles.output});

% TEW FICoS Analysis Parameters
TEW_FICoS_Analysis_Parameters_Text = uicontrol('Parent', Settings_FICoS_Tab, 'Style', 'text', 'String', '2D FICoS Spectrometry Parameters', ...
                              'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 90 261 25], 'FontSize', 10);

SEW_Capp_cBox = uicontrol('Parent', Settings_FICoS_Tab, 'Style', 'checkbox', 'String', 'Use Single Excitation Capp Calc.', ...
                            'Units', 'Pixels', 'Position', [10 60 300 25], 'FontSize', 10, ...
                            'Callback', {@SEW_Capp_cBox_Callback, handles.output});

if ~isfield(handles, 'FICoS_Params'), handles.FICoS_Params = struct('FICoS_Hist_Bin', 0.001, 'FICoS_MetaHist_Bin', 0.02, 'FICoS_nGaussians', 1, ...
                                                                  'FICoS_Fit_Method', 'Gaussian (Iterative)', 'FICoS_Fit_Range', [0 1], ...
                                                                  'FICoS_Method', 'Peak Pecking', 'SEW_Capp', 1);
elseif isempty(handles.FICoS_Params), handles.FICoS_Params = struct('FICoS_Hist_Bin', 0.001, 'FICoS_MetaHist_Bin', 0.02, 'FICoS_nGaussians', 1, ...
                                                                  'FICoS_Fit_Method', 'Gaussian (Iterative)', 'FICoS_Fit_Range', [0 1], ...
                                                                  'FICoS_Method', 'Peak Pecking', 'SEW_Capp', 1);
end;
if ~isfield(handles.FICoS_Params, 'FICoS_Hist_Bin'), handles.FICoS_Params.FICoS_Hist_Bin = 0.001; 
elseif isempty(handles.FICoS_Params.FICoS_Hist_Bin), handles.FICoS_Params.FICoS_Hist_Bin = 0.001;
end;
if ~isfield(handles.FICoS_Params, 'FICoS_MetaHist_Bin'), handles.FICoS_Params.FICoS_MetaHist_Bin = 0.01;
elseif isempty(handles.FICoS_Params.FICoS_MetaHist_Bin), handles.FICoS_Params.FICoS_MetaHist_Bin = 0.01;
end;
if ~isfield(handles.FICoS_Params, 'FICoS_nGaussians'), handles.FICoS_Params.FICoS_nGaussians = 1;
elseif isempty(handles.FICoS_Params.FICoS_nGaussians), handles.FICoS_Params.FICoS_nGaussians = 1;
end;
if ~isfield(handles.FICoS_Params, 'FICoS_Fit_Method'), handles.FICoS_Params.FICoS_Fit_Method = 'Gaussian (Iterative)';
elseif isempty(handles.FICoS_Params.FICoS_Fit_Method), handles.FICoS_Params.FICoS_Fit_Method = 'Gaussian (Iterative)';
end;
if ~isfield(handles.FICoS_Params, 'FICoS_Fit_Range'), 
    if strcmp(handles.UM_Params.Analysis_Type, 'FRET'), handles.FICoS_Params.FICoS_Fit_Range = [0 1]; else handles.FICoS_Params.FICoS_Fit_Range = [-1 1]; end
elseif isempty(handles.FICoS_Params.FICoS_Fit_Range), 
    if strcmp(handles.UM_Params.Analysis_Type, 'FRET'), handles.FICoS_Params.FICoS_Fit_Range = [0 1]; else handles.FICoS_Params.FICoS_Fit_Range = [-1 1]; end
end;
if ~isfield(handles.FICoS_Params, 'FICoS_Method'), handles.FICoS_Params.FICoS_Method = 'Peak Pecking';
elseif isempty(handles.FICoS_Params.FICoS_Method), handles.FICoS_Params.FICoS_Method = 'Peak Pecking';
end;
if ~isfield(handles.FICoS_Params, 'SEW_Capp'), handles.FICoS_Params.SEW_Capp = 1;
elseif isempty(handles.FICoS_Params.SEW_Capp), handles.FICoS_Params.SEW_Capp = 1;
end;

set(FICoS_Hist_Bin_Edit, 'String', num2str(handles.FICoS_Params.FICoS_Hist_Bin));
set(FICoS_MetaHist_Bin_Edit, 'String', num2str(handles.FICoS_Params.FICoS_MetaHist_Bin));
set(FICoS_nGaussians_Edit, 'String', num2str(handles.FICoS_Params.FICoS_nGaussians));
handles.FICoS_Params.FICoS_Fit_Method_Index = find(~cellfun(@isempty, strfind(FICoS_Fit_Method_Menu, handles.FICoS_Params.FICoS_Fit_Method)));
set(FICoS_Fit_Method_popMenu, 'Value', handles.FICoS_Params.FICoS_Fit_Method_Index);
set(FICoS_Fit_Range_Edit, 'String', num2str(handles.FICoS_Params.FICoS_Fit_Range));
handles.FICoS_Params.FICoS_Method_Index = find(~cellfun(@isempty, strfind(FICoS_Method_Menu, handles.FICoS_Params.FICoS_Method)));
set(FICoS_Method_popMenu, 'Value', handles.FICoS_Params.FICoS_Method_Index);
set(SEW_Capp_cBox, 'Value', handles.FICoS_Params.SEW_Capp);
end

%------------------------- Callbacks for the Plot Setting Tab widgets --------------------------
% Callback function for the "Capp histogram bin" Field. this callback saves values into handles.
function FICoS_Hist_Bin_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.FICoS_Params.FICoS_Hist_Bin = str2double(get(hObject, 'String'));

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        fretHandles               = guidata(FICoS_Tool_Kit_FigH);
        fretHandles.FICoS_Hist_Bin = handles.FICoS_Params.FICoS_Hist_Bin;
        guidata(FICoS_Tool_Kit_FigH, fretHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Capp Meta-histogram bin" Field. this callback saves values into handles.
function FICoS_MetaHist_Bin_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.FICoS_Params.FICoS_MetaHist_Bin = str2double(get(hObject, 'String'));

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        fretHandles                   = guidata(FICoS_Tool_Kit_FigH);
        fretHandles.FICoS_MetaHist_Bin = handles.FICoS_Params.FICoS_MetaHist_Bin;
        guidata(FICoS_Tool_Kit_FigH, fretHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "number of gaussians for the fitting calculations" Field. this callback saves values into handles.
function FICoS_nGaussians_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.FICoS_Params.FICoS_nGaussians = str2double(get(hObject, 'String'));

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        fretHandles                 = guidata(FICoS_Tool_Kit_FigH);
        fretHandles.FICoS_nGaussians = handles.FICoS_Params.FICoS_nGaussians;
        guidata(FICoS_Tool_Kit_FigH, fretHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "FICoS fitting method" popup menu. this callback saves values into handles.
function FICoS_Fit_Method_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
content = get(hObject, 'String');
handles.FICoS_Params.FICoS_Fit_Method = content{get(hObject, 'Value')};
handles.FICoS_Params.FICoS_Fit_Method_Index = get(hObject, 'Value');

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        fretHandles                       = guidata(FICoS_Tool_Kit_FigH);
        fretHandles.FICoS_Fit_Method       = handles.FICoS_Params.FICoS_Fit_Method;
        fretHandles.FICoS_Fit_Method_Index = handles.FICoS_Params.FICoS_Fit_Method_Index;
        guidata(FICoS_Tool_Kit_FigH, fretHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Histogram range for fitting" Field. this callback saves values into handles.
function FICoS_Fit_Range_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.FICoS_Params.FICoS_Fit_Range = str2num(get(hObject, 'String'));

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        fretHandles                   = guidata(FICoS_Tool_Kit_FigH);
        fretHandles.FICoS_Fit_Range    = handles.FICoS_Params.FICoS_Fit_Range;
        guidata(FICoS_Tool_Kit_FigH, fretHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "FICoS calculation method" popup menu. this callback saves values into handles.
function FICoS_Method_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
content = get(hObject, 'String');
handles.FICoS_Params.FICoS_Method = content{get(hObject, 'Value')};
handles.FICoS_Params.FICoS_Method_Index = get(hObject, 'Value');

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        fretHandles                   = guidata(FICoS_Tool_Kit_FigH);
        fretHandles.FICoS_Method       = handles.FICoS_Params.FICoS_Method;
        fretHandles.FICoS_Method_Index = handles.FICoS_Params.FICoS_Method_Index;
        guidata(FICoS_Tool_Kit_FigH, fretHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Single Excitation Wavelength Capp Calc. Select" popup menu. this callback saves values into handles.
function SEW_Capp_cBox_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.FICoS_Params.SEW_Capp = get(hObject, 'Value');

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        fretHandles            = guidata(FICoS_Tool_Kit_FigH);
        fretHandles.SEW_Capp   = handles.FICoS_Params.SEW_Capp;
        guidata(FICoS_Tool_Kit_FigH, fretHandles);
    end
end

guidata(Main_Figure, handles);
end
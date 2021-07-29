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
function handles = FRET_Setting_Tab_Fcn(FRET_FigureH)

handles          = guidata(FRET_FigureH);

FRET_Setting_Tab = handles.FRET_Setting_Tab;

% FRET histogram bin
FRET_Hist_Bin_Text = uicontrol('Parent', FRET_Setting_Tab, 'Style', 'text', 'String', 'Histogram Bin', ...
                              'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 300 110 25], 'FontSize', 10);
FRET_Hist_Bin_Edit = uicontrol('Parent', FRET_Setting_Tab, 'Style', 'edit', ...
                                 'Units', 'Pixels', 'Position', [160 300 50 25], 'FontSize', 10, ...
                                 'Callback', {@FRET_Hist_Bin_Edit_Callback, handles.output});

% FRET meta histogram bin
FRET_MetaHist_Bin_Text = uicontrol('Parent', FRET_Setting_Tab, 'Style', 'text', 'String', 'Meta-Histogram Bin', ...
                              'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [240 300 150 25], 'FontSize', 10);
FRET_MetaHist_Bin_Edit = uicontrol('Parent', FRET_Setting_Tab, 'Style', 'edit', ...
                                 'Units', 'Pixels', 'Position', [400 300 50 25], 'FontSize', 10, ...
                                 'Callback', {@FRET_MetaHist_Bin_Edit_Callback, handles.output});

% Number of Gaussians to fit intensity histogram
FRET_nGaussians_Text = uicontrol('Parent', FRET_Setting_Tab, 'Style', 'text', 'String', '# Gaussians/Peaks', ...
                           'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 260 142 25], 'FontSize', 10);
FRET_nGaussians_Edit = uicontrol('Parent', FRET_Setting_Tab, 'Style', 'edit', ...
                                 'Units', 'Pixels', 'Position', [160 260 50 25], 'FontSize', 10, ...
                                 'Callback', {@FRET_nGaussians_Edit_Callback, handles.output});

% Method of fitting Popup Menu
FRET_Fit_Method_Menu = {'Gaussian (Iterative)', 'Gaussian (Analytic)', 'Poisson (Analytic)'};
FRET_Fit_Method_Text = uicontrol('Parent', FRET_Setting_Tab, 'Style', 'text', 'String', 'Fitting Method', ...
                                   'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 220 105 25], 'FontSize', 10);
FRET_Fit_Method_popMenu = uicontrol('Parent', FRET_Setting_Tab, 'Style', 'popupmenu', 'String', FRET_Fit_Method_Menu, ...
                                      'Units', 'Pixels', 'Position', [160 220 180 25], 'FontSize', 10, ...
                                      'Callback', {@FRET_Fit_Method_popMenu_Callback, handles.output});

% Eapp Fitting Range
FRET_Fit_Range_Text = uicontrol('Parent', FRET_Setting_Tab, 'Style', 'text', 'String', 'Fitting Range', ...
                           'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 180 100 25], 'FontSize', 10);
FRET_Fit_Range_Edit = uicontrol('Parent', FRET_Setting_Tab, 'Style', 'edit', ...
                                 'Units', 'Pixels', 'Position', [160 180 100 25], 'FontSize', 10, ...
                                 'Callback', {@FRET_Fit_Range_Edit_Callback, handles.output});

% FRET calculation method Popup Menu
FRET_Method_Menu = {'Peak Pecking', 'Gaussian Fitting', 'Mode'};
FRET_Method_Text = uicontrol('Parent', FRET_Setting_Tab, 'Style', 'text', 'String', 'Method', ...
                                   'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 140 60 25], 'FontSize', 10);
FRET_Method_popMenu = uicontrol('Parent', FRET_Setting_Tab, 'Style', 'popupmenu', 'String', FRET_Method_Menu, ...
                                      'Units', 'Pixels', 'Position', [160 140 180 25], 'FontSize', 10, ...
                                      'Callback', {@FRET_Method_popMenu_Callback, handles.output});

% TEW FRET Analysis Parameters
TEW_FRET_Analysis_Parameters_Text = uicontrol('Parent', FRET_Setting_Tab, 'Style', 'text', 'String', '2D FRET Spectrometry Parameters', ...
                              'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [10 90 261 25], 'FontSize', 10);

SEW_Eapp_cBox = uicontrol('Parent', FRET_Setting_Tab, 'Style', 'checkbox', 'String', 'Use Single Excitation Eapp Calc.', ...
                            'Units', 'Pixels', 'Position', [10 60 300 25], 'FontSize', 10, ...
                            'Callback', {@SEW_Eapp_cBox_Callback, handles.output});

if ~isfield(handles, 'FRET_Hist_Bin'), handles.FRET_Hist_Bin = 0.001; elseif isempty(handles.FRET_Hist_Bin), handles.FRET_Hist_Bin = 0.001; end;
if ~isfield(handles, 'FRET_MetaHist_Bin'), handles.FRET_MetaHist_Bin = 0.02; elseif isempty(handles.FRET_MetaHist_Bin), handles.FRET_MetaHist_Bin = 0.02; end;
if ~isfield(handles, 'FRET_nGaussians'), handles.FRET_nGaussians = 1; elseif isempty(handles.FRET_nGaussians), handles.FRET_nGaussians = 1; end;
if ~isfield(handles, 'FRET_Fit_Method'), handles.FRET_Fit_Method = 'Gaussian (Iterative)'; elseif isempty(handles.FRET_Fit_Method), handles.FRET_Fit_Method = 'Gaussian (Iterative)'; end;
if length(handles.FOV_List) == 1 && isempty(handles.FOV_List.Name), FRET_Calculated = 0; elseif isempty(handles.FOV_List), FRET_Calculated = 0; else FRET_Calculated = 1; end;
if FRET_Calculated
    Image_ = [handles.FOV_List.raw_Data];
    if ~isfield(handles, 'FRET_Fit_Range'), handles.FRET_Fit_Range = [min(Image_(:)) max(Image_(:))]; elseif isempty(handles.FRET_Fit_Range), handles.FRET_Fit_Range = [min(Image_(:)) max(Image_(:))]; end;    
else
    handles.FRET_Fit_Range = [0, 1];
end;
if ~isfield(handles, 'FRET_Method'), handles.FRET_Method = 'Peak Pecking'; elseif isempty(handles.FRET_Method), handles.FRET_Method = 'Peak Pecking'; end;
if ~isfield(handles, 'SEW_Eapp'), handles.SEW_Eapp = 1; elseif isempty(handles.SEW_Eapp), handles.SEW_Eapp = 1; end;

set(FRET_Hist_Bin_Edit, 'String', num2str(handles.FRET_Hist_Bin));
set(FRET_MetaHist_Bin_Edit, 'String', num2str(handles.FRET_MetaHist_Bin));
set(FRET_nGaussians_Edit, 'String', num2str(handles.FRET_nGaussians));
FRET_Fit_Method_Index = find(~cellfun(@isempty, strfind(FRET_Fit_Method_Menu, handles.FRET_Fit_Method)));
set(FRET_Fit_Method_popMenu, 'Value', FRET_Fit_Method_Index);
set(FRET_Fit_Range_Edit, 'String', num2str(handles.FRET_Fit_Range));
FRET_Method_Index = find(~cellfun(@isempty, strfind(FRET_Method_Menu, handles.FRET_Method)));
set(FRET_Method_popMenu, 'Value', FRET_Method_Index);
set(SEW_Eapp_cBox, 'Value', handles.SEW_Eapp);
end

%------------------------- Callbacks for the Plot Setting Tab widgets --------------------------
% Callback function for the "Eapp histogram bin" Field. this callback saves values into handles.
function FRET_Hist_Bin_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.FRET_Hist_Bin = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "Eapp Meta-histogram bin" Field. this callback saves values into handles.
function FRET_MetaHist_Bin_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.FRET_MetaHist_Bin = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "number of gaussians for the fitting calculations" Field. this callback saves values into handles.
function FRET_nGaussians_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.FRET_nGaussians = str2double(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "FRET fitting method" popup menu. this callback saves values into handles.
function FRET_Fit_Method_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
content = get(hObject, 'String');
handles.FRET_Fit_Method = content{get(hObject, 'Value')};

guidata(Main_Figure, handles);
end

% Callback function for the "Histogram range for fitting" Field. this callback saves values into handles.
function FRET_Fit_Range_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.FRET_Fit_Range = str2num(get(hObject, 'String'));

guidata(Main_Figure, handles);
end

% Callback function for the "FRET calculation method" popup menu. this callback saves values into handles.
function FRET_Method_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
content = get(hObject, 'String');
handles.FRET_Method = content{get(hObject, 'Value')};

guidata(Main_Figure, handles);
end

% Callback function for the "Single Excitation Wavelength Eapp Calc. Select" popup menu. this callback saves values into handles.
function SEW_Eapp_cBox_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
handles.SEW_Eapp = get(hObject, 'Value');

guidata(Main_Figure, handles);
end
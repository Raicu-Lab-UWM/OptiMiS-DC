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
function FICoS_Calc_pButton_Callback(hObject, eventdata)

handles = guidata(hObject);

if ~isfield(handles, 'pcFigureH'), 
    msgbox('Open ROI Manager', 'Error');
    return
elseif isempty(handles.pcFigureH)
    msgbox('Open ROI Manager', 'Error');
    return
elseif ~isvalid(handles.pcFigureH)
    handles.pcFigureH = [];
    guidata(hObject, handles)
    msgbox('Open ROI Manager', 'Error');
    return
end

FICoS_Tool_Kit_FigH   = figure('units','pixels', 'Tag', 'FICoS_Tool_Kit_FigH', ...
                               'position',[750 500 250 80],...
                               'menubar','none',...
                               'name','FICoS Tool Kit',...
                               'numbertitle','off');
fcosHandles           = guihandles(FICoS_Tool_Kit_FigH);
fcosHandles.output    = FICoS_Tool_Kit_FigH;
fcosHandles.mwFigureH = hObject;

fcosHandles.FICoS_TK_ToolBar  = uitoolbar(FICoS_Tool_Kit_FigH);

fcosHandles.Load_FICoS_Data_Icon = uipushtool(fcosHandles.FICoS_TK_ToolBar,'TooltipString','Load FICoS Data', ...
                                         'ClickedCallback', {@Load_FICoS_Data_Icon_Callback});
[cdata,~]               = imread('.\Icons\open_icon.png');
fcosHandles.Load_FICoS_Data_Icon.CData = cdata;

fcosHandles.Save_FICoS_Data_Icon = uipushtool(fcosHandles.FICoS_TK_ToolBar,'TooltipString','Save FICoS Data', ...
                                         'ClickedCallback', {@Save_FICoS_Data_Icon_Callback});
[cdata,~]               = imread('.\Icons\file_save.png');
fcosHandles.Save_FICoS_Data_Icon.CData = cdata;

fcosHandles.FICoS_InfoCalc_Icon = uipushtool(fcosHandles.FICoS_TK_ToolBar,'TooltipString','Calculate FICoS/FRET Information', ...
                                         'ClickedCallback', {@FICoS_FRET_InfoCalc_Icon_Callback});
[cdata,~]               = imread('.\Icons\FICoS_InfoCalc_16x16.png');
fcosHandles.FICoS_InfoCalc_Icon.CData = cdata;

fcosHandles.Hist_Check_Icon = uipushtool(fcosHandles.FICoS_TK_ToolBar,'TooltipString','Histogram Viewer', ...
                                     'ClickedCallback', {@Hist_Check_Icon_Callback});
[cdata,~]                = imread('.\Icons\Histogram_16_Icon.png');
fcosHandles.Hist_Check_Icon.CData = cdata;

fcosHandles.FICoS_Settings_Icon = uipushtool(fcosHandles.FICoS_TK_ToolBar,'TooltipString','Settings', ...
                                        'ClickedCallback', {@FICoS_Settings_Icon_Callback});
[cdata,~]               = imread('.\Icons\Settings_16.png');
fcosHandles.FICoS_Settings_Icon.CData = cdata;

Button_Height = 50;
Button_length = 50;

[MetaHist_View_Image, ~] = imread('.\Icons\Meta_Hist_Button_50x50.png');
MetaHist_View_pButton = uicontrol('Parent', FICoS_Tool_Kit_FigH, 'Tag', 'MetaHist_View_pButton', ...
                     'Style','pushbutton',...
                     'cdata', MetaHist_View_Image, 'TooltipString', 'Plot Meta-Histogram', ...
                     'Position',[30, 20, Button_length, Button_Height], 'Units','pixels',...
                     'Visible','on',...
                     'FontSize', 10,...
                     'Callback', {@MetaHist_View_pButton_Callback});

[MetaHist_FICoS2D_View_Image, ~] = imread('.\Icons\FICoS_2D_Hist_Plot_50x50.png');
MetaHist_FICoS2D_View_pButton = uicontrol('Parent', FICoS_Tool_Kit_FigH, 'Tag', 'MetaHist_FICoS2D_View_pButton', ...
                     'Style','pushbutton',...
                     'cdata', MetaHist_FICoS2D_View_Image, 'TooltipString', 'Plot 2D FICoS Histogram', ...
                     'Position',[50 + Button_length, 20, Button_length, Button_Height], 'Units','pixels',...
                     'Visible','on',...
                     'FontSize', 10,...
                     'Callback', {@MetaHist_FICoS2D_View_pButton_Callback});

[CappScatter_FICoS2D_View_Image, ~] = imread('.\Icons\Capp_Scatter_50x50.png');
CappScatter_FICoS2D_View_pButton = uicontrol('Parent', FICoS_Tool_Kit_FigH, 'Tag', 'CappScatter_FICoS2D_View_pButton', ...
                     'Style','pushbutton',...
                     'cdata', CappScatter_FICoS2D_View_Image, 'TooltipString', 'Capp Scatter Plot', ...
                     'Position',[70 + 2*Button_length, 20, Button_length, Button_Height], 'Units','pixels',...
                     'Visible','on',...
                     'FontSize', 10,...
                     'Callback', {@CappScatter_FICoS2D_View_pButton_Callback});

% fcosHandles.FICoS_ = FICoS_Analysis_GUIO;
fcosHandles        = FICoS_Initiate(fcosHandles, handles);
pcHandles          = guidata(handles.pcFigureH);
fcosHandles        = FICoS_Initiate(fcosHandles, pcHandles);

guidata(FICoS_Tool_Kit_FigH, fcosHandles);
guidata(hObject, handles);
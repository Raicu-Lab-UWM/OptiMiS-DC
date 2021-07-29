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
function FRET_Tool_Kit_FigH = FRET_Tool_Kit_mWindow(Main_FigureH)

FRET_Tool_Kit_FigH = figure('units','pixels', 'Tag', 'FRET_Tool_Kit_FigH', ...
                            'position',[750 500 250 80],...
                            'menubar','none',...
                            'name','FRET Tool Kit',...
                            'numbertitle','off');
handles        = guihandles(FRET_Tool_Kit_FigH);
handles.output = FRET_Tool_Kit_FigH;
handles.mwFigureH = Main_FigureH;

handles.FRET_TK_ToolBar = uitoolbar(FRET_Tool_Kit_FigH);
handles.Load_FRET_Data_Icon = uipushtool(handles.FRET_TK_ToolBar,'TooltipString','Load FRET Data', ...
                                         'ClickedCallback', {@Load_FRET_Data_Icon_Callback});
[cdata,~]               = imread('.\Icons\open_icon.png');
handles.Load_FRET_Data_Icon.CData = cdata;

handles.Save_FRET_Data_Icon = uipushtool(handles.FRET_TK_ToolBar,'TooltipString','Save FRET Data', ...
                                         'ClickedCallback', {@Save_FRET_Data_Icon_Callback});
[cdata,~]               = imread('.\Icons\file_save.png');
handles.Save_FRET_Data_Icon.CData = cdata;

handles.FRET1E_Calc_Icon = uipushtool(handles.FRET_TK_ToolBar,'TooltipString','Calculate Single Wavelength Excitation FRET Data', ...
                                         'ClickedCallback', {@FRET1E_Calc_Icon_Callback});
[cdata,~]                = imread('.\Icons\1E_16x16_Icon.png');
handles.FRET1E_Calc_Icon.CData = cdata;

handles.FRET2E_Calc_Icon = uipushtool(handles.FRET_TK_ToolBar,'TooltipString','Calculate Two Wavelength Excitation FRET Data', ...
                                         'ClickedCallback', {@FRET2E_Calc_Icon_Callback});
[cdata,~]                = imread('.\Icons\2E_16x16_Icon.png');
handles.FRET2E_Calc_Icon.CData = cdata;

handles.Hist_Check_Icon = uipushtool(handles.FRET_TK_ToolBar,'TooltipString','Histogram Viewer', ...
                                     'ClickedCallback', {@Hist_Check_Icon_Callback});
[cdata,~]                = imread('.\Icons\Histogram_16_Icon.png');
handles.Hist_Check_Icon.CData = cdata;

handles.FRET_Settings_Icon = uipushtool(handles.FRET_TK_ToolBar,'TooltipString','Settings', ...
                                        'ClickedCallback', {@FRET_Settings_Icon_Callback});
[cdata,~]               = imread('.\Icons\Settings_16.png');
handles.FRET_Settings_Icon.CData = cdata;

Button_Height = 50;
Button_length = 50;

[MetaHist_View_Image, ~] = imread('.\Icons\Meta_Hist_Button_50x50.png');
MetaHist_View_pButton = uicontrol('Parent', FRET_Tool_Kit_FigH, 'Tag', 'MetaHist_View_pButton', ...
                     'Style','pushbutton',...
                     'cdata', MetaHist_View_Image, 'TooltipString', 'Plot Meta-Histogram', ...
                     'Position',[30, 20, Button_length, Button_Height], 'Units','pixels',...
                     'Visible','on',...
                     'FontSize', 10,...
                     'Callback', {@MetaHist_View_pButton_Callback});

[MetaHist_FRET2D_View_Image, ~] = imread('.\Icons\FRET_2D_Hist_Plot_50x50.png');
MetaHist_FRET2D_View_pButton = uicontrol('Parent', FRET_Tool_Kit_FigH, 'Tag', 'MetaHist_FRET2D_View_pButton', ...
                     'Style','pushbutton',...
                     'cdata', MetaHist_FRET2D_View_Image, 'TooltipString', 'Plot 2D FRET Histogram', ...
                     'Position',[50 + Button_length, 20, Button_length, Button_Height], 'Units','pixels',...
                     'Visible','on',...
                     'FontSize', 10,...
                     'Callback', {@MetaHist_FRET2D_View_pButton_Callback});

[EappScatter_FRET2D_View_Image, ~] = imread('.\Icons\Eapp_Scatter_50x50.png');
EappScatte_FRET2D_View_pButton = uicontrol('Parent', FRET_Tool_Kit_FigH, 'Tag', 'EappScatter_FRET2D_View_pButton', ...
                     'Style','pushbutton',...
                     'cdata', EappScatter_FRET2D_View_Image, 'TooltipString', 'Eapp Scatter Plot', ...
                     'Position',[70 + 2*Button_length, 20, Button_length, Button_Height], 'Units','pixels',...
                     'Visible','on',...
                     'FontSize', 10,...
                     'Callback', {@EappScatter_FRET2D_View_pButton_Callback});

handles.FRET_        = FRET_Analysis_GUIO;
mwHandles            = guidata(Main_FigureH);
handles              = FRET_Initiate(handles, mwHandles);
if isfield(mwHandles, 'pcFigureH')
    if ~isempty(mwHandles.pcFigureH)
        if isvalid(mwHandles.pcFigureH)
            pcHandles = guidata(mwHandles.pcFigureH);
            handles   = FRET_Initiate(handles, pcHandles);
        else
            mwHandles.pcFigureH = [];
            guidata(Main_FigureH, mwHandles)
            pcHandles = [];
            handles   = FRET_Initiate(handles, pcHandles);
            msgbox('Open Polygon Console', 'Error');
        end
    else
        pcHandles = [];
        handles   = FRET_Initiate(handles, pcHandles);
        msgbox('Open Polygon Console', 'Error');
    end
else
    pcHandles = [];
    handles   = FRET_Initiate(handles, pcHandles);
    msgbox('Open Polygon Console', 'Error');
end;

guidata(FRET_Tool_Kit_FigH, handles); 
end
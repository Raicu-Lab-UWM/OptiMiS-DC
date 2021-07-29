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
function UM_Contrast_Icon_ClickedCallback(hObject, eventdata, Main_FigureH)

handles       = guidata(Main_FigureH);

UM_Image_Disp_FigureH = findobj('Tag', 'UM_Image_Disp_FigureH');

Contrast_On   = get(hObject, 'State');
if strcmp(Contrast_On, 'on')
    Current_Image = handles.Scene_Inst(handles.Scene_Index(handles.iFrame)).currUnmix_Images;
    Donor_Image    = mat2gray(squeeze(Current_Image(1,:,:)));
    Acceptor_Image = mat2gray(squeeze(Current_Image(2,:,:)));
    
    dContrast_sBar = uicontrol('Style', 'Slider', 'Parent', UM_Image_Disp_FigureH, 'Units', 'normalized', 'Position', [0 0.07 0.03 0.93], ...
                              'Value', ceil(max(Donor_Image(:))), 'Min', min([min(Donor_Image(:)), 0]), 'Max', ceil(max(Donor_Image(:))), 'Tag', 'dContrast_sBar', ...
                              'SliderStep', [0.001, 0.1], 'Callback',{@dContrast_sBar_Callback, Main_FigureH});
    aContrast_sBar = uicontrol('Style', 'Slider', 'Parent', UM_Image_Disp_FigureH, 'Units', 'normalized', 'Position', [0.97 0.07 0.03 0.93], ...
                              'Value', ceil(max(Donor_Image(:))), 'Min', min([min(Donor_Image(:)), 0]), 'Max', ceil(max(Donor_Image(:))), 'Tag', 'aContrast_sBar', ...
                              'SliderStep', [0.001, 0.1], 'Callback',{@aContrast_sBar_Callback, Main_FigureH});
else
    dContrast_sBar = findobj('Tag', 'dContrast_sBar'); delete(dContrast_sBar);
    aContrast_sBar = findobj('Tag', 'aContrast_sBar'); delete(aContrast_sBar);
end
end

function dContrast_sBar_Callback(hObject, eventdata, Main_FigureH)
    handles          = guidata(Main_FigureH);
    
    Max_Image_Intens = get(hObject, 'Value');
    Current_Image    = handles.Scene_Inst(handles.Scene_Index(uint16(handles.iFrame))).currUnmix_Images;
    Donor_Image      = mat2gray(squeeze(Current_Image(1,:,:)));
    
    Donor_Image(Donor_Image > Max_Image_Intens) = Max_Image_Intens;
    Donor_ImageH     = findobj('Tag', 'Donor_ImageH');
    set(Donor_ImageH, 'CData', Donor_Image);
end

function aContrast_sBar_Callback(hObject, eventdata, Main_FigureH)
    handles          = guidata(Main_FigureH);
    
    Max_Image_Intens = get(hObject, 'Value');
    Current_Image    = handles.Scene_Inst(handles.Scene_Index(uint16(handles.iFrame))).currUnmix_Images;
    Acceptor_Image   = mat2gray(squeeze(Current_Image(2,:,:)));
    
    Acceptor_Image(Acceptor_Image > Max_Image_Intens) = Max_Image_Intens;
    Acceptor_ImageH     = findobj('Tag', 'Acceptor_ImageH');
    set(Acceptor_ImageH, 'CData', Acceptor_Image);
end
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
function ColorBar_Icon_ClickedCallback(hObject, eventdata, Main_FigH)

handles       = guidata(Main_FigH);
Contrast_On   = get(hObject, 'State');
if strcmp(Contrast_On, 'on')
    Current_Image = handles.FOV_List(handles.Image_Frame_Index).raw_Data;
    Contrast_sBar = uicontrol('Style', 'Slider', 'Parent', handles.ImPoly_figHand, 'Units', 'normalized', 'Position', [0.95 0.08 0.03 0.89], ...
                              'Value', max(Current_Image(:)), 'Min', min(Current_Image(:)), 'Max', max(Current_Image(:)), 'Tag', 'Contrast_sBar', ...
                              'SliderStep', [0.001, 0.1], ...
                              'Callback',{@Contrast_sBar_Callback, Main_FigH});
else
    Contrast_sBar = findall(handles.ImPoly_figHand, 'Tag', 'Contrast_sBar');
    delete(Contrast_sBar);
end
end

function Contrast_sBar_Callback(hObject, eventdata, Main_FigH)
    handles = guidata(Main_FigH);
    Max_Image_Intens = get(hObject, 'Value');
    Contrasted_Image = handles.FOV_List(uint16(handles.Image_Frame_Index)).raw_Data;
    Contrasted_Image(Contrasted_Image > Max_Image_Intens) = Max_Image_Intens;
    set(handles.FOV_hImage, 'CData', Contrasted_Image);
end
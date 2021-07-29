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
function UM_Stack_sBar_Callback(hObject, eventdata, Main_FigureH)

handles         = guidata(Main_FigureH);

handles.iFrame  = uint16(get(hObject, 'Value'));
currScene       = handles.Scene_Inst(handles.Scene_Index(handles.iFrame));
set(hObject, 'Max', length(handles.Scene_Index));
set(hObject, 'SliderStep', [1/(length(handles.Scene_Index)-1), 10/(length(handles.Scene_Index)-1)]);

UM_Image_Disp_FigureH     = findobj('Tag', 'UM_Image_Disp_FigureH');
if isempty(currScene.Name)
    set(UM_Image_Disp_FigureH, 'Name', [num2str(handles.iFrame) '/' num2str(length(handles.Scene_Index))], 'NumberTitle', 'off');
else
    set(UM_Image_Disp_FigureH, 'Name', [num2str(handles.iFrame) '/' num2str(length(handles.Scene_Index)) ' (' currScene.Name ')'], 'NumberTitle', 'off');
end;
Donor_ImageH = findobj('Tag', 'Donor_ImageH');
set(Donor_ImageH, 'CData', squeeze(currScene.currUnmix_Images(1,:,:)));
Acceptor_ImageH = findobj('Tag', 'Acceptor_ImageH');
set(Acceptor_ImageH, 'CData', squeeze(currScene.currUnmix_Images(2,:,:)));

if ~isfield(handles, 'Single_Pixel_UM_On'), handles.Single_Pixel_UM_On = 0; end;
if handles.Single_Pixel_UM_On
    Name = currScene.Name;
    if strcmp(Name(end-3:end),'.dat')
        Last = 999+length(currScene.Wavelength);
        currScene = currScene.Load_Dat_Images(currScene.Path, 1000, Last, handles.Hor_Shift);
    else
        currScene.currImage_Stack = currScene.Load_Tiff_Image(Name, currScene.Path, [], handles.Hor_Shift);
    end
    handles.currImage_Stack  = currScene.currImage_Stack;
else
    handles.currImage_Stack  = [];
end;

guidata(Main_FigureH, handles);
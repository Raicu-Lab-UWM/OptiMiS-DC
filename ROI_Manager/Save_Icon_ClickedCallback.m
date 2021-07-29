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
function Save_Icon_ClickedCallback(hObject, eventdata, Main_FigH)

options.Interpreter = 'tex';
options.Default     = 'Cancel';
Answer = questdlg('\fontsize{12} ROI Information will be lost', 'Warnning', 'Save', 'Cancel', options);
switch Answer
case 'Save'
    handles     = guidata(Main_FigH);
    if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
    else mwHandles = [];
    end
    
    Image_Stack = zeros(size(handles.FOV_List(1).raw_Data, 1), size(handles.FOV_List(1).raw_Data, 2), length(handles.FOV_List));
    for ii = 1:length(handles.FOV_List)
        Image_Stack(:,:,ii) = handles.FOV_List(ii).raw_Data;
        handles.FOV_List(ii).Name = handles.FOV_List(1).Name;
    end;

    if isempty(mwHandles), Path = handles.Ana_Path; else Path = mwHandles.Ana_Path; end
    ImageStack_Name = handles.FOV_List(1).Name;
    Perid_Pos       = strfind(ImageStack_Name(end-4:end),'.');
    if isempty(Perid_Pos)
        Write_Tiff_File (Image_Stack, Path, ImageStack_Name, [], 32);
    else
        Write_Tiff_File (Image_Stack, Path, ImageStack_Name(1:end-6+Perid_Pos), [], 32);
    end
case 'Cancel'
otherwise
end;
                

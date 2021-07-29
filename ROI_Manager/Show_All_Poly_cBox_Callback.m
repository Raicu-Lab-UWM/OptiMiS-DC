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
function Show_All_Poly_cBox_Callback(hObject, eventdata, handles)
handles.Show_All_Poly = get(hObject, 'Value');
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles)
    Polygon_List = handles.Polygon_List;
else
    Polygon_List = mwHandles.Polygon_List;
end
ROI_List_Names = {Polygon_List.Name};
if isfield(mwHandles, 'FIF_Tree')
    if ~isempty(mwHandles.FIF_Tree)
        if ~isfield(mwHandles, 'Image_List'), Image_List = []; else Image_List = mwHandles.Image_List; end
        ROI_List_Names = mwHandles.FIF_Tree.retrieveROI_List(Image_List);
    end
end

nROIs = length(ROI_List_Names);
for ii = 1:nROIs
    [~, iROI] = Polygon_List.findROI('Polygon_Name', ROI_List_Names{ii});
    iFrame    = Polygon_List(iROI).Image_Frame_Index; if iFrame == 0, iFrame = 1; end;
    if iFrame > length(handles.FOV_List), iFrame = length(handles.FOV_List); end;
    if isempty(mwHandles)
        if handles.Show_All_Poly && handles.Image_Frame_Index == iFrame
            set(handles.Polygon_List(iROI).Poly_PlotH, 'Visible', 'on'); set(handles.Polygon_List(iROI).Title_PrintH, 'Visible', 'on');
        else
            set(handles.Polygon_List(iROI).Poly_PlotH, 'Visible', 'off'); set(handles.Polygon_List(iROI).Title_PrintH, 'Visible', 'off');                    
        end;
    else
        if handles.Show_All_Poly && handles.Image_Frame_Index == iFrame
            set(mwHandles.Polygon_List(iROI).Poly_PlotH, 'Visible', 'on'); set(mwHandles.Polygon_List(iROI).Title_PrintH, 'Visible', 'on');
        else
            set(mwHandles.Polygon_List(iROI).Poly_PlotH, 'Visible', 'off'); set(mwHandles.Polygon_List(iROI).Title_PrintH, 'Visible', 'off');                    
        end;
    end
end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(hObject, handles);
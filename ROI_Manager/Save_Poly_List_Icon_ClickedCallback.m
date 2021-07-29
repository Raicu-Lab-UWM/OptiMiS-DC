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
function Save_Poly_List_Icon_ClickedCallback(hObject, eventdata, handles)
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles)
    Path         = handles.curr_Path;
    Polygon_List = handles.Polygon_List;
    Segment_List = handles.Segment_List;
else
    Path         = mwHandles.curr_Path;
    Polygon_List = mwHandles.Polygon_List;
    Segment_List = mwHandles.Segment_List;
end
Path = uigetdir(Path, 'Save Polygon list in ...');
Image_Name        = handles.FOV_List(1).Name;
Name = [Image_Name(1:end-4) '.mroi'];
ROI_List_Names    = get(handles.Polygon_List_ListBox, 'String');
All_Polygon_Names = {Polygon_List.Name};
iPolygons         = cellfun(@(x) strcmp(x, All_Polygon_Names), ROI_List_Names, 'UniformOutput', false);
iPolygons         = cell2mat(cellfun(@(x) find(x), iPolygons, 'UniformOutput', false));
shownPolygon_List = Polygon_List(iPolygons);
shownPolygon_List.Save_Poly_List(Path, Name);

if length(Segment_List) > 1 || length(Segment_List) == 1 && ~isempty(Segment_List(1).Master_Polygon)
    All_Polygon_Names = {Segment_List.Master_Polygon};
    iPolygons         = cellfun(@(x) strcmp(x, All_Polygon_Names), ROI_List_Names, 'UniformOutput', false);
    iPolygons         = cellfun(@(x) find(x), iPolygons, 'UniformOutput', false);
    inotEmpty_Poly    = find(cell2mat(cellfun(@(x) ~isempty(x), iPolygons, 'UniformOutput', false)));
    iPolygons         = cell2mat(iPolygons(inotEmpty_Poly));
    shownSegment_List = Segment_List(iPolygons);
    Name              = [Image_Name(1:end-4) '.mseg'];
    shownSegment_List.Save_Segment_List(Path, Name);
end;
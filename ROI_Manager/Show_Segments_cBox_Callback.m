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
function Show_Segments_cBox_Callback(hObject, eventdata, handles)
handles.Show_Segments = get(hObject, 'Value');
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end
else, mwHandles = [];
end

if ~handles.Show_Segments
    if isfield(handles, 'handSegment'), delete(handles.handSegment); end
else
    if isempty(mwHandles)
        Polygon_Selected = handles.Polygon_List(handles.Current_Polygon_Index(1));
        [Segment_Item, Found_Segment_Index] = handles.Segment_List.Segment_MasterPoly_Query('Master_Polygon', Polygon_Selected.Name);
    else
        Polygon_Selected = mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(1));
        [Segment_Item, Found_Segment_Index] = mwHandles.Segment_List.Segment_MasterPoly_Query('Master_Polygon', Polygon_Selected.Name);
    end
    if ~isempty(Found_Segment_Index)
        currSegment_Obj = Segment_Item;
        Segments_ROIs   = currSegment_Obj.Polygons;
        nSegments_ROIs  = length(Segments_ROIs);
        for ii = 1:nSegments_ROIs
            curPoly = currSegment_Obj.Polygons{ii};
            hold(handles.Image_Stack_Axes ,'on'); handles.handSegment(ii) = plot(handles.Image_Stack_Axes, curPoly(:,1),curPoly(:,2),'r','LineWidth', 1);
            if isempty(mwHandles), handles.currPolygon_Coords{ii} = curPoly; else, mwHandles.currPolygon_Coords{ii} = curPoly; end
        end
    end
end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(hObject, handles);
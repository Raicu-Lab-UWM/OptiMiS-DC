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
function fileID = Save_SegList_toTextFile(Obj, Path, Name, fileID, Seg_Index)

if nargin < 4, fileID = fopen([Path '\' Name], 'a'); elseif isempty(fileID) || fileID == -1, fileID = fopen([Path '\' Name], 'a'); end
if nargin < 5, Seg_Index = 1; elseif isempty(Seg_Index), Seg_Index = 1; end

if strcmp(Obj.Segmentation_Method,'SLIC')
    if strcmp(Obj.Segment_Type,'Area')
        Seg_Param_Val = [num2str(Obj.Segment_Param_Value(1)) 'X' num2str(Obj.Segment_Param_Value(2))];
    else
        Seg_Param_Val = num2str(Obj.Segment_Param_Value(1));
    end
    Seg_Line = 'SEG%d,ROI,%s Method,%s %s,%s nIter,%d IntensWeight,%5.2f PosErr,%5.2f nPixTH,%d\n';
    fprintf(fileID, Seg_Line, Seg_Index, Obj.Master_Polygon, Obj.Segmentation_Method, Obj.Segment_Type, Seg_Param_Val, Obj.nIterations, ...
            Obj.Intensity_Variation_Coeff, Obj.Center_Pos_Diff_Residual_TH, Obj.nPixels_min_TH);
else
    if strcmp(Obj.Segment_Type,'Area')
        Seg_Param_Val = [num2str(Obj.Segment_Param_Value(1)) 'X' num2str(Obj.Segment_Param_Value(2))];
    else
        Seg_Param_Val = num2str(Obj.Segment_Param_Value(1));
    end
    Seg_Line = 'SEG%d,ROI,%s Method,%s %s,%s nPixTH,%d\n';
    fprintf(fileID, Seg_Line, Seg_Index, Obj.Master_Polygon, Obj.Segmentation_Method, Obj.Segment_Type, Seg_Param_Val, Obj.nPixels_min_TH);
end

Coordinate_Title_Line = 'Coordinates%s\n';
fprintf(fileID, Coordinate_Title_Line, '');

Polygon_Table_Title    = 'Vertex';
Coordinate_Table_Value = '%03d';
for ii = 1:length(Obj.Polygons)
    Polygon_Table_Title    = [Polygon_Table_Title ',x-%d,y-%d'];
    Coordinate_Table_Value = [Coordinate_Table_Value ',%03d,%03d'];
    currPolygon            = Obj.Polygons{ii};
    Polys_Cords(2*ii-1:2*ii,1:size(currPolygon,1)) = currPolygon';
end
Polygon_Table_Title    = [Polygon_Table_Title '\n'];
Coordinate_Table_Value = [Coordinate_Table_Value '\n'];
Vertex_Index(1,:)      = [1:size(Polys_Cords,2)];
Vertex_Table           = [Vertex_Index; uint16(Polys_Cords)];
fprintf(fileID, Polygon_Table_Title, [1:length(Obj.Polygons);1:length(Obj.Polygons)]);
fprintf(fileID, Coordinate_Table_Value, Vertex_Table);
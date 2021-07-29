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
function fileID = Save_ROIList_toTextFile(Obj, Path, Name, fileID)

if nargin < 4, fileID = fopen([Path '\' Name], 'a'); elseif isempty(fileID) || fileID == -1, fileID = fopen([Path '\' Name], 'a'); end;
ROI_Line = 'ROI%d,%s x-%5.2f,y-%5.2f %c\n';
fprintf(fileID, ROI_Line, Obj.Index, Obj.Name, Obj.Center_Cords(1), Obj.Center_Cords(2), Obj.Polygon_Type(1));

for ii = 1:length(Obj.Images_Related)
    Image_Related_Line = 'Im%d,%s\n';
    fprintf(fileID, Image_Related_Line, ii, Obj.Images_Related{1});
end;

Image_Drawn_Line = 'ImD,%s\n';
fprintf(fileID, Image_Drawn_Line, Obj.Image_Drawn);

Frame_Index_Line = 'Frame-%d\n';
fprintf(fileID, Frame_Index_Line, Obj.Image_Frame_Index);

Coordinate_Title_Line = 'Coordinates%s\n';
fprintf(fileID, Coordinate_Title_Line, '');

Coordinate_Table_Title = 'Vertex,x,y%s\n';
fprintf(fileID, Coordinate_Table_Title, '');

Vertex_Index(1,:)      = [1:size(Obj.Coordinates,1)];
Vertex_Table           = [Vertex_Index; uint16(Obj.Coordinates')];
Coordinate_Table_Value = '%03d,%03d,%03d\n';
fprintf(fileID, Coordinate_Table_Value, Vertex_Table);
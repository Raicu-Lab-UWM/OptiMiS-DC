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
function Self = Initialte_Segment_Seed(Self, Image, Entity_Polygon)

xPoly_Min  = min(Entity_Polygon(:,1));
xPoly_Max  = max(Entity_Polygon(:,1));
yPoly_Min  = min(Entity_Polygon(:,2));
yPoly_Max  = max(Entity_Polygon(:,2));
Poly_Lenth = xPoly_Max - xPoly_Min;
Poly_Width = yPoly_Max - yPoly_Min;

switch Self.Segment_Type
case 'Number of Segments'
    xnSegments = round(sqrt(Self.Segment_Param_Value*Poly_Lenth/Poly_Width));
    ynSegments = round(sqrt(Self.Segment_Param_Value/Poly_Lenth*Poly_Width));
    Dist_Seg   = [round(Poly_Lenth/xnSegments), round(Poly_Width/ynSegments)];
case 'Area'
    Dist_Seg = Self.Segment_Param_Value;
otherwise
end;

xCord             = round(Dist_Seg(1)/2):Dist_Seg(1):size(Image,2)-round(Dist_Seg(1)/2);
yCord             = round(Dist_Seg(2)/2):Dist_Seg(2):size(Image,1)-round(Dist_Seg(2)/2);
[ycrd_Sements_Cent, xcrd_Sements_Cent] = ndgrid(yCord', xCord);
xcrd_Sements_Cent = reshape(xcrd_Sements_Cent,size(xcrd_Sements_Cent,1)*size(xcrd_Sements_Cent,2),1);
ycrd_Sements_Cent = reshape(ycrd_Sements_Cent,size(ycrd_Sements_Cent,1)*size(ycrd_Sements_Cent,2),1);
ints_Segment_Cent = Image(sub2ind(size(Image), ycrd_Sements_Cent, xcrd_Sements_Cent));
Self.Seed_Centers = [xcrd_Sements_Cent, ycrd_Sements_Cent, ints_Segment_Cent];
Self.Segment_Param_Value  = Dist_Seg;
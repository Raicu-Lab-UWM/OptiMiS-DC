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
function Self = Moving_Square_Segmentation(Self, Image, Entity_Polygon)

if nargin < 3
    [Poly_List, ~]  = bwboundaries(Image, 4);
    Outer_Poly_List = fliplr(Poly_List{1});
    Dist_btwnPoints = round(size(Outer_Poly_List,1)/Self.nPoints_inSegment_Poly);
    Entity_Polygon  = [Outer_Poly_List(1:Dist_btwnPoints:end-1,:); Outer_Poly_List(end,:); Outer_Poly_List(1,:)];
end;

Poly_yMin = ceil(min(Entity_Polygon(:,2)));
Poly_xMin = ceil(min(Entity_Polygon(:,1)));
Poly_yMax = ceil(max(Entity_Polygon(:,2)));
Poly_xMax = ceil(max(Entity_Polygon(:,1)));
nxSquares = ceil((Poly_xMax - Poly_xMin)/Self.Segment_Param_Value(1));
Self.Labeled_Image = zeros(size(Image));

Polygon_Index = 1;
for jj = Poly_yMin:Self.Segment_Param_Value(2):Poly_yMax
    for ii = Poly_xMin:Self.Segment_Param_Value(1):Poly_xMax
        y          = [jj jj (jj + Self.Segment_Param_Value(2) - 1) (jj + Self.Segment_Param_Value(2) - 1) jj];
        x          = [ii (ii + Self.Segment_Param_Value(1) - 1) (ii + Self.Segment_Param_Value(1) - 1) ii ii];
        Sub_Label  = ceil((jj-Poly_yMin)/Self.Segment_Param_Value(2))*nxSquares + ceil((ii-Poly_xMin)/Self.Segment_Param_Value(1)) + 1;
        BW_sub     = poly2mask(x, y, size(Image,1), size(Image,2));
        BW_overlap = Image & BW_sub;

        nPixels    = nnz(BW_overlap);
        if(nPixels > Self.nPixels_min_TH)
            Self.Labeled_Image(BW_overlap == 1) = Sub_Label;
            Self.Polygons{Polygon_Index} = [x',y'];
            Polygon_Index = Polygon_Index + 1;
        end;
    end;
end;
if jj == Poly_yMin && ii == Poly_xMin
    nPixels    = nnz(Image);
    if(nPixels > Self.nPixels_min_TH)
        Self.Labeled_Image(Image == 1) = 1;
    end;
end;
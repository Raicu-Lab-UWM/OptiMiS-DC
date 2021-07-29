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
function Self = Seg_Center_Avoid_Edge(Self, Image, Segment_Center_Index)

Segment_Center         = Self.Seed_Centers(Segment_Center_Index,:);

minX                   = max([Segment_Center(2)-2,0]);
maxX                   = min([Segment_Center(2)+2,size(Image,1)]);
minY                   = max([Segment_Center(1)-2,0]);
maxY                   = min([Segment_Center(1)+2,size(Image,2)]);

Neighbor_Matrix(:,:,2) = Image(minX:maxX, minY:maxY);
Neighbor_Matrix(:,:,1) = circshift(Neighbor_Matrix(:,:,2), [0,-1]);
Neighbor_Matrix(:,:,3) = circshift(Neighbor_Matrix(:,:,2), [0,1]);
xPeak                  = max(Neighbor_Matrix,[],3) - Neighbor_Matrix(:,:,2);
xValey                 = Neighbor_Matrix(:,:,2) - min(Neighbor_Matrix,[],3);
xGrad                  = xPeak + xValey;
    
Neighbor_Matrix(:,:,1) = circshift(Neighbor_Matrix(:,:,2), [-1,0]);
Neighbor_Matrix(:,:,3) = circshift(Neighbor_Matrix(:,:,2), [1,0]);
yPeak                  = max(Neighbor_Matrix,[],3) - Neighbor_Matrix(:,:,2);
yValey                 = Neighbor_Matrix(:,:,2) - min(Neighbor_Matrix,[],3);
yGrad                  = yPeak + yValey;
    
Grad                   = xGrad + yGrad;
Crop_Grad              = Grad(2:4,2:4);
Good_Ind               = find(Crop_Grad==0);
if isempty(Good_Ind), [~, Good_Ind] = min(Crop_Grad); end;
Close_Neighbor         = squeeze(Neighbor_Matrix(2:4,2:4,2));
if length(Good_Ind) > 1;
    Value_Good_Ind = Close_Neighbor(ind2sub(size(Close_Neighbor),Good_Ind));
    Best_Ind       = find(Value_Good_Ind > 0, 1);
    Best_Ind       = Good_Ind(Best_Ind);
    if isempty(Best_Ind)
        xBest_Pos = 2;
        yBest_Pos = 2;
    else
        [xBest_Pos,yBest_Pos] = ind2sub(size(Close_Neighbor),Best_Ind);
    end;
else
    [xBest_Pos,yBest_Pos] = ind2sub(size(Close_Neighbor),Good_Ind);
end;
Segment_Center(1)      = Segment_Center(1) + 2 - xBest_Pos;
Segment_Center(2)      = Segment_Center(2) + 2 - yBest_Pos;
Self.Seed_Centers(Segment_Center_Index,:) = Segment_Center;
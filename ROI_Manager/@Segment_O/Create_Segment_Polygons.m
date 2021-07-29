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
function Self = Create_Segment_Polygons(Self, Mask)

Masked_Labeled_Image = Self.Labeled_Image.*Mask;
Label_Value          = unique(Masked_Labeled_Image(:));
Label_Value(Label_Value == 0) = [];
Min_Label_Value      = min(Label_Value);
Label_Value          = Label_Value - Min_Label_Value + 1;
Masked_Labeled_Image = Masked_Labeled_Image - Min_Label_Value + 1;
Masked_Labeled_Image(Masked_Labeled_Image<0) = 0;
Segment_Image        = zeros(size(Mask));
for ii = 1:length(Label_Value)
    Segment_Image(Masked_Labeled_Image ~= Label_Value(ii)) = 0;
    Segment_Image(Masked_Labeled_Image == Label_Value(ii)) = 1;
    [Poly_List, ~]  = bwboundaries(Segment_Image, 8);
    Segment_Polygon = fliplr(Poly_List{1});
    Dist_btwnPoints = round(size(Segment_Polygon,1)/Self.nPoints_inSegment_Poly);
    sprsSeg_Polygon = [Segment_Polygon(1:Dist_btwnPoints:end-1,:); Segment_Polygon(end,:); Segment_Polygon(1,:)];
    Self.Polygons{ii} = sprsSeg_Polygon;
end;

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
function Self = Curve_Guided_Segmentation(Self, Image, Entity_Polygon)
Split_Method           = Self.Segment_Type;
Split_Value            = Self.Segment_Param_Value;
nPoints_inSegment_Poly = Self.nPoints_inSegment_Poly;

Mask                   = poly2mask(Entity_Polygon(:,1),Entity_Polygon(:,2),size(Image,1),size(Image,2));
[Poly_List, ~]         = bwboundaries(Mask, 8);
Outer_Polygon          = fliplr(Poly_List{1});
if strcmp(Split_Method,'Number of Segments')
    sprsMem_Polygon = Outer_Polygon(1:round(size(Outer_Polygon,1)/Split_Value(1)):end-1,:);
elseif strcmp(Split_Method,'Area')
    Circumf   = sum(sqrt((Outer_Polygon(2:end-1,1)-Outer_Polygon(1:end-2,1)).^2 + (Outer_Polygon(2:end-1,2)-Outer_Polygon(1:end-2,2)).^2));
    if Circumf <= Split_Value(1)
        nElements = 1;
    else
        nElements = round(Circumf/Split_Value(1));
    end;
    sprsMem_Polygon = [Outer_Polygon(1:max([round(size(Outer_Polygon,1)/nElements), 1]):end,:); Outer_Polygon(1,:)];
end;

Mem_Poly_Vect       = reshape(sprsMem_Polygon, size(sprsMem_Polygon,1)*size(sprsMem_Polygon,2), 1);
Out_Poly_Vect       = reshape(Outer_Polygon, size(Outer_Polygon,1)*size(Outer_Polygon,2), 1);
[Mem_Poly,Out_Poly] = ndgrid(Mem_Poly_Vect, Out_Poly_Vect);
Mem_Poly            = reshape(Mem_Poly, size(sprsMem_Polygon,1), size(sprsMem_Polygon,2), size(Out_Poly_Vect,1));
Out_Poly            = reshape(Out_Poly, size(Mem_Poly_Vect,1), size(Outer_Polygon,1), size(Outer_Polygon,2));
Mem_Poly            = Mem_Poly(:,:,1:size(Outer_Polygon,1));
Out_Poly            = Out_Poly(1:size(sprsMem_Polygon,1),:,:);
Out_Poly            = permute(Out_Poly,[1,3,2]);
Distance            = squeeze(sqrt((Out_Poly(:,1,:) - Mem_Poly(:,1,:)).^2 + (Out_Poly(:,2,:) - Mem_Poly(:,2,:)).^2));
[~,minOutDist_Ind]  = min(Distance,[],2);

if length(Poly_List) == 2
    Inner_Polygon       = fliplr(Poly_List{2});
    Mem_Poly_Vect       = reshape(sprsMem_Polygon, size(sprsMem_Polygon,1)*size(sprsMem_Polygon,2), 1);
    In_Poly_Vect        = reshape(Inner_Polygon, size(Inner_Polygon,1)*size(Inner_Polygon,2), 1);
    [Mem_Poly,In_Poly]  = ndgrid(Mem_Poly_Vect, In_Poly_Vect);
    Mem_Poly            = reshape(Mem_Poly, size(sprsMem_Polygon,1), size(sprsMem_Polygon,2), size(In_Poly_Vect,1));
    In_Poly             = reshape(In_Poly, size(Mem_Poly_Vect,1), size(Inner_Polygon,1), size(Inner_Polygon,2));
    Mem_Poly            = Mem_Poly(:,:,1:size(Inner_Polygon,1));
    In_Poly             = In_Poly(1:size(sprsMem_Polygon,1),:,:);
    In_Poly             = permute(In_Poly,[1,3,2]);
    Distance            = squeeze(sqrt((In_Poly(:,1,:) - Mem_Poly(:,1,:)).^2 + (In_Poly(:,2,:) - Mem_Poly(:,2,:)).^2));
    [~,minInDist_Ind]   = min(Distance,[],2);
    for ii = 1:length(minOutDist_Ind)-1
        curr_Segment_Polygon  = [Outer_Polygon(minOutDist_Ind(ii):minOutDist_Ind(ii+1),:);...
                                 flipud(Inner_Polygon(minInDist_Ind(ii):minInDist_Ind(ii+1),:));...
                                 Outer_Polygon(minOutDist_Ind(ii),:)];
        Segments_Polygons{ii} = [curr_Segment_Polygon(1:max([1, round(size(curr_Segment_Polygon,1)/nPoints_inSegment_Poly)]):end-1,:); ...
                                 curr_Segment_Polygon(end,:); curr_Segment_Polygon(1,:)];
        BW_sub                = poly2mask(Segments_Polygons{ii}(:,1), Segments_Polygons{ii}(:,2), size(Image,1), size(Image,2));
        BW_overlap            = Image & BW_sub;
        Self.Labeled_Image(BW_overlap == 1) = ii;
    end;
    curr_Segment_Polygon = [Outer_Polygon(minOutDist_Ind(end-1):end,:);Outer_Polygon(1,:);...
                            Inner_Polygon(1,:);flipud(Inner_Polygon(minInDist_Ind(end-1):end,:));...
                            Outer_Polygon(minOutDist_Ind(end-1),:)];
    Segments_Polygons{length(minOutDist_Ind)} = [curr_Segment_Polygon(1:round(size(curr_Segment_Polygon,1)/nPoints_inSegment_Poly):end-1,:); curr_Segment_Polygon(end,:); curr_Segment_Polygon(1,:)];
    BW_sub               = poly2mask(curr_Segment_Polygon(:,1), curr_Segment_Polygon(:,2), size(Image,1), size(Image,2));
    BW_overlap           = Image & BW_sub;
    Self.Labeled_Image(BW_overlap == 1) = length(minOutDist_Ind);
    Self.Polygons        = Segments_Polygons;
end
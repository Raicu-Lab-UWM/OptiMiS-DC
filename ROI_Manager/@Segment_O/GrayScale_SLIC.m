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
function Self = GrayScale_SLIC(Self, Image, Entity_Polygon)

Image(isnan(Image))     = 0;
if nargin < 3, Entity_Polygon = [1,1;1,size(Image,2);size(Image,1),size(Image,2);size(Image,1),1;1,1]; end;
Iter                    = Self.nIterations;
Self.Labeled_Image      = ones(size(Image))*-1;
Self.Pixel_Distance_Mat = ones(size(Image))*inf;

% Initiate segments seed points
Self           = Self.Initialte_Segment_Seed(Image, Entity_Polygon);

% Move Center away from boundaries
for ii = 1:length(Self.Seed_Centers)
    Self = Self.Seg_Center_Avoid_Edge(Image, ii);
    
    % set distance of image pixels as well as label
    Self = Self.Pixel_Dist_Label_Assign(Image, ii);
end;

% calculate New Segment Center
Residual_ofCenters = ones(size(Self.Seed_Centers,1),1)*inf;
for jj = 1:Iter
    if sqrt(sum(Residual_ofCenters))/length(Residual_ofCenters)/2 < 0.1, break; end;

    Labeled_Image_Prev      = Self.Labeled_Image;
    Segment_Center_Prev     = Self.Seed_Centers;
    Labels_Values           = unique(Labeled_Image_Prev(:));
    if min(Labels_Values) < 0, break; end;
    Self.Pixel_Distance_Mat = ones(size(Image))*inf;
    Self.Labeled_Image      = ones(size(Image))*(-1);
    Seg_Cent                = ones(length(Labels_Values),3);
    for ii = 1:length(Labels_Values)
        [yy, xx] = find(Labeled_Image_Prev == Labels_Values(ii));
        if ~isempty(xx)
            Seg_Cent(ii,1:2)       = [round(mean(xx)), round(mean(yy))];
            Seg_Cent(ii,3)         = Image(Seg_Cent(ii,2), Seg_Cent(ii,1));
            Self.Seed_Centers      = Seg_Cent;
            Residual_ofCenters(ii) = (Seg_Cent(ii,1)-Segment_Center_Prev(ii,1))^2+(Seg_Cent(ii,2)-Segment_Center_Prev(ii,2))^2;
            Self                   = Self.Pixel_Dist_Label_Assign(Image, ii);
        end;
    end;
end;
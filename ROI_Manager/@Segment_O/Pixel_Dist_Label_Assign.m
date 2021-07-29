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
function Self = Pixel_Dist_Label_Assign(Self, Image, Segment_Center_Index)

Dist_Seg       = Self.Segment_Param_Value;
Segment_Center = Self.Seed_Centers(Segment_Center_Index,:);

lSWE           = max(1,Segment_Center(1)-Dist_Seg(1));              % Left Search Window Boundary
rSWE           = min(size(Image,2),Segment_Center(1)+Dist_Seg(1));  % Right Search Window Boundary
uSWE           = max(1,Segment_Center(2)-Dist_Seg(2));              % Upper Search Window Boundary
dSWE           = min(size(Image,1),Segment_Center(2)+Dist_Seg(2));  % Lower Search Window Boundary
Search_Window  = Image(uSWE:dSWE, lSWE:rSWE);
xx             = lSWE-Segment_Center(1):rSWE-Segment_Center(1);
yy             = uSWE-Segment_Center(2):dSWE-Segment_Center(2);
[yCord, xCord] = ndgrid(yy',xx);
xCord          = reshape(xCord,length(xx)*length(yy),1);
yCord          = reshape(yCord,length(xx)*length(yy),1);
Signal         = reshape(Search_Window,length(xx)*length(yy),1);
dS             = sqrt(xCord.^2+yCord.^2)/mean(Dist_Seg);
dC             = (Signal-Segment_Center(3))/Self.Intensity_Variation_Coeff;
Dist           = sqrt(dS.^2+dC.^2);
Dist           = reshape(Dist,length(yy),length(xx));
Labeled_Image  = Self.Labeled_Image(uSWE:dSWE, lSWE:rSWE);
Labeled_Image(Self.Pixel_Distance_Mat(uSWE:dSWE, lSWE:rSWE)>Dist) = Segment_Center_Index;
Self.Labeled_Image(uSWE:dSWE, lSWE:rSWE)      = Labeled_Image;
Self.Pixel_Distance_Mat(uSWE:dSWE, lSWE:rSWE) = min(Dist, Self.Pixel_Distance_Mat(uSWE:dSWE, lSWE:rSWE));
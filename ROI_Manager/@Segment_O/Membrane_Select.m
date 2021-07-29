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
function [sprsMembrane_Polygon, Membrane] = Membrane_Select(Image, Entity_Polygon, Det_Membrane_Tick)

Mask                 = poly2mask(Entity_Polygon(:,1),Entity_Polygon(:,2),size(Image,1),size(Image,2));
MT                   = round(Det_Membrane_Tick/2);
Mask(1:MT+1,:)       = 0; Mask(end-MT:end,:) = 0; Mask(:,1:MT+1) = 0; Mask(:,end-MT:end) = 0;
se                   = strel('Disk', MT);
Mask                 = imdilate(Mask,se);
se                   = strel('Disk', MT*2);
InCell               = imerode(Mask, se);
Membrane             = Mask - InCell;
            
[Poly_List, ~]       = bwboundaries(Membrane, 8);
Membrane_Polygon     = fliplr(Poly_List{1});
Membrane_Poly_Vect   = reshape(Membrane_Polygon,size(Membrane_Polygon,1)*size(Membrane_Polygon,2),1);
Mid_Poly_Vect        = reshape(Entity_Polygon,size(Entity_Polygon,1)*size(Entity_Polygon,2),1);
[Mid_Poly,Mem_Poly]  = ndgrid(Mid_Poly_Vect,Membrane_Poly_Vect);
Mid_Poly             = reshape(Mid_Poly,size(Entity_Polygon,1),size(Entity_Polygon,2),size(Membrane_Poly_Vect,1));
Mem_Poly             = reshape(Mem_Poly,size(Mid_Poly_Vect,1),size(Membrane_Polygon,1),size(Membrane_Polygon,2));
Mid_Poly             = Mid_Poly(:,:,1:size(Membrane_Polygon,1));
Mem_Poly             = Mem_Poly(1:size(Entity_Polygon,1),:,:);
Mem_Poly             = permute(Mem_Poly,[1,3,2]);
Distance             = squeeze(sqrt((Mem_Poly(:,1,:)-Mid_Poly(:,1,:)).^2+(Mem_Poly(:,2,:)-Mid_Poly(:,2,:)).^2));
[~,minMemDist_Ind]   = min(Distance,[],2);

Inner_Polygon        = fliplr(Poly_List{2});
Out_Poly_Vect        = reshape(Entity_Polygon,size(Entity_Polygon,1)*size(Entity_Polygon,2),1);
In_Poly_Vect         = reshape(Inner_Polygon,size(Inner_Polygon,1)*size(Inner_Polygon,2),1);
[Out_Poly,In_Poly]   = ndgrid(Out_Poly_Vect,In_Poly_Vect);
Out_Poly             = reshape(Out_Poly,size(Entity_Polygon,1),size(Entity_Polygon,2),size(In_Poly_Vect,1));
In_Poly              = reshape(In_Poly,size(Out_Poly_Vect,1),size(Inner_Polygon,1),size(Inner_Polygon,2));
Out_Poly             = Out_Poly(:,:,1:size(Inner_Polygon,1));
In_Poly              = In_Poly(1:size(Entity_Polygon,1),:,:);
In_Poly              = permute(In_Poly,[1,3,2]);
Distance             = squeeze(sqrt((In_Poly(:,1,:)-Out_Poly(:,1,:)).^2+(In_Poly(:,2,:)-Out_Poly(:,2,:)).^2));
[~,minDist_Ind]      = min(Distance,[],2);
if length(Poly_List) >= 2, 
    sprsMembrane_Polygon = round([Membrane_Polygon(minMemDist_Ind,:);...
                                  flipud(Inner_Polygon(minDist_Ind,:));...
                                  Inner_Polygon(minDist_Ind(end),:);...
                                  Membrane_Polygon(minMemDist_Ind(end),:);...
                                  Membrane_Polygon(minMemDist_Ind(1),:)]); 
end;
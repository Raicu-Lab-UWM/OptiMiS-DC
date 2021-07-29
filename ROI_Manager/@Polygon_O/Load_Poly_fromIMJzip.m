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
function Obj = Load_Poly_fromIMJzip(Obj, Path, Name, Polygon_Prop)

if nargin < 4
    Polygon_Prop = struct('Circle_Mode', 'Polygon', 'Polygon_Type', 'Polygon', 'Images_Related', [], 'Image_Drawn', [], 'Image_Frame_Index', 1);
end;

ROIs = ReadImageJROI([Path '\' Name]);
for ii = 1:length(ROIs)
    Polygon_Prop.Polygon_Name = ROIs{1,ii}.strName;
    if ROIs{1,ii}.nPosition > 0, Polygon_Prop.Image_Frame_Index = ROIs{1,ii}.nPosition; else Polygon_Prop.Image_Frame_Index = 1; end;
    Poly_Coords               = ROIs{1,ii}.mnCoordinates + 0.5;
    Poly_Coords               = [Poly_Coords; Poly_Coords(1,:)];
    if ~isempty(ROIs{1,ii}.strType), Polygon_Prop.Circle_Mode = ROIs{1,ii}.strType; end;
    Obj = Obj.Add_Polygon_toList(Poly_Coords, Polygon_Prop);
end;
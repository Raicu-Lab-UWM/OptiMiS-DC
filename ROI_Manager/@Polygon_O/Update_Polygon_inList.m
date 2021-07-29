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
function Polygon_List = Update_Polygon_inList(Polygon_List, Polygon_Cords, Polygon_Index, Polygon_Prop)

Polygon_Prop      = Polygon_List.Polygon_Prop_Valid (Polygon_Prop);

Polygon_Type      = Polygon_Prop.Polygon_Type;
Images_Related    = Polygon_Prop.Images_Related;
Image_Drawn       = Polygon_Prop.Image_Drawn;
Image_Frame_Index = Polygon_Prop.Image_Frame_Index;

% Allocate a new polygon.
Modified_Polygon = Polygon_List(Polygon_Index);

% Finds all locations in the filename that have "\".
BackSlash_Loc    = strfind(Image_Drawn, '\');

% Grabs the name part that include the date and time in a measurement file
if isempty(BackSlash_Loc)
    fName = Image_Drawn;
else
    fName = Image_Drawn(BackSlash_Loc(end)+1:BackSlash_Loc(end)+15);
end;

% Assign Polygon Type
Modified_Polygon.Polygon_Type = Polygon_Type;

% Assign the file name of the image where the polygon was drawn.
Modified_Polygon.Image_Drawn       = Image_Drawn;
Modified_Polygon.Image_Frame_Index = Image_Frame_Index;

% Assign Coordinaes of the polygon.
Modified_Polygon.Coordinates   = Polygon_Cords;

% Finds the center coordinates and assign to polygon Properties.
Modified_Polygon.Center_Cords  = [round(mean(Polygon_Cords(:,1))), round(mean(Polygon_Cords(:,2)))];

nPolygons = length(Polygon_List);
switch Polygon_Type
case 'Patch'
    % Assign the polygon label.
    Modified_Polygon.Label = ['P' num2str(nPolygons + 1)];

    % Defines a name based off of the center coordinates and the fName defined earlier.
    Modified_Polygon.Name  = [fName(1:15) '_P_' num2str(Modified_Polygon.Center_Cords(1)) '-' num2str(Modified_Polygon.Center_Cords(2))];
case 'Membrane'
    % Assign the polygon label.
    Modified_Polygon.Label = ['M' num2str(nPolygons + 1)];

    % Defines a name based off of the center coordinates and the fName defined earlier.
    Modified_Polygon.Name  = [fName(1:15) '_M_' num2str(Modified_Polygon.Center_Cords(1)) '-' num2str(Modified_Polygon.Center_Cords(2))];
case 'Segment'
    % Assign the polygon label.
    Modified_Polygon.Label = ['S' num2str(nPolygons + 1)];

    % Defines a name based off of the center coordinates and the fName defined earlier.
    Modified_Polygon.Name  = [fName(1:15) '_S_' num2str(Modified_Polygon.Center_Cords(1)) '-' num2str(Modified_Polygon.Center_Cords(2))];
otherwise
end;

% Assign the images names related to the polygon.
Modified_Polygon.Images_Related = Images_Related;

Polygon_List(Polygon_Index) = Modified_Polygon;
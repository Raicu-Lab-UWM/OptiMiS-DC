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
function [Polygon_List, Found_Polygon] = Add_Polygon_toList(Polygon_List, Polygon_Cords, Polygon_Prop)

Polygon_Prop   = Polygon_List.Polygon_Prop_Valid (Polygon_Prop);

Circle_Mode       = Polygon_Prop.Circle_Mode;
Polygon_Type      = Polygon_Prop.Polygon_Type;
Images_Related    = Polygon_Prop.Images_Related;
Image_Drawn       = Polygon_Prop.Image_Drawn;
Image_Frame_Index = Polygon_Prop.Image_Frame_Index;
if isfield(Polygon_Prop, 'Sample_Name'), Sample_Name = Polygon_Prop.Sample_Name; else Sample_Name = []; end

% Number of Polygons existing in the list.
nPolygons      = length(Polygon_List);

% If the polygon list is empty, set the number of Polygons to 0, because
% even an empty list will have a length of 1.
if nPolygons == 1 && isempty(Polygon_List.Name)
    nPolygons = 0;
end;

% Allocate a new polygon.
New_Polygon    = Polygon_O;

% Finds all locations in the filename that have "\".
BackSlash_Loc  = strfind(Image_Drawn, '\');

% Grabs the name part that include the date and time in a measurement file
if isempty(BackSlash_Loc)
    fName = Image_Drawn;
else
    fName = Image_Drawn(BackSlash_Loc(end)+1:end);
    if length(fName) > 15
        fName = fName(1:15);
    end;
end;

% Defines the polygon index.
New_Polygon.Index = nPolygons + 1;

% Assign Polygon Type
New_Polygon.Polygon_Type = Polygon_Type;

% Assign the file name of the image where the polygon was drawn.
New_Polygon.Image_Drawn       = Image_Drawn;
New_Polygon.Image_Frame_Index = Image_Frame_Index;

% Assign Coordinaes of the polygon.
New_Polygon.Coordinates   = Polygon_Cords;

% Finds the center coordinates and assign to polygon Properties.
New_Polygon.Center_Cords  = [round(mean(Polygon_Cords(:,1))), round(mean(Polygon_Cords(:,2)))];

switch Polygon_Type
case 'Patch'
    % Assign the polygon label.
    New_Polygon.Label = ['P' num2str(nPolygons + 1)];

    % Defines a name based off of the center coordinates and the fName defined earlier.
    New_Polygon.Name  = [fName(1:min([15, length(fName)])) '_P_' num2str(Image_Frame_Index) '-' num2str(New_Polygon.Center_Cords(1)) '-' num2str(New_Polygon.Center_Cords(2))];
case 'Membrane'
    % Assign the polygon label.
    New_Polygon.Label = ['M' num2str(nPolygons + 1)];

    % Defines a name based off of the center coordinates and the fName defined earlier.
    New_Polygon.Name  = [fName(1:min([15, length(fName)])) '_M_' num2str(Image_Frame_Index) '-' num2str(New_Polygon.Center_Cords(1)) '-' num2str(New_Polygon.Center_Cords(2))];
case 'Segment'
    % Assign the polygon label.
    New_Polygon.Label = ['S' num2str(nPolygons + 1)];

    % Defines a name based off of the center coordinates and the fName defined earlier.
    New_Polygon.Name  = [fName(1:min([15, length(fName)])) '_S_' num2str(Image_Frame_Index) '-' num2str(New_Polygon.Center_Cords(1)) '-' num2str(New_Polygon.Center_Cords(2))];
otherwise
end;

if isfield(Polygon_Prop, 'Polygon_Name'), New_Polygon.Name = Polygon_Prop.Polygon_Name; end;

% Assign the polygon circling mode.
New_Polygon.Circle_Mode    = Circle_Mode;

% Assign the images names related to the polygon.
New_Polygon.Images_Related = Images_Related;

New_Polygon.Sample_Name    = Sample_Name;

% Test whether the polygon exist.
Found_Polygon = [];
Polygon_Names              = {Polygon_List.Name};
if nPolygons > 0
    Found_Polygon = find(~cellfun('isempty', strfind(Polygon_Names, New_Polygon.Name)));
end
if isempty(Found_Polygon)
    Polygon_List(nPolygons+1) = New_Polygon;
    Found_Polygon = length(Polygon_List);
end;
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
function handPoly = Draw_aPolygon(Obj, hAxes)

Editing_Tool  = Obj.Circle_Mode;
Polygon_Cords = Obj.Coordinates;

switch Editing_Tool
    case 'Ellipse'
        elpPolygon_Cords_xMin  = min(Polygon_Cords(:,1));
        elpPolygon_Cords_yMin  = min(Polygon_Cords(:,2));
        elpPolygon_Cords_xMax  = max(Polygon_Cords(:,1));
        elpPolygon_Cords_yMax  = max(Polygon_Cords(:,2));
        elpPolygon_Cords_Width = elpPolygon_Cords_xMax - elpPolygon_Cords_xMin;
        elpPolygon_Cords_Heigt = elpPolygon_Cords_yMax - elpPolygon_Cords_yMin;
        elpPolygon_Cords = [elpPolygon_Cords_xMin, elpPolygon_Cords_yMin, elpPolygon_Cords_Width, elpPolygon_Cords_Heigt];
        handPoly = imellipse(hAxes, elpPolygon_Cords);
    case 'Freehand'
        handPoly = impoly(hAxes, Polygon_Cords);
    case 'Polygon'
        hold(hAxes ,'on'); handPoly = plot(hAxes, Polygon_Cords(:,1),Polygon_Cords(:,2),'r','LineWidth', 1);
    case 'Rectangle'
        hold(hAxes ,'on'); handPoly = plot(hAxes, Polygon_Cords(:,1),Polygon_Cords(:,2),'r','LineWidth', 1);
    otherwise
        Polygon_Cord = [];
end;
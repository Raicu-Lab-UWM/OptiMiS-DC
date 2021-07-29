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
function Polygon_Prop = Polygon_Prop_Valid (Polygon_Prop)

if ~isfield(Polygon_Prop, 'Circle_Mode'), Polygon_Prop.Circle_Mode = 'Polygon'; elseif isempty(Polygon_Prop.Circle_Mode), Polygon_Prop.Circle_Mode = 'Polygon'; end;
if ~isfield(Polygon_Prop, 'Polygon_Type'), Polygon_Prop.Polygon_Type = 'Patch'; elseif isempty(Polygon_Prop.Polygon_Type), Polygon_Prop.Polygon_Type = 'Patch'; end;
if ~isfield(Polygon_Prop, 'Images_Related'), Polygon_Prop.Images_Related = []; end;
if ~isfield(Polygon_Prop, 'Image_Drawn'), Polygon_Prop.Image_Drawn = []; end;
if ~isfield(Polygon_Prop, 'Image_Frame_Index'), Polygon_Prop.Image_Frame_Index = 1; end;
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
function Found = Find_FICoS_Item(Self, Polygon_Name)

Polygons_Names = {Self.Master_Polygon};
if ~iscell(Polygons_Names)
    Polygons_Names = {Polygons_Names};
end;
if length(Polygons_Names) == 1 && isempty(Polygons_Names{1})
    Found = 0;
else
    Found = find(~cellfun('isempty', strfind(Polygons_Names, Polygon_Name)),1);
    if isempty(Found), Found = 0; end;
end
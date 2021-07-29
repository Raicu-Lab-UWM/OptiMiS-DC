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
function Self = Remove_Polygon_fromList(Self, Polygon_Name)

Polygon_Names    = {Self.Name};
if iscell(Polygon_Name)
    for ii = 1:length(Polygon_Name)
        Found_Polygon  = cellfun(@(x) strcmp(x, Polygon_Names), Polygon_Name, 'UniformOutput', false);
        Found_Polygon  = cell2mat(cellfun(@(x) find(x), Found_Polygon, 'UniformOutput', false));
        if ~isempty(Found_Polygon)
            Self(Found_Polygon)  = [];
            Polygon_Names(Found_Polygon) = [];
        end;
    end;
else
    Found_Polygon  = cellfun(@(x) strcmp(x, Polygon_Names), Polygon_Name, 'UniformOutput', false);
    Found_Polygon  = cell2mat(cellfun(@(x) find(x), Found_Polygon, 'UniformOutput', false));
    if ~isempty(Found_Polygon)
        Self(Found_Polygon) = [];
    end;
end;
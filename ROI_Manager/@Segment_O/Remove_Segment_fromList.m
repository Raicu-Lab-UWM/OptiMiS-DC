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
function Self = Remove_Segment_fromList(Self, Polygon_Name)

Segment_Names    = {Self.Master_Polygon};
if iscell(Polygon_Name)
    for ii = 1:length(Polygon_Name)
        if length(Segment_Names) == 1 && isempty(Segment_Names{1})
            Found_Segment = [];
        else
            Found_Segment = find(~cellfun('isempty', strfind(Segment_Names, Polygon_Name{ii})));
        end
        if ~isempty(Found_Segment)
            Self(Found_Segment)  = [];
            Segment_Names(Found_Segment) = [];
        end;
    end;
else
    if length(Segment_Names) == 1 && isempty(Segment_Names{1})
        Found_Segment = [];
    else
        Found_Segment = find(~cellfun('isempty', strfind(Segment_Names, Polygon_Name)));
        if ~isempty(Found_Segment)
            Self(Found_Segment) = [];
        end;
    end
end;
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
function [Self, Found_Index] = Segment_MasterPoly_Query(Self, varargin)

Property_Name = varargin(1:2:end);
Property_Value = varargin(2:2:end);

Found_Index = [1:length(Self)];
Sub_List = Self;
for ii = 1:length(Property_Name)
    switch Property_Name{ii}
        case 'Master_Polygon'
            if length(Sub_List) == 1 && isempty(Sub_List.Master_Polygon)
                Found_Index = [];
            else
                All_Master_ROIs = {Sub_List.Master_Polygon};
                Items_Index     = find(strcmp(All_Master_ROIs, Property_Value{ii})==1);
%                 Items_Index     = find(~cellfun(@isempty, strfind(All_Master_ROIs, Property_Value{ii})));
                if ~isempty(Items_Index)
                    Found_Index = Found_Index(Items_Index);
                    Sub_List    = Sub_List(Items_Index);
                else
                    Found_Index = [];
                end;
            end;
        otherwise
    end
end
Self = Sub_List;
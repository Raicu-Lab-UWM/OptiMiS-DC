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
function Self = Add_FOV_toList(Self, Image_, FOV_inStruct)

FOV_New = Field_ofView_O;

FOV_New.Name = FOV_inStruct.Name;
FOV_New.Path = FOV_inStruct.Path;
FOV_New.FOV_Dimensions = [FOV_inStruct.Width, FOV_inStruct.Height, FOV_inStruct.Depth];
FOV_New.raw_Data = Image_;
if ~isfield(FOV_inStruct, 'Frame_Number'),
    FOV_inStruct.Frame_Number = length(Self) + 1;
end;
FOV_New.iName = [FOV_inStruct.Name(1:end-4) '_' num2str(FOV_inStruct.Frame_Number)];

All_FOV_Names = {Self.iName};
if length(Self) == 1 && isempty(Self.iName)
    Self = FOV_New;
elseif length(Self) >= 1 && ~isempty(Self(1).iName)
    Found_Image = find(~cellfun(@isempty, strfind(All_FOV_Names, FOV_New.iName)));
    if isempty(Found_Image)
        Self(length(Self)+1) = FOV_New;
    end;
end;
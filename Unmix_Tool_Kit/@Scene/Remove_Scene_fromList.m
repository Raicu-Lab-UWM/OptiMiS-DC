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
function Scene_List = Remove_Scene_fromList(Scene_List, Scene_Name)

Scenes_Names    = {Scene_List.Name};
if iscell(Scene_Name)
    for ii = 1:length(Scene_Name)
        Found_Scene            = find(~cellfun('isempty', strfind(Scenes_Names, Scene_Name{ii})));
        if ~isempty(Found_Scene)
            Scene_List(Found_Scene)  = [];
            Scenes_Names(Found_Scene) = [];
        end;
    end;
else
    Found_Scene = find(~cellfun('isempty', strfind(Scenes_Names, Scene_Name)));
    if ~isempty(Found_Scene)
        Scene_List(Found_Scene) = [];
    end;
end;
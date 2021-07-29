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
function UM_Del_Scenes_Icon_Callback(hObject, eventdata)

handles = guidata(hObject);

Selected_Scenes     = handles.Scene_Inst(handles.Scene_Index);
Scenes_Names        = {Selected_Scenes.Name};

handles.Scene_Inst  = handles.Scene_Inst.Remove_Scene_fromList(Scenes_Names);
handles.Scene_Index = max([min(handles.Scene_Index)-1,1]);
set(handles.Scene_List_lBox, 'String', {handles.Scene_Inst.Name}, 'Value', handles.Scene_Index);

guidata(hObject, handles);
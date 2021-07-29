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
function Show_ROI_Polygons(hObject, eventdata, Current_Polygon_Index)
if nargin < 3, Current_Polygon_Index = 1; elseif isempty(Current_Polygon_Index), Current_Polygon_Index = 1; end
handles = guidata(hObject);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles), Polygon_List = handles.Polygon_List; else Polygon_List = mwHandles.Polygon_List; end
Polygon_Selected  = Polygon_List(Current_Polygon_Index);
nPolygon_Selected = length(Polygon_Selected);

for ii = 1:nPolygon_Selected
    if ~isempty(Polygon_Selected(ii).Poly_PlotH)
        if isvalid(Polygon_Selected(ii).Poly_PlotH)
            set(Polygon_Selected(ii).Poly_PlotH, 'Visible', 'on');
            set(Polygon_Selected(ii).Title_PrintH, 'Visible', 'on');
        end
    end
    if isempty(mwHandles), handles.currPolygon_Coords{ii} = Polygon_Selected(ii).Coordinates; else mwHandles.currPolygon_Coords{ii} = Polygon_Selected(ii).Coordinates; end
end;

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(hObject, handles);
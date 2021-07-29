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
function Extract_Membrane_Icon_OnCallback(hObject, eventdata, handles)
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = handles; end; 
else mwHandles = handles;
end

mwHandles.Polygon_Type = 'Membrane';
ROI_List               = mwHandles.Polygon_List(mwHandles.Current_Polygon_Index);
Membrane_Thckness      = mwHandles.Seg_Membrane_Thckness;

h = waitbar(0, 'Membrane Extraction in Process...');
for ii = 1:length(ROI_List)
    currMaster_Poly = ROI_List(ii);
    Image_          = handles.FOV_List(handles.Image_Frame_Index).raw_Data;
    if isempty(currMaster_Poly.Membrane)
        currMaster_Poly = currMaster_Poly.Membrane_Select(Image_, currMaster_Poly.Coordinates, Membrane_Thckness);
    elseif currMaster_Poly.Mem_Thick ~= Membrane_Thckness
        currMaster_Poly = currMaster_Poly.Membrane_Select(Image_, currMaster_Poly.Coordinates, Membrane_Thckness);
        currMaster_Poly.Mem_Thick = Membrane_Thckness;
    end;
    mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(ii)).Mem_Thick = currMaster_Poly.Mem_Thick;
    mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(ii)).Membrane  = currMaster_Poly.Membrane;
    waitbar(ii/length(ROI_List), h);
end;

mwHandles.currPolygon_Coords = {currMaster_Poly.Membrane};
close(h);

if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), guidata(handles.mwFigureH, mwHandles); else handles = mwHandles; end;
else handles = mwHandles;
end
guidata(hObject, handles);
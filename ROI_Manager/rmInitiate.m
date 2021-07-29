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
function handles = rmInitiate(hObject, Main_FigureH)

handles               = guidata(hObject);
if nargin < 2, Polygon_Console_Param = []; 
elseif isempty(Main_FigureH), Polygon_Console_Param = [];
else Polygon_Console_Param = guidata(Main_FigureH);
end;

if isempty(Polygon_Console_Param)
    handles.Polygon_List       = Polygon_O;
    handles.Segment_List       = Segment_O;
    fName                      = 'rmUserDef_Params.txt';
    guidata(hObject, handles); handles = rmLoadParam_fTextF(hObject, fName);
    handles.Ana_Path           = handles.curr_Path;
    handles.Image_Name         = [];
    handles.Image_             = [];
    handles.Image_Stack_Axes   = [];
    handles.currPolygon_Coords = {};
else handles.mwFigureH = Main_FigureH;
    mwHandles = guidata(Main_FigureH);
    handles.Image_Frame_Index = mwHandles.Image_Frame_Index;
    handles.Image_Stack_Axes  = mwHandles.Image_Stack_Axes;
end

handles.Show_All_Poly   = 0;
handles.Show_Segments   = 0;
handles.Draw_Polygon_On = 0;
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
classdef Polygon_O
    properties
        Index;                 % Polygon Index
        Name;                  % Polygon Name
        Label;                 % Label presented in a figure with the polygon
        Coordinates;           % Polygon x-y vertex coordinates
        Membrane;              % Membrane coordinates
        Mem_Thick              % Membrane thickness in pixels
        Center_Cords;          % center of mass coordinates of the polygon
        Circle_Mode;           % Circling method ('Polygon', 'Free Hand', 'Ellipse')
        Polygon_Type;          % Polygon type ('Membrane', 'Patch', 'Segment')
        Images_Related;        % Indices of images or images names where the polygon can be used
        Image_Drawn;           % Image Name or index where the polygon was drawn
        Image_Frame_Index;     % in case of loading a stack this property indicate which frame within the stack the polygon was drawn
        Mask;                  % Mask generated from the polygon coordinates
        Poly_PlotH             % handle to the polygon curve plot in the image.
        Title_PrintH           % handle to the title of the polygon in the image.
        Sample_Name;           % The name of the sample measured and circled
    end
    methods
        [Polygon_List, Found_Polygon] = Add_Polygon_toList(Polygon_List, Polygon_Cords, Polygon_Prop)
        [Self, Index] = findROI(Self, varargin)
        handPoly      = Draw_aPolygon(Obj, hAxes, Image_Stack)
        Obj = Load_aPolygon_fromFile(Obj, Path, Name, Polygon_Prop, PolyXLS_Param)
        Obj = Load_aPolygon_fromList(Obj, Label)
        Obj = Load_Poly_fromIMJzip(Obj, Path, Name, Polygon_Prop)
        Obj = Load_Poly_fromXLS(Obj, Path, Name, Polygon_Prop, PolyXLS_Param)
        Obj = Membrane_Select(Obj, Image, Entity_Polygon, Det_Membrane_Tick)
        Text_Hand     = Plot_Poly_Label(Self, Image_Stack_Axes)
        Polygon_List  = Remove_Polygon_fromList(Polygon_List, Polygon_Name)
        Save_Poly_List(Obj, Path, Name)
        fileID        = Save_ROIList_toTextFile(Obj, Path, Name, fileID)
        Polygon_List  = Update_Polygon_inList(Polygon_List, Polygon_Cords, Polygon_Index, Polygon_Prop)
        Self          = updateROI_Sample(Self, Tree, Image_List)
        ListROI_inImageO(Self, Main_FigureH)
        Empty         = isEmpty(Self)
        [Self, iSelf] = autoSelect_ROI(Self, FOV_List, Polygon_Type, Sample_Name, strEl_Radius, Axes, Find_Cells)
    end
    methods (Static)
        Polygon_Prop = Polygon_Prop_Valid (Polygon_Prop)
    end

end
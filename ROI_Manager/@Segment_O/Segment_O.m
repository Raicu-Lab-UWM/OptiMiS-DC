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
classdef Segment_O
    properties
        Master_Polygon;              % The polygon that was segmented and generated these segments
        Segmentation_Method;         % indicate which algorithm was chocen for segmentation (SLIC - for patchs or Curve_Guided - for membrane)
        Segment_Type;                % Indicate whether we use segment size or number of segments to split
        Segment_Param_Value;         % Parameter indicats size of section or number of sections
        nIterations;                 % in case of SLIC, this variable indicate how many iteratins are maximal
        Intensity_Variation_Coeff;   % in the case of SLIC this indicate the ratio between space and intensity that will effect distance calculation of the pixels from center of the segment
        Center_Pos_Diff_Residual_TH; % indicate the TH that conditions the iteration loop for which if met the interation loop will stop
        nPixels_min_TH;              % minmal number of pixels aloud within a segment area. In case lower number of pixels the segment is not considered
        Labeled_Image;               % Image that indicate different segments by assigning different number to each pixel at different segments.
        Segment_Adjacency_Mat;       % a Matix discribe the neighboring segments to each segment
        Segment_Stat_Struct;         % Statistical information about each segment such as center of mass and avrage intensity
        Pixel_Distance_Mat;          % a matrix with each pixel having the distance from the center of its segment
        Polygons;                    % for multiple segments it saves the poligon sorounding the segment
        Seed_Centers;                % the matrix holding the centers of the segments.
        nPoints_inSegment_Poly;      % for drawing purposes indicate how many vertices will be included in the plot of the segment polygon.
    end
    methods
        Self = GrayScale_SLIC(Self, Image, Entity_Plygon)
        Self = Moving_Square_Segmentation(Self, Image, Entity_Polygon)
        Self = Initialte_Segment_Seed(Self, Image, Entity_Polygon)
        Self = Seg_Center_Avoid_Edge(Self, Image, Segment_Center_Index)
        Self = Pixel_Dist_Label_Assign(Self, Image, Segment_Center_Index)
        Self = Create_Segment_Polygons(Self, Mask)
        Self = Curve_Guided_Segmentation(Self, Image, Entity_Polygon)
        Self = Curve_Guided_DAMAR(Self, ROI, Image_, Offset)
        Self = Curve_Guided_Shift_DAMAR(Self, ROI, Image_, Offset)
        [Self, Found_Index] = Segment_MasterPoly_Query(Self, varargin)
        Self = Add_Segment_toList(Self, Poly_Obj, New_Segment, New_Segment_Struct)
        Self = Remove_Segment_fromList(Self, Polygon_Name)
        Setting_Changed = Seg_Setting_Changed(Self, New_Setting_Struct)
        Save_Segment_List(Obj, Path, Name)
        fileID = Save_SegList_toTextFile(Obj, Path, Name, fileID, Seg_Index)
    end
    methods (Static)
        [sprsMembrane_Polygon, Membrane] = Membrane_Select(Image, Entity_Polygon, Det_Membrane_Tick)
    end
end

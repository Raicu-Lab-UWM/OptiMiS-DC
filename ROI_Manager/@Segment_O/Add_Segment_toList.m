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
function Self = Add_Segment_toList(Self, Poly_Obj, New_Segment, New_Segment_Struct)

if isfield(New_Segment_Struct, 'mwFigureH')
    if isvalid(New_Segment_Struct.mwFigureH), mwHandles = guidata(New_Segment_Struct.mwFigureH); else mwHandles = New_Segment_Struct; end; 
else mwHandles = New_Segment_Struct;
end

nSegments_Obj = length(Self);
Use_Default = 0;
if nargin < 3, Use_Default = 1; end;
if nargin < 4 && ~Use_Default
    if isempty(New_Segment)
        Use_Default = 1;
    end;
elseif isempty(New_Segment_Struct)
    if isempty(New_Segment)
        Use_Default = 1;
    end
else
    if isempty(New_Segment)
        New_Segment = Segment_O;
        if isempty(Poly_Obj.Mask)
            Image_        = New_Segment_Struct.FOV_List(New_Segment_Struct.Image_Frame_Index).raw_Data;
            Poly_Obj.Mask = poly2mask(Poly_Obj.Coordinates(:,1), Poly_Obj.Coordinates(:,2), size(Image_,1), size(Image_,2));
        end;

        New_Segment.Segmentation_Method    = mwHandles.Seg_Method;
        New_Segment.Segment_Type           = mwHandles.Seg_Type;
        New_Segment.Segment_Param_Value    = mwHandles.Seg_Split_Value;
        New_Segment.nPoints_inSegment_Poly = mwHandles.Seg_nVert_inPoly;
        New_Segment.Master_Polygon         = Poly_Obj.Name;
        switch New_Segment.Segmentation_Method
        case 'Moving Square'
            Seg_Split_Value = mwHandles.Seg_Split_Value;
            New_Segment.nPixels_min_TH = round((Seg_Split_Value(1)-1)*(Seg_Split_Value(2)-1)*0.4,-2);
            New_Segment     = New_Segment.Moving_Square_Segmentation(Poly_Obj.Mask, Poly_Obj.Coordinates);
%             if sum(New_Segment.Labeled_Image(:)) ~= 0
%                 New_Segment = New_Segment.Create_Segment_Polygons(Poly_Obj.Mask);
%             end;
        case 'Contour Guided Single Sample'
%             if ~isfield(New_Segment_Struct, 'Seg_Membrane_Thckness'), Det_Membrane_Tick = 10; else Det_Membrane_Tick = New_Segment_Struct.Seg_Membrane_Thckness; end;
%             [sprsMembrane_Polygon, ~] = New_Segment.Membrane_Select(Poly_Obj.Mask, Poly_Obj.Coordinates, Det_Membrane_Tick);
%             New_Segment               = New_Segment.Curve_Guided_Segmentation(Poly_Obj.Mask, Poly_Obj.Membrane);
            New_Segment = New_Segment.Curve_Guided_DAMAR(Poly_Obj.Coordinates, Poly_Obj.Mask, mwHandles.Seg_Membrane_Thckness);
        case 'Contour Guided Multiple Sample'
%             added by Damar Badu for shift in segmentation
            New_Segment = New_Segment.Curve_Guided_DAMAR(Poly_Obj.Coordinates, Poly_Obj.Mask, mwHandles.Seg_Membrane_Thckness);
        case 'SLIC'
            New_Segment.nIterations                 = mwHandles.Seg_nIterations;
            New_Segment.Intensity_Variation_Coeff   = mwHandles.Seg_Intensity_Weight;
            New_Segment.Center_Pos_Diff_Residual_TH = 0.1;
            New_Segment = New_Segment.GrayScale_SLIC(Poly_Obj.Mask, Poly_Obj.Coordinates);
            New_Segment = New_Segment.Create_Segment_Polygons(Poly_Obj.Mask);
        otherwise
        end
    end
end;

if Use_Default
    New_Segment = Segment_O;

    New_Segment.Segmentation_Method    = 'Moving Square';
    New_Segment.Segment_Type           = 'Segment Area';
    New_Segment.Segment_Param_Value    = [45, 45];
    New_Segment.nPoints_inSegment_Poly = 15;
    New_Segment.nPixels_min_TH         = 800;
    New_Segment.Master_Polygon         = Poly_Obj.Name;
    New_Segment = New_Segment.Moving_Square_Segmentation(Poly_Obj.Mask);
    New_Segment = New_Segment.Create_Segment_Polygons(Poly_Obj.Mask);
end;

[~, Found_Segment_Index] = Self.Segment_MasterPoly_Query('Master_Polygon', Poly_Obj.Name);
if isempty(Found_Segment_Index)
    if nSegments_Obj == 1 && isempty(Self(1).Master_Polygon)
        Self(1) = New_Segment;
    else
        Self(end+1) = New_Segment;
    end;
else
    Self(Found_Segment_Index) = New_Segment;
end;

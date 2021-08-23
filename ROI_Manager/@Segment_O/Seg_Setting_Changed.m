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
function Setting_Changed = Seg_Setting_Changed(Self, New_Setting_Struct)

nSegments_Obj   = length(Self);
Setting_Changed = zeros(nSegments_Obj,1);
for ii = 1:nSegments_Obj
    Setting_Changed(ii) = ~strcmp(Self(ii).Segmentation_Method, New_Setting_Struct.Seg_Method) || Setting_Changed(ii);
    Setting_Changed(ii) = ~strcmp(Self(ii).Segment_Type, New_Setting_Struct.Seg_Type) || Setting_Changed(ii);
    Setting_Changed(ii) = Self(ii).Segment_Param_Value(1) ~= New_Setting_Struct.Seg_Split_Value(1) || Setting_Changed(ii);
    Setting_Changed(ii) = Self(ii).nPoints_inSegment_Poly ~= New_Setting_Struct.Seg_nVert_inPoly || Setting_Changed(ii);
    switch Self(ii).Segmentation_Method
    case 'Moving Square'
        Setting_Changed(ii) = Self(ii).nPixels_min_TH ~= 800 || Setting_Changed(ii);
    case 'Curve Guided'
        Det_Membrane_Tick = New_Setting_Struct.Seg_Membrane_Thckness;
    case 'Curve Guided Shift'
        Det_Membrane_Tick = New_Setting_Struct.Seg_Membrane_Thckness;
    case 'SLIC'
        Setting_Changed(ii) = Self(ii).nIterations ~= New_Setting_Struct.Seg_nIterations || Setting_Changed(ii);
        Setting_Changed(ii) = Self(ii).Intensity_Variation_Coeff ~= New_Setting_Struct.Seg_Intensity_Weight || Setting_Changed(ii);
        Setting_Changed(ii) = Self(ii).Center_Pos_Diff_Residual_TH ~= 0.1 || Setting_Changed(ii);
    otherwise
    end;
end;

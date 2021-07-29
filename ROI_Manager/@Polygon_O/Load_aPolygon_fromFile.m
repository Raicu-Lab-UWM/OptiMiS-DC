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
function Obj = Load_aPolygon_fromFile(Obj, Path, Name, Polygon_Prop, PolyXLS_Param)

if nargin < 2, [Name, Path] = uigetfile('.\*.mroi;*.xls;*.xlsx', 'Load Polygon List'); 
elseif nargin < 3, [Name, Path] = uigetfile([Path '\*.mroi;*.xls;*.xlsx'], 'Load Polygon List');
% else [Name, Path] = uigetfile([Path '\' Name], 'Load Polygon List');
end;
if nargin < 4
    Polygon_Prop = struct('Circle_Mode', 'Polygon', 'Polygon_Type', 'Patch', 'Images_Related', [], 'Image_Drawn', handles.Image_Name,...
                          'Image_Frame_Index', handles.Image_Frame_Index);
end;
if nargin < 5, PolyXLS_Param  = struct('Sheet_Name', 'All_Sheets', 'Start_Cell', 'B5'); end;

if strcmp(Name(end-3:end),'mroi')
    load([Path '\' Name], '-mat', 'ROI_List_Struct');
    Obj         = ROI_List_Struct;
elseif strcmp(Name(end-3:end),'mseg')
    load([Path '\' Name], '-mat', 'Segment_List_Struct');
    Obj = Segment_List_Struct;
elseif strcmp(Name(end-2:end),'zip')
    Obj = Obj.Load_Poly_fromIMJzip(Path, Name, Polygon_Prop);
else
    Obj = Obj.Load_Poly_fromXLS(Path, Name, Polygon_Prop, PolyXLS_Param);
end;
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
function Self = Calculate_Histogram(Self, Poly_Cords, Hist_Bin, Capp_Map, Conc_Map, Bin_Range)

Self.Hist_Bin = Hist_Bin;

if nargin < 6, Self.Bin_List = [min(Capp_Map(:)):Hist_Bin:max(Capp_Map(:))]'; 
elseif isempty(Bin_Range), Self.Bin_List = [min(Capp_Map(:)):Hist_Bin:max(Capp_Map(:))]';
else Self.Bin_List = [Bin_Range(1):Hist_Bin:Bin_Range(2)]';
end
if nargin < 5, Conc_Map = []; end

if iscell(Poly_Cords)
    Self.Histogram      = zeros(length(Self.Bin_List), length(Poly_Cords));
    for ii = 1:length(Poly_Cords)
        Segment_ROI = Poly_Cords{ii};
        Mask        = poly2mask(Segment_ROI(:,1), Segment_ROI(:,2), size(Capp_Map,1), size(Capp_Map,2));
        Capp_       = [];
        Capp_(:,1)  = double(Capp_Map(Mask == 1));
        Conc_       = [];
        Conc_(:,1)  = double(Conc_Map(Mask == 1));
        if ~isempty(Conc_Map), Self.FICoS_pixLevel{ii} = [Capp_, Conc_]; else Self.FICoS_pixLevel{ii} = Capp_; end
        Self.Histogram(:,ii)= histcounts(Capp_, double([Self.Bin_List; Self.Bin_List(end) + Hist_Bin]));
    end
else
    Mask = poly2mask(Poly_Cords(:,1), Poly_Cords(:,2), size(Capp_Map,1), size(Capp_Map,2));
    Capp_(:,1)  = double(Capp_Map(Mask == 1));
    Conc_(:,1)  = double(Conc_Map(Mask == 1));
    if ~isempty(Conc_Map), Self.FICoS_pixLevel = [Capp_, Conc_]; else Self.FICoS_pixLevel = Capp_; end
    Self.Histogram(:,1) = histcounts(Capp_, double([Self.Bin_List; Self.Bin_List(end) + Hist_Bin]));
end;
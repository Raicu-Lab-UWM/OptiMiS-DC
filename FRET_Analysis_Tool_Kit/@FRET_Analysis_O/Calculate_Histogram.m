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
function Self = Calculate_Histogram(Self, Poly_Cords, Hist_Bin, Image_, Bin_Range)

Self.Hist_Bin = Hist_Bin;

if nargin < 5, Self.Bin_List = [min(Image_(:)):Hist_Bin:max(Image_(:))]'; 
elseif isempty(Bin_Range), Self.Bin_List = [min(Image_(:)):Hist_Bin:max(Image_(:))]';
else Self.Bin_List = [Bin_Range(1):Hist_Bin:Bin_Range(2)]';
end;

if iscell(Poly_Cords)
    Self.Histogram      = zeros(length(Self.Bin_List), length(Poly_Cords));
    for ii = 1:length(Poly_Cords)
        Segment_ROI = Poly_Cords{ii};
        Mask        = poly2mask(Segment_ROI(:,1), Segment_ROI(:,2), size(Image_,1), size(Image_,2));
        Self.Histogram(:,ii)= histcounts(double(Image_(Mask == 1)), double([Self.Bin_List; Self.Bin_List(end) + Hist_Bin]));
    end
else
    Mask = poly2mask(Poly_Cords(:,1), Poly_Cords(:,2), size(Image_,1), size(Image_,2));
%     Self.Histogram(:,1) = histcounts(double(Image_(Mask == 1)), double([Self.Bin_List; Self.Bin_List(end) + Hist_Bin]));
    Self.Histogram(:,1) = hist(double(Image_(Mask == 1)), double(Self.Bin_List));
end;
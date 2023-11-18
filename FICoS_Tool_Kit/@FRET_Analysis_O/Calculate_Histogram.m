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
function Self = Calculate_Histogram(Self, Poly_Cords, Hist_Bin, Eapp_Map, FDA_WL1_Map, FAD_WL1_Map, FAD_WL2_Map, Bin_Range); % espectra is removed from function
% espectra (gd, ga) is not required only to calculate FD and FA and then
% concentration

Self.Hist_Bin = Hist_Bin;

if nargin < 8, Self.Bin_List = [min(Eapp_Map(:)):Hist_Bin:max(Eapp_Map(:))]'; 
elseif isempty(Bin_Range), Self.Bin_List = [min(Eapp_Map(:)):Hist_Bin:max(Eapp_Map(:))]';
else Self.Bin_List = [Bin_Range(1):Hist_Bin:Bin_Range(2)]';
end;

if nargin < 7, FAD_WL2_Map = []; end
if nargin < 6, FAD_WL1_Map = []; end
if nargin < 5, FDA_WL1_Map = []; end

% rQuant_Yield = eSpectra(1).Quantum_Yield/eSpectra(2).Quantum_Yield;
% gD           = eSpectra(1).rIntensity; if ischar(gD), gD = str2double(gD); end;
% gA           = eSpectra(2).rIntensity; if ischar(gA), gA = str2double(gA); end;

if iscell(Poly_Cords)
    Self.Histogram      = zeros(length(Self.Bin_List), length(Poly_Cords));
    for ii = 1:length(Poly_Cords)
        Segment_ROI          = Poly_Cords{ii};
        Mask                 = poly2mask(Segment_ROI(:,1), Segment_ROI(:,2), size(Eapp_Map,1), size(Eapp_Map,2));
        if ~isempty(FDA_WL1_Map), FDA_WL1 = FDA_WL1_Map(Mask == 1); else FDA_WL1 = NaN; end
        if ~isempty(FAD_WL1_Map), FAD_WL1 = FAD_WL1_Map(Mask == 1); else FAD_WL1 = NaN; end
        if ~isempty(FAD_WL2_Map), FAD_WL2 = FAD_WL2_Map(Mask == 1); else FAD_WL2 = NaN; end
        
%         if ~isnan(FDA_WL1)
% %             Self.TEW_FD(ii,1)     = FDA_WL1 + rQuant_Yield*FAD_WL1;                                     % from Prof. Raicu's paper titled "Ab initio derivation
% %             Self.TEW_FA(ii,1)     = (FAD_WL2 - FAD_WL1/gD);                                             % of the FRET equations resolves old puzzles and 
%             Self.TEW_FDA_L1(ii,1) = FDA_WL1;
%             Self.TEW_FAD_L1(ii,1) = FAD_WL1;
%             Self.TEW_FAD_L2(ii,1) = FAD_WL2;
% %             Self.TEW_Eapp(ii,1)   = (1 + (FDA_WL1*(1-gA/gD)/(FAD_WL1 - FAD_WL2*gA))/rQuant_Yield)^(-1); % suggests measurement strategies" EQ. 53, 54 and 45'.
%         else
% %             Self.TEW_FD(ii,1)     = NaN;
% %             Self.TEW_FA(ii,1)     = NaN;
%             Self.TEW_FDA_L1(ii,1) = NaN;
%             Self.TEW_FAD_L1(ii,1) = NaN;
%             Self.TEW_FAD_L2(ii,1) = NaN;
% %             Self.TEW_Eapp(ii,1)   = NaN;
%         end
        Eapp_WL1             = double(Eapp_Map(Mask == 1));
        Eapp_bins            = double([Self.Bin_List; Self.Bin_List(end) + Hist_Bin]);
        Self.Histogram(:,ii) = histcounts(double(Eapp_Map(Mask == 1)), double([Self.Bin_List; Self.Bin_List(end) + Hist_Bin]));
        if ~isempty(FDA_WL1_Map)
        [~, Self.Avg_FDA1(:,ii)] = Histogram_and_corres_arr(Eapp_bins, Eapp_WL1, FDA_WL1);
        else
        Self.Avg_FDA1(:,ii)  = NaN;
        end
        if ~isempty(FAD_WL1_Map)
        [~, Self.Avg_FAD1(:,ii)] = Histogram_and_corres_arr(Eapp_bins, Eapp_WL1, FAD_WL1);
        else
        Self.Avg_FAD1(:,ii)  = NaN;
        end
        if ~isempty(FAD_WL2_Map)
        [~, Self.Avg_FAD2(:,ii)] = Histogram_and_corres_arr(Eapp_bins, Eapp_WL1, FAD_WL2);
        else
        Self.Avg_FAD2(:,ii)  = NaN;
        end
%         Eapp_L1 = double(Eapp_Map(Mask == 1));
%         Self.TEW_Eapp_L1 = Eapp_L1; %nonzeros(Eapp_L1);
    end
else
    Mask = poly2mask(Poly_Cords(:,1), Poly_Cords(:,2), size(Eapp_Map,1), size(Eapp_Map,2));
    if ~isempty(FDA_WL1_Map), FDA_WL1 = FDA_WL1_Map(Mask == 1); else FDA_WL1 = NaN; end
    if ~isempty(FAD_WL1_Map), FAD_WL1 = FAD_WL1_Map(Mask == 1); else FAD_WL1 = NaN; end
    if ~isempty(FAD_WL2_Map), FAD_WL2 = FAD_WL2_Map(Mask == 1); else FAD_WL2 = NaN; end
%     if ~isnan(FDA_WL1)
% %         Self.TEW_FD     = FDA_WL1 + rQuant_Yield*FAD_WL1;                                     % from Prof. Raicu's paper titled "Ab initio derivation
% %         Self.TEW_FA     = (FAD_WL2 - FAD_WL1/gD);                                             % of the FRET equations resolves old puzzles and 
%         Self.TEW_FDA_L1 = FDA_WL1;
%         Self.TEW_FAD_L1 = FAD_WL1;
%         Self.TEW_FAD_L2 = FAD_WL2;
% %         Self.TEW_Eapp   = (1 + (FDA_WL1*(1-gA/gD)/(FAD_WL1 - FAD_WL2*gA))/rQuant_Yield)^(-1); % suggests measurement strategies" EQ. 53, 54 and 45'.
%     else
% %         Self.TEW_FD     = NaN;
% %         Self.TEW_FA     = NaN;
%         Self.TEW_FDA_L1 = NaN;
%         Self.TEW_FAD_L1 = NaN;
%         Self.TEW_FAD_L2 = NaN;
% %         Self.TEW_Eapp   = NaN;
%     end
    Eapp_WL1             = double(Eapp_Map(Mask == 1));
    Eapp_bins            = double([Self.Bin_List; Self.Bin_List(end) + Hist_Bin]);
    Self.Histogram(:,1) = histcounts(double(Eapp_Map(Mask == 1)), double([Self.Bin_List; Self.Bin_List(end) + Hist_Bin]));
    if ~isempty(FDA_WL1_Map)
    [~, Self.Avg_FDA1(:,1)] = Histogram_and_corres_arr(Eapp_bins, Eapp_WL1, FDA_WL1);
    else
    Self.Avg_FDA1(:,1)  = NaN;
    end
    if ~isempty(FAD_WL1_Map)
    [~, Self.Avg_FAD1(:,1)] = Histogram_and_corres_arr(Eapp_bins, Eapp_WL1, FAD_WL1);
    else
    Self.Avg_FAD1(:,1)  = NaN;
    end
    if ~isempty(FAD_WL2_Map)
    [~, Self.Avg_FAD2(:,1)] = Histogram_and_corres_arr(Eapp_bins, Eapp_WL1, FAD_WL2);
    else
    Self.Avg_FAD2(:,1)  = NaN;
    end
%     Eapp_L1 = double(Eapp_Map(Mask == 1));
%     Self.TEW_Eapp_L1 = Eapp_L1; %nonzeros(Eapp_L1);
end;